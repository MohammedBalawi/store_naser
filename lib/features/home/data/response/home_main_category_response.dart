import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'home_main_category_response.g.dart';

@JsonSerializable()
class HomeMainCategoryResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.icon)
  String? image;

  HomeMainCategoryResponse({
    this.id,
    this.name,
    this.image,
  });

  factory HomeMainCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeMainCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeMainCategoryResponseToJson(this);
}
