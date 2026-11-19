import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/squared_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BasketViewState();
  }
}

class _BasketViewState extends State<BasketView> {
  String _confirmationMessage = '';
  List<Booking> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final CinemaDatabase database = CinemaDatabase.instance;
      final List<Booking> bookings = await database.getAllBookings();
      if (!mounted) {
        return;
      }
      setState(() {
        _bookings = bookings;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildBookingList() {
    if (_bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text("No bookings found."),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Past Bookings",
          style: cinemaHeaderStyle,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _bookings.length,
          itemBuilder: (BuildContext context, int index) {
            final Booking booking = _bookings[index];
            return Card(
              color: cinemaSurface,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booking Number: ${booking.bookingNumber}"),
                    Text("Summary: ${booking.summary}"),
                    Text("Total: £${booking.total.toStringAsFixed(2)}"),
                    Text("Date: ${booking.date}"),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          "Your basket is empty.",
        ),
      ),
    );
  }

  String _buildSummary(List<CartItem> items) {
    final List<String> parts = [];
    for (final CartItem item in items) {
      parts.add('${item.quantity}x ${item.movieData.title}');
    }
    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String year = now.year.toString();

    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Widget _buildLineItem(CartRepository cart, CartItem item) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${item.quantity} Tickets",
                style: const TextStyle(color: cinemaBrand)),
            SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${item.quantity} Standard"),
                Text("${item.movieData.title} (${item.movieData.year})"),
                Text(item.movieData.date),
                Text(item.movieData.rating),
              ],
            ),
            Row(
              children: [
                Text("£${item.lineTotal.toStringAsFixed(2)}"),
                SizedBox(width: 8.0),
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: cinemaBrand, borderRadius: BorderRadius.zero),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          cart.removeItem(cart.getItems().indexOf(item));
                        });
                      },
                      icon: Icon(Icons.delete)),
                )
              ],
            ),
          ],
        ));
  }

  Widget _buildTotalRow(String label, double amount, {bool emphasise = false}) {
    final TextStyle style;
    if (emphasise) {
      style = const TextStyle(fontWeight: FontWeight.bold);
    } else {
      style = const TextStyle();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text("£${amount.toStringAsFixed(2)}", style: style),
        ],
      ),
    );
  }

  Widget _buildBasketList(CartRepository cart, List<CartItem> items) {
    final List<Widget> children = [];

    children.add(const Text(
      "Your Order",
      style: cinemaHeaderStyle,
    ));

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("Item"),
        Text("Details"),
        Text("Price          "),
      ],
    ));

    for (int index = 0; index < items.length; index++) {
      final CartItem item = items[index];
      children.add(_buildLineItem(cart, item));
    }

    children.add(_buildTotalRow("Subtotal", cart.getSubtotal()));
    children.add(_buildTotalRow("Booking Fee", cart.getBookingFee()));
    children
        .add(_buildTotalRow("Total", cart.getTotalPrice(), emphasise: true));

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                cart.clearCart();
                _confirmationMessage = "Your cart has been cleared";
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: cinemaSurface,
                foregroundColor: cinemaFontWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            child: const Text("Cancel Order")),
        SquaredButton(
            label: "Buy Tickets",
            onPressed: () {
              _checkout(cart, items);
            })
      ],
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Future<void> _checkout(CartRepository cart, List<CartItem> items) async {
    final String summary = _buildSummary(items);
    final double total = cart.getTotalPrice();
    final String date = _formatDate(DateTime.now());

    try {
      final CinemaDatabase database = CinemaDatabase.instance;
      final int bookingNumber = await database.getNextBookingNumber();
      final Booking booking = Booking(
        bookingNumber: bookingNumber,
        summary: summary,
        total: total,
        date: date,
      );
      await database.insertBooking(booking);
      cart.clearCart();
      await _loadBookings();

      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage =
            "Your order (no. $bookingNumber) has been placed successfully";
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage =
            "An error occurred while placing your order: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> cartItems = cart.getItems();

    final Widget content;

    if (_loading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (cartItems.isEmpty) {
        if (_confirmationMessage.isNotEmpty) {
          content = Column(
            children: [
              _buildEmptyState(),
              SizedBox(height: 16.0),
              Text(_confirmationMessage),
              SizedBox(height: 16.0),
              _buildBookingList(),
            ],
          );
        } else {
          content = Column(
            children: [
              _buildEmptyState(),
              SizedBox(height: 16.0),
              _buildBookingList(),
            ],
          );
        }
      } else {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasketList(cart, cartItems),
            SizedBox(height: 16.0),
            _buildBookingList(),
          ],
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            appTitle,
          ),
        ),
        drawer: const NavDrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ));
  }
}
