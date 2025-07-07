import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/storage/local/app_settings_prefs.dart';

class SecurityController extends GetxController {
  bool twoFactorAuth = true;
  bool biometricAuth = true;
  bool securityQuestions = true;
  AppSettingsPrefs appSettingsPrefs = instance<AppSettingsPrefs>();

  void navigateToEditPassword() {
    Get.toNamed(
      Routes.changePassword,
    );
  }

  void changeTwoFactorAuth(
    bool value,
  ) {
    twoFactorAuth = value;
    appSettingsPrefs.setTwoFactorAuthStatus(
      value,
    );
    update();
  }

  void changeBiometricAuth(
    bool value,
  ) {
    biometricAuth = value;
    appSettingsPrefs.setBiometricAuthStatus(
      value,
    );
    update();
  }

  void changeSecurityQuestions(
    bool value,
  ) {
    securityQuestions = value;
    appSettingsPrefs.setSecurityQuestionsStatus(
      value,
    );
    update();
  }

  void fetchSwitches() {
    twoFactorAuth = appSettingsPrefs.getTwoFactorAuthStatus();
    biometricAuth = appSettingsPrefs.getBiometricAuthStatus();
    securityQuestions = appSettingsPrefs.getSecurityQuestionsStatus();
    update();
  }

  @override
  void onInit() {
    fetchSwitches();
    super.onInit();
  }
}
