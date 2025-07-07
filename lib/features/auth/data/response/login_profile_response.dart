import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'login_profile_response.g.dart';

@JsonSerializable()
class LoginProfileResponse extends BaseResponse {
  @JsonKey(name: ResponseConstants.fcmNotifications)
  bool? fcmNotifications;
  @JsonKey(name: ResponseConstants.emailNotification)
  bool? emailNotification;
  @JsonKey(name: ResponseConstants.biometricAuth)
  bool? biometricAuth;
  @JsonKey(name: ResponseConstants.twoFactorAuth)
  bool? twoFactorAuth;

  LoginProfileResponse({
    this.fcmNotifications,
    this.emailNotification,
    this.biometricAuth,
    this.twoFactorAuth,
  });

  factory LoginProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginProfileResponseToJson(this);
}
