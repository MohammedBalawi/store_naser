// import 'package:json_annotation/json_annotation.dart';
// import '../../../../constants/response_constants/response_constants.dart';
//
// part 'logout_response.g.dart';
//
// @JsonSerializable()
// class LogoutResponse {
//   @JsonKey(name: ResponseConstants.status)
//   bool? status;
//
//   LogoutResponse({
//     this.status,
//   });
//
//   factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
//       _$LogoutResponseFromJson(json);
//
//   Map<String, dynamic> toJson() => _$LogoutResponseToJson(this);
// }
class LogoutResponse {
  final bool status;

  LogoutResponse({required this.status});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(status: json['status'] ?? false);
  }
}
