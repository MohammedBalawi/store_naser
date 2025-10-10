import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/widgets/product_item.dart';
import '../../model/products_list_item_model.dart';

Widget productsList({
  required ProductsListItemModel model,
  bool enableRoute = true,
  // شغّل هذا عشان يطلع الهيدر بنفس شكل الصورة
  bool minimalHeader = true,
  String badgeText = 'جديد', // غيّرها لو بدك نفس النص اللي بالصورة
}) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w16,
          vertical: ManagerHeight.h16,
        ),
        child: minimalHeader
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD0ED9B), // أخضر فاتح (خلفية)
                borderRadius: BorderRadius.circular(0),
              ),
              child: Text(
                badgeText,
                textDirection: TextDirection.rtl,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: const Color(0xFF76B800), // أخضر للنص
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: enableRoute && model.route != null
                  ? () => Get.toNamed(model.route!)
                  : null,
              child: Text(
                'عرض المزيد',
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: Colors.grey, // رمادي خفيف
                ),
              ),
            ),

          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // العنوان التقليدي
            Text(
              model.title,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s18,
                color: ManagerColors.black,
              ),
            ),
            enableRoute
                ? TextButton(
              onPressed: () {
                if (model.route != null) {
                  Get.toNamed(model.route!);
                }
              },
              child: Text(
                'عرض المزيد',
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: Colors.grey,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),

      // القائمة الأفقية
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
      SizedBox(height: ManagerHeight.h8),
    ],
  );
}
