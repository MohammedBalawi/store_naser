import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/home/data/response/home_main_category_response.dart';
import 'package:app_mobile/features/home/domain/model/home_main_category_model.dart';

extension HomeMainCategoryMapper on HomeMainCategoryResponse {
  HomeMainCategoryModel toDomain() => HomeMainCategoryModel(
        id: id.onNull(),
        name: name.onNull(),
    image: image.onNull(),
      );
}
