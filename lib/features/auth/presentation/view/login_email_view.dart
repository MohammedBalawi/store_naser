// lib/features/auth/presentation/view/login_email_view.dart
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../forget_password/presentation/controller/forgot_password_controller.dart';
import '../../../forget_password/presentation/view/forgot_password_view.dart';
import '../controller/login_email_controller.dart';
import '../widget/auth_fields.dart';
import '../widget/phone_tab.dart';
import '../widget/shadow_panel.dart';

class LoginEmailView extends GetView<LoginEmailController> {
  const LoginEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon:SvgPicture.asset(ManagerImages.arrows),
            ),
            Text(
              "تسجيل الدخول",
              style: getBoldTextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(width: 40,)
          ],
        ),
        leadingWidth: 0,
        automaticallyImplyLeading: false,


        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: ManagerColors.primaryColor,
          indicatorWeight: 2,
          labelColor: ManagerColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: getBoldTextStyle(
            fontSize: 14,
            color: ManagerColors.primaryColor,
          ),
          unselectedLabelStyle: getRegularTextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          onTap: controller.onTabChanged,
          tabs: const [
            Tab(text: "رقم الهاتف"),
            Tab(text: "البريد الإلكتروني"),
          ],
        ),
      ),

      body: SafeArea(
        child: TabBarView(
          controller: controller.tabController,
          children: [
            const ShadowPanel(child: PhoneField()),
            ShadowPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const EmailField(),
                  const SizedBox(height: 12),
                  const PasswordField(),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.to(() => const ForgotPasswordView(),
                        binding: BindingsBuilder(() {
                          Get.put(ForgotPasswordController());
                        }),
                      ),

                      child: Text(
                        "نسيت كلمة المرور؟",
                        style: getBoldTextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Obx(() {
        final enabled = controller.canSubmit;

        const activeColor = ManagerColors.primaryColor; // بنفسجي غامق (مفعّل)
        const inactiveColor = ManagerColors.color_off;  // بنفسجي فاتح (غير مفعّل)

        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 46),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.submit : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white, // النص يبقى أبيض دائمًا
                backgroundColor: activeColor,
                disabledBackgroundColor: inactiveColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                "تسجيل الدخول",
                style: getBoldTextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      }),


    );
  }
}
