# Ne Pişirsem? - AI Destekli Mutfak Asistanı

Ne Pişirsem?, evdeki malzemelerinizi israf etmeden pratik yemek tarifleri oluşturmanızı sağlayan yapay zeka destekli bir mobil uygulamadır. 

Buzdolabınızda bulunan malzemeleri seçerek Google Gemini 2.5 Flash API aracılığıyla dinamik ve Türkçe yemek tarifleri üretebilirsiniz. İnternet bağlantısı olmadığında ise yerel tarif kütüphanesini kullanabilirsiniz.

## Özellikler
* **Malzeme Seçimi:** Evdeki malzemeleri kategorize listelerden seçme.
* **AI Tarif Üretimi:** Seçilen malzemelere göre Gemini API ile anlık tarif hazırlama.
* **SQLite Favori Sistemi:** Beğenilen tarifleri yerel veritabanına kaydetme ve silme.
* **Çevrimdışı Hazır Tarifler:** İnternet yokken yerel veritabanındaki hazır tarifleri isme ve puana göre sıralayarak inceleme.
* **İstatistikler:** Seçili malzeme ve favori tarif sayılarını gerçek zamanlı takip etme.
* **Açık/Koyu Tema:** Kullanıcı tercihine göre arayüz teması seçimi.

## Klasör Yapısı
Proje katmanlı mimari (Presentation, Business, Data) prensiplerine uygun olarak organize edilmiştir:
* `lib/ui/`: Arayüz ekranları, widget'lar ve tema dosyaları.
* `lib/business/`: Durum yönetimi (Provider) ve iş mantığı.
* `lib/data/`: SQLite entegrasyonu, veri modelleri ve repository katmanı.
* `lib/services/`: Gemini API servis entegrasyonu.

## Kullanılan Teknolojiler
* Flutter & Dart
* Provider (Durum Yönetimi)
* GoRouter (Navigasyon)
* sqflite & path (Yerel Veritabanı)
* google_generative_ai (Gemini API)

## Kurulum ve Çalıştırma

1. Projeyi bilgisayarınıza indirin:
   ```bash
   git clone <repository-adresi>
   cd ne_pisirsem
   ```

2. Gerekli paketleri yükleyin:
   ```bash
   flutter pub get
   ```

3. `lib/services/sef_servisi.dart` dosyasındaki `_apiKey` değişkenine kendi Gemini API anahtarınızı tanımlayın.

4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

---
Bu proje, Mobil Uygulama Tasarımı ve Geliştirme dersi final projesi olarak geliştirilmiştir.
