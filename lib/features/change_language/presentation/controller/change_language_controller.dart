import 'package:app_mobile/constants/di/dependency_injection.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/storage/local/app_settings_prefs.dart';
import 'package:app_mobile/features/change_language/presentation/models/language_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeLanguageController extends GetxController {
  String language = "ar";
  AppSettingsPrefs appSettingsPrefs = instance<AppSettingsPrefs>();
  List<LanguageModel> languages = [];

  void getLocal() {
    language = appSettingsPrefs.getLocale();
    update();
  }

  void changeLocale({
    required BuildContext context,
    required String value,
  }) {
    appSettingsPrefs.setLocale(
      value,
    );
    language = value;
    update();
    EasyLocalization.of(context)?.setLocale(
      Locale(
        value,
      ),
    );
    Get.updateLocale(
      Locale(
        value,
      ),
    );
    update();
  }

  void setSupportedLocales() {
    languages = [
      LanguageModel(
        title: ManagerStrings.arabicLanguage,
        value: 'ar',
      ),
      LanguageModel(
        title: ManagerStrings.englishLanguage,
        value: 'en',
      ),
    ];
    update();
  }

  @override
  void onInit() {
    getLocal();
    setSupportedLocales();
    super.onInit();
  }
}
