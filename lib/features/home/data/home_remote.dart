// lib/features/home/data/home_remote.dart
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/category_model.dart';

class HomeRemote {
  final Dio _dio = ApiClient.I.dio;

  Future<List<CategoryModel>> getCategories() async {
    final res = await _dio.get(Endpoints.categories);
    final data = res.data['data'];
    if (data is List) {
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    }
    return [];
  }
}
