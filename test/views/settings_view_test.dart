import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  group("Settings View Tests", () {
    testWidgets(
        "Settings view displays correctly and conatins TetFields and Switch",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsView()));

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
  });
}
