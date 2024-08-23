import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  static const _secureStorage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  static Future<void> setToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  static Future<void> deleteToken() async {
    print("Delete Token");
    await _secureStorage.delete(key: 'auth_token');
  }
}
