import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/movie_data_repository.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  

  @override
  Widget build(BuildContext context) {
    final MovieDataRepository repository = MovieDataRepository();
    final List<MovieData> movieData = repository.getAllMovies();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: cinemaHeaderStyle,
        ),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      // body: const Center(
      //   child: Padding(
      //     padding: EdgeInsets.all(16.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           'Welcome to $appTitle',
      //           style: TextStyle(
      //             color: cinemaFontWhite,
      //             fontSize: 22,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: ListView.builder(itemCount: movieData.length, itemBuilder:(context, index) {
        return MovieCard(movieData: movieData[index]);
      },)
    );
  }
}
