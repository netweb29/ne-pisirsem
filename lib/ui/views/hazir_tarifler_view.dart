import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tarif_detay_view.dart';

class HazirTariflerView extends StatefulWidget {
  const HazirTariflerView({Key? key}) : super(key: key);

  @override
  State<HazirTariflerView> createState() => _HazirTariflerViewState();
}

class _HazirTariflerViewState extends State<HazirTariflerView> {
  List<dynamic> _tarifler = [];
  bool _isLoading = true;
  String _aktifSiralaModu = 'isim';

  @override
  void initState() {
    super.initState();
    _jsonYukle();
  }

  Future<void> _jsonYukle() async {
    try {
      final String response = await rootBundle.loadString('assets/tarifler.json');
      final String temizResponse = response.replaceAll(': NaN', ': null');
      final List<dynamic> hamVeri = json.decode(temizResponse);

      final List<dynamic> saglamTarifler = hamVeri.where((tarif) {
        final yapilis = tarif['Yapılış'];
        final malzemeler = tarif['Malzemeler'];
        final isim = tarif['Yemek İsmi'];

        if (yapilis == null || yapilis.toString().trim().isEmpty) return false;
        if (malzemeler == null || malzemeler.toString().trim().isEmpty) return false;
        if (isim == null || isim.toString().trim().isEmpty) return false;

        return true;
      }).toList();

      setState(() {
        _tarifler = saglamTarifler;
        _isLoading = false;
        _sirala('isim');
      });
    } catch (e) {
      print("JSON yükleme hatası: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sirala(String mod) {
    setState(() {
      _aktifSiralaModu = mod;
      if (mod == 'isim') {
        _tarifler.sort((a, b) =>
            a['Yemek İsmi'].toString().compareTo(b['Yemek İsmi'].toString()));
      } else if (mod == 'puan') {
        _tarifler.sort((a, b) {
          final num puanA = a['Ortalama Puan'] ?? 0;
          final num puanB = b['Ortalama Puan'] ?? 0;
          return puanB.compareTo(puanA);
        });
      }
    });
  }

  Color _getYildizRengi(double puan) {
    if (puan >= 4.5) return Colors.amber;
    if (puan >= 3.5) return Colors.orange;
    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Uygulamanın o an koyu modda olup olmadığını anlayan değişken
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hazır Tarifler"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🎛️ ÜST SIRALAMA BUTONLARI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            // 🌟 Sabit renk yerine temaya göre arka plan rengi verdik
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      // 🌟 Koyu modda seçili değilse butonun rengini koyulaştırıyoruz
                      backgroundColor: _aktifSiralaModu == 'isim'
                          ? Colors.deepOrange
                          : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
                      foregroundColor: _aktifSiralaModu == 'isim'
                          ? Colors.white
                          : (isDarkMode ? Colors.white70 : Colors.black87),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.sort_by_alpha, size: 18),
                    label: const Text("İsme Göre"),
                    onPressed: () => _sirala('isim'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _aktifSiralaModu == 'puan'
                          ? Colors.deepOrange
                          : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
                      foregroundColor: _aktifSiralaModu == 'puan'
                          ? Colors.white
                          : (isDarkMode ? Colors.white70 : Colors.black87),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.star, size: 18),
                    label: const Text("Puana Göre"),
                    onPressed: () => _sirala('puan'),
                  ),
                ),
              ],
            ),
          ),

          // 📜 TARİF KARTLARI LİSTESİ
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _tarifler.length,
              itemBuilder: (context, index) {
                final tarif = _tarifler[index];
                final double puan = (tarif['Ortalama Puan'] as num?)?.toDouble() ?? 0.0;
                final String temizAd = tarif['Yemek İsmi'].toString().replaceAll(' Nasıl Yapılır?', '');

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TarifDetayView(tarif: tarif),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              temizAd,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                puan.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.star, color: _getYildizRengi(puan), size: 22),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}