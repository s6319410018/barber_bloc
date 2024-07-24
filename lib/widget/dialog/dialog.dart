import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Future<void> basic_dialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        backgroundColor: Colors.amber,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
