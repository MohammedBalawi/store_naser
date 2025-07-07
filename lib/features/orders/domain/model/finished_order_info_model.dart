import 'order_payment_model.dart';

class FinishedOrderInfoModel {
  String shippingMethod;
  OrderPaymentModel payment;
  String submitWay;
  String discount;
  String currency;
  double price;

  FinishedOrderInfoModel({
    required this.shippingMethod,
    required this.payment,
    required this.submitWay,
    required this.discount,
    required this.currency,
    required this.price,
  });
}
