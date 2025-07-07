import 'dart:io';

class AddRateRequest {
  int productId;
  int rate;
  String title;
  String comment;
  String image;
  File? file;

  AddRateRequest({
    required this.productId,
    required this.rate,
    required this.title,
    required this.comment,
    required this.image,
    this.file,
  });
}
