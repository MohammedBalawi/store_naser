import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/skin_tone_controller.dart';

class SkinToneRow extends GetView<SkinToneController> {
  final int index;
  const SkinToneRow({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final tone = SkinToneController.tones[index];

    return Obx(() {
      final selected = controller.selectedIndex.value == index;

      return InkWell(
        onTap: () => controller.select(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: tone.swatch,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? ManagerColors.primaryColor : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                tone.label,
                style: getBoldTextStyle(color: Colors.black, fontSize: 16),
              ),
              const Spacer(),


              SizedBox(
                width: 24,
                child: selected
                    ? const Icon(Icons.check, size: 18, color: Colors.black54)
                    : const SizedBox.shrink(),
              ),

            ],
          ),
        ),
      );
    });
  }
}
