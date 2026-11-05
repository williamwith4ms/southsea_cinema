import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

void main() {
  setUp(() {
    rootBundle.clear();
  });
  group("Movie Listing tests", () {
    testWidgets("Navigate to movie listing for first movie",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text("Order Tickets").first);
      await tester.pumpAndSettle();
      expect(find.byType(MovieListing), findsOneWidget);
    });

    testWidgets("Test navigate to first movie listing show correct details",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

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

      expect(find.text("Added 2 tickets to your basket."), findsOneWidget);
    });
  });
}
