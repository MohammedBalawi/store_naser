import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/validator/validator.dart';
import 'package:app_mobile/features/change_password/domain/di/di.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/routes/routes.dart';

class ChangePasswordController extends GetxController {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  FieldValidator validator = FieldValidator();
  var formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void changeIsLoading({required bool value}) {
    isLoading = value;
    update();
  }

  void performChangePassword() {
    if (formKey.currentState!.validate()) {
      changePassword();
    }
  }

  void changePassword() async {
    final supabase = Supabase.instance.client;
    changeIsLoading(value: true);
    final user = supabase.auth.currentUser;

    if (user == null) {
      changeIsLoading(value: false);
      Get.snackbar(ManagerStrings.error, ManagerStrings.youMustLog);
      return;
    }

    try {
      final signInResponse = await supabase.auth.signInWithPassword(
        email: user.email!,
        password: oldPassword.text,
      );

      if (signInResponse.user == null) {
        changeIsLoading(value: false);
        Get.snackbar(ManagerStrings.error, '${ManagerStrings.error}${ManagerStrings.oldPassword}');
        return;
      }

      await supabase.auth.updateUser(
        UserAttributes(password: newPassword.text),
      );

      await supabase.from('users').update({
        'password': newPassword.text,
      }).eq('id', user.id);

      changeIsLoading(value: false);

      Get.snackbar(ManagerStrings.ok, ManagerStrings.yourPasswordHasBeenChangedSuccessfully);

      await supabase.auth.signOut();
      Get.offAllNamed(Routes.login);
    } catch (e) {
      changeIsLoading(value: false);
      print(' Error: $e');
      Get.snackbar(ManagerStrings.error,ManagerStrings.passwordChangeSuccess );
    }
  }



  @override
  void onInit() {
    initChangePasswordRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeChangePasswordRequest();
    formKey.currentState!.dispose();
    super.dispose();
  }
}
