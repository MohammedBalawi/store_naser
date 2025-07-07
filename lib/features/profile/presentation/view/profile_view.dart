// import 'dart:io';
//
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_icons.dart';
// import 'package:app_mobile/core/resources/manager_images.dart';
// import 'package:app_mobile/core/resources/manager_opacity.dart';
// import 'package:app_mobile/core/resources/manager_radius.dart';
// import 'package:app_mobile/core/resources/manager_strings.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/service/image_service.dart';
// import 'package:app_mobile/core/widgets/main_app_bar.dart';
// import 'package:app_mobile/core/widgets/main_button.dart';
// import 'package:app_mobile/features/profile/presentation/controller/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import '../../../../core/resources/manager_width.dart';
//
// class ProfileView extends StatelessWidget {
//   const ProfileView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: ManagerColors.scaffoldBackgroundColor,
//       appBar: mainAppBar(
//         title: ManagerStrings.myAccount,
//       ),
//       body: GetBuilder<ProfileController>(builder: (controller) {
//         return Stack(
//           children: [
//             ListView(
//               shrinkWrap: true,
//               children: [
//                 Stack(
//                   children: [
//                     Image.asset(
//                       ManagerImages.profileBackground,
//                       width: double.infinity,
//                       height: ManagerHeight.h120,
//                       fit: BoxFit.fill,
//                     ),
//                     Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: ManagerHeight.h12,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               GetBuilder<ProfileController>(
//                                 builder: (controller) {
//                                   return Stack(
//                                     alignment: Alignment.bottomRight,
//                                     children: [
//                                       GetBuilder<ProfileController>(
//                                         builder: (controller) {
//                                           return CircleAvatar(
//                                             radius: ManagerRadius.r50,
//                                             backgroundImage: controller.profileImageUrl != null &&
//                                                 controller.profileImageUrl!.isNotEmpty
//                                                 ? NetworkImage(controller.profileImageUrl!)
//                                                 : null,
//                                             backgroundColor: ManagerColors.pinkBackground,
//                                             child: (controller.profileImageUrl == null ||
//                                                 controller.profileImageUrl!.isEmpty)
//                                                 ? const Icon(Icons.person, size: 50, color: Colors.white)
//                                                 : null,
//                                           );
//                                         },
//                                       ),
//
//
//                                       Positioned(
//                                         bottom: 0,
//                                         right: 4,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             Get.toNamed('/upload_profile_image');
//                                           },
//                                           child: Container(
//                                             padding: const EdgeInsets.all(6),
//                                             decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: ManagerColors.primaryColor,
//                                             ),
//                                             child: const Icon(Icons.edit, color: Colors.white, size: 20),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               )
//
//
//
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: ManagerWidth.w12,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: ManagerHeight.h30,
//                               ),
//                               SizedBox(
//                                 width: ManagerWidth.w140,
//                                 child: mainButton(
//                                   radius: ManagerRadius.r24,
//                                   onPressed: () {
//                                     controller.share();
//                                   },
//                                   child: Row(
//                                     children: [
//                                       SvgPicture.asset(
//                                         ManagerImages.share,
//                                       ),
//                                       SizedBox(
//                                         width: ManagerWidth.w10,
//                                       ),
//                                       Text(
//                                         ManagerStrings.share,
//                                         style: getBoldTextStyle(
//                                           fontSize: ManagerFontSize.s16,
//                                           color: ManagerColors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: ManagerHeight.h20,
//                               ),
//                               Text(
//                                 ManagerStrings.personalInfo,
//                                 style: getBoldTextStyle(
//                                   fontSize: ManagerFontSize.s18,
//                                   color: ManagerColors.black,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: ManagerHeight.h10,
//                               ),
//                               Text(
//                                 ManagerStrings.youCanChangeYourInfoHere,
//                                 style: getRegularTextStyle(
//                                   fontSize: ManagerFontSize.s14,
//                                   color: ManagerColors.black,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: ManagerHeight.h20,
//                               ),
//                               Container(
//                                 width: size.width > ManagerWidth.w500
//                                     ? ManagerWidth.w450
//                                     : size.width - ManagerWidth.w20,
//                                 decoration: BoxDecoration(
//                                   color: ManagerColors.white,
//                                   borderRadius: BorderRadius.circular(
//                                     ManagerRadius.r26,
//                                   ),
//                                   border: Border.all(
//                                     color: ManagerColors.greyAccent,
//                                     width: ManagerOpacity.op0_8,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: ManagerHeight.h12,
//                                     horizontal: ManagerWidth.w20,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         ManagerStrings.fullName,
//                                         style: getRegularTextStyle(
//                                           fontSize: ManagerFontSize.s14,
//                                           color: ManagerColors.lightBlack,
//                                         ),
//                                       ),
//                                       profileContainer(
//                                         value: controller.name,
//                                       ),
//                                       Text(
//                                         ManagerStrings.email,
//                                         style: getRegularTextStyle(
//                                           fontSize: ManagerFontSize.s14,
//                                           color: ManagerColors.lightBlack,
//                                         ),
//                                       ),
//                                       profileContainer(
//                                         value: controller.email,
//                                       ),
//                                       Text(
//                                         ManagerStrings.phone,
//                                         style: getRegularTextStyle(
//                                           fontSize: ManagerFontSize.s14,
//                                           color: ManagerColors.lightBlack,
//                                         ),
//                                       ),
//                                       profileContainer(
//                                         value: controller.phone,
//                                       ),
//
//
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             ManagerStrings.password,
//                                             style: getRegularTextStyle(
//                                               fontSize: ManagerFontSize.s14,
//                                               color: ManagerColors.lightBlack,
//                                             ),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               controller
//                                                   .navigateToChangePassword();
//                                             },
//                                             child: Text(
//                                               ManagerStrings.change,
//                                               style: getRegularTextStyle(
//                                                 fontSize: ManagerFontSize.s14,
//                                                 color: ManagerColors.lightBlack,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       profileContainer(
//                                         value: "*******",
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             ManagerStrings.appLocale,
//                                             style: getRegularTextStyle(
//                                               fontSize: ManagerFontSize.s14,
//                                               color: ManagerColors.lightBlack,
//                                             ),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               controller
//                                                   .navigateToChangeLanguage();
//                                             },
//                                             child: Text(
//                                               ManagerStrings.change,
//                                               style: getRegularTextStyle(
//                                                 fontSize: ManagerFontSize.s14,
//                                                 color: ManagerColors.lightBlack,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       profileContainer(
//                                         value: ManagerStrings.arabicLanguage,
//                                       ),
//                                       SizedBox(
//                                         height: ManagerHeight.h10,
//                                       ),
//                                       ElevatedButton(
//                                         onPressed: () => controller.updateUserProfile(),
//                                         child: const Text("حفظ التعديلات"),
//                                       )
//
//
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: ManagerHeight.h20,
//                               ),
//                               Text(
//                                 ManagerStrings.notifications,
//                                 style: getBoldTextStyle(
//                                   fontSize: ManagerFontSize.s18,
//                                   color: ManagerColors.black,
//                                 ),
//                               ),
//
//                               notificationTile(
//                                 title: ManagerStrings.voiceNotification,
//                                 body:
//                                     ManagerStrings.voiceNotificationDescription,
//                                 enabled: controller.notificationVoice,
//                                 onChanged: (value) {
//                                   // controller.changeNotificationVoice(
//                                   //   value: value,
//                                   // );
//                                 },
//                               ),
//                               SizedBox(
//                                 height: ManagerHeight.h10,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   controller.deleteAccount(context: context);
//                                 },
//                                 child: profileContainer(
//                                   centerRow: true,
//                                   color: ManagerColors.scaffoldBackgroundColor,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       SvgPicture.asset(
//                                         ManagerImages.drawerDeleteIcon,
//                                         width: ManagerWidth.w26,
//                                       ),
//                                       SizedBox(
//                                         width: ManagerWidth.w10,
//                                       ),
//                                       Text(
//                                         ManagerStrings.deleteAccount,
//                                         style: getRegularTextStyle(
//                                           fontSize: ManagerFontSize.s16,
//                                           color: ManagerColors.textColor,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: ManagerHeight.h60,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             )
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget notificationTile({
//     required String title,
//     required String body,
//     required bool enabled,
//     required onChanged,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: ManagerHeight.h12,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Checkbox(
//             value: enabled,
//             onChanged: onChanged,
//             activeColor: ManagerColors.purple,
//             side: BorderSide(
//               color: ManagerColors.grey,
//               width: ManagerOpacity.op0_9,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(
//                 ManagerRadius.r7,
//               ),
//               side: BorderSide(
//                 color: ManagerColors.grey,
//                 width: ManagerOpacity.op0_9,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: getBoldTextStyle(
//                     fontSize: ManagerFontSize.s18,
//                     color: ManagerColors.black,
//                   ),
//                 ),
//                 Text(
//                   body,
//                   style: getRegularTextStyle(
//                     fontSize: ManagerFontSize.s15,
//                     color: ManagerColors.blackAccent,
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget profileContainer({
//     Widget? child,
//     String? value,
//     bool centerRow = false,
//     Color? color,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: ManagerHeight.h12,
//       ),
//       child: Container(
//         height: ManagerHeight.h46,
//         decoration: BoxDecoration(
//           color: color ?? ManagerColors.white,
//           borderRadius: BorderRadius.circular(
//             ManagerRadius.r10,
//           ),
//           border: Border.all(
//             color: ManagerColors.greyAccent,
//             width: ManagerOpacity.op0_8,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: ManagerWidth.w8,
//           ),
//           child: Row(
//             mainAxisAlignment:
//                 centerRow ? MainAxisAlignment.center : MainAxisAlignment.start,
//             children: [
//               child ??
//                   Text(
//                     "$value",
//                     style: getMediumTextStyle(
//                       fontSize: ManagerFontSize.s16,
//                       color: ManagerColors.black,
//                     ),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/service/image_service.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/core/widgets/main_button.dart';
import 'package:app_mobile/features/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ManagerColors.scaffoldBackgroundColor,
      appBar: mainAppBar(
        title: ManagerStrings.myAccount,
      ),
      body: GetBuilder<ProfileController>(builder: (controller) {
        return Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      ManagerImages.profileBackground,
                      width: double.infinity,
                      height: ManagerHeight.h120,
                      fit: BoxFit.fill,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ManagerHeight.h12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: ManagerRadius.r50,
                                    backgroundImage: controller.profileImageUrl != null &&
                                        controller.profileImageUrl!.isNotEmpty
                                        ? NetworkImage(controller.profileImageUrl!)
                                        : null,
                                    backgroundColor: ManagerColors.pinkBackground,
                                    child: (controller.profileImageUrl == null ||
                                        controller.profileImageUrl!.isEmpty)
                                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed('/upload_profile_image');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ManagerColors.primaryColor,
                                        ),
                                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ManagerWidth.w12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ManagerHeight.h30),
                              SizedBox(
                                width: ManagerWidth.w140,
                                child: mainButton(
                                  radius: ManagerRadius.r24,
                                  onPressed: () => controller.share(),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(ManagerImages.share),
                                      SizedBox(width: ManagerWidth.w10),
                                      Text(
                                        ManagerStrings.share,
                                        style: getBoldTextStyle(
                                          fontSize:ManagerFontSize.s12,
                                          color: ManagerColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h20),
                              Text(
                                ManagerStrings.personalInfo,
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s18,
                                  color: ManagerColors.black,
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h10),
                              Text(
                                ManagerStrings.youCanChangeYourInfoHere,
                                style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s14,
                                  color: ManagerColors.black,
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h20),
                              Container(
                                width: size.width > ManagerWidth.w500
                                    ? ManagerWidth.w450
                                    : size.width - ManagerWidth.w20,
                                decoration: BoxDecoration(
                                  color: ManagerColors.white,
                                  borderRadius: BorderRadius.circular(ManagerRadius.r26),
                                  border: Border.all(
                                    color: ManagerColors.greyAccent,
                                    width: ManagerOpacity.op0_8,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: ManagerHeight.h12,
                                    horizontal: ManagerWidth.w20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ManagerStrings.fullName,
                                        style: getRegularTextStyle(
                                          fontSize: ManagerFontSize.s14,
                                          color: ManagerColors.lightBlack,
                                        ),
                                      ),
                                      profileContainerField(
                                        controller: controller.fullNameController,
                                        label: ManagerStrings.fullName,
                                      ),
                                      Text(
                                        ManagerStrings.email,
                                        style: getRegularTextStyle(
                                          fontSize: ManagerFontSize.s14,
                                          color: ManagerColors.lightBlack,
                                        ),
                                      ),
                                      profileContainer(
                                        value: controller.email,
                                      ),
                                      Text(
                                        ManagerStrings.phone,
                                        style: getRegularTextStyle(
                                          fontSize: ManagerFontSize.s14,
                                          color: ManagerColors.lightBlack,
                                        ),
                                      ),
                                      profileContainerField(
                                        controller: controller.phoneController,
                                        label: ManagerStrings.phone,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ManagerStrings.password,
                                            style: getRegularTextStyle(
                                              fontSize: ManagerFontSize.s14,
                                              color: ManagerColors.lightBlack,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => controller.navigateToChangePassword(),
                                            child: Text(
                                              ManagerStrings.change,
                                              style: getRegularTextStyle(
                                                fontSize: ManagerFontSize.s14,
                                                color: ManagerColors.lightBlack,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      profileContainer(value: "*******"),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ManagerStrings.appLocale,
                                            style: getRegularTextStyle(
                                              fontSize: ManagerFontSize.s14,
                                              color: ManagerColors.lightBlack,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => controller.navigateToChangeLanguage(),
                                            child: Text(
                                              ManagerStrings.change,
                                              style: getRegularTextStyle(
                                                fontSize: ManagerFontSize.s14,
                                                color: ManagerColors.lightBlack,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      profileContainer(value: ManagerStrings.arabicLanguage),
                                      SizedBox(height: ManagerHeight.h10),
                                      mainButton(
                                        onPressed: () => controller.updateUserProfile(),
                                        buttonName: ManagerStrings.saveEdit,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h20),
                              Text(
                                ManagerStrings.notifications,
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s18,
                                  color: ManagerColors.black,
                                ),
                              ),
                              notificationTile(
                                title: ManagerStrings.voiceNotification,
                                body: ManagerStrings.voiceNotificationDescription,
                                enabled: controller.notificationVoice,
                                onChanged: (value) {},
                              ),
                              SizedBox(height: ManagerHeight.h10),
                              GestureDetector(
                                onTap: () => controller.deleteAccount(context: context),
                                child: profileContainer(
                                  centerRow: true,
                                  color: ManagerColors.scaffoldBackgroundColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        ManagerImages.drawerDeleteIcon,
                                        width: ManagerWidth.w26,
                                      ),
                                      SizedBox(width: ManagerWidth.w10),
                                      Text(
                                        ManagerStrings.deleteAccount,
                                        style: getRegularTextStyle(
                                          fontSize: ManagerFontSize.s16,
                                          color: ManagerColors.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h60),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        );
      }),
    );
  }

  Widget notificationTile({
    required String title,
    required String body,
    required bool enabled,
    required onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: enabled,
            onChanged: onChanged,
            activeColor: ManagerColors.purple,
            side: BorderSide(
              color: ManagerColors.grey,
              width: ManagerOpacity.op0_9,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ManagerRadius.r7),
              side: BorderSide(
                color: ManagerColors.grey,
                width: ManagerOpacity.op0_9,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.black,
                  ),
                ),
                Text(
                  body,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s15,
                    color: ManagerColors.blackAccent,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profileContainer({
    Widget? child,
    String? value,
    bool centerRow = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
      child: Container(
        height: ManagerHeight.h46,
        decoration: BoxDecoration(
          color: color ?? ManagerColors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r10),
          border: Border.all(
            color: ManagerColors.greyAccent,
            width: ManagerOpacity.op0_8,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
          child: Row(
            mainAxisAlignment:
            centerRow ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              child ??
                  Text(
                    "$value",
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: ManagerColors.black,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileContainerField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
      child: Container(
        decoration: BoxDecoration(
          color: ManagerColors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r10),
          border: Border.all(
            color: ManagerColors.greyAccent,
            width: ManagerOpacity.op0_8,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
