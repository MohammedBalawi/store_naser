// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import '../storage/secure_store.dart';

class ApiClient {
  ApiClient._();
  static final I = ApiClient._();

  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Accept': 'application/json'},
  ))..interceptors.add(InterceptorsWrapper(onRequest: (o, h) async {
    final t = await SecureStore.readToken();
    if (t != null && t.isNotEmpty) o.headers['Authorization'] = 'Bearer $t';
    h.next(o);
  }));
}
