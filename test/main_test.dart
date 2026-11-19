import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
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
  });
}
