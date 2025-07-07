import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';
import 'order_payment_response.dart';

part 'finished_order_info_response.g.dart';

@JsonSerializable()
class FinishedOrderInfoResponse {
  @JsonKey(name: ResponseConstants.shippingMethod)
  String? shippingMethod;
  @JsonKey(name: ResponseConstants.payment)
  OrderPaymentResponse? payment;
  @JsonKey(name: ResponseConstants.submitWay)
  String? submitWay;
  @JsonKey(name: ResponseConstants.discount)
  String? discount;
  @JsonKey(name: ResponseConstants.currency)
  String? currency;
  @JsonKey(name: ResponseConstants.price)
  double? price;

  FinishedOrderInfoResponse({
    this.shippingMethod,
    this.payment,
    this.submitWay,
    this.discount,
    this.currency,
    this.price,
  });

  factory FinishedOrderInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$FinishedOrderInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedOrderInfoResponseToJson(this);
}
