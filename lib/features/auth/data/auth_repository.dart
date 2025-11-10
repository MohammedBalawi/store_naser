// lib/features/auth/data/auth_repository.dart
import '../../../core/storage/secure_store.dart';
import 'auth_remote.dart';
import 'models/auth_response.dart';

class AuthRepository {
  final AuthRemote _remote;
  AuthRepository(this._remote);

  Future<AuthData> register({
    required String name,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    String role = 'user',
    String? email,
    String? fcmToken,
  }) async {
    final r = await _remote.register(
      name: name,
      mobile: mobile,
      password: password,
      passwordConfirmation: passwordConfirmation,
      role: role,
      email: email,
      fcmToken: fcmToken,
    );
    if (r.error) throw Exception(r.message.isEmpty ? 'Registration failed' : r.message);
    await SecureStore.saveToken(r.data.accessToken);
    return r.data;
  }
}
