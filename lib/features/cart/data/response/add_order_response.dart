import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'add_order_response.g.dart';

@JsonSerializable()
class AddOrderResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  AddOrderResponse({
    this.status,
  });

  factory AddOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$AddOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddOrderResponseToJson(this);
}
