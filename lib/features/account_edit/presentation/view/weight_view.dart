import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_images.dart';
import '../controller/weight_controller.dart';

class WeightView extends GetView<WeightController> {
  const WeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(ManagerImages.arrows)),
            Text('وزنك', style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(width: 42),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أدخل وزنك', style: getBoldTextStyle(color: Colors.black, fontSize: 14)),
                const SizedBox(height: 10),

                // صندوق العجلة
      Container(
        height: 280,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // الهايلايت البنفسجي (84x60) في المنتصف
            Positioned.fill(
              top: 110,
              bottom: 110,
              left: 30,
              right: 30, // خليه متوازن يمين/يسار
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 84,
                  height: 60,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // قائمة الأرقام (من دون "كجم")
            Obx(() {
              final items = List<int>.generate(
                WeightController.maxKg - WeightController.minKg + 1,
                    (i) => WeightController.minKg + i,
              );
              final sel = controller.selected.value;
              final initialIndex = items.indexOf(sel);

              return CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: initialIndex < 0 ? 0 : initialIndex,
                ),
                itemExtent: 46,
                useMagnifier: true,
                magnification: 1,
                squeeze: 1,
                looping: false,
                selectionOverlay: const SizedBox.shrink(),
                onSelectedItemChanged: (i) => controller.onChanged(items[i]),
                children: items.map((kg) {
                  final isSelected = kg == sel;
                  return Center(
                    // ⬅️ تثبيت العرض = عرض الهايلايت ليظل الرقم بالمنتصف دائمًا
                    child: SizedBox(
                      width: 84,
                      child: Text(
                        '$kg',
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
                'كجم',
                style: getBoldTextStyle(fontSize: 12, color: ManagerColors.color),
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
