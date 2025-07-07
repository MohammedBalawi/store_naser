import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/product_category_mapper.dart';
import 'package:app_mobile/core/mapper/product_main_category_mapper.dart';
import 'package:app_mobile/features/product_details/data/mapper/product_color_image_mapper.dart';
import 'package:app_mobile/features/product_details/data/mapper/product_rate_mapper.dart';
import 'package:app_mobile/features/product_details/data/mapper/product_size_mapper.dart';
import '../../domain/model/product_details_data_model.dart';
import '../response/product_details_data_response.dart';

extension ProductDetailsDataMapper on ProductDetailsDataResponse {
  ProductDetailsDataModel toDomain() => ProductDetailsDataModel(
    id: id.onNull(),
    logo: logo.onNull(),
    name: name.onNull(),
    rate: rate.onNull(),
    isRated: isRated.onNull(),
    inFavorite: inFavorite.onNull(),
    description: description.onNull(),
    price: price.onNull(),
    discountRatio: discountRatio.onNull(),
    sellingPrice: sellingPrice.onNull(),
    availableQuantity: availableQuantity.onNull(),
    sku: sku.onNull(),
    mainCategory: mainCategory!.toDomain(),
    category: category!.toDomain(),
    images: images.onNull(),
    rates: rates!
        .map(
          (e) => e.toDomain(),
    )
        .toList(),
    vendorName: vendorName.onNull(),
    vendorId: vendorId.onNull(),
    colors: colors!
        .map(
          (e) => e.toDomain(),
    )
        .toList(),
    sizes: sizes!
        .map(
          (e) => e.toDomain(),
    )
        .toList(),
  );
}
