import 'package:app_mobile/features/product_details/domain/model/product_size_model.dart';
import '../../../../core/model/product_category_model.dart';
import '../../../../core/model/product_main_category_model.dart';
import 'product_color_image_model.dart';
import 'product_rate_model.dart';

class ProductDetailsDataModel {
  String logo;
  String name;
  String description;
  String sku;
  String vendorName;
  int vendorId;
  int id;
  int rate;
  int isRated;
  int inFavorite;
  int price;
  int discountRatio;
  int sellingPrice;
  int availableQuantity;
  ProductMainCategoryModel mainCategory;
  ProductCategoryModel category;
  List<String> images;
  List<ProductSizeModel> sizes;
  List<ProductColorImageModel> colors;
  List<ProductRateModel> rates;

  ProductDetailsDataModel({
    required this.id,
    required this.logo,
    required this.name,
    required this.vendorName,
    required this.vendorId,
    required this.rate,
    required this.isRated,
    required this.inFavorite,
    required this.description,
    required this.price,
    required this.discountRatio,
    required this.sellingPrice,
    required this.availableQuantity,
    required this.sku,
    required this.mainCategory,
    required this.category,
    required this.images,
    required this.colors,
    required this.sizes,
    required this.rates,
  });
}
