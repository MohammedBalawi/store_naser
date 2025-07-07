import 'package:app_mobile/core/storage/local/getx_storage.dart';
import 'package:get/get.dart';
import '../../../../core/model/product_model.dart';

class CartController extends GetxController {
  List<ProductModel> cart = [];
  bool isLoading = true;

  void changeIsLoading({required bool value}) {
    isLoading = value;
    update();
  }

  void cartRequest() async {
    try {
      changeIsLoading(value: true);
      cart.clear();

      final data = await GetxStorage().getCartProducts();

      for (var item in data) {
        cart.add(ProductModel(
          id: item['id'] ?? '',
          name: item['name'] ?? '',
          image: item['image'] ?? '',
          price: (item['price'] as num?)?.toInt() ?? 0,
          sku: item['sku'] ?? '',
          type: item['type'] ?? '',
          rate: (item['rate'] as num?)?.toInt() ?? 0,
          rateCount: (item['rateCount'] as num?)?.toInt() ?? 0,
          availableQuantity: (item['availableQuantity'] as num?)?.toInt() ?? 1,
          color: item['color'] ?? '',
          size: item['size'] ?? '',
        ));
      }

      changeIsLoading(value: false);
    } catch (e) {
      changeIsLoading(value: false);
    }
  }

  void fetchCart() {
    cartRequest();
  }

  void incrementQuantity({required int id}) async {
    final product = cart.firstWhereOrNull((item) => item.id == id);
    if (product != null) {
      final newQty = product.availableQuantity! + 1;
      await GetxStorage().setProductQuantity(id, newQty);
      product.availableQuantity = newQty;
      update();
    }
  }

  void decrementQuantity({required int id}) async {
    final product = cart.firstWhereOrNull((item) => item.id == id);
    if (product != null) {
      if (product.availableQuantity! > 1) {
        final newQty = product.availableQuantity! - 1;
        await GetxStorage().setProductQuantity(id, newQty);
        product.availableQuantity = newQty;
      } else {
        await GetxStorage().removeProductFromCart(id);
        cart.remove(product);
      }
      update();
    }
  }

  void deleteProduct(int id) async {
    await GetxStorage().removeProductFromCart(id);
    cart.removeWhere((item) => item.id == id);
    update();
  }

  void completeOrder() {
  }

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
