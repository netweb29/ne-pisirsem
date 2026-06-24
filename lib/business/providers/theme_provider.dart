import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Başlangıçta sistem hangi moddaysa uygulama onu alır
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // Temayı değiştiren ve tüm sayfalara haber veren fonksiyon
  void temaDegistir(ThemeMode yeniTema) {
    _themeMode = yeniTema;
    notifyListeners(); // Tüm arayüze "Yenilen!" emri verir
  }
}