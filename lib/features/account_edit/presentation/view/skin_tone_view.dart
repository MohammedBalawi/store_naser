import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/skin_tone_controller.dart';
import '../widget/skin_tone_row.dart';

class SkinToneView extends GetView<SkinToneController> {
  const SkinToneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
              Text('لون البشرة', style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
              ),
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final idx = controller.selectedIndex.value;
                    final label = SkinToneController.tones[idx].label;
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'لون : ', style: getRegularTextStyle(color: Colors.black, fontSize: 16)),
                          TextSpan(text: label, style: getBoldTextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 10),

                  for (int i = 0; i < SkinToneController.tones.length; i++) ...[
                    SkinToneRow(index: i),
                  ],
                ],
              ),
            ),
          ],
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 60),
          child: Obx(() {
            final enabled = controller.canSave;

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
      ),
    );
  }
}
