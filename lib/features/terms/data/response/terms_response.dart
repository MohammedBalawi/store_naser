import 'package:app_mobile/features/terms/data/response/terms_data_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'terms_response.g.dart';

@JsonSerializable()
class TermsResponse {
  @JsonKey(name: ResponseConstants.data)
  List<TermsDataResponse>? data;

  TermsResponse({
    this.data,
  });

  factory TermsResponse.fromJson(Map<String, dynamic> json) =>
      _$TermsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TermsResponseToJson(this);
}
