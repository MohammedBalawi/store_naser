// lib/features/auth/presentation/view/email_verification_view.dart
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../verification/presentation/widget/code_verification.dart';
import '../controller/email_verification_controller.dart';

class EmailVerificationView extends GetView<EmailVerificationController> {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          GestureDetector(
            onTap: (){
              Get.back();
            },
              child: SvgPicture.asset(ManagerImages.arrows)),
            Text('التحقق من البريد الإلكتروني',
                style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(width: 50),
          ],
        ),
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        children: [
          Text('أدخل الرمز المكون من 4 أرقام',
              style: getBoldTextStyle(color: Colors.black, fontSize: 24)),
          const SizedBox(height: 15),
          Text(
            'تم إرسال الرمز الخاص بك إلى ${controller.email}',
            style: getRegularTextStyle(
                color: ManagerColors.gray_3, fontSize: 16),
          ),
          const SizedBox(height: 25),

          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10,),
                CodeVerification(
                  controller: controller.t1,
                  focusNode: controller.f1,
                  previousFocusNode: controller.f1,
                  onChanged: (v) => controller.onBoxChanged(0, v),
                  validator: (_) => null,
                  hasError: controller.hasError.value,
                ),
                CodeVerification(
                  controller: controller.t2,
                  focusNode: controller.f2,
                  previousFocusNode: controller.f1,
                  onChanged: (v) => controller.onBoxChanged(1, v),
                  validator: (_) => null,
                  hasError: controller.hasError.value,
                ),
                CodeVerification(
                  controller: controller.t3,
                  focusNode: controller.f3,
                  previousFocusNode: controller.f2,
                  onChanged: (v) => controller.onBoxChanged(2, v),
                  validator: (_) => null,
                  hasError: controller.hasError.value,
                ),
                CodeVerification(
                  controller: controller.t4,
                  focusNode: controller.f4,
                  previousFocusNode: controller.f3,
                  onChanged: (v) => controller.onBoxChanged(3, v),
                  validator: (_) => null,
                  hasError: controller.hasError.value,
                ),
                SizedBox(width: 10,),

              ],
            );
          }),

          const SizedBox(height: 12),

          Obx(() => Visibility(
            visible: controller.hasError.value,
            child: Row(
              children: [
                SvgPicture.asset(ManagerImages.warning),
                const SizedBox(width: 6),
                Text('رمز غير صحيح',
                    style: getBoldTextStyle(
                        color: ManagerColors.like, fontSize: 12)),
              ],
            ),
          )),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: Obx(() {
              return Align(
                alignment: Alignment.centerRight,
                child: controller.canResend.value
                    ? InkWell(
                  onTap: controller.resend,
                  child: Text('إعادة إرسال الرمز',
                      style: getBoldTextStyle(
                          color: ManagerColors.primaryColor, fontSize: 14)),
                )
                    : Text(
                  'إعادة إرسال الرمز ${controller.secondsLeft.value} ثانية',
                  style: getRegularTextStyle(
                      color: ManagerColors.gray_3, fontSize: 14),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          Obx(() {
            final enabled = controller.ready;
            return SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: enabled ? controller.submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: enabled
                      ? ManagerColors.primaryColor
                      : ManagerColors.color_off,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('التحقق',
                    style:
                    getBoldTextStyle(color: Colors.white, fontSize: 16)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
