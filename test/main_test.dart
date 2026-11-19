import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group("Main Tests", () {
    testWidgets("SouthseaCinemaApp runs without errors", (tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.byType(SouthseaCinemaApp), findsOneWidget);
    });

    testWidgets("SouthseaCinemaApp contains a MaterialApp", (tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets("SouthseaCinemaApp contains the title text", (tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text(appTitle), findsOneWidget);
    });

    testWidgets("SouthseaCinemaApp loads a light theme preference",
        (tester) async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({
        prefThemeMode: "light",
      });

      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final MaterialApp app =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);
      expect(app.theme!.brightness, Brightness.light);
    });

    test("isSupportedPlatform accepts Android", () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(isSupportedPlatform(), isTrue);
    });

    test("isSupportedPlatform rejects unsupported platforms", () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      expect(isSupportedPlatform(), isFalse);
    });

    testWidgets("UnsupportedPlatformApp displays platform guidance",
        (tester) async {
      await tester.pumpWidget(const UnsupportedPlatformApp());

      expect(find.textContaining("Android only"), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets("SouthseaCinemaApp loads the default dark theme",
        (tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final MaterialApp app =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
      expect(app.darkTheme!.brightness, Brightness.dark);
    });

    testWidgets("Settings route opens and saving changes app theme",
        (tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/settings');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SettingsView), findsOneWidget);

      final Finder themeSwitch = find.byKey(const Key('theme_mode_switch'));
      await tester.tap(themeSwitch);
      await tester.pump();

      await tester.ensureVisible(find.text("Save settings"));
      await tester.tap(find.text("Save settings"));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final MaterialApp app =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);
      expect(find.text("Settings saved successfully"), findsOneWidget);
    });

    testWidgets("Basket route opens the basket view", (tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/basket');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(BasketView), findsOneWidget);
    });
  });
}
