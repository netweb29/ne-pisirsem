import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../services/sef_servisi.dart';

// UI durumlarını kontrol etmek için bir Enum tanımlıyoruz
enum RecipeState { initial, loading, loaded, error }

class RecipeProvider extends ChangeNotifier {
  final RecipeRepository _repository = RecipeRepository();

  final SefServisi _sefServisi = SefServisi();

  // Ekranların dinleyeceği değişkenler
  RecipeState _state = RecipeState.initial;
  String _generatedRecipeText = "";
  List<RecipeModel> _savedRecipes = [];
  final List<String> _selectedIngredients = [];

  // Getter'lar (Arayüzün verilere güvenli erişimi için)
  RecipeState get state => _state;
  String get generatedRecipeText => _generatedRecipeText;
  List<RecipeModel> get savedRecipes => _savedRecipes;
  List<String> get selectedIngredients => _selectedIngredients;
  bool get isLoading => _state == RecipeState.loading;

  // 1. Malzeme seçme / kaldırma mantığı
  void toggleIngredient(String ingredient) {
    if (_selectedIngredients.contains(ingredient)) {
      _selectedIngredients.remove(ingredient);
    } else {
      _selectedIngredients.add(ingredient);
    }
    notifyListeners(); // Arayüze "Malzeme listesi güncellendi, kendini yenile" der
  }

  // 2. Yapay zekadan tarif isteme mantığı
  Future<void> generateRecipe() async {
    if (_selectedIngredients.isEmpty) return;

    _state = RecipeState.loading;
    notifyListeners(); // Arayüze "Şu an yükleniyor animasyonu göster" der

    try {
      // 3. DEĞİŞİKLİK: Artık eldeki malzemeleri internet üzerinden buluttaki akıllı şefe paslıyoruz
      _generatedRecipeText = await _sefServisi.tarifUret(_selectedIngredients);
      _state = RecipeState.loaded;
    } catch (e) {
      _state = RecipeState.error;
      _generatedRecipeText = "Şef mutfakta bir kaza geçirdi dosti, internetini kontrol et: $e";
    }
    notifyListeners(); // Arayüze "Yüklenme bitti, sonucu ekrana bas" der
  }

  // 3. SQLite Veritabanı İşlemleri (Repository Köprüsü)
  Future<void> loadSavedRecipes() async {
    _savedRecipes = await _repository.fetchSavedRecipes();
    notifyListeners();
  }

  Future<void> saveCurrentRecipe(String title) async {
    final newRecipe = RecipeModel(
      title: title,
      ingredients: _selectedIngredients.join(", "),
      instructions: _generatedRecipeText,
    );
    await _repository.saveRecipe(newRecipe);
    await loadSavedRecipes(); // Listeyi güncelle
  }

  // Dışarıdan gelen hazır veya özel tarifleri kaydetmek için genel fonksiyon
  Future<void> saveReadyRecipe({
    required String title,
    required String ingredients,
    required String instructions,
  }) async {
    // Senin lib/data/models/recipe_model.dart dosandaki model yapısına göre nesne üretiyoruz
    final newRecipe = RecipeModel(
      title: title,
      ingredients: ingredients,
      instructions: instructions,
    );

    // ⚠️ BURASI ÖNEMLİ: Alt satırdaki kayıt işlemini kendi mevcut 'saveCurrentRecipe'
    // fonksiyonunun içine bakarak uyarla. Muhtemelen şu şekildedir:
    await _repository.saveRecipe(newRecipe); // veya _dbHelper.insertRecipe(newRecipe)

    // Favori listesini veritabanından yeniden çekip sayfayı yenilemesi için
    // mevcut listeleme fonksiyonunu çağır (Örn: fetchRecipes() veya loadSavedRecipes())
    await loadSavedRecipes();

    notifyListeners(); // Arayüze haber ver
  }
  Future<void> deleteRecipe(int id) async {
    await _repository.removeRecipe(id);
    await loadSavedRecipes(); // Listeyi güncelle
  }
}