import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'order_response.g.dart';

@JsonSerializable()
class OrderResponse {
  @JsonKey(name: ResponseConstants.id)
  String? id;
  @JsonKey(name: ResponseConstants.number)
  String? number;
  @JsonKey(name: ResponseConstants.dateTime)
  String? dateTime;
  @JsonKey(name: ResponseConstants.title)
  String? title;
  @JsonKey(name: ResponseConstants.currency)
  String? currency;
  @JsonKey(name: ResponseConstants.status)
  String? status;
  @JsonKey(name: ResponseConstants.quantity)
  int? quantity;
  @JsonKey(name: ResponseConstants.price)
  double? price;

  OrderResponse({
    this.id,
    this.number,
    this.dateTime,
    this.title,
    this.currency,
    this.status,
    this.quantity,
    this.price,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}
