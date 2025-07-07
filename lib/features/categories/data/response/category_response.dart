import 'package:app_mobile/core/response/product_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? title;
  @JsonKey(name: ResponseConstants.icon)
  String? image;
  @JsonKey(name: ResponseConstants.products)
  List<ProductResponse>? products;

  CategoryResponse({
    this.id,
    this.title,
    this.image,
    this.products,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
