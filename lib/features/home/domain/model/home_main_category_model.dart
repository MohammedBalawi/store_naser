class HomeMainCategoryModel {
  final int id;
  final String name;
  final String? image;
  final String? mainCategoryId;

  HomeMainCategoryModel( {
    required this.id,
    required this.name,
     this.image,
     this.mainCategoryId,

  });

  factory HomeMainCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeMainCategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image_url'],
      mainCategoryId: json['main_category_id'],
    );
  }
}
