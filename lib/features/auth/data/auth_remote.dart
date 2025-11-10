// lib/features/auth/data/auth_remote.dart
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/auth_response.dart';

class AuthRemote {
  final Dio _dio = ApiClient.I.dio;

  Future<AuthResponse> register({
    required String name,
    required String mobile,                // أرقام دولية بدون +
    required String password,
    required String passwordConfirmation,  // نفس كلمة المرور
    String role = 'user',
    String? email,                         // اختياري
    String? fcmToken,                      // اختياري
  }) async {
    final form = FormData.fromMap({
      'name': name,
      'mobile': mobile,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
      if (email != null && email.isNotEmpty) 'email': email,
      if (fcmToken != null && fcmToken.isNotEmpty) 'fcm_token': fcmToken,
    });

    final res = await _dio.post(Endpoints.register, data: form);
    return AuthResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
