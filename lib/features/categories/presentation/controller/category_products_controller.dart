// ... نفس الاستيرادات عندك
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/model/product_category_model.dart';
import '../../../../core/model/product_model.dart';
import '../../data/request/category_products_request.dart';
import '../../domain/di/categories_di.dart';
import '../../domain/usecase/category_products_usecase.dart';

enum ProductSort { popular, newest, offersFirst, priceHighLow, priceLowHigh }

class BrandChipModel {
  final String id;
  final String name;
  final String productImage; // صورة المنتج اللي بتطلع فوق الكرت الداكن
  final String? logo;        // لوجو الماركة (اختياري)
  BrandChipModel({required this.id, required this.name, required this.productImage, this.logo});
}

class CategoryProductsController extends GetxController {
  List<ProductModel> products = [];
  String categoryName = "";

  ProductCategoryModel category = ProductCategoryModel(id: 0, name: '');
  String categoryId = "";
  bool isLoading = true;
  String search = "";
  TextEditingController searchController = TextEditingController();

  // === تبويبات فرعية (نفس اللي بالصورة) ===
  final List<String> subTabs = const [
    'جميع المنتجات',
    'العناية بالوجه',
    'العناية بالجسم',
    'العناية بالشفاه',
    'العناية بالعيون',
  ];
  int selectedSubTab = 0;

  void selectSubTab(int i) {
    selectedSubTab = i;
    // TODO: استدعاء API لو عندك فلترة حسب التبويب
    update();
  }

  // === ماركات (Strip أفقي) — عيّنها من الـ API لاحقاً ===
  List<BrandChipModel> brands = [
    BrandChipModel(
      id: 'cerave',
      name: 'CeraVe',
      productImage: ManagerImages.image_1,
      logo:ManagerImages.icon_1,
    ),
    BrandChipModel(
      id: 'cerave',
      name: 'CeraVe',
      productImage: ManagerImages.image_1,
      logo:ManagerImages.icon_1,
    ),
    BrandChipModel(
      id: 'cerave',
      name: 'CeraVe',
      productImage: ManagerImages.image_1,
      logo:ManagerImages.icon_1,
    ),


  ];
  String? selectedBrandId;
  void selectBrand(String? id) {
    selectedBrandId = id;
    update();
  }

  // === الفرز (فلتر) ===
  ProductSort? sort;
  void setSort(ProductSort? s) {
    sort = s;
    update();
  }

  void changeSearch(String value) {
    search = value;
    update();
  }

  // === البحث + الفلترة + الفرز معًا ===
  List<ProductModel> filteredProducts() {
    // 1) فلترة نصية
    String q = searchController.text.toLowerCase().trim();
    Iterable<ProductModel> data = products;
    if (q.isNotEmpty) {
      data = data.where((p) => (p.name ?? '').toLowerCase().contains(q));
    }

    // 2) فلترة ماركة (اختياري)
    if (selectedBrandId != null) {
      // TODO: لو المنتج يحوي brandId
      data = data.where((p) => (p.category?.name ?? '').toLowerCase().contains(selectedBrandId!.toLowerCase()));
    }

    // 3) فلترة تبويب (اختياري) — هنا مجرد مثال بالتسمية
    if (selectedSubTab != 0) {
      final tabName = subTabs[selectedSubTab];
      data = data.where((p) => (p.category?.name ?? '').contains(tabName));
    }

    // 4) الفرز
    final list = data.toList();
    switch (sort) {
      case ProductSort.priceHighLow:
        list.sort((a, b) => (b.sellingPrice ?? b.price ?? 0).compareTo(a.sellingPrice ?? a.price ?? 0));
        break;
      case ProductSort.priceLowHigh:
        list.sort((a, b) => (a.sellingPrice ?? a.price ?? 0).compareTo(b.sellingPrice ?? b.price ?? 0));
        break;
      case ProductSort.newest:
        list.sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
        break;
      case ProductSort.offersFirst:
        list.sort((a, b) => (b.discountRatio ?? 0).compareTo(a.discountRatio ?? 0));
        break;
      case ProductSort.popular:
        list.sort((a, b) => (b.rateCount ?? 0).compareTo(a.rateCount ?? 0));
        break;
      case null:
        break;
    }
    return list;
  }

  // ====== باقي الكود الأصلي عندك ======


  void changeIsLoading({required bool value}) {
    isLoading = value;
    update();
  }

  void productsRequest() async {
    changeIsLoading(value: true);
    final CategoryProductsUseCase useCase = instance<CategoryProductsUseCase>();
    (await useCase.execute(CategoryProductsRequest(id: categoryId))).fold(
          (l) {
        changeIsLoading(value: false);
      },
          (r) async {
        changeIsLoading(value: false);
        products = r.data;
        if (r.data.isNotEmpty) {
          category = r.data[0].category!;
        }
        update();
      },
    );
  }

  void fetchCategory() {
    final cacheData = CacheData();
    categoryId = cacheData.getCategoryId();
    categoryName = cacheData.getCategoryName();
  }

  @override
  void onInit() {
    fetchCategory();
    initCategoryProductsRequest();
    productsRequest();
    super.onInit();
  }

  @override
  void dispose() {
    disposeCategoryProductsRequest();
    super.dispose();
  }
}
