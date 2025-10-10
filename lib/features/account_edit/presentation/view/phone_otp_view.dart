// lib/features/account_edit/presentation/view/phone_otp_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_images.dart';
import '../controller/phone_otp_controller.dart';

class PhoneOtpView extends GetView<PhoneOtpController> {
  const PhoneOtpView({super.key});

  Widget _box(TextEditingController c, FocusNode f, FocusNode? prev, int idx) {
    return SizedBox(
      width: 64,
      height: 56,
      child: TextField(
        controller: c,
        focusNode: f,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE9E9EF))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE9E9EF))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ManagerColors.primaryColor)),
        ),
        onChanged: (v) => controller.onBoxChanged(idx, v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ManagerColors.background,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('التحقق من الرقم', style: getBoldTextStyle(color: Colors.black, fontSize: 20)),

          leading:  GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(ManagerImages.arrows)),

        ),

        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            const SizedBox(height: 8),
            Text('أدخل الرمز المكون من 4 أرقام', style: getBoldTextStyle(color: Colors.black, fontSize: 24)),
            const SizedBox(height: 6),
            Text('تم إرسال الرمز الخاص بك إلى ${controller.phoneDisplay}',
                style: getRegularTextStyle(color: ManagerColors.gray_3, fontSize: 14)),
            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(controller.t1, controller.f1, null, 0),
                _box(controller.t2, controller.f2, controller.f1, 1),
                _box(controller.t3, controller.f3, controller.f2, 2),
                _box(controller.t4, controller.f4, controller.f3, 3),
              ],
            ),

            const SizedBox(height: 10),

            Obx(() => Visibility(
              visible: controller.hasError.value,
              child: Row(
                children: [
                  const Icon(Icons.error, color: Color(0xFFD7374A)),
                  const SizedBox(width: 6),
                  Text('رمز غير صحيح',
                      style: getBoldTextStyle(color: const Color(0xFFD7374A), fontSize: 14)),
                ],
              ),
            )),

            const SizedBox(height: 12),

            Obx(() => Align(
              alignment: Alignment.center,
              child: controller.canResend.value
                  ? InkWell(
                onTap: controller.resend,
                child: Text('إعادة إرسال الرمز',
                    style: getBoldTextStyle(color: ManagerColors.primaryColor, fontSize: 14)),
              )
                  : Text('إعادة إرسال الرمز ${controller.secondsLeft.value} ثانية',
                  style: getRegularTextStyle(color: ManagerColors.gray_3, fontSize: 14)),
            )),
          ],
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 60),
          child: Obx(() {
            final enabled = controller.ready;

            const activeColor   = ManagerColors.color; // بنفسجي غامق
            const inactiveColor = ManagerColors.color_off; // بنفسجي فاتح

            return SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: enabled ? controller.submit : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white, // لا تخليه شفاف
                  backgroundColor: activeColor,
                  disabledBackgroundColor: inactiveColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text('تحقق',
                    style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
              ),
            );
          }),
        ),
      ),
    );
  }
}
