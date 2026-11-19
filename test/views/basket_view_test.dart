import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

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

const MovieData testMovie3 = MovieData(
    id: "1917",
    title: "1917",
    year: 2019,
    rating: "R",
    description:
        "April 6th, 1917. As an infantry battalion assembles to wage war deep in enemy territory, two soldiers are assigned to race against time and deliver a message that will stop 1,600 men from walking straight into a deadly trap.",
    imagePath: "assets/images/1917.jpg",
    date: "Sat, 24th Oct 2026, 18:00",
    price: 7.50);

void main() {
  setUp(() async {
    CartRepository.instance.clearCart();
    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
          version: 1, onCreate: CinemaDatabase.instance.createTables),
    );
    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    CartRepository.instance.clearCart();
    await CinemaDatabase.instance.close();
  });

  group("Basket View Tests", () {
    testWidgets(
        'Checkout saves the order, clears the basket and displays the order', (
      WidgetTester tester,
    ) async {
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie1, quantity: 2));
      await tester.pumpWidget(MaterialApp(
        home: BasketView(),
        routes: {
          '/basket': (context) {
            return const BasketView();
          },
        },
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Buy Tickets"));
      await tester.pumpAndSettle();
      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();

      expect(bookings, isNotNull);
      expect(bookings.length, 1);
      expect(bookings[0].bookingNumber, 1001);
      expect(bookings[0].summary, "2x Crimson Tide");
      expect(bookings[0].total, 16.5);
      expect(CartRepository.instance.getItems().isEmpty, true);
      expect(find.byType(BasketView), findsOneWidget);
      expect(find.textContaining("1001) has been placed successfully"),
          findsOneWidget);
    });

    testWidgets("Basket view displays empty message when cart has no items",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

      expect(find.text("2 Tickets"), findsOneWidget);
      expect(find.text("Crimson Tide (1995)"), findsOneWidget);
      expect(find.text("Thr, 22nd Oct 2026, 18:00"), findsOneWidget);

      await tester.tap(find.text("Buy Tickets"));
      await tester.pumpAndSettle();

      expect(
          find.textContaining("has been placed successfully"), findsOneWidget);
      expect(find.text("Your basket is empty."), findsOneWidget);
    });

    testWidgets("Basket view line delete button removes tickets",
        (WidgetTester tester) async {
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie1, quantity: 1));
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie2, quantity: 1));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();

      expect(find.text("Crimson Tide (1995)"), findsOneWidget);
      expect(find.text("Avatar (2009)"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      expect(find.text("Crimson Tide (1995)"), findsNothing);
      expect(find.text("Avatar (2009)"), findsOneWidget);
    });

    testWidgets("Basket is kept when saving fails",
        (WidgetTester tester) async {
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie1, quantity: 2));

      await tester.runAsync(() async {
        final Database database = await CinemaDatabase.instance.database;
        await database.execute('DROP TABLE bookings');
      });

      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.tap(find.text("Buy Tickets"));
        await tester.pumpAndSettle();
      });

      await tester.pumpAndSettle();

      expect(find.text("2 Tickets"), findsOneWidget);
      expect(find.text("Crimson Tide (1995)"), findsOneWidget);
      expect(CartRepository.instance.getItems().length, 1);
    });

    testWidgets("Orders list is displayed after checkout",
        (WidgetTester tester) async {
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie1, quantity: 2));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Buy Tickets"));
      await tester.pumpAndSettle();

      expect(
          find.textContaining("has been placed successfully"), findsOneWidget);
      expect(find.text("Your basket is empty."), findsOneWidget);

      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      expect(bookings.length, 1);
      expect(bookings[0].bookingNumber, 1001);
    });

    testWidgets(
        "Add 3 movies and delete the middle one and check the other two remain",
        (WidgetTester tester) async {
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie1, quantity: 1));
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie2, quantity: 1));
      CartRepository.instance
          .addItem(CartItem(movieData: testMovie3, quantity: 1));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();

      expect(find.text("Crimson Tide (1995)"), findsOneWidget);
      expect(find.text("Avatar (2009)"), findsOneWidget);
      expect(find.text("1917 (2019)"), findsOneWidget);

      // use a key to find the delete button for the second movie and tap it
      const Key key = Key("delete-avatar");
      await tester.tap(find.byKey(key));
      await tester.pumpAndSettle();

      expect(find.text("Crimson Tide (1995)"), findsOneWidget);
      expect(find.text("Avatar (2009)"), findsNothing);
      expect(find.text("1917 (2019)"), findsOneWidget);
    });
  });
}
