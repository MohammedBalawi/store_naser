import 'package:app_mobile/core/response/product_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'category_products_response.g.dart';

@JsonSerializable()
class CategoryProductsResponse {

  @JsonKey(name: ResponseConstants.products)
  List<ProductResponse>? data;

  CategoryProductsResponse({
    this.data,
  });

  factory CategoryProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductsResponseToJson(this);
}
