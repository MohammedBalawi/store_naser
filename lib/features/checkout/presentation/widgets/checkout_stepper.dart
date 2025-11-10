import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CheckoutStepper extends StatelessWidget {
  final int step;
  const CheckoutStepper({super.key, required this.step});

  Color get green => ManagerColors.greens;
  Color get lineGray => const Color(0xFFE6E6E6);
  Color get nodeGray => const Color(0xFFEDEDED);
  Color get labelGray => const Color(0xFFB5B5B5);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _node(0),
            _seg(rightIndex: 0),
            _node(1),
            _seg(rightIndex: 1),

            _node(2),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label(ManagerStrings.shippingAddress, 0),
            _label(ManagerStrings.payment, 1),

            _label(ManagerStrings.orderSent, 2),
          ],
        ),
      ],
    );
  }

  Widget _node(int idx) {
    final bool isCompleted = step > idx;
    final bool isActive = step == idx;
    const double size = 32;

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: (isCompleted || isActive) ? green : nodeGray,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : isActive
            ? Container(
          width: 6, height: 6,
          decoration: const BoxDecoration(
            color: Colors.white, shape: BoxShape.circle,
          ),
        )
            : Text(
          '${idx + 1}',
          style:  getBoldTextStyle(
            color: Color(0xFF7B7B7B),
           fontSize: 14
          ),
        ),
      ),
    );
  }

  Widget _seg({required int rightIndex}) {
    final bool filled = step > rightIndex;
    return Expanded(
      child: Container(
        height: 4,
        color: filled ? green : lineGray,
      ),
    );
  }

  Widget _label(String text, int idx) {
    final bool highlight = step >= idx;
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Text(
      text,
      style: getMediumTextStyle(
      fontSize: 12,
        color: highlight ? Colors.black : labelGray,
      ),
      textAlign:isArabic? TextAlign.right:TextAlign.left,
    );
  }
}
