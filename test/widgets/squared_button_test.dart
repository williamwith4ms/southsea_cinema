import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/widgets/squared_button.dart';

void main() {
  testWidgets('SquaredButton displays label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SquaredButton(
            label: "Order",
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text("Order"), findsOneWidget);
  });

  testWidgets('SquaredButton invokes onPressed when tapped', (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SquaredButton(
            label: "Order",
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text("Order"));
    await tester.pump();

    expect(wasPressed, true);
  });
}