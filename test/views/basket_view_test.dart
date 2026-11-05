import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';

const MovieData testMovie1 = MovieData(
    id: "crimson-tide",
    title: "Crimson Tide",
    year: 1995,
    rating: "R",
    description:
        "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.",
    imagePath: "assets/images/crimson-tide.jpg",
    date: "Thr, 22nd Oct 2026, 18:00",
    price: 7.50);

const MovieData testMovie2 = MovieData(
    id: "avatar",
    title: "Avatar",
    year: 2009,
    rating: "PG-13",
    description:
        "A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.",
    imagePath: "assets/images/avatar.jpg",
    date: "Fri, 23rd Oct 2026, 18:00",
    price: 8.00);

void main() {
  setUp(() {
    CartRepository.instance.clearCart();
  });

  group("Basket View Tests", () {
    testWidgets("Basket view displays empty message when cart has no items",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text("Your basket is empty."), findsOneWidget);
      expect(
          find.text("Your order has been placed successfully"), findsNothing);
    });

    testWidgets(
        "Basket view renders items and removes item when delete pressed",
        (WidgetTester tester) async {
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie1, quantity: 2));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text("2 Tickets"), findsOneWidget);
      expect(find.text("Crimson Tide (1995)"), findsOneWidget);
      expect(find.text("Thr, 22nd Oct 2026, 18:00"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text("Your basket is empty."), findsOneWidget);
    });

    testWidgets("Basket view displays confirmation message when order placed",
        (WidgetTester tester) async {
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie1, quantity: 2));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text("2 Tickets"), findsOneWidget);
      expect(find.text("Crimson Tide (1995)"), findsOneWidget);
      expect(find.text("Thr, 22nd Oct 2026, 18:00"), findsOneWidget);

      await tester.tap(find.text("Buy Tickets"));
      await tester.pumpAndSettle();

      expect(
          find.text("Your order has been placed successfully"), findsOneWidget);
    });

    testWidgets("Basket view line delete button removes tickets",
        (WidgetTester tester) async {
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie1, quantity: 1));
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie2, quantity: 1));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text("Crimson Tide (1995)"), findsOneWidget);
      expect(find.text("Avatar (2009)"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      expect(find.text("Crimson Tide (1995)"), findsNothing);
      expect(find.text("Avatar (2009)"), findsOneWidget);
    });
  });
}
