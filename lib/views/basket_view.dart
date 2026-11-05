import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
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
        SquaredButton(label: "Update Order", onPressed: () {}),
        SquaredButton(
            label: "Buy Tickets",
            onPressed: () {
              setState(() {
                cart.clearCart();
                _confirmationMessage =
                    "Your order has been placed successfully";
              });
            })
      ],
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> cartItems = cart.getItems();

    final Widget content;
    if (cartItems.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          children: [
            _buildEmptyState(),
            SizedBox(height: 16.0),
            Text(_confirmationMessage),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasketList(cart, cartItems);
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
