import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/addressess/presentation/view/add_address_view.dart';
import 'package:app_mobile/features/addressess/presentation/view/addresses_view.dart';
import 'package:app_mobile/features/auth/presentation/view/login_email_view.dart';
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
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../constants/di/dependency_injection.dart';
import '../../features/about/presentation/view/about_view.dart';
import '../../features/account_edit/presentation/controller/account_edit_controller.dart';
import '../../features/account_edit/presentation/controller/edit_name_controller.dart';
import '../../features/account_edit/presentation/view/account_edit_view.dart';
import '../../features/account_edit/presentation/view/birthdate_view.dart';
import '../../features/account_edit/presentation/view/change_phone_view.dart';
import '../../features/account_edit/presentation/view/edit_email_view.dart';
import '../../features/account_edit/presentation/view/edit_name_view.dart';
import '../../features/account_edit/presentation/view/edit_password_view.dart';
import '../../features/account_edit/presentation/view/gender_view.dart';
import '../../features/account_edit/presentation/view/height_view.dart';
import '../../features/account_edit/presentation/view/phone_otp_view.dart';
import '../../features/account_edit/presentation/view/skin_tone_view.dart';
import '../../features/account_edit/presentation/view/weight_view.dart';
import '../../features/auth/presentation/view/signup_view.dart';
import '../../features/favorite/presentation/view/favorite_view.dart';
import '../../features/help/presentation/view/help_view.dart';
import '../../features/home/presentation/view/home_view.dart';
import '../../features/main/presentation/view/user_management_screen.dart';
import '../../features/notifications/presentation/view/notifications _view_admin.dart';
import '../../features/notifications/presentation/view/notifications_view.dart';
import '../../features/outboarding/presentation/view/screen/out_boarding_view.dart';
import '../../features/profile/presentation/view/profile_view.dart';
import '../../features/reels/presentation/binding/reels_binding.dart';
import '../../features/reels/presentation/view/reels_view.dart';
import '../../features/security/presentation/view/widgets/activity_logs_view.dart';
import '../../features/splash/presentation/view/splash_view.dart';
import '../../features/support/presentation/view/open_ticket_view.dart';
import '../../features/support/presentation/view/support_view.dart';
import '../../features/support/presentation/view/tech_support_view.dart';
import '../../features/wallet/presentation/view/wallet_view.dart';

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
  static const reels = '/reels';
  static const signUp = '/signUp';
  static const login_email = '/login_email';
  static const accountEdit = '/accountEdit';
  static const editName = '/editName';
  static const phoneOtp = '/phoneOtp';
  static const changePhone = '/changePhone';
  static const gender = '/gender';
  static const birthdate = '/birthdate';
  static const weight = '/weight';
  static const height = '/height';
  static const skinTone = '/skinTone';
  static const wallet = '/wallet';
  static const changeEmail = '/changeEmail';
  static const help = '/help';
  static const support = '/support';
  static const supportTech = '/supportTech';
  static const openTicket = '/openTicket';
  static const about = '/about';
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
        initEditPassword();
        return MaterialPageRoute(builder: (_) => const EditPasswordView());
      case Routes.changeLanguage:
        initLanguageCountry();
        return MaterialPageRoute(builder: (_) => const ChangeLanguageCountryView());
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
        return MaterialPageRoute(builder: (_) =>  HomeView());
        case Routes.userManagementScreen:
        return MaterialPageRoute(builder: (_) => const UserManagementScreen());
            case Routes.favoriteView:
        return MaterialPageRoute(builder: (_) => const FavoriteView());
      case Routes.editProfile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
        case Routes.signUp:
          initSignUp();
        return MaterialPageRoute(builder: (_) => const SignUpView());
        case Routes.login_email:
          initSignIn();
        return MaterialPageRoute(builder: (_) => const LoginEmailView());
        case Routes.accountEdit:
          initAccountEdit();
        return MaterialPageRoute(builder: (_) => const AccountEditView());
        case Routes.editName:
          initEditName();
        return MaterialPageRoute(builder: (_) => const EditNameView());
        case Routes.changeEmail:
          initEditEmail();
        return MaterialPageRoute(builder: (_) => const EditEmailView());
        case Routes.phoneOtp:
          initPhoneOtp();
        return MaterialPageRoute(builder: (_) => const PhoneOtpView());
        case Routes.changePhone:
          initChangePhone();
        return MaterialPageRoute(builder: (_) => const ChangePhoneView());
        case Routes.gender:
          initGender();
        return MaterialPageRoute(builder: (_) => const GenderView());
        case Routes.birthdate:
          initBirthdate();
        return MaterialPageRoute(builder: (_) => const BirthdateView());
        case Routes.weight:
          initWeight();
        return MaterialPageRoute(builder: (_) => const WeightView());
        case Routes.height:
          initHeight();
        return MaterialPageRoute(builder: (_) => const HeightView());
        case Routes.skinTone:
          initSkinTone();
        return MaterialPageRoute(builder: (_) => const SkinToneView());
        case Routes.wallet:
          initWallet();
        return MaterialPageRoute(builder: (_) => const WalletView());
        case Routes.help:
          initHelp();
        return MaterialPageRoute(builder: (_) => const HelpView());
        case Routes.support:
          initSupport();
        return MaterialPageRoute(builder: (_) => const SupportView());
        case Routes.openTicket:
          initSupport();
        return MaterialPageRoute(builder: (_) => const OpenTicketView());
        case Routes.supportTech:
          initTickets();
        return MaterialPageRoute(builder: (_) => const TechSupportView());
        case Routes.about:
          initAbout();
        return MaterialPageRoute(builder: (_) => const AboutView());
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
  final List<GetPage> appPages = [
    GetPage(
      name: Routes.reels,
      page: () => const ReelsView(),
      binding: ReelsBinding(),
    ),
    GetPage(
      name: Routes.accountEdit,
      page: () => const AccountEditView(),
      binding: BindingsBuilder(() {
        Get.put(AccountEditController());
      }),
    ),
    GetPage(
      name: Routes.editName,
      page: () => const EditNameView(),
      binding: BindingsBuilder(() {
        Get.put(EditNameController());
      }),
    ),
    // ...
  ];

}
