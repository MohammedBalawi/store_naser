import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/product_details/data/response/product_size_response.dart';
import 'package:app_mobile/features/product_details/domain/model/product_size_model.dart';

extension ProductSizeMapper on ProductSizeResponse {
  ProductSizeModel toDomain() => ProductSizeModel(
        id: id.onNull(),
        name: name.onNull(),
        quantity: quantity.onNull(),
      );
}
