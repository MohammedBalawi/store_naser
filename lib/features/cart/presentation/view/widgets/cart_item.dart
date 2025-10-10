import 'package:app_mobile/features/cart/presentation/view/widgets/quantity_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/widgets/product_item.dart';
import '../../../../../core/service/image_service.dart';
import 'corner_ribbon.dart';
import 'quantity_control_container.dart';

Widget cartItem({
  required BuildContext context,
  required ProductModel model,
  required int quantity,
  required VoidCallback onIncrement,
  required VoidCallback onDecrement,
  required Future<void> Function() onConfirmDelete, // يعرض دايلوج ثم يحذف
  required bool isFavorite,               // ✅ جديد
  required VoidCallback onToggleFavorite, // ✅ جديد
  bool showNewRibbon = true,
  String? discountText, // "57%" لو فيه خصم
}) {
  final currentPrice = (model.price ?? 0);
  final oldPrice     = model.sellingPrice ?? currentPrice;

  final hasDiscount  = oldPrice > currentPrice;
  final totalNow     = (currentPrice * quantity);
  final totalOld     = (oldPrice * quantity);

  return Padding(
    padding: EdgeInsets.only(top: ManagerHeight.h20),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Slidable(
        key: ValueKey(model.id),
        endActionPane: ActionPane(
          extentRatio: 0.40,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async => await onConfirmDelete(),
              backgroundColor: const Color(0xFFD0005F),
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'حذف',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(ManagerWidth.w10),
          decoration: BoxDecoration(
            color: ManagerColors.white,
            borderRadius: BorderRadius.circular(ManagerRadius.r4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنتج + الشارة
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white, // خلفية بيضاء
                      borderRadius: BorderRadius.circular(ManagerRadius.r4),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.1),
                      //     blurRadius: 6,
                      //     offset: const Offset(0, 4),
                      //   ),
                      // ],
                    ),
                    child: Center(
                      child: ImageService.networkImage(
                        path: model.image ?? '',
                        width: 78,
                        height: 78,
                        // fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  if (showNewRibbon)
                    const PositionedDirectional(
                      top: 0,
                      end: 53,
                      child: CornerRibbonSimple(
                        size: 57,
                        label: 'جديد',
                      ),
                    ),
                ],
              ),
              SizedBox(width: ManagerWidth.w10),

              // نصوص + السعر + الكمية
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان + قلب
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            model.name ?? '',
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s14,
                              color: ManagerColors.gray_taxt,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // ❤️ المفضلة (قلب أحمر عند التفعيل)
                        InkWell(
                          onTap: onToggleFavorite,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: isFavorite
                                ? SvgPicture.asset(ManagerImages.loved)
                                : SvgPicture.asset(ManagerImages.favorite),
                            // لو لازم SVG:
                            // child: isFavorite
                            //   ? SvgPicture.asset(ManagerImages.favorite_filled, width: 20, height: 20, colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn))
                            //   : SvgPicture.asset(ManagerImages.favorite, width: 20, height: 20),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ManagerHeight.h6),

                    if ((model.sku ?? '').isNotEmpty)
                      Text(
                        model.sku!,
                        style: getRegularTextStyle(
                          fontSize: 14,
                          color: ManagerColors.gray_taxt,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    SizedBox(height: ManagerHeight.h10),

                    // الكمية + الأسعار
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // const SizedBox(height: 2),
                            if (hasDiscount)
                              Padding(
                                padding:  EdgeInsets.only(left: 45),
                                child: Text(
                                  '${totalOld.toStringAsFixed(0)} ر.س',
                                  style: getBoldTextStyle(
                                    fontSize: ManagerFontSize.s14,
                                    color: ManagerColors.grey,
                                  ).copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.grey,
                                    decorationThickness: 1.0,
                                  ),
                                ),
                              ),
                            // const SizedBox(height: 6),

                            Row(
                              children: [
                                // السعر القديم بخط أحمر واضح


                                Text(
                                  '${totalNow.toStringAsFixed(0)} ر.س',
                                  style: getBoldTextStyle(
                                    fontSize: ManagerFontSize.s14,
                                    color: ManagerColors.like,
                                  ),
                                ),
                                if (discountText != null) ...[
                                  const SizedBox(width: 6),

                                  DiscountTag(text: discountText!),
                                ],
                              ],
                            ),
                          ],
                        ),

                        QuantityBox(
                          quantity: quantity,
                          onIncrement: onIncrement,
                          onDecrement: onDecrement,
                          onDelete: () async {
                            // تقدر تغيّر السلوك حسب منطقك
                            // final ok = await showDeleteConfirmDialog(context) ?? false;
                            // if (ok) await onConfirmDelete();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
