import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/logout/domain/di/logout_di.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/service/notifications_service.dart';
import '../../../../core/storage/hive/hive_session_service.dart';
import '../../domain/di/logout_usecase.dart';

class LogoutController extends GetxController {
  bool isLoading = true;

  void changeIsLoading({required bool value}) {
    isLoading = value;
    update();
  }

  void logoutRequest() async {
    changeIsLoading(value: true);

    final LogoutUseCase useCase = instance<LogoutUseCase>();

    (await useCase.execute()).fold(
          (l) {
        Get.back();
        changeIsLoading(value: false);
        Get.snackbar(ManagerStrings.error, ManagerStrings.logoutFailed);
      },
          (r) async {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          await HiveSessionService().clearSessionFromHive();

          Get.offAllNamed(Routes.login);
          await addNotification(
            title: 'تسجيل الخروج',
            description: 'تم تسجيل الخروج بنجاح',
          );


          Get.snackbar(ManagerStrings.ok, ManagerStrings.logoutSuccess);
        } catch (e) {
          Get.snackbar('خطأ', 'فشل في تسجيل الخروج: $e');
        } finally {
          changeIsLoading(value: false);
        }
      },
    );
  }

  @override
  void onInit() {
    initLogoutRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeLogoutRequest();
    super.dispose();
  }
}
