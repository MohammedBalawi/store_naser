import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/constants/constants.dart';
import '../../../../core/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _restoreSupabaseSessionFromHive().then((_) => _checkSession());
  }

  Future<void> _restoreSupabaseSessionFromHive() async {
    final box = await Hive.openBox('authBox');
    final refreshToken = box.get('refresh_token');

    if (refreshToken != null) {
      try {
        await Supabase.instance.client.auth.setSession(refreshToken);
      } catch (e) {
        await box.delete('access_token');
        await box.delete('refresh_token');
        debugPrint('فشل استرجاع الجلسة: $e');
      }
    }
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: Constants.splashTimeSecond));

    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      Get.offAllNamed(Routes.main);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }
}
