import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';

class HeightController extends GetxController {
  final currentHeight = 1.50.obs; // بالمتر مثل 1.70

  final List<double> values = List<double>.generate(
    101, // (2.20 - 1.20) / .01 + 1 = 101
        (i) => 1.20 + (i * 0.01),
  );

  late final FixedExtentScrollController scroll;

  // الحالة
  final selected = 1.50.obs;
  final canSave = false.obs;

  @override
  void onInit() {
    super.onInit();
    final initIndex = values.indexOf(currentHeight.value);
    scroll = FixedExtentScrollController(
      initialItem: initIndex >= 0 ? initIndex : 30, // احتياط
    );
    selected.value = currentHeight.value;
  }

  void onSelected(int index) {
    selected.value = values[index];
    canSave.value = selected.value != currentHeight.value;
  }

  Future<void> save() async {
    if (!canSave.value || selected.value == null) return;

    canSave.value = false;
    Get.closeAllSnackbars();

    Get.rawSnackbar(
      // ⬇️ تحكم بالموقع العمودي ليكون بمنتصف الجزء العلوي
      margin: EdgeInsets.only(
        left: Get.width * 0.1,
        right: Get.width * 0.1,
        top: Get.height * 0.02, // نسبة من ارتفاع الشاشة (عدّلها حسب موقعك المفضل)
      ),
      borderRadius: 12,
      backgroundColor: Colors.white,
      snackPosition: SnackPosition.TOP, // نخليه TOP حتى يسمح بالتحكم بالموقع
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.check_circle, color: ManagerColors.like),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'لقد تم تحديث طولك بنجاح.',
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
      snackStyle: SnackStyle.FLOATING, // شكل جميل يطفو فوق المحتوى
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }



  @override
  void onClose() {
    scroll.dispose();
    super.onClose();
  }
}
