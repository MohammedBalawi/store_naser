import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'color_response.g.dart';

@JsonSerializable()
class ColorResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.hex)
  String? hex;

  ColorResponse({
    this.id,
    this.name,
    this.hex,
  });

  factory ColorResponse.fromJson(Map<String, dynamic> json) =>
      _$ColorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ColorResponseToJson(this);
}
