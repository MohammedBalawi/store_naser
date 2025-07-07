import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final supabase = Supabase.instance.client;

  Future<String?> signUp({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signUp(email: email, password: password);
      if (response.user != null) return null;
      return 'لم يتم إنشاء الحساب';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signInWithPassword(email: email, password: password);
      if (response.user != null) return null;
      return 'بيانات الدخول غير صحيحة';
    } catch (e) {
      return e.toString();
    }
  }
}
