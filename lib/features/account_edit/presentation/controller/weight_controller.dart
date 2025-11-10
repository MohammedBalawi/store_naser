import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_styles.dart';

class WeightController extends GetxController {
  static const int minKg = 30;
  static const int maxKg = 200;

  final currentWeight = 50.obs;

  final selected = 50.obs;

  RxBool get canSave => (selected.value != currentWeight.value).obs;

  void onChanged(int v) => selected.value = v;

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
              'لقد تم تحديث وزنك بنجاح.',
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
