import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_icons.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/service/notifications_service.dart';
import '../../../../core/validator/validator.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/text_field.dart';
import '../widget/footer_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FieldValidator _validator = FieldValidator();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final supabase = Supabase.instance.client;

  Future<void> saveSessionToHive(String accessToken, String refreshToken) async {
    final box = await Hive.openBox('authBox');
    await box.put('access_token', accessToken);
    await box.put('refresh_token', refreshToken);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.session != null) {
        final token = response.session!.accessToken;
        final refreshToken = response.session!.refreshToken;
        await saveSessionToHive(token, refreshToken!);

        Get.snackbar(ManagerStrings.success, ManagerStrings.loginSuccessfully);
        Get.offAllNamed(Routes.main);
        await addNotification(
          title: 'تسجيل الدخول',
          description: 'تم تسجيل الدخول إلى حسابك بنجاح',
        );

      } else {
        Get.snackbar(ManagerStrings.error, ManagerStrings.errorlogin);
      }
    } catch (e) {
      Get.snackbar(ManagerStrings.error, ManagerStrings.errorlogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              height: ManagerHeight.h260,
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset(
                ManagerImages.background,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w20,
              vertical: ManagerHeight.h4,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ManagerHeight.h130),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        ManagerStrings.loginToYourAccount,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s32,
                          color: ManagerColors.black,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        ManagerStrings.enterEmailAndPassword,
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h26),
                    Text(
                      ManagerStrings.email,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.grey,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    textField(
                      hintText: ManagerStrings.email,
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                      obSecure: false,
                      validator: (value) => _validator.validateEmail(value ?? ''),
                    ),
                    SizedBox(height: ManagerHeight.h20),
                    Text(
                      ManagerStrings.password,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.grey,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    textField(
                      hintText: ManagerStrings.password,
                      textInputType: TextInputType.text,
                      obSecure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? ManagerIcons.visibilityOff
                              : ManagerIcons.visibility,
                          color: _obscurePassword
                              ? ManagerColors.grey
                              : ManagerColors.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      controller: _passwordController,
                      validator: (value) => _validator.validatePassword(value ?? ''),
                    ),
                    SizedBox(height: ManagerHeight.h6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.forgetPassword);
                        },
                        child: Text(
                          ManagerStrings.forgetPassword,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.forgotPasswordTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h20),
                    SizedBox(
                      width: double.infinity,
                      height: ManagerHeight.h48,
                      child: mainButton(
                        onPressed: _login,
                        buttonName: ManagerStrings.login,
                        isLoading: false,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h30),
                    FooterAuth(
                      text: ManagerStrings.footerLogin,
                      buttonName: ManagerStrings.createYourAccount,
                      onPressed: () => Get.offAllNamed(Routes.register),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear(); // نمسح أي حساب سابق
                          await prefs.setBool('is_guest', true); // نسجل كضيف
                          Get.offAllNamed(Routes.main); // ندخل على الصفحة الرئيسية
                        },
                        child: Text(
                          ManagerStrings.loginGuest,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.lightGreen,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
