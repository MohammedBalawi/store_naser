import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/product_category_model.dart';
import 'package:app_mobile/core/response/product_category_response.dart';

extension ProductCategoryMapper on ProductCategoryResponse {
  ProductCategoryModel toDomain() {
    return ProductCategoryModel(
      id: id.onNull(),
      name: name.onNull(),
      imageUrl: image.onNull()
      // mainCategoryId: mainCategoryId.onNull(),
    );
  }
}
