import 'package:app_mobile/core/storage/local/app_settings_prefs.dart';
import 'package:app_mobile/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/features/delete_account/domain/di/delete_account_di.dart';
import 'package:app_mobile/features/delete_account/presentation/view/delete_account_view.dart';
import 'package:app_mobile/features/favorite/presentation/view/favorite_view.dart';
import 'package:app_mobile/features/home/presentation/view/home_view.dart';
import 'package:app_mobile/features/logout/domain/di/logout_di.dart';
import 'package:app_mobile/features/search/presentation/view/search_view.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/routes/routes.dart';
import '../../../categories/presentation/view/categories_view.dart';
import '../../../logout/presentation/view/logout_view.dart';

class MainController extends GetxController {
  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);
  bool hasNotifications = false;
  bool hasCart = false;
  String avatar = "";
  String name = "";
  String email = "";

  var currentIndex = 0.obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void changeHasNotifications({
    required bool value,
  }) {
    hasNotifications = value;
    update();
  }

  void fetchData() {
    AppSettingsPrefs prefs = instance<AppSettingsPrefs>();
    avatar = prefs.getUserAvatar();
    email = prefs.getEmail();
    name = prefs.getUserName();
    update();
  }

  void changeHasCart({
    required bool value,
  }) {
    hasCart = value;
    update();
  }

  void navigateToNotifications() {
    changeHasNotifications(
      value: false,
    );
    Get.toNamed(
      Routes.notifications,
    );
  }

  void navigateToSecurity() {
    Get.back();
    Get.toNamed(Routes.security);

  }  void navigateToActivity() {
    Get.back();
    Get.toNamed(Routes.activity);
  }

  void navigateToContactUs() {
    Get.back();
    Get.toNamed(
      Routes.contactUs,
    );
  }

  void navigateToCart() {
    changeHasCart(
      value: false,
    );
    Get.toNamed(
      Routes.cart,
    );
  }

  // Use a getter to access the bottomNavBarItems
  List<PersistentTabConfig> get bottomNavBarItems => [
        PersistentTabConfig(
          screen: const HomeView(),
          item: ItemConfig(
            icon: SvgPicture.asset(
              ManagerImages.iconHome,
              color: ManagerColors.blue,
            ),
            inactiveIcon: SvgPicture.asset(
              ManagerImages.iconHome,
              color: ManagerColors.primaryColor,
            ),
            activeForegroundColor: ManagerColors.blue,
            title: ManagerStrings.home,
            textStyle: getRegularTextStyle(
                fontSize: ManagerFontSize.s10, color: ManagerColors.blue),
            iconSize: ManagerRadius.r26,
          ),
        ),
        PersistentTabConfig(
          screen:  CategoriesView(),
          // screen: WishlistView(),
          item: ItemConfig(
            icon: SvgPicture.asset(
              ManagerImages.iconWishlist,
              color: ManagerColors.blue,
            ),
            inactiveIcon: SvgPicture.asset(
              ManagerImages.iconWishlist,
              color: ManagerColors.primaryColor,
            ),
            title: ManagerStrings.wishlist,
            activeForegroundColor: ManagerColors.blue,
            textStyle: getRegularTextStyle(
                fontSize: ManagerFontSize.s10, color: ManagerColors.blue),
            iconSize: ManagerRadius.r26,
          ),
        ),
        PersistentTabConfig(
          screen: const SearchView(),
          item: ItemConfig(
            icon: SvgPicture.asset(
              ManagerImages.searchIcon,
              color: ManagerColors.blue,
            ),
            inactiveIcon: SvgPicture.asset(
              ManagerImages.searchIcon,
              color: ManagerColors.primaryColor,
            ),
            activeColorSecondary: ManagerColors.blue,
            title: ManagerStrings.search,
            activeForegroundColor: ManagerColors.blue,
            textStyle: getRegularTextStyle(
                fontSize: ManagerFontSize.s10, color: ManagerColors.blue),
            iconSize: ManagerRadius.r26,
          ),
        ),
        PersistentTabConfig(
          screen: const FavoriteView(),
          item: ItemConfig(
            icon: SvgPicture.asset(
              ManagerImages.favorite,
              color: ManagerColors.blue,
            ),
            inactiveIcon: SvgPicture.asset(
              ManagerImages.favorite,
              color: ManagerColors.primaryColor,
            ),
            title: ManagerStrings.favorite,
            activeForegroundColor: ManagerColors.blue,
            textStyle: getRegularTextStyle(
                fontSize: ManagerFontSize.s10, color: ManagerColors.blue),
            iconSize: ManagerRadius.r26,
          ),
        ),
        PersistentTabConfig(
          screen: const ProfileView(),
          item: ItemConfig(
            icon: SvgPicture.asset(
              ManagerImages.profileIcon,
              color: ManagerColors.blue,
            ),
            inactiveIcon: SvgPicture.asset(
              ManagerImages.profileIcon,
              color: ManagerColors.primaryColor,
            ),
            title: ManagerStrings.profile,
            activeForegroundColor: ManagerColors.blue,
            textStyle: getRegularTextStyle(
                fontSize: ManagerFontSize.s10, color: ManagerColors.blue),
            iconSize: ManagerRadius.r26,
          ),
        ),
      ];

  void navigate(int index) {
    persistentTabController.jumpToTab(index);
    currentIndex.value = index;
  }

  void navigateToOrders() {
    Get.back();
    Get.toNamed(
      Routes.orders,
    );
  }

  void navigateToAddresses() {
    Get.back();
    Get.toNamed(
      Routes.addresses,
    );
  }
  void userManagementScreen() {
    Get.back();
    Get.toNamed(
      Routes.userManagementScreen,
    );
  }

  void navigateToTerms() {
    Get.back();
    Get.toNamed(
      Routes.terms,
    );
  }

  void navigateToLogout({
    required BuildContext context,
  }) {
    Get.back();
    initLogout();
    showBottomSheet(
      context: context,
      builder: (context) {
        return const LogoutView();
      },
    );
  }

  void navigateToDeleteAccount({
    required BuildContext context,
  }) {
    Get.back();
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
    fetchData();
    super.onInit();
  }
}

void changeMainCurrentIndex(int index) {
  try {
    Get.find<MainController>().navigate(index);
    debugPrint("The Main Controller Index Changed");
  } catch (e) {
    debugPrint(e.toString());
  }
}
