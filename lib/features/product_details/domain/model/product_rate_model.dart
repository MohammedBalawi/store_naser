
class ProductRateModel {
  int id;
  int rate;
  String title;
  String comment;
  String image;
  String createdAt;
  String userName;
  String userAvatar;
  int userId;

  ProductRateModel({
    required this.id,
    required this.rate,
    required this.title,
    required this.comment,
    required this.image,
    required this.createdAt,
    required this.userName,
    required this.userAvatar,
    required this.userId,
  });
}
