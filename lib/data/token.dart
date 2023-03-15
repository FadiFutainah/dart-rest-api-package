import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> get accessToken async {
    return await _storage.read(key: 'accessToken');
  }

  Future<String?> get refreshToken async {
    return await _storage.read(key: 'refreshToken');
  }

  Future<void> setTokens({String? access, String? refresh}) async {
    if (access != null) {
      await _storage.write(key: 'accessToken', value: access);
    }
    if (refresh != null) {
      await _storage.write(key: 'refreshToken', value: refresh);
    }
  }

  Future<void> deleteTokens({bool access = false, bool refresh = false}) async {
    if (access) await _storage.delete(key: 'accessToken');
    if (refresh) await _storage.delete(key: 'refreshToken');
  }
}
