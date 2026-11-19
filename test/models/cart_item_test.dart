import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie_data.dart';

void main() {
  group('CartItem Tests', () {
    test('CartItem initializes with correct values', () {
      final cartItem = CartItem(
        movieData: MovieData(
          id: 'test-movie',
          title: 'Test Movie',
          year: 2023,
          rating: 'PG',
          description: 'A test movie description.',
          imagePath: 'assets/images/test_movie.jpg',
          date: '01/01/2023 20:00',
          price: 10.0,
        ),
        quantity: 2,
      );

      expect(cartItem.movieData.title, 'Test Movie');
      expect(cartItem.quantity, 2);
    });

    test('CartItem lineTotal calculates correctly', () {
      final cartItem = CartItem(
        movieData: MovieData(
          id: 'test-movie',
          title: 'Test Movie',
          year: 2023,
          rating: 'PG',
          description: 'A test movie description.',
          imagePath: 'assets/images/test_movie.jpg',
          date: '01/01/2023 20:00',
          price: 10.0,
        ),
        quantity: 3,
      );

      expect(cartItem.lineTotal, 30.0);
    });
  });
}
