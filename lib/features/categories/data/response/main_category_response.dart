import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';
import 'category_response.dart';

part 'main_category_response.g.dart';

@JsonSerializable()
class MainCategoryResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? title;
  @JsonKey(name: ResponseConstants.icon)
  String? icon;
  @JsonKey(name: ResponseConstants.children)
  List<CategoryResponse>? categories;

  MainCategoryResponse({
    this.id,
    this.title,
    this.icon,
    this.categories,
  });

  factory MainCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$MainCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainCategoryResponseToJson(this);
}
