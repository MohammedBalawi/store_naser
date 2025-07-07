import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'product_rate_response.g.dart';

@JsonSerializable()
class ProductRateResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.rate)
  int? rate;
  @JsonKey(name: ResponseConstants.title)
  String? title;
  @JsonKey(name: ResponseConstants.comment)
  String? comment;
  @JsonKey(name: ResponseConstants.image)
  String? image;
  @JsonKey(name: ResponseConstants.userName)
  String? userName;
  @JsonKey(name: ResponseConstants.userAvatar)
  String? userAvatar;
  @JsonKey(name: ResponseConstants.userId)
  int? userId;
  @JsonKey(name: ResponseConstants.createdAt)
  String? createdAt;

  ProductRateResponse({
    this.id,
    this.rate,
    this.title,
    this.comment,
    this.image,
    this.createdAt,
  });

  factory ProductRateResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductRateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductRateResponseToJson(this);
}
