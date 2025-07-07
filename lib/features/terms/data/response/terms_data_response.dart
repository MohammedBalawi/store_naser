import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'terms_data_response.g.dart';

@JsonSerializable()
class TermsDataResponse {
  @JsonKey(name: ResponseConstants.body)
  String? body;
  @JsonKey(name: ResponseConstants.title)
  String? title;

  TermsDataResponse({
    this.body,
    this.title,
  });

  factory TermsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$TermsDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TermsDataResponseToJson(this);
}
