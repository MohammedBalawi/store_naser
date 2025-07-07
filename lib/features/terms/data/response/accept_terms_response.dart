import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'accept_terms_response.g.dart';

@JsonSerializable()
class AcceptTermsResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  AcceptTermsResponse({
    this.status,
  });

  factory AcceptTermsResponse.fromJson(Map<String, dynamic> json) =>
      _$AcceptTermsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptTermsResponseToJson(this);
}
