import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';

import '../controller/edit_password_controller.dart';

class EditPasswordView extends GetView<PasswordController> {
  const EditPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(ManagerImages.arrows)),
            Text('تغيير كلمة المرور', style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(width: 42),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
      ),

      body: Obx(() {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              children: [
                const SizedBox(height: 12),

                // ====== بطاقة الحقول ======
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    children: [
                      // كلمة المرور الجديدة
                      _PasswordField(
                        controller: controller.newCtrl,
                        hint: 'أدخل كلمة المرور الجديدة',
                        obscureRx: controller.obscureNew,
                        onChanged: controller.onChangedNew,
                        isValidRx: controller.validLength,     // طول ≥ 8
                        showIndicatorsRx: controller.showIndicators,
                        showErrorWhenInvalidAndNotEmpty: true,
                        isLengthRule: true, // لتمييز لون الأيقونة إن رغبت
                      ),
                      const SizedBox(height: 16),

                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'سيتم تسجيل خروجك من جميع الجلسات باستثناء هذه الجلسة\nلحماية حسابك إذا حاول أي شخص الوصول إليه.',
                          style: getBoldTextStyle(fontSize: 12, color: ManagerColors.gray),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // تأكيد كلمة المرور
                      _PasswordField(
                        controller: controller.confirmCtrl,
                        hint: 'أدخل تأكيد كلمة المرور',
                        obscureRx: controller.obscureConfirm,
                        onChanged: controller.onChangedConfirm,
                        isValidRx: controller.matchValid,       // تطابق
                        showIndicatorsRx: controller.showIndicators,
                        showErrorWhenInvalidAndNotEmpty: true,
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),

            // ====== بانر منزلق فوق الـ AppBar ======
            _DropBanner(
              message: controller.banner.value?.message ?? '',
              isError: controller.banner.value?.isError ?? false,
              visible: controller.bannerShown.value,
            ),
          ],
        );
      }),

      // ====== زر الحفظ ======
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 60),
        child: Obx(() {
          final enabled = controller.canSave.value;
          const activeColor   = ManagerColors.color;      // بنفسجي غامق
          const inactiveColor = ManagerColors.color_off;  // بنفسجي فاتح

          return SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.save : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                backgroundColor: activeColor,
                disabledBackgroundColor: inactiveColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: controller.saving.value
                  ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text('تغيير كلمة المرور',
                  style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          );
        }),
      ),
    );
  }
}

// ===================== Widgets مساعدة =====================

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscureRx,
    required this.onChanged,
    required this.isValidRx,
    required this.showIndicatorsRx,
    this.showErrorWhenInvalidAndNotEmpty = false,
    this.isLengthRule = false,
  });

  final TextEditingController controller;
  final String hint;
  final RxBool obscureRx;
  final void Function(String) onChanged;
  final RxBool isValidRx;
  final RxBool showIndicatorsRx;
  final bool showErrorWhenInvalidAndNotEmpty;
  final bool isLengthRule; // true للحقل الأول (شرط الطول)

  bool _hasText() => controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFFE9E9EF);

    return Obx(() {
      final isValid   = isValidRx.value;
      final hasText   = _hasText();
      final showError = showErrorWhenInvalidAndNotEmpty && hasText && !isValid;

      // نظهر الأيقونات فقط بعد الضغط على الزر
      final shouldShowIcons = showIndicatorsRx.value && hasText;

      return TextField(
        textAlign: TextAlign.start,
        controller: controller,
        obscureText: obscureRx.value,
        onChanged: onChanged,
        maxLength: 30,
        style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
        decoration: InputDecoration(
          counterText: '',
          hintText: hint,
          hintStyle: getRegularTextStyle(fontSize: 16, color: ManagerColors.bongrey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: ManagerColors.primaryColor),
          ),
          suffixIcon: Obx(() {
            final isValid = isValidRx.value;
            final hasText = controller.text.trim().isNotEmpty;
            final showError = showErrorWhenInvalidAndNotEmpty && hasText && !isValid;
            final shouldShowIcons = showIndicatorsRx.value && hasText;

            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (shouldShowIcons)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6),
                    child: isValid
                        ? const Icon(Icons.check_circle, color: Color(0xFF8A4DD7), size: 22)
                        : showError
                        ? SvgPicture.asset(ManagerImages.warning)
                        : const SizedBox.shrink(),
                  ),
                IconButton(
                  onPressed: obscureRx.toggle,
                  icon: obscureRx.value
                      ? SvgPicture.asset(ManagerImages.close_eye, width: 22, height: 22)
                      : const Icon(Icons.visibility_outlined, size: 22),
                ),
                // أيقونة الحالة (تظهر بعد الضغط على زر الحفظ فقط)

              ],
            );
          }),
        ),
      );
    });
  }
}

/// بانر ينزل من فوق الـ AppBar ثم يطلع (AnimatedSlide + AnimatedOpacity)
class _DropBanner extends StatelessWidget {
  const _DropBanner({
    required this.message,
    required this.isError,
    required this.visible,
  });

  final String message;
  final bool isError;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final iconColor = isError ? Colors.red : ManagerColors.like;

    return IgnorePointer(
      ignoring: true, // ما يستقبل لمس
      child: Stack(
        children: [
          // Positioned حتى نتحكم بمكان الظهور بالضبط
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: visible ? kToolbarHeight - 40 : -10, // 🔹 يظهر أسفل الـ AppBar
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: visible ? 1 : 0,
              child: Center(
                child: Container(
                  height: 40,
                  width: 260,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isError ?
                          SvgPicture.asset(ManagerImages.warning):
                      Icon(Icons.check_circle, color: iconColor, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: getMediumTextStyle(
                            fontSize: 11,
                            color: ManagerColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


