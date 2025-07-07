import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/color_mapper.dart';
import 'package:app_mobile/features/product_details/data/response/product_color_image_response.dart';
import 'package:app_mobile/features/product_details/domain/model/product_color_image_model.dart';

extension ProductColorImageMapper on ProductColorImageResponse {
  ProductColorImageModel toDomain() => ProductColorImageModel(
        images: images!
            .map(
              (e) => e.onNull(),
            )
            .toList(),
        color: color!.toDomain(),
      );
}
