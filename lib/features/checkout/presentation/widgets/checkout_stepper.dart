import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';

/// step:
/// 0 = عنوان الشحن (نشط)  | 1 = الدفع (نشط)  | 2 = تم الإرسال (نشط)
class CheckoutStepper extends StatelessWidget {
  final int step;
  const CheckoutStepper({super.key, required this.step});

  Color get green => ManagerColors.greens; // الأخضر المستخدم عندك
  Color get lineGray => const Color(0xFFE6E6E6);
  Color get nodeGray => const Color(0xFFEDEDED);
  Color get labelGray => const Color(0xFFB5B5B5);

  @override
  Widget build(BuildContext context) {
    // نعرض من اليسار لليمين: تم الإرسال (2) — خط — الدفع (1) — خط — عنوان الشحن (0)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _node(0),         // عنوان الشحن (يمين)
            _seg(rightIndex: 0), // خط بين (1) و (0) — يصير أخضر فقط إذا step >= 1
            _node(1),         // الدفع (وسط)
            _seg(rightIndex: 1), // خط بين (2) و (1) — يصير أخضر فقط إذا step >= 2

            _node(2),         // تم الإرسال (يسار)
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label("عنوان الشحن", 0),
            _label("الدفع", 1),

            _label("تم الإرسال", 2),
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
        // النقطة البيضاء الصغيرة في المنتصف (مثل الصورة)
            ? Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(
            color: Colors.white, shape: BoxShape.circle,
          ),
        )
        // رقم الخطوة داخل الدائرة الرمادية
            : Text(
          '${idx + 1}',
          style: const TextStyle(
            color: Color(0xFF7B7B7B),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  /// لون المقطع بين العقدتين:
  /// يصبح أخضر فقط إذا كانت الخطوة الحالية أكبر من العقدة التي على يمينه.
  /// مثال: الخط بين (1) و(0) أخضر عندما step >= 1
  Widget _seg({required int rightIndex}) {
    final bool filled = step > rightIndex; // >=1 للخط اليميني، >=2 للخط اليساري
    return Expanded(
      child: Container(
        height: 4,
        color: filled ? green : lineGray,
      ),
    );
  }

  /// لون عنوان كل عقدة: أسود للمنجزة/النشطة، رمادي للقادمة
  Widget _label(String text, int idx) {
    final bool highlight = step >= idx;
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: highlight ? Colors.black : labelGray,
      ),
      textAlign: TextAlign.right,
    );
  }
}
