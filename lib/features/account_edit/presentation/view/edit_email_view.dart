import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controller/edit_email_controller.dart';

class EditEmailView extends GetView<EditEmailController> {
  const EditEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('تغيير البريد الإلكتروني',
            style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 16),
            child: SvgPicture.asset(ManagerImages.arrows),
          ),
        ),
      ),

      body: Obx(() {
        final state = controller.emailState.value;

        // حقل الإدخال + الشرح – نفس تصميمك
        final textField = _EmailField(
          controller: controller.emailController,
          state: state,
          onChanged: controller.onChanged,
        );

        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              children: [
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      textField,
                      const SizedBox(height: 16),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'أدخل عنوان البريد الإلكتروني الجديد',
                              style: getBoldTextStyle(
                                  fontSize: 14, color: ManagerColors.bongrey),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'هذا البريد الإلكتروني مرتبط بحسابك ولا يمكن لأحد رؤيته\n'
                                  'سواك. إذا قمت بتغييره، فقد يتم الاحتفاظ به لأغراض استرداد\n'
                                  'الحساب.',
                              style: getBoldTextStyle(
                                  fontSize: 12, color: ManagerColors.gray_3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),

            // بانر علوي بأسلوبك (✔️ أو ⚠️)
            _DropBanner(
              message: controller.banner.value?.message ?? '',
              isError: controller.banner.value?.isError ?? false,
              visible: controller.bannerShown.value,
            ),
          ],
        );
      }),

      bottomNavigationBar: Padding(
        padding:
        const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 60),
        child: Obx(() {
          final enabled = controller.canSave.value;
          const activeColor = ManagerColors.color; // بنفسجي غامق
          const inactiveColor = ManagerColors.color_off; // بنفسجي فاتح

          return SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.save : controller.save,
              // 👆 حسب اللقطات: الزر يطلق الفحص حتى لو غير مفعل (لتسهيل التجربة).
              // إن أردتها صارمة: اجعل onPressed = enabled ? controller.save : null
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                backgroundColor: activeColor,
                disabledBackgroundColor: inactiveColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text('تحديث',
                  style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          );
        }),
      ),
    );
  }
}

/// حقل البريد مع شارة "جاري التحقق..." وأيقونات (❗️/✔️) مثل الصور
class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.state,
    required this.onChanged,
  });

  final TextEditingController controller;
  final EmailState state;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFFE9E9EF);

    // أيقونة داخل الحقل (يمين = الشمال في الـ RTL)
    Widget? trailingIcon;
    if (state == EmailState.invalidFormat || state == EmailState.alreadyUsed) {
      trailingIcon = Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: SvgPicture.asset(ManagerImages.warning, height: 18),
      );
    } else if (state == EmailState.valid) {
      trailingIcon = const Padding(
        padding: EdgeInsetsDirectional.only(end: 8),
        child: Icon(Icons.check_circle, color: ManagerColors.color, size: 20),
      );
    }

    // الشارة الصغيرة "جاري التحقق..."
    final checkingChip = PositionedDirectional(
      end: 10, // 🔹 على الشمال بدل اليمين
      top: 13,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: state == EmailState.checking ? 1 : 0,
        child: IgnorePointer(
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              // boxShadow: const [
              //   BoxShadow(
              //       color: Color(0x14000000),
              //       blurRadius: 6,
              //       offset: Offset(0, 2))
              // ],
              // border: Border.all(color: borderColor),
            ),
            child: Text(
              'جاري التحقق...',
              style: getBoldTextStyle(
                  fontSize: 10, color: ManagerColors.gray_3),
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLength: 30,
          style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
          decoration: InputDecoration(
            counterText: '',
            hintText: 'اكتب البريد الاكتروني',
            hintStyle:
            getRegularTextStyle(fontSize: 16, color: ManagerColors.bongrey),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            // 🔹 الأيقونة الآن في جهة الشمال (نهاية الحقل)
            suffixIcon: trailingIcon == null
                ? null
                : SizedBox(
              width: 32,
              child: Align(
                alignment: Alignment.center,
                child: trailingIcon,
              ),
            ),
          ),
        ),
        checkingChip,
      ],
    );
  }
}


/// بانر علوي ينزل من فوق الـ AppBar ثم يطلع (✔️/⚠️)
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
      ignoring: true,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: visible ? kToolbarHeight - 40 : -80, // أسفل الـ AppBar مباشرة
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
                  padding:
                  const EdgeInsetsDirectional.only(start: 12, end: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isError
                          ? SvgPicture.asset(ManagerImages.warning, height: 20)
                          : Icon(Icons.check_circle,
                          color: iconColor, size: 20),
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
