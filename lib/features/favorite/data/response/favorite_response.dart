import 'package:app_mobile/core/response/product_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'favorite_response.g.dart';

@JsonSerializable()
class FavoriteResponse {
  @JsonKey(name: ResponseConstants.products)
  List<ProductResponse>? data;

  FavoriteResponse({
    this.data,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$FavoriteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteResponseToJson(this);
}
