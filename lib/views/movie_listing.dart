import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

// class MovieListing extends StatelessWidget {
// const MovieListing({super.key});
//
// @override
// Widget build(BuildContext context) {}
// }

class MovieListing extends StatefulWidget {
  final int maxTickets = 5;

  const MovieListing({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MovieListingState();
  }
}

class _MovieListingState extends State<MovieListing> {
  int _dropdownTickets = 0;
  int _orderedTickets = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                "Crimson Tide (1995)",
                style: cinemaHeaderStyle,
              ),
              SizedBox(width: 16),
              Text("(R) 1h 56m", style: cinemaHeaderStyle),
            ]),
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(children: [
                  Text("Screen 3 - ", style: movieListingSubStyle),
                  Text("Thursday 22 Oct 2026, 18:00",
                      style: movieListingSubStyle),
                  Text(" - Ends at 19:56", style: movieListingSubStyle)
                ]);
              } else {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("- Screen 3", style: movieListingSubStyle),
                      Text("- Thursday 22 Oct 2026, 18:00",
                          style: movieListingSubStyle),
                      Text("- Ends at 19:56", style: movieListingSubStyle)
                    ]);
              }
            }),
            SizedBox(height: 16),
            Text(
              "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so.",
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
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: cinemaFontWhite),
                  child: DropdownMenu(
                    textStyle: TextStyle(color: cinemaBackground),
                    initialSelection: 0,
                    onSelected: (int? value) {
                      if (value != null) {
                        setState(() {
                          _dropdownTickets = value;
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
                Text("Adult (£7.50)", style: movieListingBodyStyle)
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: cinemaBrand),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          _orderedTickets = _dropdownTickets;
                        });
                      },
                      child: Text(
                        "Add to Order",
                        style: movieListingBodyStyle,
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                OrderStatus(_orderedTickets),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final int tickets;

  const OrderStatus(this.tickets, {super.key});

  @override
  Widget build(BuildContext context) {
    if (tickets == 0) {
      return Text("");
    }
    return Text(
      "$tickets ticket package in order",
      style: movieListingSubStyle,
    );
  }
}
