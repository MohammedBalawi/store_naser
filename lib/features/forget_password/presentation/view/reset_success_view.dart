// lib/features/auth/presentation/view/reset_success_view.dart
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_colors.dart';
// استبدل هذه بـ شاشة الدخول عندك
import '../../../auth/presentation/view/login_email_view.dart';

class ResetSuccessView extends StatelessWidget {
  const ResetSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(ManagerImages.check),
                const SizedBox(height: 20),
                Text('تم تغيير كلمة المرور!',
                    style: getBoldTextStyle(color: Colors.black, fontSize: 25)),
                const SizedBox(height: 10),
                Text('لقد تم تغيير كلمة المرور الخاصة بك\n بنجاح.',
                    textAlign: TextAlign.center,
                    style: getRegularTextStyle(
                        color: ManagerColors.gray_3, fontSize: 16)),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offAll(() => const LoginEmailView()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ManagerColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('تسجيل الدخول',
                        style: getBoldTextStyle(
                            color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
