import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/features/contact_us/presentation/controller/contact_us_controller.dart';
import 'package:app_mobile/features/contact_us/presentation/view/widgets/contact_info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/resources/manager_radius.dart';
import '../../../home/presentation/controller/home_controller.dart';
import 'contact_us_admin_view.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});


  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}
final HomeController homeController = Get.find<HomeController>();


class _ContactUsViewState extends State<ContactUsView> {
  bool isAdmin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkAdminStatus();
  }

  Future<void> checkAdminStatus() async {
    final HomeController homeController = Get.find<HomeController>();
    bool adminResult = await homeController.checkIfAdmin();
    setState(() {
      isAdmin = adminResult;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ContactUsController>(
      init: ContactUsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ManagerColors.white,
          appBar: mainAppBar(
            title: ManagerStrings.contactUs,
            actions: [
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.edit, color: ManagerColors.primaryColor),
                  onPressed: () async {
        final result = await Get.to(() => const ContactUsAdminView());
        if (result == true) {
        controller.fetchData();
        }
                  },
                ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator(
            color: ManagerColors.primaryColor,
          ))
              : Padding(
            padding: EdgeInsets.all(ManagerHeight.h20),
            child: ListView(
              shrinkWrap: true,
              children: [
                SvgPicture.asset(
                  ManagerImages.contactUs,
                ),
                SizedBox(height: ManagerHeight.h20),
                Text(
                  ManagerStrings.contactUs,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ManagerHeight.h20),
                Text(
                  ManagerStrings.youHaveQuestionsOrNotes,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.lightBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ManagerHeight.h20),
                Padding(
                  padding: EdgeInsets.all(ManagerHeight.h16),
                  child: Container(
                    width: size.width <= ManagerWidth.w350
                        ? size.width
                        : ManagerWidth.w320,
                    decoration: BoxDecoration(
                      color: ManagerColors.primaryColor,
                      borderRadius: BorderRadius.circular(
                        ManagerRadius.r8,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: ManagerHeight.h20),
                        Text(
                          ManagerStrings.contactInfo,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s20,
                            color: ManagerColors.white,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h8),
                        Text(
                          ManagerStrings.sayThingToStartContact,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: ManagerHeight.h20),
                        contactInfoItem(
                            image: ManagerImages.contactPhone,
                            value: controller.phone),
                        SizedBox(height: ManagerHeight.h20),
                        contactInfoItem(
                            image: ManagerImages.contactEmail,
                            value: controller.email),
                        SizedBox(height: ManagerHeight.h20),
                        contactInfoItem(
                            image: ManagerImages.contactLocation,
                            value: controller.location),
                        SizedBox(height: ManagerHeight.h50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (controller.facebookLink.isNotEmpty) {
                                  await launchUrl(
                                    Uri.parse(controller.facebookLink),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: SvgPicture.asset(
                                ManagerImages.contactFacebook,
                                width: ManagerWidth.w40,
                              ),
                            ),
                            SizedBox(width: ManagerWidth.w20),
                            InkWell(
                              onTap: () async {
                                if (controller.instagramLink.isNotEmpty) {
                                  await launchUrl(
                                    Uri.parse(controller.instagramLink),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: SvgPicture.asset(
                                ManagerImages.contactInstagram,
                                width: ManagerWidth.w40,
                              ),
                            ),
                            SizedBox(width: ManagerWidth.w20),
                            InkWell(
                              onTap: () async {
                                if (controller.twitterLink.isNotEmpty) {
                                  await launchUrl(
                                    Uri.parse(controller.twitterLink),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: SvgPicture.asset(
                                ManagerImages.contactTwitter,
                                width: ManagerWidth.w40,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ManagerHeight.h20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    Get.delete<ContactUsController>();
    super.dispose();
  }
}
