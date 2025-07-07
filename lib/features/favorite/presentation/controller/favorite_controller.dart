import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/toasts/success_toast.dart';
import 'package:app_mobile/features/favorite/data/request/add_favorite_request.dart';
import 'package:app_mobile/features/favorite/domain/di/favorite_di.dart';
import 'package:app_mobile/features/favorite/domain/usecase/add_favorite_usecase.dart';
import 'package:app_mobile/features/favorite/domain/usecase/favorite_usecase.dart';
import 'package:app_mobile/features/main/presentation/controller/main_controller.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/model/product_model.dart';

class FavoriteController extends GetxController {
  List<ProductModel> favorite = [];

  bool isLoading = true;

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void favoriteRequest() async {
    changeIsLoading(
      value: true,
    );
    final FavoriteUseCase useCase = instance<FavoriteUseCase>();
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
        favorite = r.data;
        update();
      },
    );
  }

  void navigateToCategories() {
    Get.find<MainController>().navigate(
      1,
    );
  }

  void addFavoriteRequest({
    required int id,
  }) async {
    initAddFavoriteRequest();
    changeIsLoading(
      value: true,
    );
    final AddFavoriteUseCase useCase = instance<AddFavoriteUseCase>();
    (await useCase.execute(AddFavoriteRequest(
      id: id.toString(),
    )))
        .fold(
      (l) {
        changeIsLoading(
          value: false,
        );
        disposeAddFavoriteRequest();
        //@todo: Call the failed toast
      },
      (r) async {
        changeIsLoading(
          value: false,
        );
        disposeAddFavoriteRequest();
        successToast(
          body: ManagerStrings.productAddedToFavorite,
        );
        update();
      },
    );
  }

  @override
  void onInit() {
    initFavoriteRequest();
    favoriteRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeFavoriteRequest();
    super.dispose();
  }
}
