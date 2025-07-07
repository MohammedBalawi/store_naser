import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:app_mobile/features/auth/data/response/login_profile_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'login_data_response.g.dart';

@JsonSerializable()
class LoginDataResponse extends BaseResponse {
  @JsonKey(name: ResponseConstants.token)
  String? token;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.email)
  String? email;
  @JsonKey(name: ResponseConstants.mobile)
  String? mobile;
  @JsonKey(name: ResponseConstants.avatar)
  String? avatar;
  @JsonKey(name: ResponseConstants.profile)
  LoginProfileResponse? profile;


  LoginDataResponse({
    this.token,
    this.name,
    this.email,
    this.mobile,
    this.avatar,
    this.profile,
  });

  factory LoginDataResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataResponseToJson(this);
}
