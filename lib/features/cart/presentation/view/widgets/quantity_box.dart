import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_width.dart';

class QuantityBox extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement; // لما تكون > 1
  final VoidCallback onDelete;    // لما تكون == 1

  const QuantityBox({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF8F8F8); // خلفية فاتحة مثل اللقطة
    final border = Colors.black.withOpacity(0.08);

    return Container(
      height: ManagerHeight.h36, // قريب من لقطة التصميم
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // +
          if (quantity > 1)
            _tap(
              onTap: onDecrement,
              child: const Icon(Icons.remove, size: 20, color: Colors.black),
            )
          else
            _tap(
              onTap: onDelete,
              child:SvgPicture.asset(ManagerImages.delete_num,color: ManagerColors.like,height: 18,),),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w10),
            child: Text(
              '$quantity',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
            ),
          ),


          _tap(
            onTap: onIncrement,
            child: const Icon(Icons.add, size: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _tap({required VoidCallback onTap, required Widget child}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: child,
      ),
    );
  }
}
