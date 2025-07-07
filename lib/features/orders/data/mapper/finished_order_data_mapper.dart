import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/orders/data/mapper/finished_order_info_mapper.dart';
import 'package:app_mobile/features/orders/data/mapper/finished_order_product_mapper.dart';
import 'package:app_mobile/features/orders/data/response/finished_order_data_response.dart';
import 'package:app_mobile/features/orders/domain/model/finished_order_data_model.dart';
import '../../../../core/funs/format_date.dart';

extension FinishedOrderDataMapper on FinishedOrderDataResponse {
  FinishedOrderDataModel toDomain() => FinishedOrderDataModel(
        number: number.onNull(),
        step: step.onNull(),
        dateTime: formatDate(date: dateTime.onNull()),
        info: info!.toDomain(),
        products: products!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
