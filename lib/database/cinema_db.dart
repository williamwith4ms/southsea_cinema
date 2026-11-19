import 'package:path/path.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:sqflite/sqflite.dart';

class CinemaDatabase {
  CinemaDatabase._internal();

  static final CinemaDatabase instance = CinemaDatabase._internal();

  static Database? _database;

  void setDatabase(Database database) {
    _database = database;
  }

  Future<Database> get database async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      return cachedDatabase;
    }
    final Database db = await _initDB('cinema_data.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filePath = join(folder, fileName);
    final Database db = await openDatabase(
      filePath,
      version: 2,
      onCreate: _createDB,
      onUpgrade: upgradeDB,
    );
    return db;
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    if (version >= 2) {
      await _createBookingItemsTable(db);
    }
  }

  Future<void> _createBookingItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE booking_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_id INTEGER NOT NULL,
        movie_id TEXT NOT NULL,
        title TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> upgradeDB(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2 && newVersion >= 2) {
      await _createBookingItemsTable(db);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1001,
      'summary': '',
      'total': 7.5,
      'date': "2026-11-18 23:45",
    });

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1002,
      'summary': '',
      'total': 7.5,
      'date': "2026-11-18 23:30",
    });

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1003,
      'summary': '',
      'total': 7.5,
      'date': "2026-11-18 23:32",
    });
  }

  Future<void> insertBooking(Booking booking) async {
    final Database db = await database;
    await db.insert('bookings', booking.toMap());
  }

  Future<int> insertBookingWithItems(
    Booking booking,
    List<CartItem> items,
  ) async {
    final Database db = await database;
    return db.transaction<int>((Transaction transaction) async {
      final int bookingId = await transaction.insert(
        'bookings',
        booking.toMap(),
      );

      for (final CartItem item in items) {
        await transaction.insert(
          'booking_items',
          <String, Object?>{
            'booking_id': bookingId,
            'movie_id': item.movieData.id,
            'title': item.movieData.title,
            'quantity': item.quantity,
            'unit_price': item.movieData.price,
          },
        );
      }
      return bookingId;
    });
  }

  Future<List<Map<String, Object?>>> getBookingItems(int bookingId) async {
    final Database db = await database;
    return db.query(
      'booking_items',
      where: 'booking_id = ?',
      whereArgs: <Object?>[bookingId],
      orderBy: 'id ASC',
    );
  }

  Future<List<Booking>> getAllBookings() async {
    final Database db = await database;
    final List<Map<String, Object?>> records =
        await db.query('bookings', orderBy: 'booking_number DESC');

    final List<Booking> bookings = [];
    for (final Map<String, Object?> row in records) {
      final Booking booking = Booking.fromMap(row);
      final int? bookingId = booking.id;
      final List<BookingItem> items = [];
      if (bookingId != null) {
        final List<Map<String, Object?>> itemRecords = await db.query(
          'booking_items',
          where: 'booking_id = ?',
          whereArgs: <Object?>[bookingId],
          orderBy: 'id ASC',
        );
        items.addAll(
          itemRecords.map(BookingItem.fromMap),
        );
      }
      bookings.add(
        Booking(
          id: booking.id,
          bookingNumber: booking.bookingNumber,
          summary: booking.summary,
          total: booking.total,
          date: booking.date,
          items: items,
        ),
      );
    }
    return bookings;
  }

  Future<int> getNextBookingNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db
        .rawQuery('SELECT MAX(booking_number) as max_num FROM bookings');

    if (records.isEmpty) {
      return 1001;
    }

    final Object? maxValue = records[0]['max_num'];
    if (maxValue == null) {
      return 1001;
    }

    final int cuurrentMax = maxValue as int;
    return cuurrentMax + 1;
  }

  Future<void> close() async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
}
