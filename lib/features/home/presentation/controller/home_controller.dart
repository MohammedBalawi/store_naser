import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_mobile/core/model/product_model.dart';
import '../../../../core/model/product_category_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/storage/local/getx_storage.dart';
import '../../../categories/domain/model/category_model.dart';
import '../../domain/model/home_banner_model.dart';
import '../../domain/model/home_main_category_model.dart';
import '../view/widget/home_category_model.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;
  var hasNewNotification = false.obs;
  var categories = <HomeMainCategoryModel>[].obs;

  var users = <Map<String, dynamic>>[];
  var banners = <HomeBannerModel>[];

  List<ProductModel> featuredProducts = [];
  List<ProductModel> bestSales = [];
  List<ProductModel> lastProducts = [];
  var products = <ProductModel>[].obs;
  List<ProductModel> topRatedProducts = [];
  var isLoadingCart = false.obs;
  var lastProductss = <ProductModel>[].obs;

  // List<ProductModel> allProducts = [];
  List<ProductModel> productsWithDiscount = [];

  bool isWholesaler = false;
  bool isAdminn = false;
  bool isLoading = true;
  bool loadingUsers = false;
  bool isLoadingCategories = false;

  @override
  void onInit() {
    super.onInit();
    initHome();
  }
  Rxn<Map<String, dynamic>> currentUser = Rxn<Map<String, dynamic>>();


  Future<void> clearUserData() async {
    currentUser.value = null;
    await Supabase.instance.client.auth.signOut();


  }


  Future<void> initHome() async {
    isLoading = true;
    update();
    fetchCartProducts();
    await getCurrentUserType();

    if (isAdminn) {
      await fetchUsers();
    }

    await fetchProducts();
    await fetchProductss();
    await fetchBanners();
    await fetchCategories();

    isLoading = false;
    update();
  }

  Future<void> homeRequest() async {
    await getCurrentUserType();

    if (isAdminn) {
      await fetchUsers();
      await checkIfAdmin();
    }

    await fetchProducts();
    await fetchProductss();
    await fetchBanners();
    await fetchCategories();

    isLoading = false;
    update();
  }

  void markNotificationArrived() {
    hasNewNotification.value = true;
  }

  void markNotificationRead() {
    hasNewNotification.value = false;
  }
// admin & wholesaler
  Future<void> getCurrentUserType() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final response = await supabase
            .from('users')
            .select('is_wholesaler, role')
            .eq('id', user.id)
            .maybeSingle();

        isWholesaler = response?['is_wholesaler'] ?? false;
        isAdminn = response?['role'] == 'admin';

        print('User Role => Wholesaler: \$isWholesaler, Admin: \$isAdminn');
        update();
      }
    } catch (e) {
      print('Error checking user role: \$e');
    }
  }

  Future<bool> checkIfAdmin() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final email = supabase.auth.currentUser?.userMetadata?['email'];
      if (email == null) return false;

      final response = await supabase
          .from('users')
          .select('role')
          .eq('email', email)
          .maybeSingle();

      return response?['role'] == 'admin';
    } catch (e) {
      print('Error checking admin status: \$e');
      return false;
    }
  }

  Future<bool> checkIfWholesale() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final email = supabase.auth.currentUser?.userMetadata?['email'];
      if (email == null) return false;

      final response = await supabase
          .from('users')
          .select('is_wholesaler')
          .eq('email', email)
          .maybeSingle();

      return response?['is_wholesaler'] == true;
    } catch (e) {
      print('Error checking wholesaler status: \$e');
      return false;
    }
  }

  Future<bool> checkIfWholesaler() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await supabase
          .from('users')
          .select('is_wholesaler')
          .eq('id', userId)
          .maybeSingle();

      return response?['is_wholesaler'] == true;
    } catch (e) {
      print('Error checking wholesaler status: \$e');
      return false;
    }
  }

// user
  Future<void> fetchUsers() async {
    loadingUsers = true;
    update();

    try {
      final response = await supabase
          .from('users')
          .select()
          .order('created_at', ascending: true);

      if (response is List) {
        users = List<Map<String, dynamic>>.from(response);
      } else {
        users.clear();
      }
    } catch (e) {
      print('Error fetching users: \$e');
      users.clear();
    } finally {
      loadingUsers = false;
      update();
    }
  }

  Future<bool> updateUser(Map<String, dynamic> user) async {
    try {
      await supabase.from('users').update({
        'email': user['email'],
        'role': user['role'],
        'phone': user['phone'],
        'created_at': user['created_at'],
        'full_name': user['full_name'],
        'is_wholesaler': user['is_wholesaler'],
      }).eq('id', user['id']);

      Get.snackbar('نجاح', 'تم تحديث بيانات المستخدم');
      await fetchUsers();
      return true;
    } catch (e) {
      print('Error updating user: \$e');
      Get.snackbar('فشل', 'فشل في تحديث بيانات المستخدم');
      return false;
    }
  }

// product
  Future<void> fetchProducts() async {
    try {
      final response = await supabase
          .from('products')
          .select('*')
          .order('created_at', ascending: false);

      final data = response as List;
      final allProducts =
          data.map((item) => ProductModel.fromJson(item)).toList();

      lastProducts = allProducts;
      featuredProducts = allProducts.take(5).toList();
      bestSales = allProducts.skip(5).take(5).toList();
      topRatedProducts = allProducts.where((e) => (e.rate ?? 0) >= 4).toList();

      final allFetchedProducts =
          data.map((item) => ProductModel.fromJson(item)).toList();

      // allProducts = allFetchedProducts;
      lastProducts = allFetchedProducts;
      topRatedProducts =
          allFetchedProducts.where((e) => (e.rate ?? 0) >= 4).toList();
      productsWithDiscount =
          allFetchedProducts.where((e) => (e.sellingPrice ?? 0) > 0).toList();

      update();
    } catch (e) {
      print('Error fetching products: \$e');
    }
  }

  Future<void> fetchProductss() async {
    try {
      final response = await supabase.from('products').select();

      products.assignAll(
        (response as List).map((json) => ProductModel.fromJson(json)).toList(),
      );
      update();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      final inserted = await supabase
          .from('products')
          .insert(product.toJson())
          .select()
          .single();

      final newProduct = ProductModel.fromJson(inserted);
      products.add(newProduct);
      update();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> fetchBanners() async {
    try {
      final response =
          await supabase.from('ads').select('*').eq('is_active', true);

      banners = (response as List)
          .map((item) => HomeBannerModel.fromJson(item))
          .toList();

      update();
    } catch (e) {
      print('Error fetching banners: \$e');
    }
  }

  //categories
  Future<void> fetchCategories() async {
    try {
      final response = await supabase.from('product_main_category').select();

      categories.assignAll(
        (response as List)
            .map((json) => HomeMainCategoryModel.fromJson(json))
            .toList(),
      );
      update();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchProductCategories() async {
    try {
      final response = await supabase.from('product_category').select();

      categories.assignAll(
        (response as List)
            .map((json) => HomeMainCategoryModel.fromJson(json))
            .toList(),
      );
      update();
    } catch (e) {
      print('Error fetching categories: \$e');
    }
  }

  Future<void> fetchCategoriess() async {
    try {
      isLoadingCategories = true;
      update();

      final response = await supabase.from('product_main_category').select();

      categories.assignAll(
        (response as List)
            .map((json) => HomeMainCategoryModel.fromJson(json))
            .toList()
            .reversed
            .toList(),
      );
    } catch (e) {
      print('Error fetching categories: \$e');
      Get.snackbar('Error', 'Failed to fetch categories');
    } finally {
      isLoadingCategories = false;
      update();
    }
  }
  Future<void> fetchcCategories() async {
    try {
      isLoadingCategories = true;
      update();

      final response = await supabase.from('product_category').select();

      categories.assignAll(
        (response as List)
            .map((json) => HomeMainCategoryModel.fromJson(json))
            .toList()
            .reversed
            .toList(),
      );
    } catch (e) {
      print('Error fetching categories: $e');
      Get.snackbar('Error', 'Failed to fetch categories');
    } finally {
      isLoadingCategories = false;
      update();
    }
  }


  Future<List<CategoryModel>> getProductCategoriesID(String mainCategoryId) async {
    final data = await supabase
        .from('product_category')
        .select()
        .eq('main_category_id', mainCategoryId);

    return data
        .map<CategoryModel>((e) => CategoryModel.fromJson(e))
        .toList();
  }

  Future<List<CategoryModel>> getProductCategories() async {
    final data = await supabase.from('product_category').select();
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<void> addCategory(String name, String image_url) async {
    try {
      await supabase.from('product_main_category').insert({
        'name': name,
        'image_url': image_url,
        'created_at': DateTime.now().toIso8601String(),
      });
      await fetchCategories();
      update();
    } catch (e, s) {
      print('Error adding category: $e');
      print('StackTrace: $s');
    }
  }
  Future<void> addProductsCategory(String name, String image_url,
      {required int mainCategoryId}
      ) async {
    try {
      await supabase.from('product_category').insert({
        'name': name,
        'image_url': image_url,
        'main_category_id':mainCategoryId,
        'created_at': DateTime.now().toIso8601String(),

      });
      await fetchCategories();
      update();
    } catch (e, s) {
      print('Error adding category: $e');
      print('StackTrace: $s');
    }
  }

  // cart
  Future<void> fetchCartProducts() async {
    isLoadingCart.value = true;

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        lastProductss.clear();
        isLoadingCart.value = false;
        return;
      }

      final cartItemsResponse = await Supabase.instance.client
          .from('cart_items')
          .select('product_id, quantity')
          .eq('user_id', user.id);

      final cartItems = List<Map<String, dynamic>>.from(cartItemsResponse);

      if (cartItems.isEmpty) {
        lastProductss.clear();
        isLoadingCart.value = false;
        return;
      }

      final productIds = cartItems.map((e) => e['product_id'] as int).toList();

      final productsResponse = await Supabase.instance.client
          .from('products')
          .select()
          .inFilter('id', productIds);

      final products = List<Map<String, dynamic>>.from(productsResponse);

      final updatedProducts = products.map((product) {
        final cartItem = cartItems.firstWhere(
          (item) => item['product_id'] == product['id'],
          orElse: () => {'quantity': 1},
        );
        product['availableQuantity'] = cartItem['quantity'] ?? 1;
        return product;
      }).toList();

      await GetxStorage().saveCartProducts(updatedProducts);

      lastProductss.assignAll(
        updatedProducts.map((e) => ProductModel.fromJson(e)).toList(),
      );
    } catch (e) {
      print('Error loading cart: $e');
    } finally {
      isLoadingCart.value = false;
    }
  }

  void deleteCartItem(int id) async {
    await GetxStorage().removeProductFromCart(id);
    await fetchCartProducts();
  }

  void navigateToUserManagement() {
    Get.toNamed('/userManagement');
  }

  void navigateToActivity() {
    Get.back();
    Get.toNamed(Routes.activity);
  }
  void navigateToNotification() {
    Get.back();
    Get.toNamed(Routes.notificationsAdmin);
  }
}
