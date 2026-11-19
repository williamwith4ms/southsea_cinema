import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

const MovieData testMovie = MovieData(
    id: "crimson-tide",
    title: "Crimson Tide",
    year: 1995,
    rating: "R",
    description:
        "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.",
    imagePath: "assets/images/crimson-tide.jpg",
    date: "Thr, 22nd Oct 2026, 18:00",
    price: 7.50);
void main() {
  group("MovieCard tests ", () {
    testWidgets("MovieCard displays correct title and description",
        (WidgetTester tester) async {
      final MovieCard movieCard = MovieCard(
        movieData: testMovie,
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: movieCard)));

      expect(find.text("Crimson Tide"), findsOneWidget);
      expect(
          find.text(
              "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so."),
          findsOneWidget);
    });

    testWidgets("MovieCard displays correct image when it exists",
        (WidgetTester tester) async {
      final MovieCard movieCard = MovieCard(
        movieData: testMovie,
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: movieCard)));

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        "MovieCard displays placeholder image when image does not exist",
        (WidgetTester tester) async {
      final MovieData movieWithoutImage = MovieData(
        id: "no-image-movie",
        title: "No Image Movie",
        year: 1970,
        rating: "PG",
        description: "A movie without an image",
        imagePath: "assets/images/non_existent_image.jpg",
        date: "01/01/1970 00:00",
        price: 10.0,
      );

      final MovieCard movieCard = MovieCard(
        movieData: movieWithoutImage,
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: movieCard)));
      await tester.pumpAndSettle();

      expect(find.text("Image Unavailable"), findsOneWidget);
    });
  });
}
