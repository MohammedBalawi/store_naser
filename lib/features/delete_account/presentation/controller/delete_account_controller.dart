import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/delete_account/domain/di/delete_account_di.dart';
import 'package:app_mobile/features/delete_account/domain/usecase/delete_account_usecase.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/service/notifications_service.dart';

class DeleteAccountController extends GetxController {
  bool isLoading = false;

  void changeIsLoading({required bool value}) {
    isLoading = value;
    update();
  }

  Future<void> deleteAccountRequest() async {
    changeIsLoading(value: true);

    final DeleteAccountUseCase useCase = instance<DeleteAccountUseCase>();
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;

    if (user == null) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.youMustLog);
      changeIsLoading(value: false);
      return;
    }

    try {
      await supabase.from('users').delete().eq('id', user.id);

      await supabase.rpc('delete_user', params: {
        'uid': user.id,
      });

      await supabase.auth.signOut();

      Get.offAllNamed(Routes.login);
      await addNotification(
        title: 'حذف الحساب',
        description: 'تم حذف المنتح بنجاح',
      );

      Get.snackbar(ManagerStrings.success, ManagerStrings.deleteAccount);
    } catch (e) {
      print('Error deleting user: $e');
      Get.snackbar(ManagerStrings.error, 'فشل حذف الحساب: $e');
    } finally {
      changeIsLoading(value: false);
    }
  }




  @override
  void onInit() {
    initDeleteAccountRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeDeleteAccountRequest();
    super.dispose();
  }
}
