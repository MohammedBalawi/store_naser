// lib/features/profile/presentation/view/profile_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/profile_controller.dart';

class _C {
  static const bg = Color(0xFFF7F7FA);
  static const card = Colors.white;
  static const divider = Color(0xFFEDEDED);
  static const purple = Color(0xFF8E5AD7);
  static const muted = Color(0xFF717171);
}

// اللوجو الدائري البنفسجي (مطابق للصور)
class _LayeredBag extends StatelessWidget {
  const _LayeredBag({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      alignment: Alignment.center,
      child: Image.asset(ManagerImages.loge, width: 150, height: 150),
    );
  }
}

class _FlagGlyph extends StatelessWidget {
  final String asset; // svg or png asset path
  const _FlagGlyph({required this.asset, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE4E4E7), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: asset.toLowerCase().endsWith('.svg')
          ? SvgPicture.asset(asset, fit: BoxFit.cover)
          : Image.asset(asset, fit: BoxFit.cover),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    super.key,
    required this.label,
    required this.rightIcon,
    this.rightIconColor,
    required this.leftGlyph,
    this.onTap,
    required this.color,
  });

  final String label;
  final String rightIcon;
  final Color? rightIconColor;
  final Color color;
  final Widget leftGlyph;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            SvgPicture.asset(
              rightIcon,
              width: 26,
              height: 26,
              colorFilter: rightIconColor != null
                  ? ColorFilter.mode(rightIconColor!, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: getRegularTextStyle(
                  fontSize: 18,
                  color: color!,
                ),
              ),
            ),
            const SizedBox(width: 8),
            leftGlyph,
          ],
        ),
      ),
    );
  }
}

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _C.bg,
        body: SafeArea(
          child: GetBuilder<ProfileController>(
            builder: (_) {
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  const SizedBox(height: 6),
                  const Center(child: _LayeredBag()),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'إيـليـك',//Eilik
                      style: getBoldTextStyle(
                        fontSize: 20,
                        color: ManagerColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _C.card,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() {
                      if (!controller.isLoggedIn.value) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: controller.onSignupTap,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(ManagerImages.add_parson),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'تسجيل حساب جديد',
                                        style: getRegularTextStyle(
                                          fontSize: 18,
                                          color: ManagerColors.greens,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset(ManagerImages.arrow_left),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: _C.divider),
                            InkWell(
                              onTap: controller.onSigninTap,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(ManagerImages.login_2),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'تسجيل الدخول',
                                        style: getRegularTextStyle(
                                          fontSize: 18,
                                          color: ManagerColors.color,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset(ManagerImages.arrow_left),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          _MenuTile(
                            label: 'تعديل الحساب',
                            color: ManagerColors.color,
                            rightIcon: ManagerImages.edit_profile,
                            leftGlyph: SvgPicture.asset(
                              ManagerImages.arrow_left,
                              // color: ManagerColors.color,
                            ),
                            onTap: controller.onEditAccount,
                          ),
                          // const Divider(height: 1, color: _C.divider),
                          _MenuTile(
                            label: 'عنـاويني',
                            color: ManagerColors.greens,
                            rightIcon: ManagerImages.location,
                            leftGlyph: SvgPicture.asset(
                              ManagerImages.arrow_left,
                              // color: ManagerColors.greens,
                            ),
                            onTap: controller.onAddresses,
                          ),
                          // const Divider(height: 1, color: _C.divider),
                          _MenuTile(
                            label: 'طلباتي',
                            color: ManagerColors.blou,
                            rightIcon: ManagerImages.order,
                            leftGlyph: SvgPicture.asset(
                              ManagerImages.arrow_left,
                              // color: ManagerColors.blou,
                            ),
                            onTap: controller.onOrders,
                          ),
                          // const Divider(height: 1, color: _C.divider),
                          _MenuTile(
                            label: 'الرصيد',
                            color: ManagerColors.yolo,
                            rightIcon: ManagerImages.wallet,
                            leftGlyph: SvgPicture.asset(
                              ManagerImages.arrow_left,
                              // color: ManagerColors.yolo,
                            ),
                            onTap: controller.onWallet,
                          ),
                          // const Divider(height: 1, color: _C.divider),
                          _MenuTile(
                            label: 'المفضلة',
                            color: ManagerColors.like,
                            rightIcon: ManagerImages.love,
                            leftGlyph: SvgPicture.asset(ManagerImages.arrow_left),
                            onTap: controller.onFavorites,
                          ),
                        ],
                      );
                    }),
                  ),

                  const SizedBox(height: 14),

                  // الكرت السفلي (عام)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _C.card,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        // البلد واللغة — العلم ديناميكي من الكنترولر
                        _MenuTile(
                          label: 'البلد واللغة',
                          color: ManagerColors.black,

                          rightIcon: ManagerImages.country,
                          leftGlyph: Obx(
                                () => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _FlagGlyph(asset: controller.currentFlagAsset),

                                const SizedBox(width: 8),
                                SvgPicture.asset(ManagerImages.arrow_left),
                              ],
                            ),
                          ),
                          onTap: controller.onCountryLanguage,
                        ),

                        // const Divider(height: 1, color: _C.divider),
                        _MenuTile(
                          label: 'المساعدة',
                          color: ManagerColors.black,

                          rightIcon: ManagerImages.help,
                          leftGlyph: SvgPicture.asset(ManagerImages.arrow_left),
                          onTap: controller.onHelp,
                        ),
                        // const Divider(height: 1, color: _C.divider),
                        _MenuTile(
                          label: 'يدعم',
                          color: ManagerColors.black,

                          rightIcon: ManagerImages.regster,
                          leftGlyph: SvgPicture.asset(ManagerImages.arrow_left),
                          onTap: controller.onSupport,
                        ),
                        // const Divider(height: 1, color: _C.divider),
                        _MenuTile(
                          label: 'حول التطبيق',
                          color: ManagerColors.black,

                          rightIcon: ManagerImages.us,
                          leftGlyph: SvgPicture.asset(ManagerImages.arrow_left),
                          onTap: controller.onAbout,
                        ),
                        // const Divider(height: 1, color: _C.divider),
                        Obx(
                              () => Visibility(
                            visible: controller.isLoggedIn.value,
                            child: _MenuTile(
                              label: 'تسجيل الخروج',
                              color: ManagerColors.black,
                              rightIcon: ManagerImages.logout,
                              rightIconColor: ManagerColors.like,
                              leftGlyph:
                              SvgPicture.asset(ManagerImages.arrow_left),
                              onTap: () => controller.confirmLogout(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // الفوتر
                  Column(
                    children: [
                      Text(
                        'جميع الحقوق محفوظة للتطبيق ${controller.footerYear}',
                        style: getRegularTextStyle(
                          fontSize: 14,
                          color: ManagerColors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'VAT No.${controller.vatNo}  CR No.${controller.crNo}',
                        style: getRegularTextStyle(
                          fontSize: 14,
                          color: ManagerColors.bongrey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'الإصدار ${controller.version}',
                        style: getRegularTextStyle(
                          fontSize: 14,
                          color: ManagerColors.bongrey,
                        ),
                      ),
                      const SizedBox(height: 30),

                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
