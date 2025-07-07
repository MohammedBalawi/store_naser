class ProductMainCategoryModel {
  final int id;
  final String name;
  final String? imageUrl;

  ProductMainCategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory ProductMainCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductMainCategoryModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }
}
