import '../../presentation/model/order_status_model.dart';

class OrderModel {
  String id;
  String number;
  String dateTime;
  String title;
  String currency;
  OrderStatusModel statusModel;
  int quantity;
  double price;

  OrderModel({
    required this.id,
    required this.number,
    required this.dateTime,
    required this.title,
    required this.currency,
    required this.statusModel,
    required this.quantity,
    required this.price,
  });
}
