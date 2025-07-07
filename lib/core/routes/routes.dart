import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/addressess/domain/di/addresses_di.dart';
import 'package:app_mobile/features/addressess/presentation/view/add_address_view.dart';
import 'package:app_mobile/features/addressess/presentation/view/addresses_view.dart';
import 'package:app_mobile/features/addressess/presentation/view/edit_address_view.dart';
import 'package:app_mobile/features/auth/presentation/view/login_view.dart';
import 'package:app_mobile/features/auth/presentation/view/register_view.dart';
import 'package:app_mobile/features/cart/domain/di/cart_di.dart';
import 'package:app_mobile/features/cart/presentation/view/cart_view.dart';
import 'package:app_mobile/features/categories/domain/di/categories_di.dart';
import 'package:app_mobile/features/categories/presentation/view/category_products_view.dart';
import 'package:app_mobile/features/change_language/presentation/view/change_language_view.dart';
import 'package:app_mobile/features/change_password/presentation/view/change_password_view.dart';
import 'package:app_mobile/features/contact_us/presentation/view/contact_us_view.dart';
import 'package:app_mobile/features/done_reset_pass/presintaion/view/done_reset_pass_view.dart';
import 'package:app_mobile/features/forget_password/presentation/view/forget_pass_view.dart';
import 'package:app_mobile/features/main/presentation/view/main_view.dart';
import 'package:app_mobile/features/options/presintaion/view/options_view.dart';
import 'package:app_mobile/features/orders/domain/di/orders_di.dart';
import 'package:app_mobile/features/orders/presentation/view/order_details_view.dart';
import 'package:app_mobile/features/orders/presentation/view/orders_view.dart';
import 'package:app_mobile/features/otp_register/presentation/view/otp_register_view.dart';
import 'package:app_mobile/features/product_details/domain/di/di.dart';
import 'package:app_mobile/features/product_details/presentation/view/add_rate_view.dart';
import 'package:app_mobile/features/product_details/presentation/view/product_details_view.dart';
import 'package:app_mobile/features/products/domain/di/di.dart';
import 'package:app_mobile/features/products/presentation/view/products_view.dart';
import 'package:app_mobile/features/reset_password/presentation/view/reset_password_view.dart';
import 'package:app_mobile/features/reset_password/presentation/view/otp_reset_password.dart';
import 'package:app_mobile/features/search/presentation/view/search_view.dart';
import 'package:app_mobile/features/security/presentation/view/security_view.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/features/terms/domain/di/terms_di.dart';
import 'package:app_mobile/features/terms/presentation/view/terms_view.dart';
import 'package:app_mobile/features/welcome/presentaion/view/welcome_view.dart';

import '../../constants/di/dependency_injection.dart';
import '../../features/favorite/presentation/view/favorite_view.dart';
import '../../features/home/presentation/view/home_view.dart';
import '../../features/main/presentation/view/user_management_screen.dart';
import '../../features/notifications/presentation/view/notifications _view_admin.dart';
import '../../features/notifications/presentation/view/notifications_view.dart';
import '../../features/outboarding/presentation/view/screen/out_boarding_view.dart';
import '../../features/profile/presentation/view/profile_view.dart';
import '../../features/profile/presentation/view/uploadp_profile_image_view.dart';
import '../../features/security/presentation/view/widgets/activity_logs_view.dart';
import '../../features/splash/presentation/view/splash_view.dart';

class Routes {
  static const String splashView = '/splash_view';
  static const String activity = '/activity';
  static const String uploadProfileImageView = '/upload_profile_image';
  static const String outBoarding = '/outBoarding_view';
  static const String login = '/login_view';
  static const String register = '/register_view';
  static const String home = '/home_view';
  static const String forgetPassword = '/forgetPassword';
  static const String verification = '/verification_view';
  static const String main = '/main_view';
  static const String setting = '/setting_view';
  static const String search = '/search_view';
  static const String editProfile = '/editProfile';
  static const String changePassword = '/changePassword';
  static const String changeLanguage = '/changeLanguage';
  static const String resetPassword = '/resetPassword';
  static const String otpResetPassword = '/otpResetPassword';
  static const String localeView = '/locale_view';
  static const String notifications = '/notifications';
  static const String otpRegister = '/otp_register';
  static const String options = '/options';
  static const String welcome = '/welcome';
  static const String doneReset = '/done_reset';
  static const String orders = '/orders';
  static const String orderDetails = '/orderDetails';
  static const String addresses = '/addresses';
  static const String addAddress = '/addAddress';
  static const String editAddress = '/editAddress';
  static const String terms = '/terms';
  static const String cart = '/cart';
  static const String categoryProducts = '/categoryProducts';
  static const String productDetails = '/productDetails';
  static const String addRate = '/addRate';
  static const String products = '/products';
  static const String contactUs = '/contactUs';
  static const String security = '/security';
  static const String authChecker = '/authChecker';
  static const String userManagementScreen = '/userManagement';
  static const String favoriteView = '/favoriteView';
  static const String notificationsAdmin = '/notificationsAdmin';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashView:
        initSplash();
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.outBoarding:
        initOutBoarding();
        return MaterialPageRoute(builder: (_) => const OutBoardingView());
      case Routes.login:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.register:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case Routes.forgetPassword:
        initForgetPassword();
        return MaterialPageRoute(builder: (_) => ForgetPassView());
      case Routes.main:
        initMain();
        return MaterialPageRoute(builder: (_) => const MainView());
        case Routes.notificationsAdmin:
        return MaterialPageRoute(builder: (_) => const NotificationsAdminView());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchView());
      case Routes.resetPassword:
        initResetPasswordModule();
        return MaterialPageRoute(builder: (_) => ResetPasswordView());
      case Routes.otpResetPassword:
        initResetPasswordModule();
        return MaterialPageRoute(builder: (_) => OTPResetPasswordView());
      case Routes.otpRegister:
        initResetPasswordModule();
        initOtpRegisterModule();
        return MaterialPageRoute(builder: (_) => OtpRegisterView());
      case Routes.options:
        initOptions();
        return MaterialPageRoute(builder: (_) => OptionsView());
      case Routes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
      case Routes.doneReset:
        return MaterialPageRoute(builder: (_) => const DoneResetPassView());
      case Routes.notifications:
        initNotifications();
        return MaterialPageRoute(builder: (_) => const NotificationsView());
      case Routes.orders:
        initOrders();
        return MaterialPageRoute(builder: (_) => const OrdersView());
      case Routes.orderDetails:
        initOrderDetails();
        return MaterialPageRoute(builder: (_) => const OrderDetailsView());
      case Routes.addresses:
        initAddresses();
        return MaterialPageRoute(builder: (_) => const AddressesView(),  );
      case Routes.addAddress:
        initAddAddress();
        return MaterialPageRoute(builder: (_) => const AddAddressView());
      case Routes.editAddress:
        initEditAddress();
        return MaterialPageRoute(builder: (_) => const EditAddressView());
      case Routes.terms:
        initTerms();
        return MaterialPageRoute(builder: (_) => const TermsView());
      case Routes.cart:
        initCart();
        return MaterialPageRoute(builder: (_) => const CartView());
      case Routes.categoryProducts:
        initCategoryProducts();
        return MaterialPageRoute(builder: (_) => const CategoryProductsView());
      case Routes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordView());
      case Routes.changeLanguage:
        return MaterialPageRoute(builder: (_) => const ChangeLanguageView());
      case Routes.productDetails:
        initProductDetails();
        return MaterialPageRoute(
          builder: (_) => const ProductDetailsView(),
        );
      case Routes.addRate:
        initAddRate();
        return MaterialPageRoute(builder: (_) => const AddRateView());
      case Routes.products:
        initProducts();
        return MaterialPageRoute(builder: (_) => const ProductsView( title: '',));
      case Routes.contactUs:
        return MaterialPageRoute(builder: (_) => const ContactUsView());
      case Routes.security:
        return MaterialPageRoute(builder: (_) => const SecurityView());
        case Routes.activity:
        return MaterialPageRoute(builder: (_) => const ActivityLogsTabsView());
      case Routes.home:
        initHome();
        return MaterialPageRoute(builder: (_) => const HomeView());
        case Routes.userManagementScreen:
        return MaterialPageRoute(builder: (_) => const UserManagementScreen());
            case Routes.favoriteView:
        return MaterialPageRoute(builder: (_) => const FavoriteView());
      case Routes.editProfile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
        case Routes.uploadProfileImageView:
        return MaterialPageRoute(builder: (_) => const UploadProfileImageView());
      default:
        return unDefinedRoute();
    }
  }

  // If PushNamed Failed Return This Page With No Actions
  // This Screen Will Tell The User This Page Is Not Exist
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(ManagerStrings.noRouteFound),
        ),
        body: Center(
          child: Text(ManagerStrings.noRouteFound),
        ),
      ),
    );
  }
}
