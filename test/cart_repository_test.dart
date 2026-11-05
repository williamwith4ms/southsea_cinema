import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';

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
  group("CartRepository Tests", () {
    test("Starts with an empty cart and all totals are zero or defaults", () {
      final cartRepository = CartRepository.instance;
      expect(cartRepository.getItems().length, 0);
      expect(cartRepository.totalItemCount, 0);
      expect(cartRepository.getSubtotal(), 0.0);
      expect(cartRepository.getBookingFee(), 1.50);
      expect(cartRepository .getTotalPrice(), 1.50);
    });
  });

  test("Adding items to the cart updates totals correctly", () {
    final cartRepository = CartRepository.instance;

    cartRepository.addItem(const CartItem(movieData: testMovie1, quantity: 2));
    cartRepository.addItem(const CartItem(movieData: testMovie2, quantity: 1));

    expect(cartRepository.getItems().length, 2);
    expect(cartRepository.getTotalItems(), 3);
    expect(cartRepository.totalItemCount, 3);
    expect(cartRepository.getSubtotal(), 23.0);
    expect(cartRepository.getBookingFee(), 1.50);
    expect(cartRepository.getTotalPrice(), 24.50);
  });

  test("Removing items from the cart updates totals correctly", () {
    final cartRepository = CartRepository.instance;

    cartRepository.addItem(const CartItem(movieData: testMovie1, quantity: 2));
    cartRepository.addItem(const CartItem(movieData: testMovie2, quantity: 1));

    cartRepository.removeItem(0);

    expect(cartRepository.getItems().length, 1);
    expect(cartRepository.getTotalItems(), 1);
    expect(cartRepository.totalItemCount, 1);
    expect(cartRepository.getSubtotal(), 8.0);
    expect(cartRepository.getBookingFee(), 1.50);
    expect(cartRepository.getTotalPrice(), 9.50);
  });

  test("Clearing the cart resets totals correctly", () {
    final cartRepository = CartRepository.instance;

    cartRepository.addItem(const CartItem(movieData: testMovie1, quantity: 2));
    cartRepository.addItem(const CartItem(movieData: testMovie2, quantity: 1));

    cartRepository.clearCart();

    expect(cartRepository.getItems().length, 0);
    expect(cartRepository.getTotalItems(), 0);
    expect(cartRepository.totalItemCount, 0);
    expect(cartRepository.getSubtotal(), 0.0);
    expect(cartRepository.getBookingFee(), 1.50);
    expect(cartRepository.getTotalPrice(), 1.50);
  });
}