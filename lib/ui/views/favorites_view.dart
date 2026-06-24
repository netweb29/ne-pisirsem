import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/providers/recipe_provider.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 Uygulamanın o an koyu modda olup olmadığını anlayan değişken
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Tariflerim', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          final recipes = provider.savedRecipes;

          // Eğer veritabanında hiç tarif yoksa boş durum tasarımı
          if (recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz favorilere eklenmiş\nbir tarifiniz bulunmuyor.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return Dismissible(
                key: Key(recipe.id.toString()),
                // 🌟 DOĞRUSU: dismisis yönü tamamen küçük harfle düzeltildi
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white, size: 30),
                ),
                onDismissed: (direction) {
                  provider.deleteRecipe(recipe.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${recipe.title} silindi.')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  // 🌟 Kartın kendi arka planını da temaya bağımlı hale getiriyoruz
                  color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                  child: ExpansionTile(
                    iconColor: Colors.deepOrange,
                    collapsedIconColor: isDarkMode ? Colors.white70 : Colors.black54,
                    // 🌟 Koyu modda başlıkların beyaz kalmasını garanti altına alıyoruz
                    textColor: isDarkMode ? Colors.white : Colors.black87,
                    collapsedTextColor: isDarkMode ? Colors.white : Colors.black87,
                    // 🌟 Genişleyen kısmın arka plan rengini bu iki parametreyle ExpansionTile'a da bildiriyoruz
                    backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.orange.shade50,
                    collapsedBackgroundColor: Colors.transparent,
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      child: Icon(Icons.restaurant, color: Colors.white),
                    ),
                    title: Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        // 🌟 DÜZELTME: Olmayan shade850 yerine standart shade800 kullanıldı
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.orange.shade50,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. MALZEMELER KISMI
                            const Text(
                              "🥦 Malzemeler",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recipe.ingredients,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                // Yazı renklerini de garantiye alalım
                                color: isDarkMode ? Colors.white70 : Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // 2. YAPILIŞI KISMI
                            const Text(
                              "🍳 Hazırlanışı",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recipe.instructions,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: isDarkMode ? Colors.white70 : Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 12),
                            const Divider(),

                            // 3. FAVORİLERDEN KALDIR BUTONU
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  provider.deleteRecipe(recipe.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${recipe.title} favorilerden kaldırıldı.'),
                                      backgroundColor: Colors.red.shade400,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                label: const Text(
                                  "Favorilerden Kaldır",
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}