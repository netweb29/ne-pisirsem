import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/providers/recipe_provider.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider üzerinden verilerimizi çekiyoruz
    final provider = Provider.of<RecipeProvider>(context);
    final recipes = provider.savedRecipes;
    final fridgeIngredientsCount = provider.selectedIngredients.length;
    final fridgeIngredientsText = provider.selectedIngredients.isEmpty 
        ? "Seçili malzeme yok" 
        : provider.selectedIngredients.join(", ");

    // Dinamik İstatistik Hesaplamaları
    final int totalRecipes = recipes.length;

    // Son Eklenen Tarif
    String lastAddedRecipe = "Favori tarifiniz bulunmuyor";
    
    if (recipes.isNotEmpty) {
      lastAddedRecipe = recipes.first.title;
    }

    // UI Teması Kontrolü
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutfak İstatistikleri', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gemini 2.5 Yapay Zeka Özeti",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.deepOrange.shade300 : Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 16),

            // 1. İstatistik Kartı: Aktif Yapay Zeka Modeli
            _buildStatCard(
              icon: Icons.smart_toy,
              title: "Aktif Yapay Zeka Modeli",
              value: "Gemini 2.5 Flash (Bulut API)",
              color: Colors.purple,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 12),

            // 2. İstatistik Kartı: Buzdolabındaki Aktif Malzemeler
            _buildStatCard(
              icon: Icons.kitchen,
              title: "Buzdolabında Seçili Malzeme",
              value: "$fridgeIngredientsCount adet",
              subtitle: fridgeIngredientsText,
              color: Colors.orange,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 12),

            // 3. İstatistik Kartı: Toplam Kayıtlı Tarif
            _buildStatCard(
              icon: Icons.menu_book_rounded,
              title: "Favori Tarifler",
              value: "$totalRecipes adet",
              color: Colors.blueAccent,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 12),

            // 4. İstatistik Kartı: Son Eklenen Tarif
            _buildStatCard(
              icon: Icons.history,
              title: "Son Eklenen Tarif",
              value: lastAddedRecipe,
              color: Colors.teal,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  // İstatistik kartlarını oluşturan yardımcı widget metodu
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isDarkMode,
    String? subtitle,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey.shade900 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 26, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}