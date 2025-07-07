import '../../../../core/model/product_model.dart';

class CategoryModel {
  int id;
  String name;
  String image;
  bool productLoaded = false;
  List<ProductModel>? products = [];

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
     this.products,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      products: [],
    );
  }
}
