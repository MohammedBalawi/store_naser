import 'package:app_mobile/core/model/product_model.dart';
import 'product_details_data_model.dart';

class ProductDetailsModel {
  ProductDetailsDataModel product;
  List<ProductModel> relatedProducts;

  ProductDetailsModel({
    required this.product,
    required this.relatedProducts,
  });
}
