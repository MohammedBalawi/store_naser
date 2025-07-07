import 'package:app_mobile/features/categories/data/response/main_category_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../constants/response_constants/response_constants.dart';

part 'main_categories_response.g.dart';

@JsonSerializable()
class MainCategoriesResponse {
  @JsonKey(name: ResponseConstants.mainCategories)
  List<MainCategoryResponse>? data;

  MainCategoriesResponse({
    this.data,
  });

  factory MainCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$MainCategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainCategoriesResponseToJson(this);
}
