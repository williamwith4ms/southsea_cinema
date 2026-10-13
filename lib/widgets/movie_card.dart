import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie_data.dart';

class MovieCard extends StatelessWidget {
  final MovieData movieData;

  const MovieCard({super.key, required this.movieData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinemaSurface,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(movieData.title, style: cinemaHeaderStyle),
                SizedBox(
                  width: 16.0,
                ),
                Text("(${movieData.rating})", style: movieListingSubStyle),
                SizedBox(
                  width: 16.0,
                ),
                Text(movieData.year.toString(), style: movieListingSubStyle)
              ],
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image.asset(
                movieData.imagePath,
                width: 120,
                height: 180,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text(movieData.description),
                  ],
                ),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(movieData.date),
                Container(
                  decoration: BoxDecoration(color: cinemaBrand),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Order Tickets",
                        style: movieListingBodyStyle,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
