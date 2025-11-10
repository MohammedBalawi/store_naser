// lib/core/storage/secure_store.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _kToken = 'access_token';
  static const _kExp   = 'access_token_expires_at';
  static final _s = const FlutterSecureStorage();

  static Future<void> saveToken(String t, {String? exp}) async {
    await _s.write(key: _kToken, value: t);
    if (exp != null) await _s.write(key: _kExp, value: exp);
  }

  static Future<String?> readToken() => _s.read(key: _kToken);
  static Future<void> clear() async {
    await _s.delete(key: _kToken);
    await _s.delete(key: _kExp);
  }
}
