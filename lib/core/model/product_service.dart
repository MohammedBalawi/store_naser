import 'package:app_mobile/core/model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final supabase = Supabase.instance.client;

  Future<List<ProductModel>> fetchProducts() async {
    final response = await supabase
        .from('products')
        .select('*, main_category:product_main_category(*), category:product_category(*)')
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
}
