import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/core/widgets/text_field.dart';
import 'package:app_mobile/core/validator/validator.dart';
import 'package:app_mobile/core/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/service/notifications_service.dart';
import '../widget/footer_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _validator = FieldValidator();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final supabase = Supabase.instance.client;

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
              child: SvgPicture.asset(ManagerImages.background, fit: BoxFit.cover),
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
                        ManagerStrings.createYourAccount,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s32,
                          color: ManagerColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h26),

                    Text(ManagerStrings.fullName, style: _labelStyle()),
                    SizedBox(height: ManagerHeight.h8),
                    textField(
                      hintText: ManagerStrings.fullName,
                      controller: _nameController,
                      validator: (value) => _validator.validateFullName(value ?? ''),
                    ),
                    SizedBox(height: ManagerHeight.h16),

                    Text(ManagerStrings.email, style: _labelStyle()),
                    SizedBox(height: ManagerHeight.h8),
                    textField(
                      hintText: "example@gmail.com",
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) => _validator.validateEmail(value ?? ''),
                    ),
                    SizedBox(height: ManagerHeight.h16),

                    Text(ManagerStrings.phone, style: _labelStyle()),
                    SizedBox(height: ManagerHeight.h8),
                    textField(
                      hintText: "05xxxxxxxx",
                      controller: _phoneController,
                      textInputType: TextInputType.phone,
                      validator: (value) => _validator.validatePhoneNumber(value ?? ''),
                    ),
                    SizedBox(height: ManagerHeight.h16),

                    Text(ManagerStrings.password, style: _labelStyle()),
                    SizedBox(height: ManagerHeight.h8),
                    textField(
                      hintText: "********",
                      controller: _passwordController,
                      obSecure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? ManagerIcons.visibilityOff : ManagerIcons.visibility,
                          color: ManagerColors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) => _validator.validatePassword(value ?? ''),
                    ),
                    SizedBox(height: ManagerHeight.h16),

                    Text(ManagerStrings.confirmPassword, style: _labelStyle()),
                    SizedBox(height: ManagerHeight.h8),
                    textField(
                      hintText: "********",
                      controller: _confirmPasswordController,
                      obSecure: _obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? ManagerIcons.visibilityOff : ManagerIcons.visibility,
                          color: ManagerColors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                      validator: (value) => _validator.confirmPassword(
                        _passwordController.text,
                        value ?? '',
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h20),

                    SizedBox(
                      width: double.infinity,
                      height: ManagerHeight.h48,
                      child: mainButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final response = await supabase.auth.signUp(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );

                              final user = response.user;
                              if (user != null) {
                                await supabase.from('users').insert({
                                  'id': user.id,
                                  'email': _emailController.text.trim(),
                                  'full_name': _nameController.text.trim(),
                                  'phone': _phoneController.text.trim(),
                                  'password': _passwordController.text.trim(),
                                  'is_wholesaler': false,
                                  'role': 'user',
                                });

                                Get.snackbar(ManagerStrings.success, ManagerStrings.accountCreatedSuccessfully);
                                Get.offAllNamed(Routes.login);
                                await addNotification(
                                  title: 'انشاء حساب',
                                  description: 'تم انشاء حساب جديد بنجاح',
                                );

                              } else {
                                Get.snackbar(ManagerStrings.error, ManagerStrings.errorlogin);
                              }
                            } catch (e) {
                              Get.snackbar(ManagerStrings.registerFailed, e.toString());
                            }
                          }
                        },


                        buttonName: ManagerStrings.login,
                      ),
                    ),



                    SizedBox(height: ManagerHeight.h30),
                    FooterAuth(
                      text: ManagerStrings.doYouHaveAnAccount,
                      buttonName: ManagerStrings.login,
                      onPressed: () => Get.toNamed(Routes.login),
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

  TextStyle _labelStyle() {
    return getRegularTextStyle(
      fontSize: ManagerFontSize.s14,
      color: ManagerColors.grey,
    );
  }
}
