// lib/features/profile/presentation/controller/profile_controller.dart
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/service/notifications_service.dart';
import '../../../../core/storage/local/app_settings_prefs.dart';

class ProfileController extends GetxController {
  final footerYear = '2025';
  final vatNo = '312324245562';
  final crNo = '103242491';
  final version = '3.1.2';

  final isLoggedIn = false.obs;

  String name = "";
  String email = "";
  String phone = "";
  String? profileImageUrl = '';

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  SupabaseClient get _sb => Supabase.instance.client;
  final AppSettingsPrefs _prefs = instance<AppSettingsPrefs>();

  final RxString countryCode = ''.obs;

  static const Map<String, String> _flagByCode = {
    'SA': ManagerImages.saudi,
    'KW': ManagerImages.kuwait,
    'AE': ManagerImages.united,
    'BH': ManagerImages.sai,
    'QA': ManagerImages.qatar,
    'OM': ManagerImages.oman,
  };

  String get currentFlagAsset =>
      _flagByCode[countryCode.value] ?? _flagByCode['SA']!;

  @override
  void onInit() {
    super.onInit();

    isLoggedIn.value = _sb.auth.currentUser != null;

    countryCode.value = _prefs.getCountry() ?? 'SA';

    _sb.auth.onAuthStateChange.listen((event) async {
      isLoggedIn.value = event.session?.user != null;
      if (isLoggedIn.value) {
        await fetchUserData();
      } else {
        name = email = phone = '';
        fullNameController.clear();
        emailController.clear();
        phoneController.clear();
      }
      update();
    });

    if (isLoggedIn.value) {
      fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    final user = _sb.auth.currentUser;
    if (user == null) return;

    final data = await _sb
        .from('users')
        .select('full_name, email, phone, image')
        .eq('id', user.id)
        .maybeSingle();

    name = (data?['full_name'] ?? '') as String;
    email = (data?['email'] ?? '') as String;
    phone = (data?['phone'] ?? '') as String;
    profileImageUrl = data?['image'] as String?;

    fullNameController.text = name;
    emailController.text = email;
    phoneController.text = phone;

    update();
  }

  void onSignupTap() => Get.toNamed(Routes.signUp);
  void onSigninTap() => Get.toNamed(Routes.login_email);

  void onEditAccount() => Get.toNamed(Routes.accountEdit);
  void onAddresses() => Get.toNamed(Routes.addresses);
  void onOrders() => Get.toNamed(Routes.orders);
  void onWallet() => Get.toNamed(Routes.wallet);
  void onFavorites() => Get.toNamed(Routes.favoriteView);

  Future<void> onCountryLanguage() async {
    final result = await Get.toNamed(Routes.changeLanguage);
    if (result is Map) {
      final selected = result['country'];
      if (selected is String && selected.isNotEmpty) {
        countryCode.value = selected;
        await _prefs.setCountry(selected); // حفظ في SharedPreferences
      }
      // final locale = result['locale']; ...
    }
  }

  void onHelp() {
    Get.toNamed(Routes.help);
  }
  void onSupport() { Get.toNamed(Routes.support); }


  void onAbout() {
     Get.toNamed(Routes.about);}

  Future<void> confirmLogout(BuildContext context) async {
    final w = MediaQuery.of(context).size.width;

    final yes = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 24),
        child: Container(
          width: w - 40,
          constraints: const BoxConstraints(
            maxWidth: 520,
            minWidth: 280,
          ),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                 ManagerStrings.supLogout,
                textAlign: TextAlign.center,
                style: getBoldTextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManagerColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child:  Text(
                        ManagerStrings.supNo,
                        style: getBoldTextStyle(
                          fontSize: 16,
                          color: ManagerColors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManagerColors.like,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: ManagerColors.gray_divedr,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child:  Text(
                       ManagerStrings.supYes ,
                        style: getBoldTextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (yes == true) {
      await _sb.auth.signOut();
      isLoggedIn.value = false;



      // Get.offAllNamed(Routes.login_email);
    }
  }


  Future<void> updateUserProfile() async {
    final user = _sb.auth.currentUser;
    if (user == null) return;

    await _sb.from('users').update({
      'full_name': fullNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
    }).eq('id', user.id);

    await addNotification(
      title: 'تحديث البيانات',
      description: 'تم تحديث بيانات الحساب بنجاح',
    );

    await fetchUserData();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
