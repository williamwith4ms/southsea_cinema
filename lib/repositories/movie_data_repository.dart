import 'package:southsea_cinema/models/movie_data.dart';

class MovieDataRepository {
  List<MovieData> getAllMovies() {
    return [
      MovieData(
        id: "crimson-tide",
        title: "Crimson Tide",
        year: 1995,
        rating: "R",
        description:
            "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.",
        imagePath: "assets/images/crimson-tide.jpg",
        date: "Thurs, 22th Oct 2026, 18:00",
        price: 7.50
      ),
      MovieData(
        id: "avatar",
        title: "Avatar",
        year: 2009,
        rating: "PG-13",
        description:
            "A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.",
        imagePath: "assets/images/avatar.jpg",
        date: "Fri, 23th Oct 2026, 18:00",
        price: 8.00
      ),
      MovieData(
          id: "1917",
          title: "1917",
          year: 2019,
          rating: "R",
          description:
              "April 6th, 1917. As an infantry battalion assembles to wage war deep in enemy territory, two soldiers are assigned to race against time and deliver a message that will stop 1,600 men from walking straight into a deadly trap.",
          imagePath: "assets/images/1917.jpg",
          date: "Sat, 24th Oct 2026, 18:00",
          price: 7.50  
        )
    ];
  }
}
