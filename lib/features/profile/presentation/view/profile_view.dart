// lib/features/profile/presentation/view/profile_view.dart
import 'package:app_mobile/core/resources/manager_strings.dart';
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

class _LayeredBag extends StatelessWidget {
  const _LayeredBag({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      alignment: Alignment.center,
      child: Image.asset(ManagerImages.image_app, width: 150, height: 150),
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
                  color: color,
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
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
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
                    ManagerStrings.eilik,
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
                                      ManagerStrings.registerAccount,
                                      style: getRegularTextStyle(
                                        fontSize: 18,
                                        color: ManagerColors.greens,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    isArabic?
                                    ManagerImages.arrow_left:
                                    ManagerImages.arrow_en,
                                    // color: ManagerColors.color,
                                  ),
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
                                      ManagerStrings.login,

                                      style: getRegularTextStyle(
                                        fontSize: 18,
                                        color: ManagerColors.color,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    isArabic?
                                    ManagerImages.arrow_left:
                                    ManagerImages.arrow_en,
                                    // color: ManagerColors.color,
                                  ),

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
                          label: ManagerStrings.editAccount,
                          color: ManagerColors.color,
                          rightIcon: ManagerImages.edit_profile,
                          leftGlyph: SvgPicture.asset(
                            isArabic?
                            ManagerImages.arrow_left:
                              ManagerImages.arrow_en,
                            // color: ManagerColors.color,
                          ),
                          onTap: controller.onEditAccount,
                        ),
                        // const Divider(height: 1, color: _C.divider),
                        _MenuTile(
                          label: ManagerStrings.myAddresses,
                          color: ManagerColors.greens,
                          rightIcon: ManagerImages.location,
                          leftGlyph:  SvgPicture.asset(
                            isArabic?
                            ManagerImages.arrow_left:
                            ManagerImages.arrow_en,
                            // color: ManagerColors.color,
                          ),
                          onTap: controller.onAddresses,
                        ),
                        // const Divider(height: 1, color: _C.divider),
                        _MenuTile(
                          label:ManagerStrings.myOrders ,
                          color: ManagerColors.blou,
                          rightIcon: ManagerImages.order,
                          leftGlyph: SvgPicture.asset(
                            isArabic?
                            ManagerImages.arrow_left:
                            ManagerImages.arrow_en,
                            // color: ManagerColors.color,
                          ),
                          onTap: controller.onOrders,
                        ),
                        // const Divider(height: 1, color: _C.divider),
                        _MenuTile(
                          label: ManagerStrings.balance,
                          color: ManagerColors.yolo,
                          rightIcon: ManagerImages.wallet,
                          leftGlyph: SvgPicture.asset(
                            isArabic?
                            ManagerImages.arrow_left:
                            ManagerImages.arrow_en,
                            // color: ManagerColors.color,
                          ),
                          onTap: controller.onWallet,
                        ),
                        // const Divider(height: 1, color: _C.divider),
                        _MenuTile(
                          label: ManagerStrings.favourites,
                          color: ManagerColors.like,
                          rightIcon: ManagerImages.love,
                          leftGlyph:  SvgPicture.asset(
                            isArabic?
                            ManagerImages.arrow_left:
                            ManagerImages.arrow_en,
                            // color: ManagerColors.color,
                          ),
                          onTap: controller.onFavorites,
                        ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 14),

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
                      _MenuTile(
                        label: ManagerStrings.countryAndLanguage,
                        color: ManagerColors.black,

                        rightIcon: ManagerImages.country,
                        leftGlyph: Obx(
                              () => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _FlagGlyph(asset: controller.currentFlagAsset),

                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                isArabic?
                                ManagerImages.arrow_left:
                                ManagerImages.arrow_en,
                                // color: ManagerColors.color,
                              ),
                            ],
                          ),
                        ),
                        onTap: controller.onCountryLanguage,
                      ),

                      _MenuTile(
                        label: ManagerStrings.help,
                        color: ManagerColors.black,

                        rightIcon: ManagerImages.help,
                        leftGlyph:  SvgPicture.asset(
                          isArabic?
                          ManagerImages.arrow_left:
                          ManagerImages.arrow_en,
                          // color: ManagerColors.color,
                        ),
                        onTap: controller.onHelp,
                      ),
                      // const Divider(height: 1, color: _C.divider),
                      _MenuTile(
                        label: ManagerStrings.support,
                        color: ManagerColors.black,

                        rightIcon: ManagerImages.regster,
                        leftGlyph:  SvgPicture.asset(
                          isArabic?
                          ManagerImages.arrow_left:
                          ManagerImages.arrow_en,
                          // color: ManagerColors.color,
                        ),
                        onTap: controller.onSupport,
                      ),
                      // const Divider(height: 1, color: _C.divider),
                      _MenuTile(
                        label: ManagerStrings.aboutApp,
                        color: ManagerColors.black,

                        rightIcon: ManagerImages.us,
                        leftGlyph:  SvgPicture.asset(
                          isArabic?
                          ManagerImages.arrow_left:
                          ManagerImages.arrow_en,
                          // color: ManagerColors.color,
                        ),
                        onTap: controller.onAbout,
                      ),
                      // const Divider(height: 1, color: _C.divider),
                      Obx(
                            () => Visibility(
                          visible: controller.isLoggedIn.value,
                          child: _MenuTile(
                            label: ManagerStrings.logout,
                            color: ManagerColors.black,
                            rightIcon: ManagerImages.logout,
                            rightIconColor: ManagerColors.like,
                            leftGlyph:
                            SvgPicture.asset(
                              isArabic?
                              ManagerImages.arrow_left:
                              ManagerImages.arrow_en,
                              // color: ManagerColors.color,
                            ),
                            onTap: () => controller.confirmLogout(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Column(
                  children: [
                    Text(
                  ManagerStrings.supVersion,
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
                      '${ManagerStrings.version} ${controller.version}',
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
    );
  }
}
