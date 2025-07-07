import 'package:json_annotation/json_annotation.dart';
import '../../constants/response_constants/response_constants.dart';

part 'product_category_response.g.dart';

@JsonSerializable()
class ProductCategoryResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.icon)
  String? image;

  ProductCategoryResponse({
    this.id,
    this.name,
    this.image,
  });

  factory ProductCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryResponseToJson(this);
}
