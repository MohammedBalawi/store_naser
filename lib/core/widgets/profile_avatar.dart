import 'package:flutter/material.dart';
import '../resources/manager_radius.dart';
import '../service/image_service.dart';

Widget profileAvatar({
  required String image,
  double? radius,
}) {
  return CircleAvatar(
    radius: radius ?? ManagerRadius.r50,
    backgroundImage: ImageService.networkImageContainer(
      path: image,
    ),
  );
}
