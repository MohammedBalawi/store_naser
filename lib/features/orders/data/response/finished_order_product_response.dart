import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'finished_order_product_response.g.dart';

@JsonSerializable()
class FinishedOrderProductResponse {
  @JsonKey(name: ResponseConstants.id)
  String? id;
  @JsonKey(name: ResponseConstants.title)
  String? title;
  @JsonKey(name: ResponseConstants.image)
  String? image;
  @JsonKey(name: ResponseConstants.subTitle)
  String? subTitle;
  @JsonKey(name: ResponseConstants.color)
  String? color;
  @JsonKey(name: ResponseConstants.size)
  String? size;
  @JsonKey(name: ResponseConstants.units)
  int? units;
  @JsonKey(name: ResponseConstants.currency)
  String? currency;
  @JsonKey(name: ResponseConstants.price)
  double? price;

  FinishedOrderProductResponse({
    this.id,
    this.title,
    this.image,
    this.subTitle,
    this.color,
    this.size,
    this.units,
    this.currency,
    this.price,
  });

  factory FinishedOrderProductResponse.fromJson(Map<String, dynamic> json) =>
      _$FinishedOrderProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedOrderProductResponseToJson(this);
}
