import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'add_favorite_response.g.dart';

@JsonSerializable()
class AddFavoriteResponse {
  @JsonKey(name: ResponseConstants.status)
  bool? status;

  AddFavoriteResponse({
    this.status,
  });

  factory AddFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$AddFavoriteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddFavoriteResponseToJson(this);
}
