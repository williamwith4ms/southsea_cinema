import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group("Settings View Tests", () {
    testWidgets(
        "Settings view displays correctly and conatins TetFields and Switch",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsView()));
      await tester.pumpAndSettle();

      expect(find.text("My Settings"), findsOneWidget);
      expect(find.text("Address"), findsOneWidget);
      expect(find.text("Email"), findsOneWidget);
      expect(find.text("Patron Number"), findsOneWidget);
      expect(find.text("Preferences"), findsOneWidget);

      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets(
        "Settings view saves settings and displays confirmation message",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsView()));
      await tester.pumpAndSettle();

      final Finder addressField =
          find.widgetWithText(TextField, "Enter your address");
      final Finder emailField =
          find.widgetWithText(TextField, "Enter your email");
      final Finder patronNumberField =
          find.widgetWithText(TextField, "Enter your patron number");

      await tester.enterText(addressField, "123 Test Street");
      await tester.enterText(emailField, "email@example.com");
      await tester.enterText(patronNumberField, "1234");

      final Finder switchFinder = find.byType(Switch);
      expect(tester.widget<Switch>(switchFinder).value, isFalse);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(switchFinder).value, isTrue);

      await tester.tap(find.text("Save settings"));
      await tester.pumpAndSettle();

      expect(find.text("Settings saved successfully"), findsOneWidget);
    });

    testWidgets(
        "Settings view loads saved settings and displays them correctly",
        (WidgetTester tester) async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({
        prefAddress: "123 Test Street, PO1 000",
        prefEmail: "email@example.com",
        prefPatronNumber: "1234",
        prefReceiveEmailNews: true,
      });

      await tester.pumpWidget(const MaterialApp(home: SettingsView()));
      await tester.pumpAndSettle();

      expect(find.text("123 Test Street, PO1 000"), findsOneWidget);
      expect(find.text("email@example.com"), findsOneWidget);
      expect(find.text("1234"), findsOneWidget);
      expect(find.text("Receive news by email"), findsOneWidget);
      final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });
  });
}
