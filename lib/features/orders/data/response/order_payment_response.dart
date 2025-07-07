import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'order_payment_response.g.dart';

@JsonSerializable()
class OrderPaymentResponse {
  @JsonKey(name: ResponseConstants.title)
  String? title;
  @JsonKey(name: ResponseConstants.number)
  String? number;

  OrderPaymentResponse({
    this.title,
    this.number,
  });

  factory OrderPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentResponseToJson(this);
}
