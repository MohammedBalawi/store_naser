import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app_mobile/core/model/product_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/storage/local/getx_storage.dart';

// موديل الواجهة لديك
import '../../domain/model/home_banner_model.dart';
import '../../domain/model/home_main_category_model.dart';

// شبكة REST للأصناف
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;

  var hasNewNotification = false.obs;

  var categories = <HomeMainCategoryModel>[].obs;
  bool isLoadingCategories = false;
  String? categoriesError;

  var users = <Map<String, dynamic>>[];
  bool loadingUsers = false;

  var banners = <HomeBannerModel>[];

  List<ProductModel> featuredProducts = [];
  List<ProductModel> bestSales = [];
  List<ProductModel> lastProducts = [];
  var products = <ProductModel>[].obs;
  List<ProductModel> topRatedProducts = [];
  var productsWithDiscount = <ProductModel>[];

  var isLoadingCart = false.obs;
  var lastProductss = <ProductModel>[].obs;

  bool isWholesaler = false;
  bool isAdminn = false;
  bool isLoading = true;
  Rxn<Map<String, dynamic>> currentUser = Rxn<Map<String, dynamic>>();
  final _dio = ApiClient.I.dio;

  @override
  void onInit() {
    super.onInit();
    initHome();
  }

  Future<void> clearUserData() async {
    currentUser.value = null;
    await supabase.auth.signOut();
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

    await fetchCategoriesFromApi();

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
    await fetchCategoriesFromApi();

    isLoading = false;
    update();
  }

  void markNotificationArrived() => hasNewNotification.value = true;
  void markNotificationRead() => hasNewNotification.value = false;

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
        update();
      }
    } catch (e) {
    }
  }

  Future<bool> checkIfAdmin() async {
    try {
      final email = supabase.auth.currentUser?.userMetadata?['email'];
      if (email == null) return false;
      final response =
      await supabase.from('users').select('role').eq('email', email).maybeSingle();
      return response?['role'] == 'admin';
    } catch (_) {
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
    } catch (_) {
      return false;
    }
  }

  Future<void> fetchUsers() async {
    loadingUsers = true;
    update();
    try {
      final response =
      await supabase.from('users').select().order('created_at', ascending: true);
      if (response is List) {
        users = List<Map<String, dynamic>>.from(response);
      } else {
        users.clear();
      }
    } catch (_) {
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
    } catch (_) {
      Get.snackbar('فشل', 'فشل في تحديث بيانات المستخدم');
      return false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response =
      await supabase.from('products').select('*').order('created_at', ascending: false);

      final data = response as List;
      final all = data.map((e) => ProductModel.fromJson(e)).toList();

      lastProducts = all;
      featuredProducts = all.take(5).toList();
      bestSales = all.skip(5).take(5).toList();
      topRatedProducts = all.where((e) => (e.rate ?? 0) >= 4).toList();

      productsWithDiscount = all.where((e) => (e.sellingPrice ?? 0) > 0).toList();
      update();
    } catch (_) {
    }
  }

  Future<void> fetchProductss() async {
    try {
      final response = await supabase.from('products').select();
      products.assignAll(
        (response as List).map((j) => ProductModel.fromJson(j)).toList(),
      );
      update();
    } catch (_) {
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      final inserted =
      await supabase.from('products').insert(product.toJson()).select().single();
      products.add(ProductModel.fromJson(inserted));
      update();
    } catch (_) {
    }
  }

  Future<void> fetchBanners() async {
    try {
      final response =
      await supabase.from('ads').select('*').eq('is_active', true);
      banners = (response as List).map((e) => HomeBannerModel.fromJson(e)).toList();
      update();
    } catch (_) {
    }
  }

  Future<void> fetchCategoriesFromApi() async {
    try {
      isLoadingCategories = true;
      categoriesError = null;
      update();

      final res = await _dio.get(Endpoints.categories);
      final body = res.data;

      final list = (body is Map && body['data'] is List) ? body['data'] as List : <dynamic>[];

      categories.assignAll(
        list.map<HomeMainCategoryModel>((e) {
          final m = e as Map<String, dynamic>;
          final img = (m['image'] ?? m['image_url'])?.toString();
          return HomeMainCategoryModel(
            id: m['id'] is int ? m['id'] : int.tryParse('${m['id']}') ?? 0,
            name: m['name']?.toString() ?? '',
            image: img,
          );
        }).toList(),
      );
    } catch (e) {
      categories.clear();
      categoriesError = e.toString();
    } finally {
      isLoadingCategories = false;
      update();
    }
  }

  Future<void> fetchCartProducts() async {
    isLoadingCart.value = true;
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        lastProductss.clear();
        isLoadingCart.value = false;
        return;
      }

      final cartItemsResponse = await supabase
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
      final productsResponse =
      await supabase.from('products').select().inFilter('id', productIds);

      final productsList = List<Map<String, dynamic>>.from(productsResponse);
      final updated = productsList.map((p) {
        final item = cartItems.firstWhere(
              (it) => it['product_id'] == p['id'],
          orElse: () => {'quantity': 1},
        );
        p['availableQuantity'] = item['quantity'] ?? 1;
        return p;
      }).toList();

      await GetxStorage().saveCartProducts(updated);
      lastProductss.assignAll(updated.map((e) => ProductModel.fromJson(e)).toList());
    } catch (_) {
      // ignore
    } finally {
      isLoadingCart.value = false;
    }
  }

  void deleteCartItem(int id) async {
    await GetxStorage().removeProductFromCart(id);
    await fetchCartProducts();
  }

  void navigateToUserManagement() => Get.toNamed('/userManagement');
  void navigateToActivity() { Get.back(); Get.toNamed(Routes.activity); }
  void navigateToNotification() { Get.back(); Get.toNamed(Routes.notificationsAdmin); }
}
