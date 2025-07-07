import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_mobile/features/home/domain/model/home_main_category_model.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/widgets/category_item.dart';
import '../../../../main/presentation/controller/main_controller.dart';
import '../../controller/home_controller.dart';

Widget homeCategoriesList(List<HomeMainCategoryModel> categories) {
  final HomeController controller = Get.find();

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w16,
          vertical: ManagerHeight.h16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ManagerStrings.wishlist,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s18,
                color: ManagerColors.primaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.find<MainController>().navigate(1);
              },
              child: Text(
                ManagerStrings.viewAll,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),

      // Obx(() {
      //   if (controller.categories.isEmpty) {
      //     return const Center(child: CircularProgressIndicator());
      //   }
      //   return SizedBox(
      //     height: ManagerHeight.h100,
      //     child: ListView.builder(
      //       scrollDirection: Axis.horizontal,
      //       shrinkWrap: true,
      //       itemCount: controller.categories.length,
      //       itemBuilder: (context, index) {
      //         return categoryItem(
      //           model: controller.categories[index],
      //         );
      //       },
      //     ),
      //   );
      // }),
      Obx(() {
        if (controller.categories.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: ManagerHeight.h100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              return categoryItem(
                model: controller.categories[index],
              );
            },
          ),
        );
      }),
    ],
  );
}

