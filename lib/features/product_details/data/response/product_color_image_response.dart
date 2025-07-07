import 'package:app_mobile/core/response/color_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'product_color_image_response.g.dart';

@JsonSerializable()
class ProductColorImageResponse {
  @JsonKey(name: ResponseConstants.color)
  ColorResponse? color;
  @JsonKey(name: ResponseConstants.images)
  List<String>? images;

  ProductColorImageResponse({
    this.color,
    this.images,
  });

  factory ProductColorImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductColorImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductColorImageResponseToJson(this);
}
