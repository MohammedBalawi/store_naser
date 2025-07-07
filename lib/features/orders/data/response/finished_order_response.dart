import 'package:app_mobile/features/orders/data/response/finished_order_data_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'finished_order_response.g.dart';

@JsonSerializable()
class FinishedOrderResponse {
  @JsonKey(name: ResponseConstants.data)
  FinishedOrderDataResponse? data;
  FinishedOrderResponse({
    this.data,
  });

  factory FinishedOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$FinishedOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedOrderResponseToJson(this);
}
