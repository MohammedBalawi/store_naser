import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_images.dart';
import '../controller/change_language_controller.dart';

class ChangeLanguageCountryView extends StatelessWidget {
  const ChangeLanguageCountryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountryLanguageController>(
      init: CountryLanguageController(),
      builder: (c) {
        return Scaffold(
          backgroundColor: ManagerColors.background,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset(ManagerImages.arrows)),
                Text('البلد واللغة',
                    style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
                SizedBox(width: 30,),
              ],
            ),
            leadingWidth: 0,
            automaticallyImplyLeading: false,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ManagerWidth.w20,
                    vertical: ManagerHeight.h14,
                  ),
                  children: [
                    // عنوان داخلي مثل الصور
                    Text(
                      'البلد واللغة',
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s18,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h20),

                    // تبويبات اللغات (عربي / English)
                    Row(
                      children: [
                        Expanded(
                          child: _LangTab(
                            text: 'English',
                            isSelected: c.language == 'en',
                            onTap: () => c.selectLanguage(context, 'en'),
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w16),

                        Expanded(
                          child: _LangTab(
                            text: 'العربية',
                            isSelected: c.language == 'ar',
                            onTap: () => c.selectLanguage(context, 'ar'),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: ManagerHeight.h20),

                    // قائمة الدول
                    ...c.countries.map((country) {
                      final isSelected = c.selectedCountry == country.code;
                      return Padding(
                        padding: EdgeInsets.only(bottom: ManagerHeight.h12),
                        child: _CountryTile(
                          title: c.language == 'ar'
                              ? country.nameAr
                              : country.nameEn,
                          flagAsset: country.flag,
                          selected: isSelected,
                          onTap: () => c.selectCountry(country.code),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              // زر "تم"
              SafeArea(
                top: false,
                minimum: EdgeInsets.all(ManagerWidth.w20),
                child: SizedBox(
                  width: double.infinity,
                  height: ManagerHeight.h56,
                  child: ElevatedButton(
                    onPressed: c.canSubmit
                        ? () {
                      c.submit();
                      // بعد التنفيذ رجّع الزر غير مفعّل
                      c.selectedCountry = null;
                      c.update();
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ManagerColors.color, // اللون الأساسي
                      disabledBackgroundColor:
                      ManagerColors.color.withOpacity(0.35), // اللون المعطّل
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تم',
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.white,
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        );
      },
    );
  }
}

/// تبويب لغة بشكل كبسّة بحواف مستديرة وحدود بنفسجية عند التحديد
class _LangTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const _LangTab({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: ManagerHeight.h48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color
              : ManagerColors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: ManagerColors.greyAccent,
            width: .2,
          ),
        ),
        child: Text(
          text,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s16,
            color: isSelected ? ManagerColors.color : ManagerColors.black,
          ),
        ),
      ),
    );
  }
}

/// عنصر الدولة كما في الصور: حاوية بظل خفيف وحدود، وعند التحديد يصبح الحد بنفسجي واضح
class _CountryTile extends StatelessWidget {
  final String title;
  final String flagAsset;
  final bool selected;
  final VoidCallback onTap;

  const _CountryTile({
    required this.title,
    required this.flagAsset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ManagerColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Container(
          height: ManagerHeight.h56,
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: selected ? ManagerColors.color : ManagerColors.greyAccent,
              width: selected ? 1.6 : .2,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                flagAsset,
                height: 24,
                width: 32,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Text(
                  title,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.black,
                  ),
                ),
              ),
              // العلم على اليمين مثل الصور

            ],
          ),
        ),
      ),
    );
  }
}
