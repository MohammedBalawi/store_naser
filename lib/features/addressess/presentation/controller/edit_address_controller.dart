import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/service/notifications_service.dart';
import '../../domain/model/address_model.dart';

class EditAddressController extends GetxController {
  final SupabaseClient supabase = getIt<SupabaseClient>();

  TextEditingController typeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  AddressModel model = AddressModel();
  bool check = false;
  bool isLoading = false;

  void changeIsLoading({required bool value}) {
    isLoading = value;
    update();
  }

  void changeCheck({required bool value}) {
    check = value;
    update();
  }

  void fetchModel() {
    if (Get.arguments != null) {
      model = Get.arguments as AddressModel;

      typeController.text = model.type ?? '';
      cityController.text = model.city ?? '';
      stateController.text = model.state ?? '';
      streetController.text = model.street ?? '';
      postalCodeController.text = model.postalCode ?? '';
      check = model.isDefault ?? false;

      update();
    } else {
    }
  }

  Future<void> editAddressRequest() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.youMustLog);
      return;
    }

    try {
      await supabase.from('addresses').delete().eq('user_id', user.id);

      await supabase.from('addresses').insert({
        'user_id': user.id,
        'type': typeController.text,
        'city': cityController.text,
        'state': stateController.text,
        'street': streetController.text,
        'postal_code': postalCodeController.text,
        'is_default': check,
        'created_at': DateTime.now().toIso8601String(),
      });


      Get.back();
      await addNotification(
        title: 'عنوان جديد',
        description: 'تمت إضافة عنوان جديد إلى حسابك',
      );
      Get.snackbar(ManagerStrings.success, ManagerStrings.addressAddedSuccessfully);
    } catch (e) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.failedUpdated);
    }
  }


  @override
  void onInit() {
    fetchModel();
    super.onInit();
  }

  @override
  void dispose() {
    typeController.dispose();
    cityController.dispose();
    stateController.dispose();
    streetController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }
}
