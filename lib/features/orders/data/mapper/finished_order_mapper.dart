import 'package:app_mobile/features/orders/data/mapper/finished_order_data_mapper.dart';
import 'package:app_mobile/features/orders/data/response/finished_order_response.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_model.dart';

extension FinishedOrderMapper on FinishedOrderResponse {
  FinishedOrderModel toDomain() => FinishedOrderModel(
        data: data!.toDomain(),
      );
}
