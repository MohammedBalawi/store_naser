import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_mobile/constants/di/dependency_injection.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/storage/local/app_settings_prefs.dart';

import 'package:app_mobile/core/routes/routes.dart';
import 'package:app_mobile/features/categories/presentation/view/categories_view.dart';
import 'package:app_mobile/features/home/presentation/view/home_view.dart';
import 'package:app_mobile/features/profile/presentation/view/profile_view.dart';
import 'package:app_mobile/features/reels/presentation/view/reels_view.dart';
import 'package:app_mobile/features/reels/presentation/binding/reels_binding.dart';
import 'package:app_mobile/features/reels/presentation/controller/reels_controller.dart';
import 'package:app_mobile/features/cart/presentation/view/cart_view.dart';
import 'package:app_mobile/features/logout/presentation/view/logout_view.dart';
import 'package:app_mobile/features/delete_account/presentation/view/delete_account_view.dart';
import 'package:app_mobile/features/delete_account/domain/di/delete_account_di.dart';
import 'package:app_mobile/features/logout/domain/di/logout_di.dart';

class MainController extends GetxController {
  late PersistentTabController persistentTabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var currentIndex = 0.obs;
  bool get isReels => currentIndex.value == 2;

  bool hasNotifications = false;
  bool hasCart = false;

  String avatar = "";
  String name = "";
  String email = "";

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  void changeHasNotifications({required bool value}) {
    hasNotifications = value;
    update();
  }

  void changeHasCart({required bool value}) {
    hasCart = value;
    update();
  }

  void fetchData() {
    final prefs = instance<AppSettingsPrefs>();
    avatar = prefs.getUserAvatar();
    email = prefs.getEmail();
    name = prefs.getUserName();
    update();
  }

  void navigateToNotifications() {
    changeHasNotifications(value: false);
    Get.toNamed(Routes.notifications);
  }

  void navigateToSecurity() {
    Get.back();
    Get.toNamed(Routes.security);
  }

  void navigateToActivity() {
    Get.back();
    Get.toNamed(Routes.activity);
  }

  void navigateToContactUs() {
    Get.back();
    Get.toNamed(Routes.contactUs);
  }

  void navigateToCart() {
    changeHasCart(value: false);
    Get.toNamed(Routes.cart);
  }

  void navigateToOrders() {
    Get.back();
    Get.toNamed(Routes.orders);
  }

  void navigateToAddresses() {
    Get.back();
    Get.toNamed(Routes.addresses);
  }

  void userManagementScreen() {
    Get.back();
    Get.toNamed(Routes.userManagementScreen);
  }

  void navigateToTerms() {
    Get.back();
    Get.toNamed(Routes.terms);
  }

  void navigateToLogout({required BuildContext context}) {
    Get.back();
    initLogout();
    showBottomSheet(
      context: context,
      builder: (context) => const LogoutView(),
    );
  }

  void navigateToDeleteAccount({required BuildContext context}) {
    Get.back();
    initDeleteAccount();
    showBottomSheet(
      context: context,
      builder: (context) => const DeleteAccountView(),
    );
  }

  void navigate(int index) {
    persistentTabController.jumpToTab(index);
    currentIndex.value = index;
  }

  void changeMainCurrentIndex(int index) {
    try {
      Get.find<MainController>().navigate(index);
      debugPrint("The Main Controller Index Changed");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<PersistentTabConfig> get bottomNavBarItems {
    final inactiveColor = isReels ? Colors.white : ManagerColors.black;
    final labelColor = isReels ? Colors.white : ManagerColors.black;

    TextStyle labelStyle() => getRegularTextStyle(
      fontSize: ManagerFontSize.s10,
      color: labelColor,
    );

    return [
      PersistentTabConfig(
        screen: HomeView(),
        item: ItemConfig(
          icon: SvgPicture.asset(ManagerImages.iconHome, color: ManagerColors.color),
          inactiveIcon: SvgPicture.asset(ManagerImages.iconHome, color: inactiveColor),
          title: ManagerStrings.home,
          activeForegroundColor: ManagerColors.color,
          textStyle: labelStyle(),
          iconSize: ManagerRadius.r26,
        ),
      ),
      PersistentTabConfig(
        screen: CategoriesView(),
        item: ItemConfig(
          icon: SvgPicture.asset(ManagerImages.iconWishlist, color: ManagerColors.color),
          inactiveIcon: SvgPicture.asset(ManagerImages.iconWishlist, color: inactiveColor),
          title: ManagerStrings.wishlist,
          activeForegroundColor: ManagerColors.color,
          textStyle: labelStyle(),
          iconSize: ManagerRadius.r26,
        ),
      ),
      PersistentTabConfig(
        screen: ReelsView(),
        item: ItemConfig(
          icon: SvgPicture.asset(ManagerImages.reels, color: ManagerColors.color),
          inactiveIcon: SvgPicture.asset(ManagerImages.reels, color: inactiveColor),
          title: ManagerStrings.reels,
          activeForegroundColor: ManagerColors.color,
          textStyle: labelStyle(),
          iconSize: ManagerRadius.r26,
        ),
      ),
      PersistentTabConfig(
        screen: const CartView(),
        item: ItemConfig(
          icon: SvgPicture.asset(ManagerImages.shopping, color: ManagerColors.color),
          inactiveIcon: SvgPicture.asset(ManagerImages.shopping, color: inactiveColor),
          title: ManagerStrings.mY_BAG,
          activeForegroundColor: ManagerColors.color,
          textStyle: labelStyle(),
          iconSize: ManagerRadius.r26,
        ),
      ),
      PersistentTabConfig(
        screen: const ProfileView(),
        item: ItemConfig(
          icon: SvgPicture.asset(ManagerImages.profileIcon, color: ManagerColors.color),
          inactiveIcon: SvgPicture.asset(ManagerImages.profileIcon, color: inactiveColor),
          title: ManagerStrings.profile,
          activeForegroundColor: ManagerColors.color,
          textStyle: labelStyle(),
          iconSize: ManagerRadius.r26,
        ),
      ),
    ];
  }

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>?;
    final initialIndex = (args?['tab'] as int?) ?? 0;

    persistentTabController = PersistentTabController(initialIndex: initialIndex);

    persistentTabController.addListener(() {
      final idx = persistentTabController.index;
      if (currentIndex.value != idx) currentIndex.value = idx;
    });

    currentIndex.value = initialIndex;

    if (!Get.isRegistered<ReelsController>()) {
      ReelsBinding().dependencies();
    }

    fetchData();

    if (args?['openDeepRating'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        persistentTabController.jumpToTab(0);
      });
    }

    super.onInit();
  }
}
