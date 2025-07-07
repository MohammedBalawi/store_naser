import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse  extends BaseResponse{
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  RegisterResponse({required this.status});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
