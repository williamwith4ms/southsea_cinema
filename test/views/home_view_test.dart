import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/movie_data_repository.dart';
import 'package:southsea_cinema/views/home_view.dart';

class SuccessfulMovieRepository extends MovieDataRepository {
  @override
  Future<List<MovieData>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    return const [
      MovieData(
        id: "test-movie",
        title: "Test Movie",
        year: 2026,
        rating: "PG",
        description: "Test movie description",
        imagePath: "assets/images/test.jpg",
        date: "Thu, 22nd Oct 2026, 18:00",
        price: 7.50,
      ),
    ];
  }
}

class FailingMovieRepository extends MovieDataRepository {
  @override
  Future<List<MovieData>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    throw Exception("asset unavailable");
  }
}

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    rootBundle.clear();
  });

  group("Home View Tests", () {
    testWidgets("App loads and contains movie cards",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.byType(MovieCard), findsWidgets);
    });

    testWidgets("Home view displays title", (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.text('Southsea Cinema & Art Centre'), findsOneWidget);
    });

    testWidgets("Check the first card loads and contains the correct data",
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.text("Crimson Tide"), findsOneWidget);
      expect(
          find.text(
              "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so."),
          findsOneWidget);
    });

    testWidgets("Home view shows loading indicator while movies load",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeView()),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

  });
}
