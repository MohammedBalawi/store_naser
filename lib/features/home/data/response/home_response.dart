import 'package:app_mobile/core/base_response/base_response.dart';
import 'package:app_mobile/features/home/data/response/home_banner_response.dart';
import 'package:app_mobile/features/home/data/response/home_main_category_response.dart';
import 'package:app_mobile/core/model/product_model.dart';

class HomeResponse extends BaseResponse {
  final List<HomeMainCategoryResponse> mainCategory;
  final List<HomeBannerResponse> banners;
  final List<HomeBannerResponse> featuredBanners; // إذا كان في تمييز خاص
  final List<ProductModel> featuredProducts;
  final List<ProductModel> bestSales;
  final List<ProductModel> lastProducts;
  final List<ProductModel> topRatedProducts;

  HomeResponse({
    required this.mainCategory,
    required this.banners,
    required this.featuredBanners,
    required this.featuredProducts,
    required this.bestSales,
    required this.lastProducts,
    required this.topRatedProducts,
  });

  factory HomeResponse.fromSupabase({
    required List<HomeMainCategoryResponse> mainCategories,
    required List<HomeBannerResponse> banners,
    required List<ProductModel> allProducts,
  }) {
    return HomeResponse(
      mainCategory: mainCategories,
      banners: banners,
      featuredBanners: banners.take(2).toList(),
      featuredProducts: allProducts.take(5).toList(),
      bestSales: allProducts.skip(5).take(5).toList(),
      lastProducts: allProducts,
      topRatedProducts: allProducts.where((e) => (e.rate ?? 0) >= 4).toList(),
    );
  }
  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      mainCategory:json['mainCategory'] ?? '',
      banners: json['banners'] ?? '',
      featuredBanners: json['featuredBanners'] ?? '',
      featuredProducts: json['featuredProducts'] ?? '',
      bestSales: json['bestSales'] ?? '',
      lastProducts: json['lastProducts'] ?? '',
      topRatedProducts: json['topRatedProducts'] ?? '',
    );
  }
}
