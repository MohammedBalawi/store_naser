import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> addNotification({
  required String title,
  required String description,
}) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    print(' لا يوجد مستخدم مسجل حالياً');
    return;
  }

  final response = await Supabase.instance.client.from('notifications').insert({
    'title': title,
    'description': description,
    'user_id': user.id,
    'is_read':false,

  });

  if (response == null) {

    print(' فشل إرسال الإشعار');
  } else {
    print(' إشعار مرسل بنجاح');
  }
}

