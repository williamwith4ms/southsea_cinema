class BookingItem {
  final int? id;
  final int bookingId;
  final String movieId;
  final String title;
  final int quantity;
  final double unitPrice;

  const BookingItem({
    this.id,
    required this.bookingId,
    required this.movieId,
    required this.title,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => unitPrice * quantity;

  factory BookingItem.fromMap(Map<String, Object?> map) {
    return BookingItem(
      id: map['id'] as int?,
      bookingId: map['booking_id'] as int,
      movieId: map['movie_id'] as String,
      title: map['title'] as String,
      quantity: map['quantity'] as int,
      unitPrice: map['unit_price'] as double,
    );
  }
}

class Booking {
  final int? id;
  final int bookingNumber;
  final String summary;
  final double total;
  final String date;
  final List<BookingItem> items;

  const Booking({
    this.id,
    required this.bookingNumber,
    required this.summary,
    required this.total,
    required this.date,
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    final Map<String, Object?> data = <String, Object?>{
      'booking_number': bookingNumber,
      'summary': summary,
      'total': total,
      'date': date,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  factory Booking.fromMap(Map<String, Object?> map) {
    final int bookingNumber = map['booking_number'] as int;
    final String summary = map['summary'] as String;
    final double total = map['total'] as double;
    final String date = map['date'] as String;

    return Booking(
      id: map['id'] as int?,
      bookingNumber: bookingNumber,
      summary: summary,
      total: total,
      date: date,
      items: const [],
    );
  }
}
