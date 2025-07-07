import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';
import '../../../../core/base_response/base_response.dart';
import 'order_response.dart';

part 'orders_response.g.dart';

@JsonSerializable()
class OrdersResponse extends BaseResponse {
  @JsonKey(name: ResponseConstants.data)
  List<OrderResponse>? data;

  OrdersResponse({
    this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResponseToJson(this);
}
