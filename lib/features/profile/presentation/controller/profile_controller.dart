// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../../../constants/di/dependency_injection.dart';
// import '../../../../core/routes/routes.dart';
// import '../../../delete_account/domain/di/delete_account_di.dart';
// import '../../../delete_account/presentation/view/delete_account_view.dart';
//
// class ProfileController extends GetxController {
//   String phone = "";
//   String name = "";
//   String email = "";
//   String avatar = "";
//   String? profileImageUrl = '';
//   String? existingImageUrl;
//   TextEditingController fullNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//
//
//   String language = "اللغة العربية";
//   bool notificationEmail = false;
//   bool notificationVoice = true;
//
//   void share() {
//     Share.share('تحقق من حسابي: https://bubble.com/');
//   }
//
//   void changeAvatar() {
//     // TODO: Implement avatar update with Supabase storage
//   }
//
//   Future<void> loadExistingImage() async {
//     final supabase = Supabase.instance.client;
//     final userId = supabase.auth.currentUser?.id;
//
//     if (userId == null) return;
//
//     try {
//       final response = await supabase
//           .from('users')
//           .select('image')
//           .eq('id', userId)
//           .maybeSingle();
//
//       if (response != null && response['image'] != null) {
//         existingImageUrl = response['image'];
//         profileImageUrl = response['image'];
//         update();
//       }
//     } catch (e) {
//       print('فشل تحميل صورة المستخدم: $e');
//     }
//   }
//
//   void navigateToChangePassword() {
//     Get.toNamed(Routes.changePassword);
//   }
//
//   void navigateToChangeLanguage() {
//     Get.toNamed(Routes.changeLanguage);
//   }
//
//   Future<void> fetchUserDataFromSupabase() async {
//     final supabase = getIt<SupabaseClient>();
//     final user = supabase.auth.currentUser;
//
//     if (user == null) return;
//
//     final response = await supabase
//         .from('users')
//         .select('full_name, email, phone, password, image')
//         .eq('id', user.id)
//         .maybeSingle();
//
//     if (response != null) {
//       name = response['full_name'] ?? '';
//       email = response['email'] ?? '';
//       phone = response['phone'] ?? '';
//       avatar = response['password'] ?? '';
//       profileImageUrl = response['image'] ?? '';
//
//       update();
//     }
//   }
//
//   void deleteAccount({required BuildContext context}) {
//     initDeleteAccount();
//     showBottomSheet(
//       context: context,
//       builder: (context) {
//         return const DeleteAccountView();
//       },
//     );
//   }
//   Future<void> updateUserProfile() async {
//     final supabase = Supabase.instance.client;
//     final userId = supabase.auth.currentUser?.id;
//     if (userId == null) return;
//
//     try {
//       await supabase.from('users').update({
//         'full_name': fullNameController.text,
//         'email': emailController.text,
//         'phone': phoneController.text,
//       }).eq('id', userId);
//
//       Get.snackbar('تم', 'تم تحديث بيانات الحساب بنجاح');
//       fetchUserDataFromSupabase();
//     } catch (e) {
//       print('❌ فشل التحديث: $e');
//       Get.snackbar('خطأ', 'حدث خطأ أثناء تحديث البيانات');
//     }
//   }
//
//
//   @override
//   void onInit() {
//     fetchUserDataFromSupabase();
//     loadExistingImage();
//     super.onInit();
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/service/notifications_service.dart';
import '../../../delete_account/domain/di/delete_account_di.dart';
import '../../../delete_account/presentation/view/delete_account_view.dart';

class ProfileController extends GetxController {
  String phone = "";
  String name = "";
  String email = "";
  String avatar = "";
  String? profileImageUrl = '';
  String? existingImageUrl;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String language = "اللغة العربية";
  bool notificationEmail = false;
  bool notificationVoice = true;

  void share() {
    Share.share('تحقق من حسابي: https://bubble.com/');
  }

  void changeAvatar() {
    // TODO: Implement avatar update with Supabase storage
  }

  Future<void> loadExistingImage() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return;

    try {
      final response = await supabase
          .from('users')
          .select('image')
          .eq('id', userId)
          .maybeSingle();

      if (response != null && response['image'] != null) {
        existingImageUrl = response['image'];
        profileImageUrl = response['image'];
        update();
      }
    } catch (e) {
      print('فشل تحميل صورة المستخدم: $e');
    }
  }

  void navigateToChangePassword() {
    Get.toNamed(Routes.changePassword);
  }

  void navigateToChangeLanguage() {
    Get.toNamed(Routes.changeLanguage);
  }

  Future<void> fetchUserDataFromSupabase() async {
    final supabase = getIt<SupabaseClient>();
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final response = await supabase
        .from('users')
        .select('full_name, email, phone, password, image')
        .eq('id', user.id)
        .maybeSingle();

    if (response != null) {
      name = response['full_name'] ?? '';
      email = response['email'] ?? '';
      phone = response['phone'] ?? '';
      avatar = response['password'] ?? '';
      profileImageUrl = response['image'] ?? '';

      fullNameController.text = name;
      emailController.text = email;
      phoneController.text = phone;

      update();
    }
  }

  Future<void> updateUserProfile() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await supabase.from('users').update({
        'full_name': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      }).eq('id', userId);

      Get.snackbar('تم', 'تم تحديث بيانات الحساب بنجاح');
      await addNotification(
        title: 'تحديث بيانات الشخصية',
        description: 'تم تحديث بيانات الحساب بنجاح',
      );

      fetchUserDataFromSupabase();
    } catch (e) {
      print(' فشل التحديث: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحديث البيانات');
    }
  }

  void deleteAccount({required BuildContext context}) {
    initDeleteAccount();
    showBottomSheet(
      context: context,
      builder: (context) {
        return const DeleteAccountView();
      },
    );
  }

  @override
  void onInit() {
    fetchUserDataFromSupabase();
    loadExistingImage();
    super.onInit();
  }
}
