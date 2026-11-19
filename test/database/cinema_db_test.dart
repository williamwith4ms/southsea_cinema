import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'package:southsea_cinema/database/cinema_db.dart';

const MovieData testMovie = MovieData(
  id: "crimson-tide",
  title: "Crimson Tide",
  year: 1995,
  rating: "R",
  description: "Test description",
  imagePath: "assets/images/crimson-tide.jpg",
  date: "22nd Oct 2026, 18:00",
  price: 7.50,
);

void main() {
  setUp(() async {
    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
          version: 2,
          onConfigure: (Database db) async {
            await db.execute('PRAGMA foreign_keys = ON');
          },
          onCreate: CinemaDatabase.instance.createTables,
          onUpgrade: CinemaDatabase.instance.upgradeDB),
    );
    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
  });

  Booking buildBooking(int bookingNumber, String summary, double total) {
    return Booking(
      bookingNumber: bookingNumber,
      summary: summary,
      total: total,
      date: "01/01/1970 00:00",
    );
  }

  group("Cinema Database Tests", () {
    test("Insert and retrieve a booking", () async {
      final Booking booking = buildBooking(1001, "1x Crimson Tide", 7.5);
      await CinemaDatabase.instance.insertBooking(booking);

      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      expect(bookings.length, 1);
      expect(bookings[0].bookingNumber, 1001);
      expect(bookings[0].summary, '1x Crimson Tide');
      expect(bookings[0].total, 7.5);
      expect(bookings[0].date, "01/01/1970 00:00");
    });

    test("getNextBookingNumber increments the current maximum booking number",
        () async {
      expect(await CinemaDatabase.instance.getNextBookingNumber(), 1001);

      await CinemaDatabase.instance
          .insertBooking(buildBooking(10000, "1x Crimson Tide", 7.5));

      expect(await CinemaDatabase.instance.getNextBookingNumber(), 10001);
    });

    test("getAllOrders returns the newest order number first", () async {
      await CinemaDatabase.instance
          .insertBooking(buildBooking(1001, "First", 7.5));
      await CinemaDatabase.instance
          .insertBooking(buildBooking(1002, "Second", 7.5));
      await CinemaDatabase.instance
          .insertBooking(buildBooking(1003, "Third", 7.5));

      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      expect(bookings.length, 3);
      expect(bookings[0].bookingNumber, 1003);
      expect(bookings[1].bookingNumber, 1002);
      expect(bookings[2].bookingNumber, 1001);
    });

    test("saves a booking and all items transactionally", () async {
      final Booking booking = buildBooking(1001, "", 15.0);
      final CartItem item = const CartItem(movieData: testMovie, quantity: 2);

      final int bookingId =
          await CinemaDatabase.instance.insertBookingWithItems(booking, [item]);

      final List<Map<String, Object?>> items =
          await CinemaDatabase.instance.getBookingItems(bookingId);
      expect(items.length, 1);
      expect(items[0]['booking_id'], bookingId);
      expect(items[0]['movie_id'], "crimson-tide");
      expect(items[0]['title'], "Crimson Tide");
      expect(items[0]['quantity'], 2);
      expect(items[0]['unit_price'], 7.5);

      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      expect(bookings.length, 1);
      expect(bookings[0].items.length, 1);
      expect(bookings[0].items[0].title, "Crimson Tide");
      expect(bookings[0].items[0].quantity, 2);
      expect(bookings[0].items[0].unitPrice, 7.5);
      expect(bookings[0].items[0].lineTotal, 15.0);
      expect(bookings[0].summary, isEmpty);
    });

    test("rolls back the booking and items when a later item insert fails",
        () async {
      final Database db = await CinemaDatabase.instance.database;
      await db.execute('''
        CREATE TRIGGER reject_fail_item
        BEFORE INSERT ON booking_items
        WHEN NEW.title = 'Fail'
        BEGIN
          SELECT RAISE(FAIL, 'item insert failed');
        END
      ''');

      const MovieData failMovie = MovieData(
        id: "fail",
        title: "Fail",
        year: 2026,
        rating: "R",
        description: "Test",
        imagePath: "assets/images/crimson-tide.jpg",
        date: "22nd Oct 2026, 18:00",
        price: 8.0,
      );
      final Booking booking = buildBooking(1001, "Valid and Fail", 23.0);

      await expectLater(
        CinemaDatabase.instance.insertBookingWithItems(
          booking,
          const [
            CartItem(movieData: testMovie, quantity: 1),
            CartItem(movieData: failMovie, quantity: 1),
          ],
        ),
        throwsException,
      );

      expect(await CinemaDatabase.instance.getAllBookings(), isEmpty);
      expect(
        await db.query('booking_items'),
        isEmpty,
      );
    });

    test("rejects a booking item with an unknown booking id", () async {
      final Database db = await CinemaDatabase.instance.database;
      await expectLater(
        db.insert('booking_items', <String, Object?>{
          'booking_id': 999,
          'movie_id': 'crimson-tide',
          'title': 'Crimson Tide',
          'quantity': 1,
          'unit_price': 7.5,
        }),
        throwsException,
      );
    });

    test("v1 upgrade preserves existing bookings and creates booking_items",
        () async {
      await CinemaDatabase.instance.close();
      final Database v1 = await databaseFactoryFfiNoIsolate.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onConfigure: (Database db) async {
            await db.execute('PRAGMA foreign_keys = ON');
          },
          onCreate: (Database db, int version) async {
            await db.execute('''
              CREATE TABLE bookings (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                booking_number INTEGER NOT NULL,
                summary TEXT NOT NULL,
                total REAL NOT NULL,
                date TEXT NOT NULL
              )
            ''');
          },
        ),
      );
      await v1.insert('bookings', <String, Object?>{
        'booking_number': 1001,
        'summary': '1x Crimson Tide',
        'total': 7.5,
        'date': '01/01/1970 00:00',
      });
      CinemaDatabase.instance.setDatabase(v1);
      await CinemaDatabase.instance.upgradeDB(v1, 1, 2);

      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      expect(bookings.length, 1);
      expect(bookings[0].bookingNumber, 1001);
      expect(
        await v1.rawQuery(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name = 'booking_items'",
        ),
        isNotEmpty,
      );
    });
  });
}
