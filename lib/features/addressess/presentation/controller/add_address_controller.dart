import 'package:app_mobile/features/addressess/presentation/controller/addresses_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/features/addressess/data/request/add_address_request.dart';
import 'package:app_mobile/features/addressess/domain/di/addresses_di.dart';
import 'package:app_mobile/features/addressess/domain/usecase/add_address_usecase.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';

class AddAddressController extends GetxController {
  TextEditingController typeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  bool isLoading = false;
  bool check = false;

  void changeCheck({required bool value}) {
    check = value;
    update();
  }

  void addAddressRequest() async {
    try {
      changeIsLoading(
        value: true,
      );
      final AddAddressUseCase useCase = instance<AddAddressUseCase>();
      (await useCase.execute(AddAddressRequest(
        type: typeController.text,
        city: cityController.text,
        state: stateController.text,
        street: streetController.text,
        postalCode: postalCodeController.text,
        useDefault: check,
        mobile: "99911",
        lat: '',
        lang: '',
      )))
          .fold(
        (l) {
          changeIsLoading(
            value: false,
          );
          //@todo: Call the failed toast
        },
        (r) async {
          changeIsLoading(
            value: false,
          );
          Get.back();
          Get.find<AddressesController>().addressesRequest();
          //@todo: Adding success toast
        },
      );
    } catch (e) {
      //@todo: Call the failed toast
    }
  }

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  @override
  void onInit() {
    initAddAddressRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeAddAddressRequest();
    super.dispose();
  }
}
