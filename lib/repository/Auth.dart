import 'dart:convert';

import 'package:barber_bloc/model/model_response.dart';
import 'package:barber_bloc/repository/Get_token.dart';

import '../model/model_user.dart';
import 'package:http/http.dart' as http;

class Domain {
  static String Url = "http://192.168.100.230:3000";
}

class Auth {
  static Future<String> register(User user) async {
    final url = Uri.parse('${Domain.Url}/api/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );
      final Response_Body = jsonDecode(response.body);
      switch (response.statusCode) {
        case 201:
          return Response_Body["message"];
        case 400:
          return Response_Body["message"];
        case 401:
          return Response_Body["message"];
        case 403:
          return Response_Body["message"];
        case 404:
          return Response_Body["message"];
        case 500:
          return Response_Body["message"];
        default:
          return 'Unexpected error: ${response.statusCode}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  static Future<LoginResponse> login(User user) async {
    final url = Uri.parse('${Domain.Url}/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      final responseBody = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          return LoginResponse(token: responseBody["token"]);
        case 400:
        case 401:
        case 403:
        case 404:
        case 500:
          return LoginResponse(
              message: responseBody["message"] ?? 'An error occurred');
        default:
          return LoginResponse(message: 'Login Failed');
      }
    } catch (e) {
      return LoginResponse(message: 'An error occurred: $e');
    }
  }

  static Future<User> getData(String? token) async {
    String? tokenStore = token ?? await Token.getToken();

    if (tokenStore == null) {
      throw Exception('Token is null');
    }

    final url = Uri.parse('${Domain.Url}/api/auth/me');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenStore',
      },
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return User.fromJson(responseBody);
    } else {
      throw Exception('Failed to load user data :${response.statusCode}');
    }
  }
}
