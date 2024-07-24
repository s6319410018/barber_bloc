import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopSnackBar extends StatelessWidget {
  final String message;
  final Color color;

  const TopSnackBar({
    Key? key,
    required this.message,
    this.color = Colors.amber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: color,
          child: Text(
            message,
            style: GoogleFonts.kanit(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
