import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/auth/data/mapper/login_profile_mapper.dart';
import 'package:app_mobile/features/auth/data/response/login_data_response.dart';
import 'package:app_mobile/features/auth/domain/models/login_data_model.dart';

extension LoginDataMapper on LoginDataResponse {
  toDomain() {
    return LoginDataModel(
      token: token.onNull(),
      name: name.onNull(),
      email: email.onNull(),
      mobile: mobile.onNull(),
      avatar: avatar.onNull(),
      profile: profile!.toDomain(),
    );
  }
}
