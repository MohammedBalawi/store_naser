import 'package:get_storage/get_storage.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/toasts/success_toast.dart';
import '../../../constants/shared_prefs_constants/shared_prefs_constants.dart';
import '../../service/notifications_service.dart';

class GetxStorage {
  final GetStorage storage = GetStorage();
  final _cartKey = SharedPrefsConstants.cart;

  Future<void> saveCartProducts(List<Map<String, dynamic>> products) async {
    await storage.write(_cartKey, products);
  }

  Future<List<Map<String, dynamic>>> getCartProducts() async {
    return List<Map<String, dynamic>>.from(storage.read(_cartKey) ?? []);
  }

  Future<void> addProductToCart(Map<String, dynamic> newProduct) async {
    final products = await getCartProducts();
    final index = products.indexWhere((p) => p['id'] == newProduct['id']);

    if (index != -1) {
      products[index]['quantity'] = (products[index]['quantity'] ?? 1) + 1;
    } else {
      newProduct['quantity'] = 1;
      products.add(newProduct);
    }

    await saveCartProducts(products);

    await addNotification(
      title: 'السلة',
      description: 'تمت إضافة منتج إلى سلة التسوق',
    );

    successToast(body: ManagerStrings.productAddedToCart);
  }

  Future<void> setProductQuantity(int id, int quantity) async {
    final products = await getCartProducts();
    final index = products.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      products[index]['quantity'] = quantity;
      await saveCartProducts(products);
    }
  }

  Future<void> incrementProductQuantity(int id) async {
    final products = await getCartProducts();
    final index = products.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      products[index]['quantity'] = (products[index]['quantity'] ?? 1) + 1;
      await saveCartProducts(products);
    }
  }

  Future<void> decrementProductQuantity(int id) async {
    final products = await getCartProducts();
    final index = products.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      int currentQty = products[index]['quantity'] as int? ?? 1;
      if (currentQty > 1) {
        products[index]['quantity'] = currentQty - 1;
      } else {
        products.removeAt(index);
      }
      await saveCartProducts(products);
    }
  }

  Future<void> removeProductFromCart(int id) async {
    final products = await getCartProducts();
    products.removeWhere((p) => p['id'] == id);
    await saveCartProducts(products);
  }

  Future<void> clearCart() async {
    await saveCartProducts([]);
  }

  Future<void> saveSearches(List<String> searches) async {
    await storage.write(SharedPrefsConstants.searches, searches);
  }

  Future<List<String>> getSearches() async {
    return List<String>.from(storage.read(SharedPrefsConstants.searches) ?? []);
  }

  Future<List<String>> addSearch(String search) async {
    final searches = await getSearches();
    if (!searches.contains(search)) {
      searches.add(search);
      await saveSearches(searches);
    }
    return searches;
  }

  Future<List<String>> deleteSearch(String search) async {
    final searches = await getSearches();
    searches.remove(search);
    await saveSearches(searches);
    return searches;
  }

  Future<List<String>> emptySearch() async {
    await saveSearches([]);
    return [];
  }
}
