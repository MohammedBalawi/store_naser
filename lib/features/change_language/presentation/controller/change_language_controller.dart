import 'package:app_mobile/constants/di/dependency_injection.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/storage/local/app_settings_prefs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryModel {
  final String nameAr;
  final String nameEn;
  final String code;     // SA, KW, AE, BH, QA, OM
  final String flag;
  CountryModel({
    required this.nameAr,
    required this.nameEn,
    required this.code,
    required this.flag,
  });
}

class CountryLanguageController extends GetxController {
  static const _kLocaleKey = 'locale';
  static const _kCountryKey = 'country_code';

  final AppSettingsPrefs _prefs = instance<AppSettingsPrefs>();

  String language = 'ar';
  String? selectedCountry;
  late final List<CountryModel> countries;

  bool get canSubmit => selectedCountry != null && selectedCountry!.isNotEmpty;

  @override
  void onInit() {
    _loadInitial();
    _buildCountries();
    super.onInit();
  }

  void _loadInitial() {
    language = _prefs.getLocale();
    selectedCountry = _prefs.getCountry();
  }

  void submit() {
    if (!canSubmit) return;
    _prefs.setCountry(selectedCountry!);
    Get.back(result: {'locale': language, 'country': selectedCountry});
  }


  void _buildCountries() {
    countries = [
      CountryModel(
        nameAr: 'المملكة العربية السعودية',
        nameEn: 'Saudi Arabia',
        code: 'SA',
        flag: ManagerImages.saudi,
      ),
      CountryModel(
        nameAr: 'الكويت',
        nameEn: 'Kuwait',
        code: 'KW',
        flag: ManagerImages.kuwait,
      ),
      CountryModel(
        nameAr: 'الإمارات العربية المتحدة',
        nameEn: 'United Arab Emirates',
        code: 'AE',
        flag: ManagerImages.united,
      ),
      CountryModel(
        nameAr: 'البحرين',
        nameEn: 'Bahrain',
        code: 'BH',
        flag: ManagerImages.sai,
      ),
      CountryModel(
        nameAr: 'قطر',
        nameEn: 'Qatar',
        code: 'QA',
        flag: ManagerImages.qatar,
      ),
      CountryModel(
        nameAr: 'عمان',
        nameEn: 'Oman',
        code: 'OM',
        flag: ManagerImages.oman,
      ),
    ];
  }

  void selectLanguage(BuildContext context, String value) {
    if (language == value) return;
    language = value;
    _prefs.setLocale(value);
    EasyLocalization.of(context)?.setLocale(Locale(value));
    Get.updateLocale(Locale(value));
    update();
  }

  void selectCountry(String code) {
    selectedCountry = code;
    update();
  }


}
