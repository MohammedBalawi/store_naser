import '../../../../core/model/product_model.dart';

class ProductsListItemModel {
  final String title;
  final List<ProductModel> items;
  final String? route;

  ProductsListItemModel({
    required this.title,
    required this.items,
    this.route,
  });
}
