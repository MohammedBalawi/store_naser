import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_mobile/features/home/data/response/home_response.dart';
import 'package:app_mobile/features/home/data/response/home_banner_response.dart';
import 'package:app_mobile/features/home/data/response/home_main_category_response.dart';
import 'package:app_mobile/core/model/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeResponse> home();
}

class HomeRemoteDataSourceImplement implements HomeRemoteDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<HomeResponse> home() async {
    try {
      final bannerData = await supabase.from('ads').select().eq('is_active', true);
      final banners = (bannerData as List).map((e) => HomeBannerResponse.fromJson(e)).toList();

      final categoryData = await supabase.from('product_main_category').select();
      final categories = (categoryData as List).map((e) => HomeMainCategoryResponse.fromJson(e)).toList();

      final productsData = await supabase
          .from('products')
          .select('*, main_category:product_main_category(*), category:product_category(*)')
          .order('created_at', ascending: false);

      final products = (productsData as List).map((e) => ProductModel.fromJson(e)).toList();

      return HomeResponse(
        banners: banners,
        mainCategory: categories,
        featuredBanners: banners.take(2).toList(),
        featuredProducts: products.take(5).toList(),
        bestSales: products.skip(5).take(5).toList(),
        topRatedProducts: products.where((e) => (e.rate ?? 0) >= 4).toList(),
        lastProducts: products,
      );

    } catch (e) {
      print(' Error fetching home data: $e');
      rethrow;
    }
  }
}
