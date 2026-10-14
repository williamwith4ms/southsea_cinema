import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie_data.dart';

void main() {
  group("Movie Data Tests", () {
    test("create and test movie data with given paramaters", () {
      const MovieData movieData = MovieData(
          id: "crimson-tide",
          title: "Crimson Tide",
          year: 1995,
          rating: "R",
          description:
              "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.",
          imagePath: "assets/images/crimson-tide.jpg",
          date: "Thurs, 22th Oct 2026, 18:00",
          price: 7.50);

      expect(movieData.id, "crimson-tide");
      expect(movieData.title, "Crimson Tide");
      expect(movieData.year, 1995);
      expect(movieData.rating, "R");
      expect(movieData.description,
          "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.");
      expect(movieData.imagePath, "assets/images/crimson-tide.jpg");
      expect(movieData.date, "Thurs, 22th Oct 2026, 18:00");
      expect(movieData.price, 7.50);
    });

    group("formatedPrice tests", () {
      test("formattedPrice returns correct string for whole pound price", () {
        const MovieData movieData = MovieData(
            id: "crimson-tide",
            title: "Crimson Tide",
            year: 1995,
            rating: "R",
            description:
                "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.",
            imagePath: "assets/images/crimson-tide.jpg",
            date: "Thurs, 22th Oct 2026, 18:00",
            price: 7.00);

        expect(movieData.formattedPrice, '£7.00');
      });
      test("formattedPrice returns correct string for price with pence", () {
        const MovieData movieData = MovieData(
            id: "crimson-tide",
            title: "Crimson Tide",
            year: 1995,
            rating: "R",
            description:
                "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.",
            imagePath: "assets/images/crimson-tide.jpg",
            date: "Thurs, 22th Oct 2026, 18:00",
            price: 7.99);

        expect(movieData.formattedPrice, '£7.99');
      });
    });
  });
}
