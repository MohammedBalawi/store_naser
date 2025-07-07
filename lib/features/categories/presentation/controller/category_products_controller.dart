import 'package:flutter/material.dart';
import 'package:app_mobile/features/categories/data/request/category_products_request.dart';
import 'package:app_mobile/features/categories/domain/di/categories_di.dart';
import 'package:app_mobile/features/categories/domain/usecase/category_products_usecase.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/model/product_category_model.dart';
import '../../../../core/model/product_model.dart';

class CategoryProductsController extends GetxController {
  List<ProductModel> products = [];
  String categoryName = "";

  ProductCategoryModel category = ProductCategoryModel(
    id: 0,
    // icon: "",
    name: '',
  );
  String categoryId = "";
  bool isLoading = true;
  String search = "";
  TextEditingController searchController = TextEditingController();

  void changeSearch(String value) {
    search = value;
    update();
  }

  List<ProductModel> filteredProducts() {
    return products.where((element) => searching(element)).toList();
  }

  bool searching(ProductModel product) {
    String value = product.name.toString().toLowerCase();
    String search = searchController.text.toLowerCase();
    if (value.startsWith(search) ||
        value.endsWith(search) ||
        value.contains(search)) {
      return true;
    }
    return false;
  }

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void productsRequest() async {
    changeIsLoading(
      value: true,
    );
    final CategoryProductsUseCase useCase = instance<CategoryProductsUseCase>();
    (await useCase.execute(CategoryProductsRequest(
      id: categoryId,
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

        products = r.data;
        if (r.data.isNotEmpty) {
          category = r.data[0].category!;
        }
        update();
      },
    );
  }

  void fetchCategory() {
    CacheData cacheData = CacheData();
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
