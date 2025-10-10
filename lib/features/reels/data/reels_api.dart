import 'models/reel.dart';

/// واجهة عامة لمصدر البيانات (HTTP / Supabase / ...).
abstract class ReelsApi {
  Future<List<Reel>> fetchReels({int page = 1});
}
