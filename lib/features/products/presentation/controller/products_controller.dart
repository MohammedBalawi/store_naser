import 'package:app_mobile/features/products/domain/di/di.dart';
import 'package:app_mobile/features/products/domain/use_case/products_use_case.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/model/product_model.dart';

class ProductsController extends GetxController {
  List<ProductModel> products = [];
  bool isLoading = true;

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  // void productsRequest() async {
  //   changeIsLoading(
  //     value: true,
  //   );
  //   final ProductsUseCase useCase = instance<ProductsUseCase>();
  //   (await useCase.execute()).fold(
  //     (l) {
  //       changeIsLoading(
  //         value: false,
  //       );
  //       //@todo: Call the failed toast
  //     },
  //     (r) async {
  //       changeIsLoading(
  //         value: false,
  //       );
  //       products = r.products;
  //       update();
  //     },
  //   );
  // }
  void productsRequest() async {
    changeIsLoading(value: true);
    final ProductsUseCase useCase = instance<ProductsUseCase>();

    (await useCase.execute()).fold(
          (l) {
        changeIsLoading(value: false);
        // TODO: Add a toast for error
      },
          (r) {
        changeIsLoading(value: false);
        products = r.products;
        update();
      },
    );
  }


  @override
  void onInit() {
    initProductsRequest();
    productsRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeProductsRequest();
    super.dispose();
  }
}
