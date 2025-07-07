import 'package:app_mobile/features/home/domain/model/home_banner_model.dart';
import 'package:app_mobile/features/home/domain/model/home_main_category_model.dart';
import '../../../../core/model/product_model.dart';

class HomeModel {
  List<HomeMainCategoryModel> mainCategory;
  List<HomeBannerModel> banners;
  List<HomeBannerModel> featuredBanners;
  List<ProductModel> featuredProducts;
  List<ProductModel> bestSales;
  List<ProductModel> lastProducts;
  List<ProductModel> topRatedProducts;

  HomeModel({
    required this.mainCategory,
    required this.banners,
    required this.featuredBanners,
    required this.featuredProducts,
    required this.bestSales,
    required this.lastProducts,
    required this.topRatedProducts,
  });
}
