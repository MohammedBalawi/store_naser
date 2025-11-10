// lib/features/auth/presentation/view/new_password_view.dart
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/new_password_controller.dart';
import 'reset_success_view.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});

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
            Text('إنشاء كلمة مرور جديدة',
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
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFEDEDED)),
            ),
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [

                    Expanded(
                      child: TextField(
                        obscureText: controller.obscure.value,
                        onChanged: controller.onPassChanged,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: 'أدخل كلمة المرور الجديدة',
                          hintStyle: getRegularTextStyle(
                              fontSize: 16, color: ManagerColors.gray_3),
                          border: InputBorder.none,
                        ),
                        style: getRegularTextStyle(
                            fontSize: 16, color: Colors.black),
                      ),
                    ),
                    if (controller.validPass)
                       Padding(
                        padding: EdgeInsetsDirectional.only(end: 12),
                        child: Icon(Icons.check_circle,
                            color: ManagerColors.color, size: 20),
                      ),
                    InkWell(
                      onTap: controller.toggleObscure,
                      child: controller.obscure.value
                          ? SvgPicture.asset(ManagerImages.close_eye, width: 22, height: 22)
                          : const Icon(Icons.visibility_outlined, size: 22),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.password.value.isEmpty || controller.validPass) {
              return const SizedBox.shrink();
            }
            return Row(
              children: [
                Text('يجب أن تكون كلمة المرور من 8 أحرف على الأقل',
                    style: getRegularTextStyle(color: ManagerColors.like, fontSize: 12)),
              ],
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final enabled = controller.validPass;
        return Padding(
          padding: const EdgeInsets.only(top : 16,left: 16,right: 16,bottom: 44),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled
                  ? () {
                // TODO: نداء API لتعيين كلمة المرور
                Get.to(() => const ResetSuccessView());
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                enabled ? ManagerColors.primaryColor : ManagerColors.color_off,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Reset Password',
                  style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        );
      }),
    );
  }
}
