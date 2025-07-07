import 'package:supabase_flutter/supabase_flutter.dart';

/// Logs any user activity (add/update/delete) to the `activity_logs` table in Supabase.
///
/// Required:
/// - [actionType] : 'add', 'update', or 'delete'
/// - [affectedTable] : the table name (e.g., 'products', 'users')
/// - [actionDescription] : description of what happened
/// Optional:
/// - [recordId] : the ID of the affected record
Future<void> logActivity({
  required String actionType,
  required String affectedTable,
  required String actionDescription,
  String? recordId,
}) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) {
    print('لا يوجد مستخدم مسجّل حالياً. لن يتم تسجيل الحدث.');
    return;
  }

  try {
    await supabase.from('activity_logs').insert({
      'user_id': user.id,
      'action_type': actionType,
      'affected_table': affectedTable,
      'action_description': actionDescription,
      'record_id': recordId,
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
    });
    print('✅ تم تسجيل النشاط: [$actionType] $actionDescription');
  } catch (e) {
    print(' فشل تسجيل الحدث في activity_logs: $e');
  }
}
