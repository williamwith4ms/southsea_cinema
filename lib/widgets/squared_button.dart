import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

class SquaredButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SquaredButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: cinemaBrand,
        foregroundColor: cinemaFontWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
