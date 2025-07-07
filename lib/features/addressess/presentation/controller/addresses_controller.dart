import 'package:app_mobile/features/addressess/data/request/delete_address_request.dart';
import 'package:app_mobile/features/addressess/domain/di/addresses_di.dart';
import 'package:app_mobile/features/addressess/domain/model/address_area_id_model.dart';
import 'package:app_mobile/features/addressess/domain/model/address_gov_id_model.dart';
import 'package:app_mobile/features/addressess/domain/model/address_model.dart';
import 'package:app_mobile/features/addressess/domain/usecase/addresses_usecase.dart';
import 'package:app_mobile/features/addressess/domain/usecase/delete_address_usecase.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/routes/routes.dart';

class AddressesController extends GetxController {
  List<AddressModel> addresses = [];
  AddressModel defaultAddress = AddressModel(
    isDefault: true,
    // id:1 ,
    type: '',
    street: '',
    postalCode: '',
    lat: '',
    lang: '',
    mobile: '',
    areaId: AddressAreaIdModel(
      id: 0,
      name: "",
    ),
    govId: AddressGovIdModel(
      id: 0,
      name: "",
    ),
  );
  bool isLoading = false;

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void addressesRequest() async {
    try {
      changeIsLoading(
        value: true,
      );
      final AddressesUseCase useCase = instance<AddressesUseCase>();
      (await useCase.execute()).fold(
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
          addresses = r.data;
          update();
        },
      );
    } catch (e) {
      //@todo: Call the failed toast
    }
  }

  void deleteAddressRequest({
    required int id,
  }) async {
    try {
      initDeleteAddressRequest();
      final DeleteAddressUseCase useCase = instance<DeleteAddressUseCase>();
      (await useCase.execute(DeleteAddressRequest(id: id))).fold(
        (l) {
          disposeDeleteAddressRequest();
          //@todo: Call the failed toast
        },
        (r) async {
          disposeDeleteAddressRequest();
          //@todo: Adding success toast
        },
      );
    } catch (e) {
      disposeDeleteAddressRequest();
      //@todo: Call the failed toast
    }
  }

  void navigateToAddAddress() {
    Get.toNamed(
      Routes.addAddress,
    );
  }

  void navigateToEditAddress({
    required AddressModel model,
  }) {
    CacheData cacheData = CacheData();
    cacheData.setAddressModel(
      model: model,
    );
    Get.toNamed(Routes.editAddress);
  }

  @override
  void onInit() {
    initAddressesRequest();
    addressesRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeAddressesRequest();
    super.dispose();
  }
}
