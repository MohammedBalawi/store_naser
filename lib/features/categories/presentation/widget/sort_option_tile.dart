import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
class SortOptionTile<T> extends StatelessWidget {
  const SortOptionTile({
    required this.title,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final T? groupValue;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(value),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              fillColor: MaterialStateProperty.resolveWith<Color>(
                    (states) {
                  if (states.contains(MaterialState.selected)) {
                    return ManagerColors.color; // النقطة الداخلية زهري
                  }
                  return ManagerColors.gray_divedr; // ما في نقطة لما مش مختار
                },
              ),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              // نستخدم side لتغيير الحواف
              visualDensity: VisualDensity.compact,
              splashRadius: 18,
            ),


            // النص يمين مع وزن واضح مثل الصورة
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
              ),
            ),
            // دائرة الراديو بنفسجية عند التحديد
          ],
        ),
      ),
    );
  }
}