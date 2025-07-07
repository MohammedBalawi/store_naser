import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/storage/local/app_settings_prefs.dart';
import 'package:app_mobile/features/auth/domain/usecase/login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../constants/env/env_constants.dart';
import '../../../../core/routes/routes.dart';
import '../../data/request/login_request.dart';
import '../../domain/models/login_model.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController(
    text: dotenv.env[EnvConstants.email].onNull(),
  );
  TextEditingController password = TextEditingController(
    text: dotenv.env[EnvConstants.password].onNull(),
  );
  var formKey = GlobalKey<FormState>();
  bool check = true;
  bool isObscurePassword = true;
  bool isLoading = false;

  onChangeObscurePassword() {
    isObscurePassword = !isObscurePassword;
    update();
  }

  onChange(bool status) {
    check = status;
    update();
  }

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void performLogin() {
    if (formKey.currentState!.validate()) {
      loginRequest();
    }
  }

  void loginRequest() async {
    try {
      changeIsLoading(
        value: true,
      );
      LoginUseCase useCase = instance<LoginUseCase>();

      (await useCase.execute(LoginRequest(
        identifier: email.text,
        password: password.text,
      )))
          .fold(
        (l) {
          changeIsLoading(
            value: false,
          );
          //@todo: Adding failed toast here
        },
        (r) async {
          changeIsLoading(
            value: false,
          );
          setSharedPrefsData(
            data: r,
          );
        },
      );
    } catch (e) {
      changeIsLoading(
        value: false,
      );
      //@todo: adding failed toast here
    }
  }

  void setSharedPrefsData({
    required Login data,
  }) async {
    AppSettingsPrefs appSettingsPrefs = instance<AppSettingsPrefs>();
    if (check) {
      appSettingsPrefs.setUserAvatar(
        data.user.avatar,
      );
      appSettingsPrefs.setUserName(
        data.user.name,
      );
      appSettingsPrefs.setUserPhone(
        data.user.mobile,
      );
      appSettingsPrefs.setEmail(
        data.user.email,
      );
      appSettingsPrefs.setToken(
        data.user.token,
      );
      appSettingsPrefs.setEnableNotifications(
        data.user.profile.fcmNotifications,
      );
      appSettingsPrefs.setEmailNotificationStatus(
        data.user.profile.emailNotification,
      );
      appSettingsPrefs.setTwoFactorAuthStatus(
        data.user.profile.twoFactorAuth,
      );
      appSettingsPrefs.setBiometricAuthStatus(
        data.user.profile.biometricAuth,
      );
      appSettingsPrefs.setUserLoggedIn();
    } else {
      appSettingsPrefs.setUserAvatar(
        data.user.avatar,
      );
      appSettingsPrefs.setUserName(
        data.user.name,
      );
      appSettingsPrefs.setUserPhone(
        data.user.mobile,
      );
      appSettingsPrefs.setEmail(
        data.user.email,
      );
      appSettingsPrefs.setEnableNotifications(
        data.user.profile.fcmNotifications,
      );
      appSettingsPrefs.setEmailNotificationStatus(
        data.user.profile.emailNotification,
      );
      appSettingsPrefs.setTwoFactorAuthStatus(
        data.user.profile.twoFactorAuth,
      );
      appSettingsPrefs.setBiometricAuthStatus(
        data.user.profile.biometricAuth,
      );
      appSettingsPrefs.setToken(
        data.user.token,
      );
    }
    Get.toNamed(
      Routes.main,
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    formKey.currentState!.dispose();
    super.dispose();
  }
}
