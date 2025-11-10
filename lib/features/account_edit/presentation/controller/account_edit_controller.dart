import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/routes/routes.dart';

class AccountEditController extends GetxController {
  void onEditName() => Get.toNamed(Routes.editName);
  void onChangePassword() => Get.toNamed(Routes.changePassword);
  void onChangePhone(){
    Get.toNamed(Routes.changePhone);
  }
  void onChangeEmail(){
    Get.toNamed(Routes.changeEmail);

  }

  void onGender() {
    Get.toNamed(Routes.gender);


  }
  void onBirthday() {


    Get.toNamed(Routes.birthdate);

  }
  void onHeight() {
    Get.toNamed(Routes.height);


  }
  void onWeight() {
    Get.toNamed(Routes.weight);

  }
  void onSkinTone() {
    Get.toNamed(Routes.skinTone);


  }

  Future<void> onDeleteAccount(BuildContext context) async {
    final w = MediaQuery.of(context).size.width;

    final sure = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 24), // 5 من اليمين و 5 من الشمال
          child: Container(
            width: w - 40,
            constraints: const BoxConstraints(
              maxWidth: 520,
              minWidth: 280,
            ),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                ManagerStrings.supDelete,
                  textAlign: TextAlign.center,
                  style: getBoldTextStyle(fontSize: 18, color: Colors.black),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB26BE8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: Text(
                            ManagerStrings.no,
                          style: getBoldTextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD70C63),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: Text(
                          ManagerStrings.yes,
                          style: getBoldTextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (sure == true) {
      Get.snackbar(
        'تم', 'تم تسجيل الخروج بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    }
  }




}
