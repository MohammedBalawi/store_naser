import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_styles.dart';

class BirthdateController extends GetxController {
  DateTime initial = DateTime(2017, 8, 31);

  final year = 2017.obs;
  final month = 8.obs;  // 1..12
  final day = 31.obs;

  final canSave = false.obs;
  final hasError = false.obs;
  final errorText = ''.obs;

  // حدود الاختيار
  late final int minYear;
  late final int maxYear;
  final months = const [
    'يناير','فبراير','مارس','أبريل','مايو','يونيو',
    'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'
  ];

  String get display =>
      '${day.value.toString().padLeft(2,'0')} ${months[month.value-1]} ${year.value}';
  String get displayEn =>
      '${day.value.toString().padLeft(2,'0')}  ${months[month.value-1]}  ${year.value}';

  @override
  void onInit() {
    final arg = Get.arguments?['birthdate'] as DateTime?;
    if (arg != null) initial = arg;

    year.value = initial.year;
    month.value = initial.month;
    day.value = initial.day;

    final now = DateTime.now();
    minYear = 1950;
    maxYear = now.year;
    _revalidate();
    super.onInit();
  }

  int _daysInMonth(int y, int m) {
    if (m == 12) return 31;
    final firstNext = DateTime(y, m + 1, 1);
    final lastThis = firstNext.subtract(const Duration(days: 1));
    return lastThis.day;
  }

  void onYearChanged(int newYear) {
    year.value = newYear;
    _fitDayRange();
    _revalidate();
  }

  void onMonthChanged(int newMonth) {
    month.value = newMonth;
    _fitDayRange();
    _revalidate();
  }

  void onDayChanged(int newDay) {
    day.value = newDay;
    _revalidate();
  }

  void _fitDayRange() {
    final maxDay = _daysInMonth(year.value, month.value);
    if (day.value > maxDay) day.value = maxDay;
  }

  void _revalidate() {
    hasError.value = false;
    errorText.value = '';
    canSave.value = false;

    final picked = DateTime(year.value, month.value, day.value);
    final now = DateTime.now();

    if (!picked.isBefore(DateTime(now.year, now.month, now.day))) {
      hasError.value = true;
      errorText.value = 'الرجاء إدخال تاريخ ميلاد صالح';
      return;
    }

    canSave.value = picked != initial;
  }

  Future<void> save() async {
    _revalidate();
    if (!canSave.value) return;

    // TODO: استدعاء API لحفظ تاريخ الميلاد

    initial = DateTime(year.value, month.value, day.value);
    canSave.value = false;

    Get.closeAllSnackbars();

    Get.rawSnackbar(
      // 🟣 موقع الإشعار في منتصف الجزء العلوي من الشاشة
      margin: EdgeInsets.only(
        left: Get.width * 0.1,
        right: Get.width * 0.1,
        top: Get.height * 0.02,
      ),
      borderRadius: 12,
      backgroundColor: Colors.white,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      duration: const Duration(seconds: 2),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.check_circle, color: ManagerColors.like),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'لقد تم تحديث تاريخ ميلادك بنجاح.',
              textAlign: TextAlign.right,
              style: getMediumTextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
