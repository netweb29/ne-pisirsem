import '../local/recipe_dao.dart';
import '../models/recipe_model.dart';

class RecipeRepository {
  // Veritabanı işlemlerini yürütecek DAO nesnesini çağırıyoruz
  final RecipeDao _recipeDao = RecipeDao();

  // İş Mantığı (Business) katmanı yeni bir tarif kaydetmek istediğinde bu fonksiyonu çağıracak
  Future<bool> saveRecipe(RecipeModel recipe) async {
    try {
      final id = await _recipeDao.insertRecipe(recipe);
      return id > 0; // Eğer ID 0'dan büyükse başarılı şekilde kaydedilmiştir
    } catch (e) {
      return false; // Bir hata oluşursa false döner
    }
  }

  // Kayıtlı tüm tarifleri getiren soyutlanmış fonksiyon
  Future<List<RecipeModel>> fetchSavedRecipes() async {
    return await _recipeDao.getAllRecipes();
  }

  // Bir tarifi silmek için kullanılan soyutlanmış fonksiyon
  Future<bool> removeRecipe(int id) async {
    try {
      final deletedCount = await _recipeDao.deleteRecipe(id);
      return deletedCount > 0; // Silinen satır sayısı 0'dan büyükse işlem başarılıdır
    } catch (e) {
      return false;
    }
  }
}