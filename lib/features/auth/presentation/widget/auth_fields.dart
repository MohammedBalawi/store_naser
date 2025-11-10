// lib/features/auth/presentation/widget/auth_fields.dart
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/login_email_controller.dart';

class EmailField extends GetView<LoginEmailController> {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _boxed(
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: controller.onEmailChanged,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: ManagerStrings.email,
              hintStyle: getRegularTextStyle(fontSize: 16, color: Colors.grey),
              border: InputBorder.none,
            ),
            style: getRegularTextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final msg = controller.emailErrorText;
          return _errorOrEmpty(msg);
        }),
      ],
    );
  }
}

class PasswordField extends GetView<LoginEmailController> {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _boxed(
          child: Obx(() {
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    obscureText: controller.obscure.value,
                    onChanged: controller.onPassChanged,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: ManagerStrings.password,
                      hintStyle: getRegularTextStyle(fontSize: 16, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: getRegularTextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                InkWell(
                  onTap: controller.toggleObscure,
                  child: controller.obscure.value
                      ? SvgPicture.asset(ManagerImages.close_eye, width: 22, height: 22)
                      : const Icon(Icons.visibility_outlined, size: 22),
                ),

              ],
            );
          }),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final msg = controller.passErrorText;
          return _errorOrEmpty(msg);
        }),
      ],
    );
  }
}

Widget _boxed({required Widget child}) {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFEDEDED)),
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
      child: Center(child: child),
    ),
  );
}

Widget _errorOrEmpty(String? message) {
  if (message == null) return const SizedBox(height: 0);
  return Row(
    children: [
    SvgPicture.asset(ManagerImages.warning),
      const SizedBox(width: 6),
      Text(message, style: getRegularTextStyle(fontSize: 12, color: ManagerColors.like)),
    ],
  );
}
