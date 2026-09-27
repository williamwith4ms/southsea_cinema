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
        child: Column(
          children: [
            Row(children: [
              Text("Crimson Tide (1995)"),
              SizedBox(width: 16),
              Text("(R) 1h 56m")
            ]),
            Text(
                "On a U.S. nuclear missile sub, a young First Officer stages a mutiny to prevent his trigger-happy Captain from launching his missiles before confirming his orders to do so."),
            Row(
              children: [
                DropdownMenu(
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
                Text("Adult (£7.50)")
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _orderedTickets += _dropdownTickets;
                  });
                },
                child: Text("Add to Order")),
            OrderStatus(_orderedTickets)
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
    return Text("$tickets tickets added");
  }
}
