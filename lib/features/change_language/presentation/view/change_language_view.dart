import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/features/change_language/presentation/controller/change_language_controller.dart';
import 'package:app_mobile/features/change_language/presentation/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/main_app_bar.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangeLanguageController>(
      init: ChangeLanguageController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ManagerColors.white,
          appBar: mainAppBar(
            title: ManagerStrings.changeAppLanguage,
          ),
          body: ListView(
            children: [
              SvgPicture.asset(
                ManagerImages.changeLanguage,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w20,
                  vertical: ManagerHeight.h14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ManagerStrings.changeAppLanguage,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s26,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(
                      height: ManagerHeight.h16,
                    ),
                    Text(
                      ManagerStrings.changeAppViewLanguage,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.grey,
                      ),
                    ),
                    SizedBox(
                      height: ManagerHeight.h16,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ManagerRadius.r10,
                        ),
                        border: Border.all(
                          color: ManagerColors.greyAccent,
                          width: ManagerWidth.w1,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: controller.language,
                        isExpanded: true,
                        icon: Icon(
                          ManagerIcons.dropDown,
                          color: ManagerColors.greyAccent,
                        ),
                        underline: const SizedBox(),
                        style: getRegularTextStyle(
                          color: ManagerColors.greyAccent,
                          fontSize: ManagerFontSize.s16,
                        ),
                        items: controller.languages
                            .map<DropdownMenuItem<String>>(
                                (LanguageModel model) {
                          return DropdownMenuItem<String>(
                            value: model.value,
                            child: Text(
                              model.title,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          controller.changeLocale(
                            context: context,
                            value: value.pareWithDefaultLocale(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    Get.delete<ChangeLanguageController>();
    super.dispose();
  }
}
