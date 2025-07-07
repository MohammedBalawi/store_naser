import 'package:app_mobile/core/response/product_category_response.dart';
import 'package:app_mobile/core/response/product_main_category_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../constants/response_constants/response_constants.dart';

part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.mainCategory)
  ProductMainCategoryResponse? mainCategory;
  @JsonKey(name: ResponseConstants.category)
  ProductCategoryResponse? category;
  @JsonKey(name: ResponseConstants.inFavorite)
  int? inFavorite;
  @JsonKey(name: ResponseConstants.availableQuantity)
  int? availableQuantity;
  @JsonKey(name: ResponseConstants.sku)
  String? sku;
  @JsonKey(name: ResponseConstants.rate)
  int? rate;
  @JsonKey(name: ResponseConstants.rateCount)
  int? rateCount;
  @JsonKey(name: ResponseConstants.price)
  int? price;
  @JsonKey(name: ResponseConstants.sellingPrice)
  int? sellingPrice;
  @JsonKey(name: ResponseConstants.discountRatio)
  int? discountRatio;
  @JsonKey(name: ResponseConstants.logoImage)
  String? image;
  @JsonKey(name: ResponseConstants.createdAt)
  String? createdAt;

  ProductResponse({
    this.id,
    this.name,
    this.mainCategory,
    this.category,
    this.inFavorite,
    this.availableQuantity,
    this.sku,
    this.rate,
    this.rateCount,
    this.price,
    this.sellingPrice,
    this.discountRatio,
    this.image,
    this.createdAt,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}
