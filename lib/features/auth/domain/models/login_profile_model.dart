class LoginProfileModel {
  bool fcmNotifications;
  bool emailNotification;
  bool biometricAuth;
  bool twoFactorAuth;

  LoginProfileModel({
    required this.fcmNotifications,
    required this.emailNotification,
    required this.biometricAuth,
    required this.twoFactorAuth,
  });
}
