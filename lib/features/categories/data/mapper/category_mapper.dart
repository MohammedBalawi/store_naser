import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/product_mapper.dart';
import 'package:app_mobile/features/categories/data/response/category_response.dart';
import 'package:app_mobile/features/categories/domain/model/category_model.dart';

extension CategoryMapper on CategoryResponse {
  CategoryModel toDomain() => CategoryModel(
        id: id.onNull(),
    name: title.onNull(),
        image: image.onNull(),
        products: products!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
