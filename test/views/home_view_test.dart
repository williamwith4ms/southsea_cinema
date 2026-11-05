import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:flutter/services.dart';

void main() {
  setUp(() {
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
  });
}
