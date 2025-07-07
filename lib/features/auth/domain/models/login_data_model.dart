import 'package:app_mobile/features/auth/domain/models/login_profile_model.dart';

class LoginDataModel {
  String token;
  String name;
  String email;
  String mobile;
  String avatar;
  LoginProfileModel profile;

  LoginDataModel({
    required this.token,
    required this.name,
    required this.email,
    required this.mobile,
    required this.avatar,
    required this.profile,
  });
}
