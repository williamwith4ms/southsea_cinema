import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie_data.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/squared_button.dart';

// class MovieListing extends StatelessWidget {
// const MovieListing({super.key});
//
// @override
// Widget build(BuildContext context) {}
// }

class MovieListing extends StatefulWidget {
  final int maxTickets = 5;
  final MovieData movieData;

  const MovieListing({super.key, required this.movieData});

  @override
  State<StatefulWidget> createState() {
    return _MovieListingState();
  }
}

class _MovieListingState extends State<MovieListing> {
  int _tickets = 0;
  String _confirmation_message = "";

  void _addToBasket() {
    if (_tickets > 0) {
      final CartItem item =
          CartItem(movieData: widget.movieData, quantity: _tickets);
      CartRepository.instance.addItem(item);
      setState(() {
        _confirmation_message = "Added $_tickets tickets to your basket.";
      });
    } else {
      setState(() {
        _confirmation_message = "Please select at least one ticket.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.movieData.title,
                  style: cinemaHeaderStyle,
                ),
                SizedBox(width: 16.0),
                Text(
                  "${widget.movieData.year} ${widget.movieData.rating}",
                  style: movieListingSubStyle,
                )
              ],
            ),
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(children: [
                  Text(widget.movieData.date, style: movieListingSubStyle),
                ]);
              } else {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.movieData.date, style: movieListingSubStyle),
                    ]);
              }
            }),
            SizedBox(height: 16),
            Text(
              widget.movieData.description,
              style: movieListingBodyStyle,
            ),
            SizedBox(height: 16),
            Text(
              "Please note that Discounts / Membership benefits will be applied once you have selected your tickets",
              style: movieListingBodyStyle,
            ),
            SizedBox(height: 16),
            Text("Tickets", style: cinemaHeaderStyle),
            Text("(Select quantity up to 5 total)",
                style: movieListingSubStyle),
            SizedBox(height: 16),
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: cinemaFontWhite),
                      child: DropdownMenu(
                        textStyle: TextStyle(color: cinemaBackground),
                        initialSelection: 0,
                        onSelected: (int? value) {
                          if (value != null) {
                            setState(() {
                              _tickets = value;
                            });
                          }
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: 0, label: "0"),
                          DropdownMenuEntry(value: 1, label: "1"),
                          DropdownMenuEntry(value: 2, label: "2"),
                          DropdownMenuEntry(value: 3, label: "3"),
                          DropdownMenuEntry(value: 4, label: "4"),
                          DropdownMenuEntry(value: 5, label: "5")
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Adult ${widget.movieData.formattedPrice}",
                        style: movieListingBodyStyle)
                  ],
                );
              } else {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: cinemaFontWhite),
                      child: DropdownMenu(
                        textStyle: TextStyle(color: cinemaBackground),
                        initialSelection: 0,
                        onSelected: (int? value) {
                          if (value != null) {
                            setState(() {
                              _tickets = value;
                            });
                          }
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: 0, label: "0"),
                          DropdownMenuEntry(value: 1, label: "1"),
                          DropdownMenuEntry(value: 2, label: "2"),
                          DropdownMenuEntry(value: 3, label: "3"),
                          DropdownMenuEntry(value: 4, label: "4"),
                          DropdownMenuEntry(value: 5, label: "5")
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Adult ${widget.movieData.formattedPrice}",
                        style: movieListingBodyStyle)
                  ],
                );
              }
            }),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: cinemaBrand),
                  child: SquaredButton(
                    label: "Add to Order",
                    onPressed: () {
                      setState(() {
                        _addToBasket();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(_confirmation_message, style: movieListingBodyStyle)
              ],
            )
          ],
        ),
      ),
    );
  }
}
