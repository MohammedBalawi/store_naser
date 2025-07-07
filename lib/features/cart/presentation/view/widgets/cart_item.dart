import 'package:app_mobile/features/cart/presentation/view/widgets/quantity_control_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/service/image_service.dart';

Widget cartItem({
  required ProductModel model,
  required int quantity,
  required VoidCallback onIncrement,
  required VoidCallback onDecrement,
  required VoidCallback onDelete,
}) {
  return Padding(
    padding: EdgeInsets.only(top: ManagerHeight.h20),
    child: Container(
      padding: EdgeInsets.all(ManagerWidth.w10),
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ManagerWidth.w100,
            height: ManagerHeight.h100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ManagerRadius.r10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: ImageService.networkImage(
              path: model.image ?? '',
              width: ManagerWidth.w100,
              height: ManagerHeight.h100,
            ),
          ),
          SizedBox(width: ManagerWidth.w10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.name ?? '',
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: onDelete,
                      child: SvgPicture.asset(
                        ManagerImages.delete,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ManagerHeight.h6),
                Row(
                  children: [
                    Text("${ManagerStrings.color} ",
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.grey,
                      ),
                    ),
                    Text(
                      model.color ?? '',
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w16),
                    Text("${ManagerStrings.size} ",
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.grey,
                      ),
                    ),
                    Text(
                      model.size ?? '',
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ManagerHeight.h10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        quantityControlContainer(
                          icon: ManagerIcons.add,
                          onPressed: onIncrement,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w10),
                          child: Text(
                            '$quantity',
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s16,
                              color: ManagerColors.black,
                            ),
                          ),
                        ),
                        quantityControlContainer(
                          icon: ManagerIcons.remove,
                          onPressed: onDecrement,
                        ),
                      ],
                    ),
                    Text(
                      '${(model.price ?? 0) * quantity} ₪',
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
