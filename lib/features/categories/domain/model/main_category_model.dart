import 'package:app_mobile/features/categories/domain/model/category_model.dart';

class MainCategoryModel {
  int id;
  String title;
  // String icon;
  List<CategoryModel> categories;

  MainCategoryModel({
    required this.id,
    required this.title,
    // required this.icon,
    required this.categories,
  });
}
