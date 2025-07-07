import 'package:flutter/material.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_width.dart';

Widget homeAdvertisementItem({
  required String imageUrl,
}) {
  return Container(
    width: ManagerWidth.w335,
    height: ManagerHeight.h160,
    margin: EdgeInsets.symmetric(
      horizontal: ManagerWidth.w12,
      vertical: ManagerHeight.h12,
    ),
    decoration: ShapeDecoration(
      color: Colors.white,
      image: DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ManagerRadius.r10,
        ),
      ),
    ),
  );
}
