import 'dart:convert';
import 'package:barber_bloc/repository/Domain.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;
import '../model/model_response.dart';
import '../model/model_user.dart';
import 'package:barber_bloc/repository/Get_token.dart';

import 'HttpStatus.dart';

class AuthRepository {
  Future<String> register(User user) async {
    final url = Uri.parse('${Domain.Url}/api/auth/register');

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
        case HttpStatusCodes.created:
          return 'User registered successfully';
        case HttpStatusCodes.badRequest:
          return responseBody["message"] ??
              'Bad request: ${response.statusCode}';
        case HttpStatusCodes.unauthorized:
          return responseBody["message"] ??
              'Unauthorized access: ${response.statusCode}';
        case HttpStatusCodes.forbidden:
          return responseBody["message"] ?? 'Forbidden: ${response.statusCode}';
        case HttpStatusCodes.notFound:
          return responseBody["message"] ?? 'Not found: ${response.statusCode}';
        case HttpStatusCodes.internalServerError:
          return responseBody["message"] ??
              'Internal server error: ${response.statusCode}';
        default:
          return 'Unexpected error: ${response.statusCode}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  Future<LoginResponse> login(User user) async {
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
        case HttpStatusCodes.ok:
          return LoginResponse(token: responseBody["token"]);
        case HttpStatusCodes.badRequest:
        case HttpStatusCodes.unauthorized:
        case HttpStatusCodes.forbidden:
        case HttpStatusCodes.notFound:
        case HttpStatusCodes.internalServerError:
          return LoginResponse(
              message: responseBody["message"] ?? 'An error occurred');
        default:
          return LoginResponse(message: 'Login Failed');
      }
    } catch (e) {
      return LoginResponse(message: 'An error occurred: $e');
    }
  }

  Future<User> getData(String? token) async {
    final tokenStore = token ?? await Token.getToken();

    if (tokenStore == null) {
      throw Exception('Token is null');
    }

    final url = Uri.parse('${Domain.Url}/api/auth/me');
    final validateUrl = Uri.parse('${Domain.Url}/api/auth/expire_token');

    try {
      final validateResponse = await http.get(validateUrl, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenStore',
      });

      if (validateResponse.statusCode == HttpStatusCodes.ok) {
        final validate = jsonDecode(validateResponse.body);

        if (validate["message"] == false) {
          final response = await http.get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $tokenStore',
            },
          );

          if (response.statusCode == HttpStatusCodes.ok) {
            final responseBody = jsonDecode(response.body);

            return User.fromJson(responseBody);
          } else {
            await Token.deleteToken();
            throw Exception("Login required");
          }
        } else {
          throw Exception('Token is still valid or invalid response format');
        }
      } else {
        throw Exception(
            'Failed to validate token: ${validateResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<User> editProfile(User user) async {
    final tokenStore = await Token.getToken();

    if (tokenStore == null) {
      throw Exception('Token is null');
    }

    final url = Uri.parse('${Domain.Url}/api/auth/me');
    final validateUrl = Uri.parse('${Domain.Url}/api/auth/expire_token');

    try {
      final validateResponse = await http.get(
        validateUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenStore',
        },
      );

      if (validateResponse.statusCode == HttpStatus.ok) {
        final validateData = jsonDecode(validateResponse.body);

        final isTokenExpired = validateData["message"] == true;
        if (!isTokenExpired) {
          final userJson = jsonEncode({
            'username': user.username,
            'email': user.email,
            'profile': user.profile
          });

          final response = await http.patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $tokenStore',
            },
            body: userJson,
          );

          if (response.statusCode == HttpStatus.ok) {
            final responseData = jsonDecode(response.body);

            return User.fromJson(responseData);
          } else {
            throw Exception('Failed to update profile: ${response.statusCode}');
          }
        } else {
          throw Exception('Token is expired');
        }
      } else {
        throw Exception(
            'Failed to validate token: ${validateResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<User> delete({required User user}) async {
    final tokenStore = await Token.getToken();

    if (tokenStore == null) {
      throw Exception('Token is null');
    }

    final url = Uri.parse('${Domain.Url}/api/auth/me');
    final validateUrl = Uri.parse('${Domain.Url}/api/auth/expire_token');

    try {
      final validateResponse = await http.get(
        validateUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenStore',
        },
      );

      if (validateResponse.statusCode == HttpStatus.ok) {
        final validateData = jsonDecode(validateResponse.body);

        final isTokenExpired = validateData["message"] == true;
        if (!isTokenExpired) {
          final userJson =
              jsonEncode({'email': user.email, 'message': user.message});

          print("function running ${userJson}");

          final response = await http.delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $tokenStore',
            },
            body: userJson,
          );

          if (response.statusCode == HttpStatus.ok) {
            final responseData = jsonDecode(response.body);

            return User.fromJson(responseData);
          } else {
            throw Exception('Failed to update profile: ${response.statusCode}');
          }
        } else {
          throw Exception('Token is expired');
        }
      } else {
        throw Exception(
            'Failed to validate token: ${validateResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
