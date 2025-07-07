import 'package:app_mobile/core/response/product_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';
import 'product_details_data_response.dart';

part 'product_details_response.g.dart';

@JsonSerializable()
class ProductDetailsResponse {
  @JsonKey(name: ResponseConstants.product)
  ProductDetailsDataResponse? product;
  @JsonKey(name: ResponseConstants.relatedProducts)
  List<ProductResponse>? relatedProducts;

  ProductDetailsResponse({
    this.product,
    this.relatedProducts,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsResponseToJson(this);
}
