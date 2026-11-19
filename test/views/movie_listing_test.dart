import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

const MovieData testMovie = MovieData(
  id: "test-movie",
  title: "Test Movie",
  year: 2026,
  rating: "PG",
  description: "Test movie description",
  imagePath: "assets/images/test.jpg",
  date: "Thu, 22nd Oct 2026, 18:00",
  price: 7.50,
);

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    rootBundle.clear();
    CartRepository.instance.clearCart();
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
      expect(CartRepository.instance.getTotalItems(), 2);
    });

    testWidgets("Adding with zero tickets shows validation message",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieListing(movieData: testMovie),
        ),
      );

      await tester.tap(find.text("Add to Order"));
      await tester.pump();

      expect(
        find.text("Please select at least one ticket."),
        findsOneWidget,
      );
      expect(CartRepository.instance.getItems(), isEmpty);
    });

    testWidgets("Movie listing displays all details at wide width",
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: MovieListing(movieData: testMovie),
        ),
      );

      expect(find.text("Test Movie"), findsOneWidget);
      expect(find.text("2026 PG"), findsOneWidget);
      expect(find.text("Thu, 22nd Oct 2026, 18:00"), findsOneWidget);
      expect(find.text("Test movie description"), findsOneWidget);
      expect(find.text("Adult £7.50"), findsOneWidget);
      expect(find.byType(DropdownMenu<int>), findsOneWidget);
    });

    testWidgets("Movie listing supports narrow width",
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: MovieListing(movieData: testMovie),
        ),
      );

      expect(find.byType(MovieListing), findsOneWidget);
      expect(find.text("(Select quantity up to 5 total)"), findsOneWidget);
      expect(find.text("Adult £7.50"), findsOneWidget);
    });
  });
}
