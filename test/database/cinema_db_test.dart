import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'package:southsea_cinema/database/cinema_db.dart';

void main() {
  setUp(() async {
    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
          version: 1, onCreate: CinemaDatabase.instance.createTables),
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
      expect(bookings[0].summary, "1x Crimson Tide");
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
  });
}
