import 'package:southsea_cinema/models/movie_data.dart';

class CartItem {
  final MovieData movieData;
  final int quantity;

  const CartItem({required this.movieData, required this.quantity});

  double get lineTotal => movieData.price * quantity;
}