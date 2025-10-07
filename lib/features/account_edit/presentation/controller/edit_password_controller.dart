import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNameController extends GetxController {
  late final TextEditingController nameController;

  final length = 0.obs;
  final canSave = false.obs;

  @override
  void onInit() {
    super.onInit();
    final initial = (Get.arguments?['name'] as String?) ?? '';
    nameController = TextEditingController(text: initial);
    length.value = initial.characters.length;
    canSave.value = length.value > 0;
  }

  void onChanged(String v) {
    length.value = v.characters.length;
    canSave.value = v.trim().isNotEmpty;
  }

  Future<void> save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // TODO: استدعاء API لحفظ الاسم
    Get.snackbar('تم', 'تم حفظ الاسم بنجاح',
        snackPosition: SnackPosition.BOTTOM);
    Get.back(result: nameController.text.trim());
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
