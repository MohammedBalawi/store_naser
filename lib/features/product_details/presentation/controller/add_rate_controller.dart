// lib/features/product_details/presentation/controller/add_rate_controller.dart
import 'dart:io';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddRateController extends GetxController {
  final title = TextEditingController();
  final comment = TextEditingController();

  double rate = 0.0;

  final List<XFile> selectedImages = [];
  final int maxImages = 3;

  String userName = 'Guest';

  void resetForm() {
    title.clear();
    comment.clear();
    rate = 0.0;
    selectedImages.clear();
    update();
  }

  void changeRate(double v) {
    rate = v.clamp(0, 5); // double
    update();
  }

  String get ratingLabel {
    switch (rate) {
      case 5:
        return ManagerStrings.amazing;
      case 4:
        return ManagerStrings.veryGood;
      case 3:
        return ManagerStrings.itWasGood;
      case 2:
        return ManagerStrings.notVeryGood;
      case 1:
        return ManagerStrings.disappointing;
      default:
        return '';
    }
  }

  bool checkButtonEnabled() {
    return rate >= 1 && comment.text.trim().isNotEmpty;
  }

  Future<void> pickImages() async {
    if (selectedImages.length >= maxImages) return;

    final picker = ImagePicker();
    final files = await picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );

    if (files == null || files.isEmpty) return;

    final remain = maxImages - selectedImages.length;
    selectedImages.addAll(files.take(remain));

    update();
  }



  void removeImageAt(int index) {
    if (index < 0 || index >= selectedImages.length) return;
    selectedImages.removeAt(index);
    update();
  }

  Map<String, dynamic> buildLocalReview() {
    return {
      'rate': rate.round(),                          // int من 1 إلى 5
      'username': userName,
      'title': title.text.trim(),               // اختياري
      'comment': comment.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
      'likes': 1,                               // قيمة ابتدائية
      'photos': selectedImages.map((x) => x.path).toList(), // مسارات محلية
    };
  }

  Map<int, int> countsByStar(List<Map<String, dynamic>> reviews) {
    final Map<int, int> m = {1:0, 2:0, 3:0, 4:0, 5:0};
    for (final r in reviews) {
      final v = (r['rate'] ?? 0);
      final int star = v is int ? v : (v as num).round();
      if (m.containsKey(star)) m[star] = (m[star] ?? 0) + 1;
    }
    return m;
  }
}
