import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // GoRouter eklendi
import '../../business/providers/recipe_provider.dart';
import 'hazir_tarifler_view.dart'; // Yanlış olan 'path_to_your_views/...' kısmını komple silip bunu yaz

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Eski düz listeyi bununla değiştiriyoruz dosti:
  final Map<String, List<String>> categorizedIngredients = const {
    "🥦 Sebzeler & Yeşillikler": [
      "🍅 Domates", "🫑 Biber", "🧅 Soğan", "🧄 Sarımsak",
      "🥔 Patates", "🍆 Patlıcan", "🥕 Havuç", "🥬 Ispanak",
      "🍄 Mantar", "🌽 Mısır", "🌿 Maydanoz"
    ],
    "🥩 Et, Tavuk & Şarküteri": [
      "🥩 Kıyma", "🍗 Tavuk", "🥩 Kuşbaşı Et", "🐟 Balık",
      "🍕 Sucuk", "🌭 Sosis", "🥓 Salam"
    ],
    "🥛 Süt Ürünleri & Yumurta": [
      "🥚 Yumurta", "🧀 Kaşar Peyniri", "🥛 Süt", "🧈 Tereyağı",
      "🍦 Yoğurt", "🧀 Beyaz Peynir", "🥛 Krema"
    ],
    "🌾 Bakliyat & Temel Gıda": [
      "🍞 Un", "🥫 Salça", "🍝 Makarna", "🌾 Pirinç",
      "🫘 Mercimek", "🌾 Bulgur", "🫘 Nohut", "🥖 Ekmek"
    ],
    "🫒 Yağlar & Baharatlar": [
      "🫒 Zeytinyağı", "🌻 Ayçiçek Yağı", "🧂 Tuz", "🌶️ Pul Biber",
      "🌿 Kekik", "🖤 Karabiber", "💛 Kimyon"
    ]
  };

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final selectedList = recipeProvider.selectedIngredients;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buzdolabım', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrange),
              child: Text('Menü', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favori Tariflerim'),
              // GoRouter ile modern geçiş yöntemi (context.push)
              onTap: () {
                Navigator.pop(context); // Önce drawer'ı kapatıyoruz
                context.push('/favorites');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu), // Diğer ikonlarla uyumlu olsun diye gri yaptık
              title: const Text(
                'Hazır Tarifler'
                ),
                onTap: () {
                  // Önce açılan bu yan menüyü kapatıyoruz
                  Navigator.pop(context);

                  // Sonra bizim hazırladığımız puanlı listeye uçuruyoruz
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HazirTariflerView()),
                  );
                }),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('İstatistikler'),
              onTap: () {
                Navigator.pop(context);
                context.push('/statistics');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),
          ],
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Evde hangi malzemeler var?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 🚀 YENİ KATEGORİZASYON LİSTESİ
              Expanded(
                child: ListView.builder(
                  itemCount: categorizedIngredients.keys.length,
                  itemBuilder: (context, index) {
                    String categoryName = categorizedIngredients.keys.elementAt(index);
                    List<String> ingredients = categorizedIngredients[categoryName]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kategori Başlığı (Örn: 🥦 Sebzeler & Yeşillikler)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            categoryName,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDarkMode ? Colors.deepOrange.shade300 : Colors.deepOrange.shade700
                            ),
                          ),
                        ),
                        // O kategoriye ait malzemelerin Chip'leri
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: ingredients.map((ingredient) {
                            final isSelected = selectedList.contains(ingredient);
                            return FilterChip(
                              label: Text(
                                ingredient, 
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected 
                                      ? (isDarkMode ? Colors.white : Colors.deepOrange.shade900)
                                      : (isDarkMode ? Colors.white70 : Colors.black87),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: isDarkMode ? Colors.deepOrange.shade900 : Colors.deepOrange.shade100,
                              checkmarkColor: isDarkMode ? Colors.white : Colors.deepOrange,
                              backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                              onSelected: (bool selected) {
                                recipeProvider.toggleIngredient(ingredient);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        const Divider(), // Kategoriler arasına ince bir çizgi çeker
                      ],
                    );
                  },
                ),
              ),

              // "Bana Tarif Öner" Butonun (Burası aynen kalıyor)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.deepOrange.withOpacity(0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: recipeProvider.isLoading
                      ? null
                      : () async {
                    await recipeProvider.generateRecipe();
                    if (context.mounted && recipeProvider.state == RecipeState.loaded) {
                      context.push('/recipe_detail');
                    }
                  },
                  child: recipeProvider.isLoading
                      ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                  )
                      : const Text('Bana Tarif Öner', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
    );
  }
}