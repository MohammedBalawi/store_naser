import 'dart:convert';
import 'package:http/http.dart' as http;

const String kApiAuthUrl = 'http://195.35.56.128:4675/api/auth';

class AuthApiResult {
  final bool ok;
  final String? token;
  final String? message;
  final Map<String, dynamic>? raw;

  const AuthApiResult({
    required this.ok,
    this.token,
    this.message,
    this.raw,
  });
}

class AuthApi {
  static String _normalizeMobile(String input) =>
      input.replaceAll(RegExp(r'[^\d]'), '');

  static Future<AuthApiResult> loginWithMobile({
    required String mobile,
    required String password,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final uri = Uri.parse('$kApiAuthUrl/login');

    final resp = await http
        .post(
      uri,
      headers: const {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'mobile': _normalizeMobile(mobile),
        'password': password,
      },
      encoding: Encoding.getByName('utf-8'),
    )
        .timeout(timeout);

    return _parseLoginResponse(resp);
  }

  static Future<AuthApiResult> loginWithEmail({
    required String email,
    required String password,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final uri = Uri.parse('$kApiAuthUrl/login');

    final resp = await http
        .post(
      uri,
      headers: const {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email.trim(),
        'password': password,
      },
      encoding: Encoding.getByName('utf-8'),
    )
        .timeout(timeout);

    return _parseLoginResponse(resp);
  }

  static AuthApiResult _parseLoginResponse(http.Response resp) {
    final code = resp.statusCode;
    final rawText = resp.body.isEmpty ? '{}' : resp.body;

    Map<String, dynamic> json;
    try {
      json = jsonDecode(rawText) as Map<String, dynamic>;
    } catch (_) {
      return AuthApiResult(
        ok: false,
        message: 'استجابة غير متوقعة (${code})',
      );
    }

    final error = json['error'] == true;
    final msg = (json['message'] ?? '').toString();
    final data = json['data'] as Map<String, dynamic>?;
    final token = data?['access_token']?.toString();

    if (!error && token != null && token.isNotEmpty) {
      return AuthApiResult(ok: true, token: token, raw: json);
    }

    final friendly = msg.isNotEmpty
        ? msg
        : (code == 401
        ? 'بيانات اعتماد غير صحيحة (401)'
        : (code == 422
        ? 'بيانات غير صالحة (422)'
        : 'فشل تسجيل الدخول (${code})'));

    return AuthApiResult(ok: false, message: friendly, raw: json);
  }
}
