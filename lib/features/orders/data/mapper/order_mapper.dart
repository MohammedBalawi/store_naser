import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/orders/presentation/model/order_status_mapper.dart';
import '../../../../core/funs/format_date.dart';
import '../../domain/model/order_model.dart';
import '../response/order_response.dart';

extension OrderMapper on OrderResponse {
  OrderModel toDomain() => OrderModel(
        id: id.onNull(),
        number: number.onNull(),
        dateTime: formatDate(
          date: dateTime.onNull(),
        ),
        title: title.onNull(),
        currency: currency.onNull(),
        statusModel: orderStatusMapper(
          status: status.onNull(),
        ),
        quantity: quantity.onNull(),
        price: price.onNull(),
      );
}
