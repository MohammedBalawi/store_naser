import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/categories/data/mapper/category_mapper.dart';
import 'package:app_mobile/features/categories/data/response/main_category_response.dart';
import 'package:app_mobile/features/categories/domain/model/main_category_model.dart';

extension MainCategoryMapper on MainCategoryResponse {
  MainCategoryModel toDomain() => MainCategoryModel(
        id: id.onNull(),
        title: title.onNull(),
        categories: categories!.map((e) => e.toDomain()).toList(),
        // icon: icon.onNull(),
      );
}
