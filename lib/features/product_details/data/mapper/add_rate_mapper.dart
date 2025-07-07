import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/product_details/data/response/add_rate_response.dart';
import 'package:app_mobile/features/product_details/domain/model/add_rate_model.dart';

extension AddRateMapper on AddRateResponse {
  AddRateModel toDomain() => AddRateModel(
        status: status.onNull(),
      );
}
