import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Katmanlı mimari içe aktarmaları
import 'business/providers/recipe_provider.dart';
import 'business/providers/theme_provider.dart'; // 👈 TEMA PROVIDER IMPORTU
import 'ui/theme/app_theme.dart'; // 👈 YENİ TEMA SINIFI IMPORTU
import 'ui/views/home_view.dart';
import 'ui/views/recipe_detail_view.dart';
import 'ui/views/favorites_view.dart';
import 'ui/views/statistics_view.dart';
import 'ui/views/settings_view.dart';

// GoRouter Yapılandırması (Declarative Routing)
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
    ),
    GoRoute(
      path: '/recipe_detail',
      builder: (BuildContext context, GoRouterState state) => const RecipeDetailView(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (BuildContext context, GoRouterState state) => const FavoritesView(),
    ),
    GoRoute(
      path: '/statistics',
      builder: (BuildContext context, GoRouterState state) => const StatisticsView(),
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) => const SettingsView(),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()..loadSavedRecipes()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // 👈 TEMA PROVIDER'INI BURAYA EKLEDİK
      ],
      child: const NePisirsemApp(),
    ),
  );
}

class NePisirsemApp extends StatelessWidget {
  const NePisirsemApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 Tema değişikliklerini dinlemek için provider'ı buraya bağlıyoruz
    final themeProvider = Provider.of<ThemeProvider>(context);

    // MaterialApp yerine MaterialApp.router kullanarak GoRouter'ı aktif ediyoruz
    return MaterialApp.router(
      title: 'Ne Pişirsem?',
      debugShowCheckedModeBanner: false,

      // 🌟 TEMA AYARLARINI BURADA BAĞLIYORUZ
      themeMode: themeProvider.themeMode, // Aktif temayı dinler (Sistem, Açık, Koyu)
      theme: AppTheme.lightTheme,         // ui/theme/app_theme.dart dosyasından gelen açık tema
      darkTheme: AppTheme.darkTheme,     // ui/theme/app_theme.dart dosyasından gelen koyu tema

      routerConfig: _router, // GoRouter konfigürasyonunu bağlıyoruz
    );
  }
}