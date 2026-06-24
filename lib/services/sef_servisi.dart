import 'package:google_generative_ai/google_generative_ai.dart';

class SefServisi {
  // ⚠️ Google AI Studio'dan aldığın AIzaSy... ile başlayan kodu buraya yapıştır
  final String _apiKey = "AIzaSyDfL2ItR3LAK9iMsgVSQCGHMK8povhUnE8";
  late final GenerativeModel _model;

  SefServisi() {
    // Hem ışık hızında çalışan hem de mantık yürütmede harika olan Gemini 2.5 Flash modelini seçiyoruz
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );
  }

  /// Kullanıcının seçtiği malzemeleri alır ve ona özel akıllı tarif üretir
  Future<String> tarifUret(List<String> secilenMalzemeler) async {
    if (secilenMalzemeler.isEmpty) {
      return "Şefin yemek yapabilmesi için önce birkaç malzeme seçmelisin dosti! 🍅";
    }

    final malzemeMetni = secilenMalzemeler.join(", ");

    // Yapay zekanın beynini yıkayıp onu tam bir şefe dönüştürdüğümüz ana komut:
    final prompt = """
Sen sadece Türkçe konuşan, esprili, samimi ve yaratıcı bir Türk başaşçısın. 
Kullanıcının elinde şu malzemeler var: $malzemeMetni

Senden ricam şu kurallara göre bir tarif üretmen:
1. Bu malzemelerle yapılabilecek en mantıklı ve en lezzetli yemeği seç.
2. Eğer eldeki malzemeler bu yemek için tam olarak yetmiyorsa, en az ekstra malzeme gerektiren (kullanıcıyı en az masrafa sokacak) yemeği bul.
3. Çıktıyı tam olarak aşağıdaki şablona sadık kalarak ver, ekstra gereksiz giriş cümleleri kurma, doğrudan konuya gir:

🤖 ŞEFİN ÖNERİSİ: [Yemek Adı]

🛒 MARKETTIEN ALMAN GEREKEN EKSİK MALZEMELER:
- [Eksik Malzeme 1]
- [Eksik Malzeme 2]
(Eğer eldeki malzemeler tarif için tamamen yeterliyse bu bölüme "Her şey hazır, markete gitmene gerek yok! 🎉" yaz)

🍳 HAZIRLANIŞI:
[Adım adım, anlaşılır, samimi bir dille tarifin yapılışını anlat.]
""";

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? "Şef şu an mutfakta değil, bir hata oluştu dosti.";
    } catch (e) {
      return "Şef bağlanırken bir hata oluştu: $e";
    }
  }
}