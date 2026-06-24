import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Klasör yapına göre recipe_provider yolu tam olarak budur:
import '../../business/providers/recipe_provider.dart';

class TarifDetayView extends StatelessWidget {
  final Map<String, dynamic> tarif;

  const TarifDetayView({Key? key, required this.tarif}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String temizAd = tarif['Yemek İsmi'].toString().replaceAll(' Nasıl Yapılır?', '');

    final List<String> malzemelerList = tarif['Malzemeler']?.toString().split('\n') ?? [];
    final List<String> yapilisAdimlari = tarif['Yapılış']?.toString().split('\n') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(temizAd, style: const TextStyle(fontSize: 18)),
        actions: [
          // 📑 SENİN KENDİ FAVORİ KAYDETME BUTONUN
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            tooltip: 'Tarifi Kaydet',
            onPressed: () async {
              final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

              // JSON'daki ham malzemeleri ve yapılış metinlerini olduğu gibi alıyoruz
              final String hamMalzemeler = tarif['Malzemeler']?.toString() ?? '';
              final String hamYapilis = tarif['Yapılış']?.toString() ?? '';

              // Yeni yazdığımız genel fonksiyonu çağırıp her şeyi eksiksiz gönderiyoruz
              await recipeProvider.saveReadyRecipe(
                title: temizAd,
                ingredients: hamMalzemeler,
                instructions: hamYapilis,
              );

              // Kullanıcıya başarılı SnackBar mesajı gösteriyoruz
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
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🥦 MALZEMELER BAŞLIĞI
            const Text(
              "🥦 Malzemeler",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const Divider(),
            const SizedBox(height: 6),

            ...malzemelerList.map((malzeme) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Icon(Icons.fiber_manual_record, size: 8, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      malzeme,
                      style: const TextStyle(fontSize: 15, height: 1.2),
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 28),

            // 🍳 YAPILIŞI BAŞLIĞI
            const Text(
              "🍳 Hazırlanışı",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const Divider(),
            const SizedBox(height: 6),

            ...yapilisAdimlari.map((adim) {
              if (adim.trim() == "PÜF NOKTALARI") {
                return const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 8.0),
                  child: Text(
                    "💡 PÜF NOKTALARI",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  adim,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}