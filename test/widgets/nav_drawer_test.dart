import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

void main() {
  testWidgets('NavDrawer contains expected menu items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NavDrawer(),
        ),
      ),
    );

    expect(find.byType(NavDrawer), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('My Basket'), findsOneWidget);
    expect(find.text('My Settings'), findsOneWidget);
  });
}
