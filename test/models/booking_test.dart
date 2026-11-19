import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';

void main() {
  const Booking testBooking = Booking(
    bookingNumber: 1001,
    summary: "1x Crimson Tide",
    total: 7.5,
    date: "01/01/1970 00:00",
  );
  group("Booking Model Tests", () {
    test("Booking model properties are set correctly", () {
      final Booking booking = Booking(
        bookingNumber: 1001,
        summary: "1x Crimson Tide",
        total: 7.5,
        date: "01/01/1970 00:00",
      );

      expect(booking.bookingNumber, 1001);
      expect(booking.summary, "1x Crimson Tide");
      expect(booking.total, 7.5);
      expect(booking.date, "01/01/1970 00:00");
    });

    test("new Bookings omit database ids and convert to map", () {
      expect(testBooking.id, isNull);
      expect(testBooking.toMap(), {
        'booking_number': 1001,
        'summary': "1x Crimson Tide",
        'total': 7.5,
        'date': "01/01/1970 00:00",
      });
    });

    test("A database map converts back into an order", () {
      final Map<String, Object?> bookingMap = {
        'id': 1,
        'booking_number': 1001,
        'summary': "1x Crimson Tide",
        'total': 7.5,
        'date': "01/01/1970 00:00",
      };

      final Booking restoredBooking = Booking.fromMap(bookingMap);
      expect(restoredBooking.id, 1);
      expect(restoredBooking.bookingNumber, 1001);
      expect(restoredBooking.summary, "1x Crimson Tide");
      expect(restoredBooking.total, 7.5);
      expect(restoredBooking.date, "01/01/1970 00:00");
      expect(restoredBooking.toMap(), bookingMap);
    });

    test("Whole number SQLite values are converted to doubles", () {
      final Map<String, Object?> bookingMap = {
        'id': 1,
        'booking_number': 1001,
        'summary': "1x Crimson Tide",
        'total': 7.0,
        'date': "01/01/1970 00:00",
      };

      final Booking restoredBooking = Booking.fromMap(bookingMap);
      expect(restoredBooking.total, isA<double>());
    });
  });
}
