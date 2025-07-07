import 'package:app_mobile/core/service/image_service.dart';
import 'package:app_mobile/features/home/domain/model/home_main_category_model.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:get/get.dart';
import '../../features/categories/presentation/controller/categories_controller.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_width.dart';

Widget categoryItem({
  required HomeMainCategoryModel model,
  double? width,
  double? height,
}) {
  return InkWell(
    onTap: () {
      Get.find<CategoriesController>().navigateToProducts(
        id: model.id.toString(),
        name: model.name,
      );
    },
    child: Column(
      children: [
        Container(
          width: width ?? ManagerWidth.w58,
          height: height ?? ManagerHeight.h58,
          margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
          decoration: ShapeDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: ImageService.networkImageContainer(
                path: 'model',
              ),
              fit: BoxFit.fill,
            ),
            shape: const OvalBorder(),
          ),
        ),
        SizedBox(
          height: ManagerHeight.h6,
        ),
        Text(
          model.name,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s12,
            color: ManagerColors.primaryColor,
          ),
        )
      ],
    ),
  );
}
