import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/birthdate_controller.dart';

class BirthdateView extends GetView<BirthdateController> {
  const BirthdateView({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar:
      AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        notificationPredicate: (notification) => false,

        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: isArabic? EdgeInsets.all(2.0):EdgeInsets.all(15.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                isArabic
                    ? ManagerImages.arrows
                    : ManagerImages.arrow_left,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        automaticallyImplyLeading: false,
        leadingWidth: 52,

        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
        ),

        flexibleSpace: const SizedBox.expand(
          child: ColoredBox(color: Colors.white),
        ),

        title: Text(ManagerStrings.birthDate,
            style: getBoldTextStyle(color: Colors.black, fontSize: 20)),


        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 4))
                ],
              ),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color:  ManagerColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: controller.hasError.value
                              ? const Color(0xFFE9E9EF)
                              : const Color(0xFFE9E9EF),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isArabic ?
                              controller.display:
                              controller.displayEn,
                              style: getRegularTextStyle(
                                  color: Colors.black, fontSize: 16)),

                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.hasError.value) ...[
                      Row(
                        children: [
                          SvgPicture.asset(ManagerImages.warning),
                          SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              controller.errorText.value,
                              textAlign:isArabic ? TextAlign.right:TextAlign.left,
                              style: getRegularTextStyle(
                                fontSize: 11,
                                color: ManagerColors.red_worn,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                    const SizedBox(height: 32),


                    // Text('اختر التاريخ', style: getBoldTextStyle(color: Colors.black54, fontSize: 12)),
                    // const SizedBox(height: 8),

                    SizedBox(
                      height: 180,
                      child:isArabic ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Wheel(
                            width: w / 3 - 40,
                            items: List.generate(
                              controller.maxYear - controller.minYear + 1,
                              (i) => (controller.minYear + i).toString(),
                            ),
                            initialIndex:
                                controller.year.value - controller.minYear,
                            onSelectedItemChanged: (i) =>
                                controller.onYearChanged(controller.minYear + i),
                          ),
                          _Wheel(
                            width: w / 3 - 20,
                            items: controller.months,
                            initialIndex: controller.month.value - 1,
                            onSelectedItemChanged: (i) =>
                                controller.onMonthChanged(i + 1),
                          ),
                          Obx(() {
                            final days = List.generate(
                                DateTime(controller.year.value,
                                        controller.month.value + 1, 0)
                                    .day,
                                (i) => (i + 1).toString().padLeft(2, '0'));
                            final init = controller.day.value - 1;
                            return _Wheel(
                              width: w / 3 - 20,
                              items: days,
                              initialIndex: init.clamp(0, days.length - 1),
                              onSelectedItemChanged: (i) =>
                                  controller.onDayChanged(i + 1),
                            );
                          }),
                        ],
                      ): Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            final days = List.generate(
                                DateTime(controller.year.value,
                                    controller.month.value + 1, 0)
                                    .day,
                                    (i) => (i + 1).toString().padLeft(2, '0'));
                            final init = controller.day.value - 1;
                            return _Wheel(
                              width: w / 3 - 20,
                              items: days,
                              initialIndex: init.clamp(0, days.length - 1),
                              onSelectedItemChanged: (i) =>
                                  controller.onDayChanged(i + 1),
                            );
                          }),
                          _Wheel(
                            width: w / 3 - 20,
                            items: controller.months,
                            initialIndex: controller.month.value - 1,
                            onSelectedItemChanged: (i) =>
                                controller.onMonthChanged(i + 1),
                          ),

                          _Wheel(
                            width: w / 3 - 40,
                            items: List.generate(
                              controller.maxYear - controller.minYear + 1,
                                  (i) => (controller.minYear + i).toString(),
                            ),
                            initialIndex:
                            controller.year.value - controller.minYear,
                            onSelectedItemChanged: (i) =>
                                controller.onYearChanged(controller.minYear + i),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 60),
        child: Obx(() {
          final enabled = controller.canSave.value;

          const activeColor   = ManagerColors.color;
          const inactiveColor = ManagerColors.color_off;

          return SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.save : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
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

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.items,
    required this.onSelectedItemChanged,
    required this.initialIndex,
    this.width,
  });

  final List<String> items;
  final ValueChanged<int> onSelectedItemChanged;
  final int initialIndex;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // boxShadow: const [
          // BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 2)),
        // ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 36, // قريب من itemExtent (44) مع هوامش
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2), // الرمادي الفاتح المطلوب
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),


          CupertinoPicker(
            backgroundColor: Colors.white,
            itemExtent: 44,
            useMagnifier: true,
            magnification: 1,
            squeeze: 1,
            scrollController: FixedExtentScrollController(initialItem: initialIndex),
            onSelectedItemChanged: onSelectedItemChanged,

            selectionOverlay: const SizedBox.shrink(),

            children: items
                .map((t) => Center(
              child: Text(
                t,
                style: getBoldTextStyle(fontSize: 18, color: Colors.black),
              ),
            ))
                .toList(),
          ),
          const Positioned(left: 10, right: 10, top: 56, child: _Line()),
          const Positioned(left: 10, right: 10, bottom: 56, child: _Line()),

        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 80,
        height: 1.3,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}


