import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Gender { male, female }

class GenderController extends GetxController {
  final Gender? current = null;

  final Rxn<Gender> selected = Rxn<Gender>();

  final canSave = false.obs;

  void pick(Gender g) {
    selected.value = g;
    canSave.value = (selected.value != current) && selected.value != null;
  }

  Future<void> save() async {
    if (!canSave.value || selected.value == null) return;

    canSave.value = false;
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
              'لقد تم تحديث تفضيلات الجنس الخاصة بك بنجاح.',
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
