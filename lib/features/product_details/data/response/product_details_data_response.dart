import 'package:app_mobile/features/product_details/data/response/product_color_image_response.dart';
import 'package:app_mobile/features/product_details/data/response/product_rate_response.dart';
import 'package:app_mobile/features/product_details/data/response/product_size_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';
import '../../../../core/response/product_category_response.dart';
import '../../../../core/response/product_main_category_response.dart';

part 'product_details_data_response.g.dart';

@JsonSerializable()
class ProductDetailsDataResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.logoImage)
  String? logo;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.vendorName)
  String? vendorName;
  @JsonKey(name: ResponseConstants.vendorId)
  int? vendorId;
  @JsonKey(name: ResponseConstants.rate)
  int? rate;
  @JsonKey(name: ResponseConstants.isRated)
  int? isRated;
  @JsonKey(name: ResponseConstants.inFavorite)
  int? inFavorite;
  @JsonKey(name: ResponseConstants.description)
  String? description;
  @JsonKey(name: ResponseConstants.price)
  int? price;
  @JsonKey(name: ResponseConstants.discountRatio)
  int? discountRatio;
  @JsonKey(name: ResponseConstants.sellingPrice)
  int? sellingPrice;
  @JsonKey(name: ResponseConstants.availableQuantity)
  int? availableQuantity;
  @JsonKey(name: ResponseConstants.sku)
  String? sku;
  @JsonKey(name: ResponseConstants.mainCategoryProduct)
  ProductMainCategoryResponse? mainCategory;
  @JsonKey(name: ResponseConstants.subCategory)
  ProductCategoryResponse? category;
  @JsonKey(name: ResponseConstants.detailImages)
  List<String>? images;
  @JsonKey(name: ResponseConstants.colors)
  List<ProductColorImageResponse>? colors;
  @JsonKey(name: ResponseConstants.rates)
  List<ProductRateResponse>? rates;
  @JsonKey(name: ResponseConstants.sizes)
  List<ProductSizeResponse>? sizes;

  ProductDetailsDataResponse({
    this.id,
    this.logo,
    this.name,
    this.vendorName,
    this.vendorId,
    this.rate,
    this.isRated,
    this.inFavorite,
    this.description,
    this.price,
    this.discountRatio,
    this.sellingPrice,
    this.availableQuantity,
    this.sku,
    this.mainCategory,
    this.category,
    this.images,
    this.colors,
    this.sizes,
    this.rates,
  });

  factory ProductDetailsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsDataResponseToJson(this);
}
