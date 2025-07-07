import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/server_config.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/usecase/notifications_usecase.dart';

class NotificationsController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final homeController = Get.find<HomeController>();
  Timer? _pollingTimer;
  List<NotificationModel> notifications = [];
  bool isLoading = true;

  String get serverUrl => ServerConfig.getNotificationServerUrl();

  void changeIsLoading({required bool value}) {
    isLoading = value;
    update();
  }
  Future<void> markAllNotificationsAsRead() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .or('user_id.eq.${user.id},user_id.is.null');

      homeController.markNotificationRead();
    }
  }


  Future<void> notificationsRequest() async {
    changeIsLoading(value: true);

    final user = _supabase.auth.currentUser;
    if (user == null) {
      changeIsLoading(value: false);
      return;
    }

    final response = await _supabase
        .from('notifications')
        .select()
        .or('user_id.eq.${user.id},user_id.is.null')
        .order('created_at', ascending: false);

    if (response != null && response is List) {
      notifications = response
          .map((e) => NotificationModel.fromJson(e))
          .toList();

      if (notifications.any((n) => n.isRead == false)) {
        final hasUnread = notifications.any((n) => n.isRead == false);

        if (hasUnread) {
          homeController.markNotificationArrived();  // يصير true
        } else {
          homeController.markNotificationRead();     // يصير false
        }
        homeController.markNotificationArrived();
      }
    }

    changeIsLoading(value: false);
  }

  /// ارسال اشعار
  Future<void> sendNotification(String title, String body, {bool isPublic = false}) async {
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "title": title,
          "body": body,
          "topic": isPublic ? "all_users" : null,
        }),
      );

      if (response.statusCode == 200) {
        print('تم إرسال الإشعار بنجاح');

        final user = _supabase.auth.currentUser;

        await _supabase.from('notifications').insert({
          'title': title,
          'description': body,
          'user_id': isPublic ? null : user?.id,
          'created_at': DateTime.now().toIso8601String(),
          'is_read': false,
        });

        notifications.insert(
          0,
          NotificationModel(
            id: (notifications.length + 1).toString(),
            title: title,
            description: body,
            createdAt: DateTime.now(),
            isRead: false,
          ),
        );

        homeController.markNotificationArrived();
        update();
      } else {
        print('فشل في إرسال الإشعار: ${response.body}');
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال الإشعار: $e');
    }
  }

  /// ارسال الاشعارات من usecase
  Future<void> notificationsSendRequest() async {
    changeIsLoading(value: true);
    final NotificationsUseCase useCase = instance<NotificationsUseCase>();
    (await useCase.execute()).fold(
          (l) {
        changeIsLoading(value: false);
        // @todo: show error
      },
          (r) async {
        changeIsLoading(value: false);
        notifications = r.data;
        update();
      },
    );
  }

  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      notificationsRequest();
    });
  }
  @override
  void onInit() {
    notificationsRequest();
    super.onInit();
    startPolling();
  }
  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }
  @override
  void dispose() {

    super.dispose();
  }
}
