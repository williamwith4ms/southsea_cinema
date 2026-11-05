import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/movie_data_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Movie Data Repository Tests", () {
    test("getAllMovies returns 1 movie", () {
      final MovieDataRepository repository = MovieDataRepository();
      final List allMovies = repository.getAllMovies();

      expect(allMovies.length, 1);
    });

    test("getAllMovies contains valid movie data", () {
      final MovieDataRepository repository = MovieDataRepository();
      final List<MovieData> allMovies = repository.getAllMovies();

      final MovieData crimsonTide = allMovies[0];
      expect(crimsonTide.id, "crimson-tide");
      expect(crimsonTide.title, "Crimson Tide");
      expect(crimsonTide.year, 1995);
      expect(crimsonTide.imagePath, isNotEmpty);
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

    test("loadMoviesFromAsset reads the bundled JSON file", () async {
      final MovieDataRepository repository = MovieDataRepository();
      final List<MovieData> movies = await repository.loadMoviesFromAsset();

      expect(movies.length, 3);
      expect(movies[0].id, "crimson-tide");
      expect(movies[1].id, "avatar");
      expect(movies[2].id, "1917");

      expect(repository.getAllMovies(), movies);
    });

  });

}
