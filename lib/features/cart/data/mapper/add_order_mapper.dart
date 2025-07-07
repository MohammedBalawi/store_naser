import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/cart/data/response/add_order_response.dart';
import 'package:app_mobile/features/cart/domain/model/add_order_model.dart';

extension AddOrderMapper on AddOrderResponse {
  AddOrderModel toDomain() => AddOrderModel(
        status: status.onNull(),
      );
}
