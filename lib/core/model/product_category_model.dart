class ProductCategoryModel {
  final int id;
  final String name;
  final int? mainCategoryId;
  final String? imageUrl; // ✅ جديد: رابط صورة التصنيف

  ProductCategoryModel({
    required this.id,
    required this.name,
    this.mainCategoryId,
    this.imageUrl,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'],
      name: json['name'],
      mainCategoryId: json['main_category_id'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'main_category_id': mainCategoryId,
      'image_url': imageUrl,
    };
  }
}
