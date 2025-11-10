// lib/features/home/data/models/category_model.dart
class CategoryModel {
  final int id;
  final String name;
  final String? image;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
    name: json['name']?.toString() ?? '',
    image: json['image']?.toString(),
  );
}
