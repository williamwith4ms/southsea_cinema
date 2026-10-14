import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/movie_data_repository.dart';

void main() {
  group("Movie Data Repository Tests", () {
    test("getAllMovies returns 3 movies", () {
      final MovieDataRepository repository = MovieDataRepository();
      final List allMovies = repository.getAllMovies();

      expect(allMovies.length, 3);
    });

    test("getAllMovies contains valid movie data", () {
      final MovieDataRepository repository = MovieDataRepository();
      final List<MovieData> allMovies = repository.getAllMovies();

      final MovieData crimsonTide = allMovies[0];
      expect(crimsonTide.id, "crimson-tide");
      expect(crimsonTide.title, "Crimson Tide");
      expect(crimsonTide.year, 1995);
      expect(crimsonTide.imagePath, isNotEmpty);

      final MovieData avatar = allMovies[1];
      expect(avatar.id, "avatar");
      expect(avatar.title, "Avatar");
      expect(avatar.year, 2009);
      expect(avatar.imagePath, isNotEmpty);

      final MovieData nineteenSeventeen = allMovies[2];
      expect(nineteenSeventeen.id, "1917");
      expect(nineteenSeventeen.title, "1917");
      expect(nineteenSeventeen.year, 2019);
      expect(nineteenSeventeen.imagePath, isNotEmpty);
    });

    group("getMovieDataById tests", () {
      test("getMovieDataById returns correct movie for existing id", () {
        final MovieDataRepository repository = MovieDataRepository();
        final movie = repository.getMovieDataById("crimson-tide");

        expect(movie?.id, "crimson-tide");
        expect(movie?.title, "Crimson Tide");
        expect(movie?.year, 1995);
        expect(movie?.description,
            "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.");
      });
      test("getMovieDataById returns null for non-existing id", () {
        final MovieDataRepository repository = MovieDataRepository();
        final movie = repository.getMovieDataById("fantastic-mr-fox");

        expect(movie, null);
      });
    });
  });
}
