// lib/features/auth/data/models/auth_response.dart
class UserData {
  final String id, name, mobile, role;
  final String? avatar;
  UserData({required this.id, required this.name, required this.mobile, required this.role, this.avatar});
  factory UserData.fromJson(Map<String, dynamic> j) => UserData(
    id: j['id']?.toString() ?? '',
    name: j['name']?.toString() ?? '',
    mobile: j['mobile']?.toString() ?? '',
    role: j['role']?.toString() ?? 'user',
    avatar: j['avatar']?.toString(),
  );
}

class AuthData {
  final String accessToken;
  final bool mobileVerified, kycVerified;
  final String? expiresAt;
  final UserData user;
  AuthData({required this.accessToken, required this.mobileVerified, required this.kycVerified, required this.expiresAt, required this.user});
  factory AuthData.fromJson(Map<String, dynamic> j) => AuthData(
    accessToken: j['access_token']?.toString() ?? '',
    mobileVerified: j['mobile_verified'] == true,
    kycVerified: j['kyc_verified'] == true,
    expiresAt: j['expires_at']?.toString(),
    user: UserData.fromJson(j['user_data'] ?? {}),
  );
}

class AuthResponse {
  final bool error;
  final String message;
  final AuthData data;
  AuthResponse({required this.error, required this.message, required this.data});
  factory AuthResponse.fromJson(Map<String, dynamic> j) => AuthResponse(
    error: j['error'] == true,
    message: j['message']?.toString() ?? '',
    data: AuthData.fromJson(j['data'] ?? {}),
  );
}
