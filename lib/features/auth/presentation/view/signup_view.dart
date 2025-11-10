import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_images.dart';
import '../controller/signup_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.background_2,
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: SvgPicture.asset(isArabic ?ManagerImages.arrows:ManagerImages.arrow_left),
            ),
            Text(
              ManagerStrings.register,
              style: getBoldTextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(width: 40),
          ],
        ),
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        // automaticallyImplyLeading: false,
        // leadingWidth: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          const SizedBox(height: 6),
          Align(
            alignment:isArabic?  Alignment.centerRight:Alignment.centerLeft,
            child: Text(ManagerStrings.createNewAccount,
                style: getBoldTextStyle(
                    color: ManagerColors.greens, fontSize: 18)),
          ),
          const SizedBox(height: 15),

          Container(
            decoration: BoxDecoration(
              color: ManagerColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ManagerColors.white),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: const [
                _NameField(),
                SizedBox(height: 10),
                PhoneField(),
                SizedBox(height: 10),
                _EmailField(),
                SizedBox(height: 10),
                _PasswordField(),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const _TermsText(),

          const SizedBox(height: 32),
          Obx(() {
            final enabled = controller.canSubmit && !controller.isSubmitting.value;

            const activeColor = ManagerColors.color;      // بنفسجي غامق
            const inactiveColor = ManagerColors.color_off; // بنفسجي فاتح

            return SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: enabled ? controller.onSubmitPressed : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  backgroundColor: enabled ? activeColor : inactiveColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  ManagerStrings.continues
                  ,
                  style: getBoldTextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }),



          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// الاسم
class _NameField extends GetView<SignUpController> {
  const _NameField({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError =
          controller.showErrors.value && !controller.validName;
      return _FieldShell(
        errorText: hasError ? ManagerStrings.enterTheName : null,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style:
                getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
                focusNode: controller.focusName,
                onChanged: (v) => controller.name.value = v,
                decoration:  InputDecoration(
                  hintText:ManagerStrings.firstAndLastName ,
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            if (hasError) const _ErrorDot(),
          ],
        ),
      );
    });
  }
}

class PhoneField extends GetView<SignUpController> {
  const PhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError =
          controller.showErrors.value && !controller.validPhone; // ⬅️ هنا

      return _FieldShell(
        errorText: hasError ? controller.phoneErrorText : null,
        child: Row(
          children: [
            CountryButton(),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                focusNode: controller.focusPhone,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: getRegularTextStyle(
                    fontSize: 16, color: ManagerColors.grey_2),
                onChanged: controller.onPhoneChanged,
                decoration:  InputDecoration(
                  hintText: ManagerStrings.phone,
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
              ),
            ),

            if (hasError) const _ErrorDot(),
          ],
        ),
      );
    });
  }
}

class _EmailField extends GetView<SignUpController> {
  const _EmailField({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError =
          controller.showErrors.value && !controller.validEmail;
      return _FieldShell(
        errorText: hasError ? ManagerStrings.enterEmailAddress : null,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: getRegularTextStyle(
                    fontSize: 16, color: ManagerColors.grey_2),
                focusNode: controller.focusEmail,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => controller.email.value = v,
                decoration:  InputDecoration(
                  hintText: ManagerStrings.emailAddress,
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            if (hasError) const _ErrorDot(),
          ],
        ),
      );
    });
  }
}

class _PasswordField extends GetView<SignUpController> {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError =
          controller.showErrors.value && !controller.validPass; // ⬅️ هنا

      return _FieldShell(
        errorText: hasError ? ManagerStrings.thePasswordMustCharacters : null,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: controller.focusPass,
                obscureText: controller.obscure.value,
                onChanged: (v) => controller.password.value = v,
                style: getRegularTextStyle(
                    fontSize: 16, color: ManagerColors.grey_2),
                decoration:  InputDecoration(
                  hintText:ManagerStrings.password,
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            if (hasError) const _ErrorDot(),
            const SizedBox(width: 10),
            InkWell(
              onTap: controller.toggleObscure,
              child: controller.obscure.value
                  ? SvgPicture.asset(ManagerImages.close_eye,
                  width: 22, height: 22)
                  : const Icon(Icons.visibility_outlined, size: 22),
            ),
          ],
        ),
      );
    });
  }
}

class _FieldShell extends StatelessWidget {
  final Widget child;
  final String? errorText;
  const _FieldShell({required this.child, this.errorText, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: ManagerColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ManagerColors.white),
          ),
          child: child,
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              errorText!,
              style: getRegularTextStyle(
                color: ManagerColors.like,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ErrorDot extends StatelessWidget {
  const _ErrorDot({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return  Padding(
      padding: isArabic? EdgeInsets.only(right: 6.0):EdgeInsets.only(left: 6.0),
      child: SvgPicture.asset(ManagerImages.warning),
    );
  }
}

class _TermsText extends GetView<SignUpController> {
  const _TermsText({super.key});
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'من خلال الاستمرار، فإنك توافق على ',
        style: getRegularTextStyle(color: ManagerColors.text_color, fontSize: 12),
        children: [
          TextSpan(
            text: 'شروط الخدمة',
            style: getBoldTextStyle(color: ManagerColors.black, fontSize: 12),
            recognizer: controller.tosRecognizer,
          ),
          const TextSpan(text: ' لدينا، وتقر بأنك قد قرأت '),
          TextSpan(
            text: 'سياسة الخصوصية',
            style: getBoldTextStyle(color: ManagerColors.black, fontSize: 12),
            recognizer: controller.privacyRecognizer,
          ),
          const TextSpan(text: ' الخاصة بنا'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class CountryButton extends GetView<SignUpController> {
  CountryButton({super.key});

  final GlobalKey _btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _btnKey,
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsetsDirectional.only(start: 8, end: 6),
      height: 36,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => controller.openCountryMenu(context, _btnKey),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.asset(
                controller.selected.value.flagAsset,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              controller.selected.value.dialCode,
              style: getRegularTextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.expand_more, size: 18, color: Colors.black54),

          ],
        ),
      ),
    );
  }
}
