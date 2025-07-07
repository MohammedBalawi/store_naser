import 'package:app_mobile/core/mapper/product_mapper.dart';
import 'package:app_mobile/features/categories/data/mapper/category_mapper.dart';
import 'package:app_mobile/features/categories/data/response/category_products_response.dart';
import 'package:app_mobile/features/categories/domain/model/category_products_model.dart';

extension CategoryProductsMapper on CategoryProductsResponse {
  CategoryProductsModel toDomain() => CategoryProductsModel(
        data: data!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
