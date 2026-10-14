import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

void main() {
  // testWidgets('Basic app loading test', (WidgetTester tester) async {
  //   await tester.pumpWidget(const SouthseaCinemaApp());
  //   expect(find.text('Welcome to Southsea Cinema'), findsOneWidget);
  // });

  group("Home View Tests", () {
    testWidgets("App loads and contains movie cards",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.byType(MovieCard), findsWidgets);
    });

    testWidgets("Home view displays title", (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.text('Southsea Cinema & Art Centre'), findsOneWidget);
    });

    testWidgets("Check the first card loads and contains the correct data",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.text("Crimson Tide"), findsOneWidget);
      expect(
          find.text(
              "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so."),
          findsOneWidget);
    });
  });

  group("Movie Listing tests", () {
    testWidgets("Navigate to movie listing for first movie",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      await tester.tap(find.text("Order Tickets").first);
      await tester.pumpAndSettle();
      expect(find.byType(MovieListing), findsOneWidget);
    });

    testWidgets("Test navigate to first movie listing show correct details",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      await tester.tap(find.text("Order Tickets").first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsOneWidget);

      expect(find.text("Crimson Tide"), findsOneWidget);
      expect(
          find.text(
              "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so."),
          findsOneWidget);
    });

    testWidgets("Test Movie listing add to order button",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      await tester.tap(find.text("Order Tickets").first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsOneWidget);

      // set dropdown to 2 tickets
      await tester.tap(find.byType(DropdownMenu<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text("2").last);
      await tester.pumpAndSettle();

      // tap add to order button
      await tester.tap(find.text("Add to Order"));
      await tester.pumpAndSettle();

      expect(find.text("2 ticket package in order"), findsOneWidget);
    });
  });
}
