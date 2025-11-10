import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';

class SkinTone {
  final String label;
  final Color swatch;
  const SkinTone(this.label, this.swatch);
}

class SkinToneController extends GetxController {
  static  List<SkinTone> tones = <SkinTone>[
    SkinTone(ManagerStrings.white,  Color(0xFFF9E4C6)),
    SkinTone(ManagerStrings.light,  Color(0xFFF3C981)),
    SkinTone(ManagerStrings.medium, Color(0xFFD9B061)),
    SkinTone(ManagerStrings.dark,  Color(0xFFB7793E)),
    SkinTone(ManagerStrings.black,  Color(0xFF5E2B22)),
  ];

  final currentIndex = 4.obs;

  final selectedIndex = 4.obs;

  bool get canSave => selectedIndex.value != currentIndex.value;

  void select(int i) => selectedIndex.value = i;

  Future<void> save() async {
    currentIndex.value = selectedIndex.value;
    Get.closeAllSnackbars();

    Get.rawSnackbar(
      margin: EdgeInsets.only(
        left: Get.width * 0.1,
        right: Get.width * 0.1,
        top: Get.height * 0.02,
      ),
      borderRadius: 12,
      backgroundColor: Colors.white,
      snackPosition: SnackPosition.TOP,
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.check_circle, color: ManagerColors.like),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ManagerStrings.skinColorSuccessfully,
              textAlign: TextAlign.right,
              style: getMediumTextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

}
