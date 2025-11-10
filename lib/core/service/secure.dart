import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _key = 'access_token';
  static const _expKey = 'access_token_expires_at';
  static final _s = const FlutterSecureStorage();

  static Future<void> saveToken(String token, {String? expiresAt}) async {
    await _s.write(key: _key, value: token);
    if (expiresAt != null) {
      await _s.write(key: _expKey, value: expiresAt);
    }
  }

  static Future<String?> readToken() => _s.read(key: _key);
  static Future<void> clear() async {
    await _s.delete(key: _key);
    await _s.delete(key: _expKey);
  }
}
