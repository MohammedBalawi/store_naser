import 'package:app_mobile/features/orders/domain/model/finished_order_info_model.dart';
import 'finished_order_product_model.dart';

class FinishedOrderDataModel {
  String number;
  String step;
  String dateTime;
  FinishedOrderInfoModel info;
  List<FinishedOrderProductModel> products;

  FinishedOrderDataModel({
    required this.number,
    required this.step,
    required this.dateTime,
    required this.info,
    required this.products,
  });
}
