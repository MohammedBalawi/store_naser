// lib/features/auth/presentation/view/forgot_password_view.dart
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../auth/presentation/widget/shadow_panel.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: SvgPicture.asset(ManagerImages.arrows),
            ),
            Text('نسيت كلمة المرور؟',
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
          Text('أدخل بريدك الإلكتروني',
              textAlign: TextAlign.start,
              style: getBoldTextStyle(color: Colors.black, fontSize: 18)),
          const SizedBox(height: 12),
          ShadowPanel(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFEDEDED)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: controller.onEmailChanged,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: 'عنوان البريد الإلكتروني',
                          hintStyle: getRegularTextStyle(
                              fontSize: 16, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        style: getRegularTextStyle(
                            fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Obx(() {
                  if (!controller.showNotRegistered.value) {
                    return const SizedBox.shrink();
                  }
                  return Row(
                    children: [
                      SvgPicture.asset(ManagerImages.warning,height: 24,),
                      const SizedBox(width: 8),
                      Text(
                        'هذا البريد الإلكتروني غير مسجل بعد.',
                        style: getRegularTextStyle(
                            color: ManagerColors.like, fontSize: 12),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 8),
                Text(
                  'سيرسل إليك عبر البريد الإلكتروني رمزًا لإعادة\n تعيين كلمة المرور الخاصة بك.',
                  textAlign: TextAlign.right,
                  style: getRegularTextStyle(
                      color: ManagerColors.gray_3, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final enabled = controller.validEmail;
        return Padding(
          padding: const EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 44),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.send : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                enabled ? ManagerColors.primaryColor : ManagerColors.color_off,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(ManagerStrings.send,
                  style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        );
      }),
    );
  }
}
