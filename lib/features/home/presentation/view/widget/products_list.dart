import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/widgets/product_item.dart';
import '../../model/products_list_item_model.dart';

Widget productsList({
  required ProductsListItemModel model,
  bool enableRoute = true,
}) {
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
              model.title,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s18,
                color: ManagerColors.primaryColor,
              ),
            ),
            enableRoute
                ? TextButton(
              onPressed: () {
                Get.toNamed(Routes.products);
              },
              child: Text(
                ManagerStrings.viewAll,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.primaryColor,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      SizedBox(
        height: ManagerHeight.h330,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: model.items.length,
          itemBuilder: (context, index) {
            return productItem(
              model: model.items[index],
            );
          },
        ),
      ),
      SizedBox(
        height: ManagerHeight.h8,
      ),
    ],
  );
}
