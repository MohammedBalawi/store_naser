// lib/features/product_details/presentation/controller/add_rate_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddRateController extends GetxController {
  // الحقول
  final title = TextEditingController();
  final comment = TextEditingController();

  /// التقييم الحالي (عدد صحيح 1..5)
  double rate = 0.0;

  /// صور مختارة محليًا (حد أقصى 5)
  final List<XFile> selectedImages = [];
  final int maxImages = 5;

  /// اسم المستخدم المؤقت (بدّله ببيانات البروفايل عندك)
  String userName = 'Guest';

  /// إعادة ضبط النموذج
  void resetForm() {
    title.clear();
    comment.clear();
    rate = 0.0;
    selectedImages.clear();
    update();
  }

  /// تغيير قيمة التقييم من الـ RatingBar
  void changeRate(double v) {
    rate = v.clamp(0, 5); // double
    update();
  }

  /// يظهر نصًا أسفل النجوم مثل الصور (5=رائع، 4=جيد جدًا...)
  String get ratingLabel {
    switch (rate) {
      case 5:
        return 'رائع';
      case 4:
        return 'جيد جدًا';
      case 3:
        return 'لقد كان جيدا';
      case 2:
        return 'ليس جيدا جدا';
      case 1:
        return 'مخيب للآمال';
      default:
        return '';
    }
  }

  /// فعالية زر الإرسال
  bool checkButtonEnabled() {
    return rate >= 1 && comment.text.trim().isNotEmpty;
  }

  /// اختيار صور متعددة
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

  /// حذف صورة من المعاينة
  void removeImageAt(int index) {
    if (index < 0 || index >= selectedImages.length) return;
    selectedImages.removeAt(index);
    update();
  }

  /// بناء مراجعة محلية (لإضافتها مباشرةً إلى القائمة)
  /// ملاحظة: المفتاح 'photos' هو ما تستخدمه واجهة العرض _ReviewTile
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

  /// (اختياري) إحصاءات بعدد المراجعات لكل نجمة؛ مفيد لو أردت شارات أرقام بجانب الفلاتر
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
