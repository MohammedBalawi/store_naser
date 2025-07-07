import '../../../../core/base_model/base_model.dart';
import 'order_model.dart';

class OrdersModel extends BaseModel {
  List<OrderModel> data;

  OrdersModel({
    required super.message,
    required this.data,
  });
}
