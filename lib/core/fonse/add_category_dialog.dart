import 'dart:io';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_fonts.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../features/home/presentation/controller/home_controller.dart';
import '../service/notifications_service.dart';

class AddCategoryDialog {
  final BuildContext context;
  final TextEditingController nameController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;
  bool isLoading = false;
  AddCategoryDialog(this.context);

  void show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 12,
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ManagerStrings.addCategories,
                        style: TextStyle(
                          fontFamily: ManagerFontFamily.fontFamily,
                          fontSize: ManagerFontSize.s15,
                          fontWeight: FontWeight.bold,
                          color: ManagerColors.primaryColor,
                          shadows: [
                            Shadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: nameController,
                        style: getRegularTextStyle(fontSize: ManagerFontSize.s16, color: ManagerColors.black),
                        decoration: InputDecoration(
                          labelText: ManagerStrings.choiceCategories,
                          labelStyle:  getRegularTextStyle(color: ManagerColors.primaryColor, fontSize: ManagerFontSize.s14),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                            const BorderSide(color: ManagerColors.primaryColor, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                            const BorderSide(color: ManagerColors.primaryColor),
                          ),
                          filled: true,
                          fillColor: Colors.deepPurple.shade50,
                          prefixIcon: const Icon(Icons.category, color: ManagerColors.primaryColor),
                        ),
                      ),

                      const SizedBox(height: 25),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: imageFile != null
                            ? Image.file(
                          File(imageFile!.path),
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: ManagerColors.primaryColor,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child:  Center(
                            child: Text(
                              ManagerStrings.choiceImage,
                              style:  getRegularTextStyle(
                                color: ManagerColors.primaryColor,
                                fontSize: ManagerFontSize.s16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ManagerColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          elevation: 6,
                          shadowColor: ManagerColors.primaryColor,
                        ),
                        icon: const Icon(Icons.image_outlined, size: 24,color: ManagerColors.white,),
                        label:  Text(
                          ManagerStrings.choiceImage,
                          style:  getRegularTextStyle(fontSize: ManagerFontSize.s18,color: ManagerColors.white),
                        ),
                        onPressed: () async {
                          final picked =
                          await picker.pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            setState(() => imageFile = picked);
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      if (isLoading)
                        Column(
                          children: [
                            LinearProgressIndicator(
                              minHeight: 6,
                              color: ManagerColors.primaryColor,
                              backgroundColor: ManagerColors.deepPurpleShade,
                            ),
                            const SizedBox(height: 10),
                             Text(
                              ManagerStrings.uploadingImage,
                              style:  getMediumTextStyle(
                                  color: ManagerColors.primaryColor,
                                   fontSize: ManagerFontSize.s16),
                            ),
                          ],
                        ),

                      if (!isLoading)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: ManagerColors.primaryColor,
                                textStyle:  getMediumTextStyle(
                                  fontSize: ManagerFontSize.s16,
                                  color: ManagerColors.primaryColor,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child:  Text(ManagerStrings.cancel,
                              style: const TextStyle(color: ManagerColors.primaryColor),),
                            ),

                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ManagerColors.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 7,
                                shadowColor: ManagerColors.white,
                              ),
                              icon: const Icon(Icons.check_circle_outline, size: 22,color: ManagerColors.white,),
                              label:  Text(
                                ManagerStrings.addCategories,
                                style:  getRegularTextStyle(
                                    fontSize: ManagerFontSize.s18,
                                    color: ManagerColors.white),
                              ),
                              onPressed: () async {
                                if (nameController.text.isEmpty || imageFile == null) {
                                  Get.snackbar(ManagerStrings.error, ManagerStrings.failedUpdated,
                                      backgroundColor: ManagerColors.redShade,
                                      colorText: ManagerColors.white);
                                  return;
                                }

                                setState(() => isLoading = true);

                                final uuid = const Uuid().v4();
                                final fileExt = imageFile!.path.split('.').last;
                                final filePath = 'categories/$uuid.$fileExt';

                                try {
                                  final supabase = Get.find<HomeController>().supabase;

                                  final imageBytes = await imageFile!.readAsBytes();
                                  await supabase.storage
                                      .from('product-images')
                                      .uploadBinary(filePath, imageBytes);

                                  final imageUrl = supabase.storage
                                      .from('product-images')
                                      .getPublicUrl(filePath);

                                  await Get.find<HomeController>()
                                      .addCategory(nameController.text.trim(), imageUrl);

                                  Get.back();
                                  await addNotification(
                                    title: 'اضافة اصناف',
                                    description: 'تمت إضافة صنف  جديد بنجاح',
                                  );

                                  Get.snackbar(ManagerStrings.success, ManagerStrings.addSuccessfully,
                                      backgroundColor: ManagerColors.greenShade,
                                      colorText: ManagerColors.white);
                                } catch (e) {
                                  print('Error adding category: $e');
                                  Get.snackbar(ManagerStrings.error, ManagerStrings.uploadingImage,
                                      backgroundColor: ManagerColors.redShade,
                                      colorText: ManagerColors.white);
                                } finally {
                                  setState(() => isLoading = false);
                                }
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
