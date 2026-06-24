import 'package:flutter/material.dart';

class AppTheme {
  // ☀️ AÇIK TEMA AYARLARI
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.deepOrange,
      scaffoldBackgroundColor: Colors.white,

      // 🌟 CardTheme yerine doğrudan cardColor kullandık, hata verme şansı SIFIR!
      cardColor: Colors.white,

      // AppBar Tasarımı
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.deepOrange),
      ),

      // Renk Şeması
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        brightness: Brightness.light,
      ),
    );
  }

  // 🌙 KOYU TEMA AYARLARI
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.deepOrange,
      scaffoldBackgroundColor: Colors.grey.shade900,

      // 🌟 Koyu mod için kart arka plan rengi
      cardColor: Colors.grey.shade800,

      // AppBar Tasarımı
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF212121), // Hafif koyu gri
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.deepOrange),
      ),

      // Renk Şeması
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
    );
  }
}