import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/product_main_category_model.dart';
import 'package:app_mobile/core/response/product_main_category_response.dart';

extension ProductMainCategoryMapper on ProductMainCategoryResponse {
  ProductMainCategoryModel toDomain() => ProductMainCategoryModel(
    id: id.onNull(),
    name: name.onNull(),
    imageUrl: image.onNull(),
  );
}
