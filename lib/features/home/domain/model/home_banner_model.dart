class HomeBannerModel {
  final String id;
  final String title;
  final String? imageUrl;

  HomeBannerModel({
    required this.id,
    required this.title,
     this.imageUrl,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
