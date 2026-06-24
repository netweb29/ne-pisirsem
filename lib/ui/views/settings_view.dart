import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/providers/theme_provider.dart'; // Yeni import

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 Tema değiştirmek için provider'a erişiyoruz
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          // Uygulama Logosu ve Sürüm Bilgisi
          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepOrange,
                  child: Icon(Icons.restaurant_menu, size: 50, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Ne Pişirsem? - AI Şef',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Sürüm 1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Divider(),

          // 🎨 TEMA SEÇİMİ KISMI
          ListTile(
            leading: const Icon(Icons.palette_outlined, color: Colors.deepOrange),
            title: const Text('Uygulama Teması', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Görünüm modunu seçin'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: themeProvider.themeMode == ThemeMode.dark ? Colors.grey.shade800 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode, // Değeri direkt provider'dan okuyoruz
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.deepOrange),
                dropdownColor: themeProvider.themeMode == ThemeMode.dark ? Colors.grey.shade800 : Colors.orange.shade50,
                onChanged: (ThemeMode? yeniDeger) {
                  if (yeniDeger != null) {
                    // Seçilen yeni temayı tüm uygulamaya duyuruyoruz
                    themeProvider.temaDegistir(yeniDeger);
                  }
                },
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text('Sistem Tercihi')),
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Açık Tema')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Koyu Tema')),
                ],
              ),
            ),
          ),
          const Divider(),

          // Diğer Ayar Seçenekleri
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.deepOrange),
            title: const Text('Hakkında'),
            subtitle: const Text('Bu uygulama EFC304 dersi final projesi için geliştirilmiştir.'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.memory, color: Colors.deepOrange),
            title: const Text('Yapay Zeka Motoru'),
            subtitle: const Text('Google Gemini 2.5 Flash (Bulut API)'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.deepOrange),
            title: const Text('Gizlilik ve Veri Güvenliği'),
            subtitle: const Text('Tüm veriler cihazınızda (SQLite) saklanır, internete gönderilmez.'),
          ),
          const Divider(),
        ],
      ),
    );
  }
}