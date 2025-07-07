import 'package:flutter/material.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_height.dart';

Widget divider() {
  return Column(
    children: [
      SizedBox(
        height: ManagerHeight.h14,
      ),
      Row(
        children: [
          Expanded(
            child: Container(
              color: ManagerColors.greyLight,
              height: ManagerHeight.h2,
            ),
          )
        ],
      ),
      SizedBox(
        height: ManagerHeight.h14,
      ),
    ],
  );
}
