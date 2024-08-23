import 'package:flutter/material.dart';
import 'dart:convert';

class Avatar extends StatelessWidget {
  final String? image;
  final bool isDarkMode;
  final String? email;

  const Avatar({super.key, this.image, required this.isDarkMode, this.email});

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.9)
                      : Colors.black.withOpacity(0.9),
                  spreadRadius: 2,
                  blurRadius: 2,
                  blurStyle: BlurStyle.normal,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: isDarkMode ? Colors.white : Colors.black,
              backgroundImage: MemoryImage(
                base64Decode(image!),
              ),
            ),
          )
        : CircleAvatar(
            radius: 40,
            backgroundColor: isDarkMode ? Colors.white : Colors.black,
            child: Text(
              email?.isNotEmpty == true ? email![0].toUpperCase() : '?',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          );
  }
}
