import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/storage/local/app_settings_prefs.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/service/notifications_service.dart';
import '../view/add_rate_dialog.dart';

class AddRateController extends GetxController {
  TextEditingController title = TextEditingController();
  TextEditingController comment = TextEditingController();
  String userName = "";
  String avatar = "";
  double rate = 0;
  bool isLoading = false;

  late int productId;

  void changeIsLoading({required bool value}) {
    isLoading = value;
    update();
  }

  bool checkButtonEnabled() {
    return title.text.length > 4 && rate >= 1;
  }

  Future<void> addRate() async {
    changeIsLoading(value: true);

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      print(' User not logged in');
      changeIsLoading(value: false);
      return;
    }

    try {
      await supabase
          .from('product_rates')
          .insert({
        'product_id': CacheData.productId,
        'user_id': userId,
        'rate': rate.toInt(),
        'title': ' العنوان :${title.text}',
        'comment': ' التفاصيل :${comment.text}',
        'created_at': DateTime.now().toIso8601String(),
      });

      print('Rating inserted for product ${CacheData.productId} by user $userId');

      await supabase
          .from('products')
          .update({
        'rate': rate.toInt(),
      })
          .eq('id', CacheData.productId);

      print('Product rate updated for product ${CacheData.productId} to rate=${rate.toInt()}');

      changeIsLoading(value: false);
      Get.back();
      await addNotification(
        title: 'تقييم',
        description: 'شكراً على تقييمك لمنتجنا',
      );



      AwesomeDialog(
        customHeader: Image.asset(
          ManagerImages.assessAdded,
        ),
        context: Get.context!,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        body: addRateDialog(rate: rate),
      ).show();
    } catch (error) {
      changeIsLoading(value: false);
      print('Error adding rate to product ${CacheData.productId}: $error');
    }
  }


  void getUser() {
    AppSettingsPrefs prefs = instance<AppSettingsPrefs>();
    avatar = prefs.getUserAvatar();
    userName = prefs.getUserName();
    update();
  }

  void changeRate(double value) {
    rate = value;
    update();
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }
}
