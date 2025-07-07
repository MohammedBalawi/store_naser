import 'package:app_mobile/core/mapper/product_mapper.dart';
import 'package:app_mobile/features/product_details/data/mapper/product_details_data_mapper.dart';
import 'package:app_mobile/features/product_details/data/response/product_details_response.dart';
import 'package:app_mobile/features/product_details/domain/model/product_details_model.dart';

extension ProductDetailsMapper on ProductDetailsResponse {
  ProductDetailsModel toDomain() => ProductDetailsModel(
        product: product!.toDomain(),
        relatedProducts: relatedProducts!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
