import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/providers/recipe_provider.dart';

class RecipeDetailView extends StatelessWidget {
  const RecipeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider'ı dinliyoruz (Arayüz her durum değiştiğinde otomatik güncellenecek)
    final recipeProvider = Provider.of<RecipeProvider>(context);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şefin Önerisi', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // Yalnızca tarif yüklendiyse "Favorilere Kaydet" butonunu gösteriyoruz
        actions: [
          if (recipeProvider.state == RecipeState.loaded)
            IconButton(
              icon: const Icon(Icons.bookmark_add),
              tooltip: 'Tarifi Kaydet',
              onPressed: () async {
                // Kayıt işlemi için basit bir varsayılan başlık oluşturuyoruz
                final title = "AI Tarifi (${DateTime.now().day}/${DateTime.now().month})";
                await recipeProvider.saveCurrentRecipe(title);

                // Kullanıcıya başarılı olduğuna dair Toast (SnackBar) mesajı gösteriyoruz
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tarif başarıyla favorilere kaydedildi! 👨‍🍳'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
        ],
      ),
      // Duruma göre ekranın ortasında gösterilecek widget'ı belirliyoruz
      body: _buildBody(recipeProvider, isDarkMode),
    );
  }

  // Arayüzü kirletmemek için Body kısmını ayrı bir fonksiyona böldük (Temiz Kod Prensibi)
  Widget _buildBody(RecipeProvider provider, bool isDarkMode) {
    switch (provider.state) {
      case RecipeState.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.deepOrange),
              const SizedBox(height: 20),
              Text(
                'Şef yemeğinizi tasarlıyor...\nLütfen bekleyin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
              ),
            ],
          ),
        );

      case RecipeState.error:
        return const Center(
          child: Text(
            'Üzgünüm, tarifi oluştururken bir hata meydana geldi.',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        );

      case RecipeState.loaded:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade900 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.deepOrange.shade200),
            ),
            // Yapay zekadan gelen metni ekrana basıyoruz
            child: Text(
              provider.generatedRecipeText,
              style: TextStyle(
                fontSize: 16, 
                height: 1.5,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );

      default:
        return const Center(child: Text('Beklenmeyen bir durum oluştu.'));
    }
  }
}