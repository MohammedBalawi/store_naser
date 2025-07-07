import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/orders/data/response/finished_order_product_response.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_product_model.dart';

extension FinishedOrderProductMapper on FinishedOrderProductResponse {
  FinishedOrderProductModel toDomain() => FinishedOrderProductModel(
        id: id.onNull(),
        title: title.onNull(),
        image: image.onNull(),
        subTitle: subTitle.onNull(),
        color: color.onNull(),
        size: size.onNull(),
        currency: currency.onNull(),
        units: units.onNull(),
        price: price.onNull(),
      );
}
