import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'change_password_response.g.dart';

@JsonSerializable()
class ChangePasswordResponse extends BaseResponse{
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  ChangePasswordResponse({
    required this.status,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseFromJson(json);

  Map<String, dynamic> _toJson() => _$ChangePasswordResponseToJson(this);
}
