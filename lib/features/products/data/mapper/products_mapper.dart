import 'package:app_mobile/core/mapper/product_mapper.dart';
import 'package:app_mobile/features/products/data/response/products_response.dart';
import 'package:app_mobile/features/products/domain/model/products_model.dart';

extension ProductsMapper on ProductsResponse {
  ProductsModel toDomain() => ProductsModel(
        products: products!.map((e) => e.toDomain()).toList(),
      );
}
