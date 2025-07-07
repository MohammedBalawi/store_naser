import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/orders/data/response/order_payment_response.dart';
import 'package:app_mobile/features/orders/domain/model/order_payment_model.dart';

extension OrderPaymentMapper on OrderPaymentResponse {
  OrderPaymentModel toDomain() => OrderPaymentModel(
        number: number.onNull(),
        title: title.onNull(),
      );
}
