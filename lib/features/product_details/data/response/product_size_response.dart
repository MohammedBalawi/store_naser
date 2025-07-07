import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'product_size_response.g.dart';

@JsonSerializable()
class ProductSizeResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.quantity)
  String? quantity;

  ProductSizeResponse({
    this.id,
    this.name,
    this.quantity,
  });

  factory ProductSizeResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSizeResponseToJson(this);
}
