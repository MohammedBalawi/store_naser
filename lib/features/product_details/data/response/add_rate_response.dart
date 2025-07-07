import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'add_rate_response.g.dart';

@JsonSerializable()
class AddRateResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  AddRateResponse({
    this.status,
  });

  factory AddRateResponse.fromJson(Map<String, dynamic> json) =>
      _$AddRateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddRateResponseToJson(this);
}
