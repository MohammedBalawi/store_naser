import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/edit_name_controller.dart';

class EditNameView extends GetView<EditNameController> {
  const EditNameView({super.key});

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
            GestureDetector(
                onTap: () => Get.back(),
                child: SvgPicture.asset(ManagerImages.arrows)),
            Text('تعديل الاسم',
                style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(height: 25),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        children: [
          const SizedBox(height: 15),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                TextField(
                  style: getRegularTextStyle(
                      fontSize: 16, color: ManagerColors.black),
                  controller: controller.nameController,
                  onChanged: controller.onChanged,
                  maxLength: 30,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'اكتب اسمك',
                    hintStyle: getRegularTextStyle(
                        fontSize: 16, color: ManagerColors.bongrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      const BorderSide(color: Color(0xFFE9E9EF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      const BorderSide(color: Color(0xFFE9E9EF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      BorderSide(color: ManagerColors.primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 6),
                Obx(() => Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${controller.length.value}/30',
                    style: getRegularTextStyle(
                        fontSize: 12, color: ManagerColors.bongrey),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),

      // الزر يظل تحت
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 44),
        child: Obx(() {
          final enabled = controller.canSave.value;
          return SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled
                    ? ManagerColors.primaryColor
                    : ManagerColors.color_off,
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
