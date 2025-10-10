// Core imports
import 'package:app_mobile/features/auth/data/repository/login_repository.dart';
import 'package:app_mobile/features/auth/presentation/controller/login_email_controller.dart';
import 'package:app_mobile/features/auth/presentation/controller/register_controller.dart';
import 'package:app_mobile/features/categories/domain/di/categories_di.dart';
import 'package:app_mobile/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:app_mobile/features/notifications/data/repository/notifications_repository.dart';
import 'package:app_mobile/features/notifications/domain/usecase/notifications_usecase.dart';
import 'package:app_mobile/features/notifications/presentation/controller/notifications_controller.dart';
import 'package:app_mobile/features/options/presintaion/controller/options_controller.dart';
import 'package:app_mobile/features/otp_register/data/data_souces/otp_register_remote_data_source.dart';
import 'package:app_mobile/features/otp_register/data/repoitory_impl/otp_register_repository_impl.dart';
import 'package:app_mobile/features/otp_register/domain/repositroy/otp_register_repositroy.dart';
import 'package:app_mobile/features/otp_register/domain/usecase/otp_register_use_case.dart';
import 'package:app_mobile/features/otp_register/presentation/controller/otp_register_controller.dart';
import 'package:app_mobile/features/main/presentation/controller/main_controller.dart';
import 'package:app_mobile/features/profile/domain/di/di.dart';
import 'package:app_mobile/features/reset_password/data/data_souces/reset_password_remote_data_source.dart';
import 'package:app_mobile/features/reset_password/data/repoitory_impl/reset_password_repository_impl.dart';
import 'package:app_mobile/features/reset_password/domain/repositroy/reset_password_repositroy.dart';
import 'package:app_mobile/features/reset_password/domain/usecase/reset_password_use_case.dart';
import 'package:app_mobile/features/search/presentation/controller/search_controller.dart';
import 'package:app_mobile/features/wallet/domain/repo/wallet_repo.dart' hide IWalletRepo;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_mobile/features/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/internet_checker/interent_checker.dart';
import '../../core/network/app_api.dart';
import '../../core/network/dio_factory.dart';
import '../../core/notifications/notification_helper.dart';
import '../../core/storage/hive/hive_session_box.dart';
import '../../core/storage/local/app_settings_prefs.dart';
import '../../features/about/presentation/controller/about_controller.dart';
import '../../features/account_edit/presentation/controller/account_edit_controller.dart';
import '../../features/account_edit/presentation/controller/birthdate_controller.dart';
import '../../features/account_edit/presentation/controller/change_phone_controller.dart';
import '../../features/account_edit/presentation/controller/edit_email_controller.dart';
import '../../features/account_edit/presentation/controller/edit_name_controller.dart';
import '../../features/account_edit/presentation/controller/gender_controller.dart';
import '../../features/account_edit/presentation/controller/height_controller.dart';
import '../../features/account_edit/presentation/controller/phone_otp_controller.dart';
import '../../features/account_edit/presentation/controller/skin_tone_controller.dart';
import '../../features/account_edit/presentation/controller/weight_controller.dart';
import '../../features/auth/data/data_source/login_data_source.dart';
import '../../features/auth/data/data_source/remote_data_source.dart';
import '../../features/auth/data/repository/register_repository_impl.dart';
import '../../features/auth/domain/repository/register_repository.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../features/auth/domain/usecase/register_usecase.dart';
import '../../features/auth/presentation/controller/login_controller.dart';
import '../../features/auth/presentation/controller/signup_controller.dart';
import '../../features/favorite/domain/di/favorite_di.dart';
import '../../features/forget_password/data/data_souces/remote_data_source.dart';
import '../../features/forget_password/data/repoitory_impl/forget_password_repository_impl.dart';
import '../../features/forget_password/domain/repositroy/forget_password_repositroy.dart';
import '../../features/forget_password/domain/usecase/forget_password_usecase.dart';
import '../../features/forget_password/presentation/controller/forget_pass_controller.dart';
import '../../features/help/presentation/controller/help_controller.dart';
import '../../features/home/presentation/controller/home_controller.dart';
import '../../features/outboarding/presentation/controller/out_boarding_controller.dart';
import '../../features/reset_password/presentation/controller/reset_password_controller.dart';
import '../../features/splash/presentation/controller/splash_controller.dart';
import '../../features/support/data/repo/support_repo_impl.dart';
import '../../features/support/presentation/controller/support_controller.dart';
import '../../features/support/presentation/controller/tickets_controller.dart';
import '../../features/wallet/presentation/controller/wallet_controller.dart';


final getIt = GetIt.instance;
final instance = GetIt.instance;

initModule() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initHive();


  // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   await Firebase.initializeApp();
  //   print(' Background Message: ${message.notification?.title}');
  // }
  await Supabase.initialize(
    url: 'https://hxtylnrbponinmhegpkt.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4dHlsbnJicG9uaW5taGVncGt0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgzNTg3NTQsImV4cCI6MjA2MzkzNDc1NH0.qnzV85EmT3237f-dtZRIupbOZ2hr6rz4wTmZW_skqgQ',
  );

  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  // FToastBuilder();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  await GetStorage.init();

  if (!GetIt.I.isRegistered<SharedPreferences>()) {
    instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  }

  if (!GetIt.I.isRegistered<AppSettingsPrefs>()) {
    instance.registerLazySingleton<AppSettingsPrefs>(
        () => AppSettingsPrefs(instance()));
  }
  // ToDo: remove this code
  AppSettingsPrefs _app = instance<AppSettingsPrefs>();
  var pref = await SharedPreferences.getInstance();
  pref.clear();

  AppSettingsPrefs _appSettings = instance<AppSettingsPrefs>();

  // ToDo: implement notifications
  // if (_appSettings.getEnableNotifications()) {
  //   // await initFirebaseNotification();
  // }

  if (!GetIt.I.isRegistered<NetworkInfo>()) {
    instance.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImp(InternetConnectionCheckerPlus()));
  }
  if (!GetIt.I.isRegistered<DioFactory>()) {
    instance.registerLazySingleton<DioFactory>(() => DioFactory());
  }
  Dio dio = await instance<DioFactory>().getDio();
  if (!GetIt.I.isRegistered<AppService>()) {
    instance.registerLazySingleton<AppService>(() => AppService(dio));
  }
}

initSplash() {
  Get.put<SplashController>(SplashController());
}

finishSplash() {
  Get.delete<SplashController>();
}

initOutBoarding() {
  finishSplash();
  Get.put<OutBoardingController>(OutBoardingController());
}

finishOutBoarding() {
  Get.delete<OutBoardingController>();
}

initLoginModule() async {
  finishSplash();
  finishOutBoarding();
  finishRegister();
  disposeResetPasswordModule();

  if (!GetIt.I.isRegistered<LoginRemoteDataSource>()) {
    instance.registerLazySingleton<LoginRemoteDataSource>(
        () => LoginRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<LoginRepository>()) {
    instance.registerLazySingleton<LoginRepository>(
        () => LoginRepoImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(
        () => LoginUseCase(instance<LoginRepository>()));
  }

  Get.put<LoginController>(LoginController());
}

finishLoginModule() async {
  if (GetIt.I.isRegistered<LoginRemoteDataSource>()) {
    instance.unregister<LoginRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<LoginRepository>()) {
    instance.unregister<LoginRepository>();
  }

  if (GetIt.I.isRegistered<LoginUseCase>()) {
    instance.unregister<LoginUseCase>();
  }

  Get.delete<LoginController>();
}

initRegisterModule() async {
  finishLoginModule();
  if (!GetIt.I.isRegistered<RemoteRegisterDataSource>()) {
    instance.registerLazySingleton<RemoteRegisterDataSource>(
        () => RemoteRegisterDateSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<RegisterRepository>()) {
    instance.registerLazySingleton<RegisterRepository>(
        () => RegisterRepoImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance.registerFactory<RegisterUseCase>(
        () => RegisterUseCase(instance<RegisterRepository>()));
  }

  Get.put<RegisterController>(RegisterController());
}

finishRegister() {
  if (GetIt.I.isRegistered<RemoteRegisterDataSource>()) {
    instance.unregister<RemoteRegisterDataSource>();
  }

  if (GetIt.I.isRegistered<RegisterRepository>()) {
    instance.unregister<RegisterRepository>();
  }

  if (GetIt.I.isRegistered<RegisterUseCase>()) {
    instance.unregister<RegisterUseCase>();
  }
  Get.delete<RegisterController>();
}

initForgetPassword() async {
  finishLoginModule();

  if (!GetIt.I.isRegistered<ForgetPasswordDataSource>()) {
    instance.registerLazySingleton<ForgetPasswordDataSource>(
        () => RemoteForgetPasswordDataSourceImpl(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<ForgetPasswordRepository>()) {
    instance.registerLazySingleton<ForgetPasswordRepository>(
        () => ForgetPasswordRepositoryImpl(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<ForgetPasswordUseCase>()) {
    instance.registerFactory<ForgetPasswordUseCase>(
      () => ForgetPasswordUseCase(
        instance<ForgetPasswordRepository>(),
      ),
    );
  }

  Get.put(ForgetPasswordController());
}

disposeForgetPassword() async {
  if (GetIt.I.isRegistered<ForgetPasswordDataSource>()) {
    instance.unregister<ForgetPasswordDataSource>();
  }

  if (GetIt.I.isRegistered<ForgetPasswordRepository>()) {
    instance.unregister<ForgetPasswordRepository>();
  }

  if (GetIt.I.isRegistered<ForgetPasswordUseCase>()) {
    instance.unregister<ForgetPasswordUseCase>();
  }
}

initResetPasswordModule() {
  if (!GetIt.I.isRegistered<ResetPasswordRemoteDataSource>()) {
    instance.registerLazySingleton<ResetPasswordRemoteDataSource>(
      () => RemoteResetPasswordRemoteDataSourceImpl(
        instance<AppService>(),
      ),
    );
  }

  if (!GetIt.I.isRegistered<ResetPasswordRepository>()) {
    instance.registerLazySingleton<ResetPasswordRepository>(
      () => ResetPasswordRepositoryImpl(
        instance<NetworkInfo>(),
        instance<ResetPasswordRemoteDataSource>(),
      ),
    );
  }

  if (!GetIt.I.isRegistered<ResetPasswordUseCase>()) {
    instance.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(
        instance<ResetPasswordRepository>(),
      ),
    );
  }
  Get.put<ResetPasswordController>(ResetPasswordController());
}

disposeResetPasswordModule() {
  disposeForgetPassword();
  if (GetIt.I.isRegistered<ResetPasswordRemoteDataSource>()) {
    instance.unregister<ResetPasswordRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<ResetPasswordRepository>()) {
    instance.unregister<ResetPasswordRepository>();
  }

  if (GetIt.I.isRegistered<ResetPasswordUseCase>()) {
    instance.unregister<ResetPasswordUseCase>();
  }

  Get.delete<ResetPasswordController>();
}

initMain() {
  initHome();
  initWishlist();
  finishLoginModule();
  initFavorite();
  initCategories();
  initProfile();
  initSearch();
  Get.put<MainController>(MainController());
}

finishMain() {
  Get.delete<MainController>();
  finishHome();
  disposeCategories();
  disposeProfile();
  disposeSearch();
  disposeFavorite();
}

initSearch() {
  Get.put(AppSearchController());
}

disposeSearch() {
  Get.delete<AppSearchController>();
}

initOtpRegisterModule() {
  if (!GetIt.I.isRegistered<OtpRegisterRemoteDataSource>()) {
    instance.registerLazySingleton<OtpRegisterRemoteDataSource>(
      () => OtpRegisterRemoteDataSourceImpl(
        instance<AppService>(),
      ),
    );
  }

  if (!GetIt.I.isRegistered<OtpRegisterRepositroy>()) {
    instance.registerLazySingleton<OtpRegisterRepositroy>(
      () => OtpRegisterRepositroyImpl(
        instance<NetworkInfo>(),
        instance<OtpRegisterRemoteDataSource>(),
      ),
    );
  }

  if (!GetIt.I.isRegistered<OtpRegisterUseCase>()) {
    instance.registerLazySingleton<OtpRegisterUseCase>(
      () => OtpRegisterUseCase(
        instance<OtpRegisterRepositroy>(),
      ),
    );
  }
  Get.put<OtpRegisterController>(OtpRegisterController());
}

disposeOtpRegisterModule() {
  disposeForgetPassword();
  if (GetIt.I.isRegistered<OtpRegisterRemoteDataSource>()) {
    instance.unregister<OtpRegisterRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<OtpRegisterRepositroy>()) {
    instance.unregister<OtpRegisterRepositroy>();
  }

  if (GetIt.I.isRegistered<OtpRegisterUseCase>()) {
    instance.unregister<OtpRegisterUseCase>();
  }

  Get.delete<OtpRegisterController>();
}

initHome() {
  Get.put<HomeController>(HomeController());
}

finishHome() {
  Get.delete<HomeController>();
}
initSignUp() {
  Get.put<SignUpController>(SignUpController());
}

finishSignUp() {
  Get.delete<SignUpController>();
}
initSignIn() {
  Get.put<LoginEmailController>(LoginEmailController());
}

finishSignIn() {
  Get.delete<LoginEmailController>();
}
initAccountEdit() {
  Get.put<AccountEditController>(AccountEditController());
}

finishAccountEdit() {
  Get.delete<AccountEditController>();
}
initEditName() {
  Get.put<EditNameController>(EditNameController());
}

finishEditName() {
  Get.delete<EditNameController>();
}
initEditEmail() {
  Get.put<EditEmailController>(EditEmailController());
}

finishEditEmail() {
  Get.delete<EditEmailController>();
}
initPhoneOtp() {
  Get.put<PhoneOtpController>(PhoneOtpController());
}

finishPhoneOtp() {
  Get.delete<PhoneOtpController>();
}
initChangePhone() {
  Get.put<ChangePhoneController>(ChangePhoneController());
}

finishPChangePhone() {
  Get.delete<ChangePhoneController>();
}
initGender() {
  Get.put<GenderController>(GenderController());
}

finishGender() {
  Get.delete<GenderController>();
}
initBirthdate() {
  Get.put<BirthdateController>(BirthdateController());
}

finishBirthdate() {
  Get.delete<BirthdateController>();
}
initWeight() {
  Get.put<WeightController>(WeightController());
}

finishWeight() {
  Get.delete<WeightController>();
}
initHeight() {
  Get.put<HeightController>(HeightController());
}

finishHeight() {
  Get.delete<HeightController>();
}
initSkinTone() {
  Get.put<SkinToneController>(SkinToneController());
}

finishSkinTone() {
  Get.delete<SkinToneController>();
}
initWallet() {
  Get.put<WalletController>(WalletController());
}

finishWallet() {
  Get.delete<WalletController>();
}
initHelp() {
  Get.put<HelpController>(HelpController());
}

finishHelp() {
  Get.delete<HelpController>();
}
initSupport() {
  Get.put<SupportController>(SupportController());
}

finishSupport() {
  Get.delete<SupportController>();
}

initTickets() {
  final repo = SupportRepoImpl();           // أو مرر نسخة الريبو الحقيقي (Dio/Supabase)
  Get.put<TicketsController>(TicketsController(repo));
}

finishTickets() {
  Get.delete<TicketsController>();
}
initAbout() {
  Get.put<AboutController>(AboutController());
}

finishAbout() {
  Get.delete<AboutController>();
}




initOptions() {
  Get.put<OptionsController>(OptionsController());
}

finishOptions() {
  Get.delete<OptionsController>();
}

initWishlist() {
  Get.put<WishlistController>(WishlistController());
}

finishWishlist() {
  Get.delete<WishlistController>();
}

initNotificationsRequest() async {
  if (!GetIt.I.isRegistered<NotificationsRemoteDataSource>()) {
    instance.registerLazySingleton<NotificationsRemoteDataSource>(
        () => NotificationsRemoteDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<NotificationsRepository>()) {
    instance.registerLazySingleton<NotificationsRepository>(
        () => NotificationsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<NotificationsUseCase>()) {
    instance.registerFactory<NotificationsUseCase>(
        () => NotificationsUseCase(instance<NotificationsRepository>()));
  }
}

disposeNotificationsRequest() {
  if (GetIt.I.isRegistered<NotificationsRemoteDataSource>()) {
    instance.unregister<NotificationsRemoteDataSource>();
  }

  if (GetIt.I.isRegistered<NotificationsRepository>()) {
    instance.unregister<NotificationsRepository>();
  }

  if (GetIt.I.isRegistered<NotificationsUseCase>()) {
    instance.unregister<NotificationsUseCase>();
  }
}

initNotifications() {
  Get.put(NotificationsController());
}

disposeNotifications() {
  Get.delete<NotificationsController>();
}

// initHomeRequest() async {
//   if (!GetIt.I.isRegistered<HomeRemoteDataSource>()) {
//     instance.registerLazySingleton<HomeRemoteDataSource>(
//         () => HomeRemoteDataSourceImplement(instance<AppService>()));
//   }
//
//   if (!GetIt.I.isRegistered<HomeRepository>()) {
//     instance.registerLazySingleton<HomeRepository>(
//         () => HomeRepositoryImplement(instance(), instance()));
//   }
//
//   if (!GetIt.I.isRegistered<HomeUseCase>()) {
//     instance.registerFactory<HomeUseCase>(
//         () => HomeUseCase(instance<HomeRepository>()));
//   }
// }

// disposeHomeRequest() {
//   if (GetIt.I.isRegistered<HomeRemoteDataSource>()) {
//     instance.unregister<HomeRemoteDataSource>();
//   }
//
//   if (GetIt.I.isRegistered<HomeRepository>()) {
//     instance.unregister<HomeRepository>();
//   }
//
//   if (GetIt.I.isRegistered<HomeUseCase>()) {
//     instance.unregister<HomeUseCase>();
//   }
// }

Future<void> initHive() async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(HiveSessionAdapter());
  }

  await Hive.openBox('authBox');
}

