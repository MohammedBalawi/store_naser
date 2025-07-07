import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/auth/data/response/login_profile_response.dart';
import 'package:app_mobile/features/auth/domain/models/login_profile_model.dart';

extension LoginProfileMapper on LoginProfileResponse {
  toDomain() {
    return LoginProfileModel(
      fcmNotifications: fcmNotifications.onNull(),
      emailNotification: emailNotification.onNull(),
      twoFactorAuth: twoFactorAuth.onNull(),
      biometricAuth: biometricAuth.onNull(),
    );
  }
}
