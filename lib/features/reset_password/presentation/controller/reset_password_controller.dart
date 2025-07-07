import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/reset_password/domain/usecase/reset_password_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart' as Supabase;
import '../../../../core/routes/routes.dart';
import '../../../../core/service/notifications_service.dart';
import '../../../../core/validator/validator.dart';

class ResetPasswordController extends GetxController {
  late TextEditingController firstCodeTextController;
  late TextEditingController secondCodeTextController;
  late TextEditingController thirdCodeTextController;
  late TextEditingController fourthCodeTextController;
  late TextEditingController fifthCodeTextController;
  late TextEditingController sixthCodeTextController;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  ResetPasswordUseCase _useCase = Supabase.instance<ResetPasswordUseCase>();
  FieldValidator validator = FieldValidator();

  late FocusNode firstFocusNode;
  late FocusNode secondFocusNode;
  late FocusNode thirdFocusNode;
  late FocusNode fourthFocusNode;
  late FocusNode fifthFocusNode;
  late FocusNode sixthFocusNode;
  late FocusNode seventhFocusNode;
  late FocusNode eightFocusNode;

  var formKey = GlobalKey<FormState>();

  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;

  onChangeObscurePassword() {
    isObscurePassword = !isObscurePassword;
    update();
  }

  onChangeObscureConfirmPassword() {
    isObscureConfirmPassword = !isObscureConfirmPassword;
    update();
  }

  void resetPassword(String newPassword) async {
    final supabase = Supabase.getIt<SupabaseClient>();

    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('reset_phone') ?? '';

    if (phone.isEmpty) {
      Get.snackbar(ManagerStrings.error,ManagerStrings.noPhoneNumberSaved);
      return;
    }

    try {
      await supabase
          .from('users')
          .update({
        'password': newPassword,
      })
          .eq('phone', phone);

      Get.snackbar(ManagerStrings.success, ManagerStrings.passwordUpdatedSuccessfully);
      Get.offAllNamed(Routes.login);
      await addNotification(
        title: 'تغير كلمة المرور',
        description: 'تمت تغير كلمة المرور بنجاح',
      );

    } catch (e) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.errorOccurredWhileUpdatingYourPassword);
    }
  }

  @override
  void onInit() {
    super.onInit();
    firstCodeTextController = TextEditingController();
    secondCodeTextController = TextEditingController();
    thirdCodeTextController = TextEditingController();
    fourthCodeTextController = TextEditingController();
    fifthCodeTextController = TextEditingController();
    sixthCodeTextController = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();

    firstFocusNode = FocusNode();
    secondFocusNode = FocusNode();
    thirdFocusNode = FocusNode();
    fourthFocusNode = FocusNode();
    fifthFocusNode = FocusNode();
    sixthFocusNode = FocusNode();
    seventhFocusNode = FocusNode();
    eightFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    firstCodeTextController.dispose();
    secondCodeTextController.dispose();
    thirdCodeTextController.dispose();
    fourthCodeTextController.dispose();
    fifthCodeTextController.dispose();
    sixthCodeTextController.dispose();
    password.dispose();
    confirmPassword.dispose();

    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fourthFocusNode.dispose();
    fifthFocusNode.dispose();
    sixthFocusNode.dispose();
    seventhFocusNode.dispose();
    eightFocusNode.dispose();

  }

  otp() {
    return "${firstCodeTextController.text}${secondCodeTextController.text}${thirdCodeTextController.text}${fourthCodeTextController.text}${fifthCodeTextController.text}${sixthCodeTextController.text}";
  }
}
