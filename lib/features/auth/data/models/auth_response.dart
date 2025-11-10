class UserData {
  final String id;
  final String name;
  final String mobile;
  final String? avatar;
  final String role;

  UserData({required this.id, required this.name, required this.mobile, this.avatar, required this.role});

  factory UserData.fromJson(Map<String, dynamic> j) => UserData(
    id: j['id']?.toString() ?? '',
    name: j['name']?.toString() ?? '',
    mobile: j['mobile']?.toString() ?? '',
    avatar: j['avatar']?.toString(),
    role: j['role']?.toString() ?? 'user',
  );
}

class AuthData {
  final String accessToken;
  final bool mobileVerified;
  final bool kycVerified;
  final String? expiresAt;
  final UserData user;

  AuthData({
    required this.accessToken,
    required this.mobileVerified,
    required this.kycVerified,
    required this.expiresAt,
    required this.user,
  });

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
