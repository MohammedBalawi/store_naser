class HomeCategoryModel {
  final String name;
  final String iconUrl;

  HomeCategoryModel({required this.name, required this.iconUrl});

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      name: json['name'] ?? '',
      iconUrl: json['icon_url'] ?? '',
    );
  }
}