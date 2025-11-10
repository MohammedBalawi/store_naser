import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../controller/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';
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
                child: SvgPicture.asset(isArabic ?ManagerImages.arrows:ManagerImages.arrow_left )),
            Text(ManagerStrings.aboutTheApplication,
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
      body: ListView(
        children: [
          const SizedBox(height: 14),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: ManagerColors.white, borderRadius: BorderRadius.circular(0),
                boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0,4))]
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,bottom: 10),
              child: Column(children: [
                _RowTile(title:ManagerStrings.website , rightIcon: ManagerImages.www, onTap: controller.toTechSupport),
                 Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 25,indent: 25,),
                _RowTile(title: ManagerStrings.instagrams, rightIcon: ManagerImages.instagram, onTap: controller.callCustomerService),
                const Divider(height: 1, color: ManagerColors.gray_divedr,endIndent: 25,indent: 25,),
                _RowTile(title: ManagerStrings.tikTok, rightIcon: ManagerImages.tiktok),
                const Divider(height: 1, color: ManagerColors.gray_divedr,endIndent: 25,indent: 25,),
                _RowTile(title: ManagerStrings.snapchat, rightIcon: ManagerImages.social, onTap: controller.mailUs),
                const Divider(height: 1, color: ManagerColors.gray_divedr,endIndent: 25,indent: 25,),
                _RowTile(title: ManagerStrings.telegram, rightIcon: ManagerImages.telegram_, onTap: controller.mailUs),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.title, required this.rightIcon, this.subtitle, this.onTap, this.iconSize = 22,});
  final String title;
  final String rightIcon;
  final String? subtitle;
  final VoidCallback? onTap;
  final double iconSize;


  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(children: [
          const SizedBox(width: 22),
          SvgPicture.asset(rightIcon),
          const SizedBox(width: 16),
          Expanded(

              child: Text(
                 title ,
                style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
              ),
          ),
          subtitle != null ?
          Expanded(
              child: Text(
              subtitle!,
                style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
              ),
          ):
          const SizedBox(width: 12),
          isArabic
              ? SvgPicture.asset(
            ManagerImages.arrow_left,
            width: iconSize,
            height: iconSize,
          )
              : SvgPicture.asset(
            ManagerImages.arrow_en,
            width: iconSize,
            height: iconSize,
          ),

          const SizedBox(width: 22),
        ]),
      ),
    );
  }
}
