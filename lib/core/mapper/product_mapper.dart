import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/product_category_mapper.dart';
import 'package:app_mobile/core/mapper/product_main_category_mapper.dart';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/core/response/product_response.dart';

extension ProductMapper on ProductResponse {
  ProductModel toDomain() => ProductModel(
        id: id.onNull(),
        name: name.onNull(),
        mainCategory: mainCategory!.toDomain(),
        category: category!.toDomain(),
        favorite: inFavorite.onNull(),
        availableQuantity: availableQuantity.onNull(),
        sku: sku.onNull(),
        rate: rate.onNull(),
        rateCount: rateCount.onNull(),
        price: price.onNull(),
        sellingPrice: sellingPrice.onNull(),
        discountRatio: discountRatio.onNull(),
        image: image.onNull(),
        createdAt: createdAt.onNull(),
      );
}
