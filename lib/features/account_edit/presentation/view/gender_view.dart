import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/gender_controller.dart';

class GenderView extends GetView<GenderController> {
  const GenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar:
      AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,        // يمنع تأثير الـ tint
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,   // لا تضيف طبقة لونية
        shadowColor: Colors.transparent,  // حتى لو حاول يعمل ظل/تيـنت
        notificationPredicate: (notification) => false,

        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: Colors.white),

        flexibleSpace: const SizedBox.expand(
          child: ColoredBox(color: Colors.white), // يلوّن خلف شريط الحالة بالكامل
        ),

        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(isArabic?ManagerImages.arrows:ManagerImages.arrow_left)),
            Text(
              ManagerStrings.gender,
              style: getBoldTextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(width: 32),
          ],
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
      ),



    body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: isArabic ?Alignment.centerRight:Alignment.centerLeft,
                    child: Text(ManagerStrings.selectGender, style: getBoldTextStyle(color: ManagerColors.gray_3, fontSize: 14)),
                  ),
                  const SizedBox(height: 6),

                  Obx(() {
                    final sel = controller.selected.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _GenderChip(
                          label: ManagerStrings.male,
                          icon: ManagerImages.male,
                          selected: sel == Gender.male,
                          onTap: () => controller.pick(Gender.male),
                        ),
                        _GenderChip(
                          label: ManagerStrings.female,
                          icon: ManagerImages.fmale,
                          selected: sel == Gender.female,
                          onTap: () => controller.pick(Gender.female),
                        ),

                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 60),
        child: Obx(() {
          final enabled = controller.canSave.value;

          const activeColor   = ManagerColors.color; // بنفسجي غامق
          const inactiveColor = ManagerColors.color_off; // بنفسجي فاتح

          return SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.save : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white, // لا تخليه شفاف
                backgroundColor: activeColor,
                disabledBackgroundColor: inactiveColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(ManagerStrings.save,
                  style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          );
        }),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? ManagerColors.primaryColor : const Color(0xFFE9E9EF);
    final iconColor   = selected ? ManagerColors.primaryColor : Colors.black87;
    final textColor   = selected ? ManagerColors.primaryColor : ManagerColors.gray_3;

    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              icon,
              width: 24,  // ✅ عرض 24
              height: 24, // ✅ ارتفاع 24
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: getBoldTextStyle(color: textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}


