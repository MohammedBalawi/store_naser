import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../categories/presentation/controller/category_products_controller.dart';
import '../../../home/presentation/controller/home_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CategoryProductsController>(() => CategoryProductsController(), fenix: true);
  }
}
