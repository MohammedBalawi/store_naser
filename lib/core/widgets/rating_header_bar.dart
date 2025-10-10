import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

class RatingHeaderBar extends StatelessWidget {
  const RatingHeaderBar({
    super.key,
    required this.average,      // مثال: 5.0
    required this.count,        // مثال: 3242
    required this.onRateTap,    // الضغط على "تقييم المنتج"
    this.bgColor = const Color(0xFFF3ECFF), // بنفسجي فاتح
    this.primary = const Color(0xFF8A4DFF), // بنفسجي للنص
  });

  final double average;
  final int count;
  final VoidCallback onRateTap;
  final Color bgColor;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                        (_) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5),
                      child: Icon(Icons.star, size: 15, color: Color(0xFFFFC107)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Text(
                  ' ${average.toStringAsFixed(1)} ',
                  style:  getRegularTextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),                Text(
                  '( ${count.toString()} مراجعة)  ',
                  style:  getRegularTextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                // 5 نجوم ممتلئة (يمكنك جعلها ديناميكية إن أردت)
              ],
            ),
            const Spacer(),

            InkWell(
              onTap: onRateTap,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Icon(Icons.add, color: ManagerColors.color, size: 22),
                  const SizedBox(width: 8),

                  Text(
                    'تقييم المنتج',
                    style: getRegularTextStyle(
                      fontSize: 12,

                      color: ManagerColors.color,
                    ),
                  ),
                ],
              ),
            ),


            // التقييم + النجوم
          ],
        ),
      ),
    );
  }
}
