import 'package:app_mobile/features/orders/data/response/finished_order_product_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';
import 'finished_order_info_response.dart';

part 'finished_order_data_response.g.dart';

@JsonSerializable()
class FinishedOrderDataResponse {
  @JsonKey(name: ResponseConstants.number)
  String? number;
  @JsonKey(name: ResponseConstants.step)
  String? step;
  @JsonKey(name: ResponseConstants.dateTime)
  String? dateTime;
  @JsonKey(name: ResponseConstants.info)
  FinishedOrderInfoResponse? info;
  @JsonKey(name: ResponseConstants.products)
  List<FinishedOrderProductResponse>? products;

  FinishedOrderDataResponse({
    this.number,
    this.step,
    this.dateTime,
    this.info,
    this.products,
  });

  factory FinishedOrderDataResponse.fromJson(Map<String, dynamic> json) =>
      _$FinishedOrderDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedOrderDataResponseToJson(this);
}
