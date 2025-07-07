import 'package:app_mobile/features/search/presentation/controller/search_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/di/dependency_injection.dart' as Supabase;
import '../../../../core/model/product_model.dart';

extension SupabaseProductSearch on AppSearchController {
  Future<void> searchProductsInSupabase() async {
    changeIsLoading(value: true);
    changeSearched(value: true);

    addSearch();

    try {
      final supabase = Supabase.getIt<SupabaseClient>();

      final response = await supabase
          .from('products')
          .select();


      List<ProductModel> allProducts = (response as List<dynamic>)
          .map((json) => ProductModel.fromJson(json))
          .toList();

      products = allProducts
          .where((p) =>
      (p.name?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false) ||
          (p.type?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false) ||
          (p.price?.toString().contains(searchController.text) ?? false) ||
          (p.createdAt?.toString().contains(searchController.text) ?? false))
          .toList();

      update();
      changeIsLoading(value: false);
      changeSearched(value: true);
    } catch (e) {
      changeIsLoading(value: false);
    }
  }
}
