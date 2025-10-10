import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_colors.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.onTap,
    this.selected = false,
    this.width = 100,
    this.cardHeight = 45,
    this.popAmount = 28,
    this.radius = 20,
    this.iconSize = 50,
    this.gap = 10,
  });

  final String iconAsset;
  final String title;
  final VoidCallback onTap;
  final bool selected;

  final double width;
  final double cardHeight;
  final double popAmount;
  final double radius;
  final double iconSize;
  final double gap;

  bool get _isSvg => iconAsset.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF1EFF0);
    final titleColor = selected ? ManagerColors.primaryColor : Colors.black;

    final totalHeight = popAmount + cardHeight + gap + 26; // زيادة شوي للنص مع الخط

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: totalHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الكرت + الأيقونة الطالعة
            SizedBox(
              height: popAmount + cardHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: popAmount,
                    left: 0,
                    right: 0,
                    height: cardHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _isSvg
                          ? SvgPicture.asset(
                        iconAsset,
                        width: iconSize,
                        height: iconSize,
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      )
                          : Image.asset(
                        iconAsset,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 75,
                    left: 0,
                    right: 0,
                    child:  Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumTextStyle(fontSize: 12, color: titleColor)
                        ),

                      ],
                    )
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
