import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/routes/routes.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/service/notifications_service.dart';

class ForgetPasswordController extends GetxController {
  final SupabaseClient supabase = getIt<SupabaseClient>();

  late TextEditingController phone;
  var formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    phone = TextEditingController();
  }

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  void forgetPassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      final response = await supabase
          .from('users')
          .select('id')
          .eq('phone', phone.text.trim())
          .maybeSingle();

      if (response != null) {

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('reset_phone', phone.text.trim());

        Get.offNamed(Routes.resetPassword);
        await addNotification(
          title: 'استعادة كلمة المرور',
          description: 'تم استعاة كلمة المرور بنجاح',
        );

      } else {
        Get.snackbar(ManagerStrings.error, ManagerStrings.phoneNumberNotRegistered);
      }
    } catch (e) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.errorSearchingForTheUser);
    }
  }
}
