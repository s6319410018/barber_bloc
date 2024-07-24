import 'dart:convert';

import '../model/model_user.dart';
import 'package:http/http.dart' as http;

class Auth {
  static Future<String> register(User user) async {
    final url = Uri.parse('http://192.168.100.230:3000/api/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return 'success';
      } else {
        return 'faile';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}
