import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/settings_view.dart';
import 'package:flutter/foundation.dart';

bool isSupportedPlatform() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  return false;
}

void main() {
  if (isSupportedPlatform()) {
    runApp(const SouthseaCinemaApp());
  } else {
    runApp(const UnsupportedPlatformApp());
  }
}

class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'This app saves orders with SQLite and is set up to run on '
              'Android only. Stop the app and run it on an Android emulator '
              'or device instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class SouthseaCinemaApp extends StatefulWidget {
  const SouthseaCinemaApp({super.key});

  @override
  State<SouthseaCinemaApp> createState() => _SouthseaCinemaAppState();
}

class _SouthseaCinemaAppState extends State<SouthseaCinemaApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = SharedPreferencesAsync();
    final savedTheme = await prefs.getString(prefThemeMode);
    if (!mounted) {
      return;
    }
    setState(() {
      _themeMode = savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
    });
  }

  Future<void> _setThemeMode(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    await SharedPreferencesAsync().setString(
      prefThemeMode,
      themeMode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: cinemaBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cinemaBrand,
        brightness: Brightness.dark,
        primary: cinemaBrand,
        surface: cinemaSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cinemaSurface,
        iconTheme: IconThemeData(color: cinemaBrand),
        titleTextStyle: cinemaHeaderStyle,
        elevation: 0,
      ),
      cardColor: cinemaSurface,
    );

    final ThemeData lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: cinemaLightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cinemaBrand,
        brightness: Brightness.light,
        primary: cinemaBrand,
        surface: cinemaLightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cinemaLightSurface,
        foregroundColor: cinemaBrand,
        iconTheme: IconThemeData(color: cinemaBrand),
        titleTextStyle: TextStyle(
          color: cinemaLightFont,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      cardColor: cinemaLightSurface,
      cardTheme: const CardThemeData(
        color: cinemaLightSurface,
      ),
    );

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/basket': (context) => const BasketView(),
        '/settings': (context) => SettingsView(
              onThemeModeChanged: _setThemeMode,
            ),
      },
    );
  }
}
