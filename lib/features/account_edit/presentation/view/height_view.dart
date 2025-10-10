// lib/features/account_edit/presentation/view/height_view.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/height_controller.dart';

class HeightView extends GetView<HeightController> {
  const HeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(ManagerImages.arrows)),
            Text('طولك', style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(width: 42),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أدخل طولك', style: getBoldTextStyle(color: Colors.black, fontSize: 14)),
                const SizedBox(height: 10),

      Container(
        height: 280,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // المستطيل البنفسجي (هايلايت)
            Positioned.fill(
              top: 110,
              bottom: 110,
              left: 20,
              right: 20,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 84, // حسب لقطة الشاشة 84x60
                  height: 60,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // الـ Picker (الأرقام فقط)
            Obx(() {
              final items = controller.values; // List<double>
              final sel = controller.selected.value;
              final initialIndex = items.indexOf(sel);

              return CupertinoPicker(
                scrollController: controller.scroll ??
                    FixedExtentScrollController(
                      initialItem: initialIndex < 0 ? 0 : initialIndex,
                    ),
                itemExtent: 46,
                useMagnifier: true,
                magnification: 1,
                squeeze: 1,
                onSelectedItemChanged: controller.onSelected,
                selectionOverlay: const SizedBox.shrink(), // لأننا رسمنا الهايلايت
                looping: false,
                children: items.map((v) {
                  final isSelected = v == sel;
                  return Center(
                    child: SizedBox(
                      width: 84, // نفس عرض المستطيل ليثبت التمركز
                      child: Text(
                        v.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: isSelected
                            ? getBoldTextStyle(color: Colors.white, fontSize: 22)
                            : getRegularTextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),

            PositionedDirectional(
              end: 78,
              child: Text(
                'سم',
                style: getBoldTextStyle(
                  color: ManagerColors.primaryColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      )


      ],
            ),
          ),
        ],
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
              child: Text('حفظ',
                  style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          );
        }),
      ),
    );
  }
}

