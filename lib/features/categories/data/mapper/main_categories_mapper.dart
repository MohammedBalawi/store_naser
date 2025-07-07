import 'package:app_mobile/features/categories/domain/model/main_categories_model.dart';
import '../response/main_categories_response.dart';
import 'main_category_mapper.dart';

extension MainCategoriesMapper on MainCategoriesResponse {
  MainCategoriesModel toDomain() => MainCategoriesModel(
        data: data!
            .map(
              (e) => e.toDomain(),
            )
            .toList(),
      );
}
