import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

class CornerRibbon extends StatelessWidget {
  final String label;        // "جديد" / "العروضات"
  final Color color;         // أخضر للعادي - فوشيا للعروض
  final double size;         // عرض المثلث
  const CornerRibbon({
    super.key,
    required this.label,
    required this.color,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // مثلث
        Transform.translate(
          offset: const Offset(-4, -4),
          child: CustomPaint(
            size: Size(size, size),
            painter: _RibbonTrianglePainter(color),
          ),
        ),
        // النص داخل شريط صغير فوق المثلث
        Positioned(
          top: 8, left: 0,
          child: Transform.rotate(
            angle: -0.785398, // -45°
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RibbonTrianglePainter extends CustomPainter {
  final Color color;
  _RibbonTrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiscountTag extends StatelessWidget {
  final String text; // "57%"
  const DiscountTag({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFAE5EE), // وردي فاتح
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style:  getBoldTextStyle(
          color: ManagerColors.like,  fontSize: 10,
        ),
      ),
    );
  }
}
