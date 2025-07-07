import 'package:json_annotation/json_annotation.dart';
import '../../constants/response_constants/response_constants.dart';

part 'product_main_category_response.g.dart';

@JsonSerializable()
class ProductMainCategoryResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.icon)
  String? image;

  ProductMainCategoryResponse({
    this.id,
    this.name,
    this.image,
  });

  factory ProductMainCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductMainCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMainCategoryResponseToJson(this);
}
