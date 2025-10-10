import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/verification_controller.dart';
import '../widget/code_verification.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            ),
            Text('التحقق من الرقم',
                style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            SizedBox(width: 50,),
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
          SizedBox(height: 10,),
          Text(
            'أدخل الرمز المكون من 4 أرقام',
            style: getBoldTextStyle(color: Colors.black, fontSize: 24),
          ),
          const SizedBox(height: 6),

          RichText(
            text: TextSpan(
              style: getRegularTextStyle(
                  color: ManagerColors.gray_3, fontSize: 16),
              children: [
                const TextSpan(text: 'تم إرسال الرمز الخاص بك إلى '),
                TextSpan(
                  text: controller.phoneDisplay,
                  style: getRegularTextStyle(
                      color: ManagerColors.gray_3, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CodeVerification(
                  controller: controller.firstCodeTextController,
                  focusNode: controller.firstFocusNode,
                  previousFocusNode: controller.firstFocusNode,
                  onChanged: (v) => controller.onBoxChanged(0, v),
                  validator: (_) => null,
                  hasError: controller.hasError.value,
                ),
                CodeVerification(
                  controller: controller.secondCodeTextController,
                  focusNode: controller.secondFocusNode,
                  previousFocusNode: controller.firstFocusNode,
                  onChanged: (v) => controller.onBoxChanged(1, v),
                  validator: (_) => null,
                  hasError: controller.hasError.value,
                ),
                CodeVerification(
                  controller: controller.thirdCodeTextController,
                  focusNode: controller.thirdFocusNode,
                  previousFocusNode: controller.secondFocusNode,
                  onChanged: (v) => controller.onBoxChanged(2, v),
                  validator: (_) => null,
                  hasError: controller.hasError.value,
                ),
                CodeVerification(
                  controller: controller.fourthCodeTextController,
                  focusNode: controller.fourthFocusNode,
                  previousFocusNode: controller.thirdFocusNode,
                  onChanged: (v) => controller.onBoxChanged(3, v),
                  validator: (_) => null,
                  hasError: controller.hasError.value,
                ),
              ],
            );
          }),

          const SizedBox(height: 10),

          // رسالة خطأ
          Obx(() => Visibility(
            visible: controller.hasError.value,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                   Icon(Icons.error,
                      color: ManagerColors.like, size: 22),
                  const SizedBox(width: 6),
                  Text('رمز غير صحيح',
                      style: getBoldTextStyle(
                          color: ManagerColors.like, fontSize: 14)),
                ],
              ),
            ),
          )),

          const SizedBox(height: 12),

          // إعادة إرسال
          Obx(() {
            return Align(
              alignment: Alignment.center,
              child: controller.canResend.value
                  ? InkWell(
                onTap: controller.resend,
                child: Text(
                  'إعادة إرسال الرمز',
                  style: getBoldTextStyle(
                      color: ManagerColors.primaryColor, fontSize: 14),
                ),
              )
                  : Text(
                'إعادة إرسال الرمز ${controller.secondsLeft.value} ثانية',
                style: getRegularTextStyle(
                    color: ManagerColors.gray_3, fontSize: 14),
              ),
            );
          }),

          const SizedBox(height: 24),

          // زر سجّل الآن
          Obx(() {
            final enabled = controller.ready;

            const activeColor = ManagerColors.primaryColor; // بنفسجي غامق
            const inactiveColor = ManagerColors.color_off;  // بنفسجي فاتح

            return SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: enabled ? controller.submit : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white, // خلي النص أبيض حتى لما يتعطل
                  backgroundColor: activeColor,
                  disabledBackgroundColor: inactiveColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'سجل الآن',
                  style: getBoldTextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }),

        ],
      ),
    );
  }
}
