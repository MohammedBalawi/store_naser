import 'package:json_annotation/json_annotation.dart';

part 'otp_register_response.g.dart';

@JsonSerializable()
class OtpRegisterResponse {
  @JsonKey(name: 'status')
  bool? status;

  OtpRegisterResponse(this.status);

  factory OtpRegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpRegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRegisterResponseToJson(this);
}
