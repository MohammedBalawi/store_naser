import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/cart/presentation/view/widgets/quantity_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/service/image_service.dart';
import '../../../../../core/widgets/product_item.dart';
import 'corner_ribbon.dart';

Future<bool?> showDeleteConfirmDialog(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (dialogCtx) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 24),
      child: Container(
        width: w - 40,
        constraints: const BoxConstraints(maxWidth: 520, minWidth: 280),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ManagerStrings.supDeleteCart
              ,
              textAlign: TextAlign.center,
              style: getBoldTextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogCtx).pop(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ManagerColors.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(ManagerStrings.no,
                        style: getBoldTextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogCtx).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD0005F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(ManagerStrings.yes,
                        style: getBoldTextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class SwipeToDeleteWrapper extends StatefulWidget {
  const SwipeToDeleteWrapper({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.onConfirmDelete,
    this.icon,
    this.label = 'حذف',
    this.revealFraction = 0.40,
    this.openThreshold = 0.25,
    this.dismissThreshold = 0.85,
    this.borderRadius = 0,
  });

  final Widget child;
  final Color backgroundColor;
  final Future<void> Function() onConfirmDelete;
  final Widget? icon;
  final String label;

  final double revealFraction;
  final double openThreshold;
  final double dismissThreshold;
  final double borderRadius;

  @override
  State<SwipeToDeleteWrapper> createState() => _SwipeToDeleteWrapperState();
}

class _SwipeToDeleteWrapperState extends State<SwipeToDeleteWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  double _dx = 0.0;
  double _maxReveal = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    final tween = Tween<double>(begin: _dx, end: target).animate(_anim)
      ..addListener(() => setState(() {}));
    _anim
      ..reset()
      ..forward().whenComplete(() => _dx = target);
  }

  Future<void> _callDeleteAndClose() async {
    if (_busy) return;
    _busy = true;
    try {
      await widget.onConfirmDelete();
    } finally {
      if (mounted) _animateTo(0);
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, cons) {
      final width = cons.maxWidth;
      _maxReveal = width * widget.revealFraction;
      final bool isArabic = Get.locale?.languageCode == 'ar';

      final double minDX = isArabic ? 0.0 : -_maxReveal; // إنجليزي يسار
      final double maxDX = isArabic ? _maxReveal : 0.0;   // عربي يمين

      double openedDX() => isArabic ? _maxReveal : -_maxReveal;

      return Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Container(
                color: widget.backgroundColor,
                alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                padding: EdgeInsets.only(
                  left: isArabic ? 80 : 0,
                  right: isArabic ? 0 : 80,
                  top: 10,
                  bottom: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    widget.icon ??
                        const Icon(Icons.delete, color: Colors.white, size: 26),
                    const SizedBox(height: 6),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (d) {
              setState(() {
                _dx = (_dx + d.delta.dx).clamp(minDX, maxDX);
              });
            },
            onHorizontalDragEnd: (d) {
              final frac = (_dx.abs()) / width;
              if (frac < widget.openThreshold) {
                _animateTo(0);
              } else if (frac < widget.dismissThreshold) {
                _animateTo(openedDX());
                _callDeleteAndClose();
              } else {
                _animateTo(openedDX());
                _callDeleteAndClose();
              }
            },
            onTap: () {
              if (_dx != 0) _animateTo(0);
            },
            child: Transform.translate(offset: Offset(_dx, 0), child: widget.child),
          ),
        ],
      );
    });
  }
}

Widget cartItem({
  required BuildContext context,
  required ProductModel model,
  required int quantity,
  required VoidCallback onIncrement,
  required VoidCallback onDecrement,
  required Future<void> Function() onConfirmDelete,
  required bool isFavorite,
  required VoidCallback onToggleFavorite,
  bool showNewRibbon = true,
  String? discountText,
}) {
  final currentPrice = (model.price ?? 0);
  final oldPrice     = model.sellingPrice ?? currentPrice;

  final hasDiscount  = oldPrice > currentPrice;
  final totalNow     = (currentPrice * quantity);
  final totalOld     = (oldPrice * quantity);
  final bool isArabic = Get.locale?.languageCode == 'ar';

  final card = Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        margin: const EdgeInsetsDirectional.only(start: 0),
        padding: EdgeInsets.all(ManagerWidth.w20),
        decoration: BoxDecoration(
          color: ManagerColors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ManagerRadius.r4),
                  ),
                  child: Center(
                    child: ImageService.networkImage(
                      path: model.image ?? '',
                      width: 78,
                      height: 78,
                    ),
                  ),
                ),
                if (showNewRibbon)
                  PositionedDirectional(
                    top: 0,
                    start: 0,
                    child: CornerRibbonSimple(size: 57, label: ManagerStrings.news),
                  ),
              ],
            ),

            SizedBox(width: ManagerWidth.w10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      InkWell(
                        onTap: onToggleFavorite,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: isFavorite
                              ? SvgPicture.asset(ManagerImages.loved)
                              : SvgPicture.asset(ManagerImages.favorite),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (hasDiscount)
                            Padding(
                              padding: const EdgeInsets.only(left: 45),
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
                          Row(
                            children: [
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
                        onDelete: () async {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Divider(
        color: ManagerColors.grey.withOpacity(0.3),
        thickness: 1,
        height: 0,
      ),

      Positioned.fill(
        child: Align(
          alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ManagerRadius.r4),
            child: Container(width: 5, color: ManagerColors.like),
          ),
        ),
      ),
    ],
  );

  return SwipeToDeleteWrapper(
    backgroundColor: ManagerColors.like,
    borderRadius: ManagerRadius.r4,
    revealFraction: 0.40,
    openThreshold: 0.25,
    dismissThreshold: 0.85,
    onConfirmDelete: onConfirmDelete,
    label: ManagerStrings.delete,
    icon: SvgPicture.asset(
      ManagerImages.delete_num,
      width: 26,
      height: 26,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    ),
    child: card,
  );
}
