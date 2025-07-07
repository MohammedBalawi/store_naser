import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/orders/data/mapper/order_mapper.dart';
import 'package:app_mobile/features/orders/data/response/orders_response.dart';
import 'package:app_mobile/features/orders/domain/model/orders_model.dart';

extension OrdersMapper on OrdersResponse {
  OrdersModel toDomain() => OrdersModel(
        message: message.onNull(),
        data: data!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
