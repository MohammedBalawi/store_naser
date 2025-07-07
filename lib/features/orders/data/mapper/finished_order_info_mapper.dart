import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/orders/data/mapper/order_payment_mapper.dart';
import 'package:app_mobile/features/orders/data/response/finished_order_info_response.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_info_model.dart';

extension FinishedOrderInfoMapper on FinishedOrderInfoResponse {
  FinishedOrderInfoModel toDomain() => FinishedOrderInfoModel(
        shippingMethod: shippingMethod.onNull(),
        payment: payment!.toDomain(),
        submitWay: submitWay.onNull(),
        discount: discount.onNull(),
        currency: currency.onNull(),
        price: price.onNull(),
      );
}
