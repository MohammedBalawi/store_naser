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
            Text('الدعم',
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
                _RowTile(title: 'الدعم الفني', rightIcon: ManagerImages.plusCirc, onTap: controller.toTechSupport),
                 Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 25,indent: 25,),
                _RowTile(title: 'اتصل بخدمة العملاء', rightIcon: ManagerImages.chatCirc, onTap: controller.callCustomerService),
                const Divider(height: 1, color: ManagerColors.gray_divedr,endIndent: 25,indent: 25,),
                _RowTile(title: 'واتساب', subtitle: controller.hotline, rightIcon: ManagerImages.basil_whatsapp, onTap: controller.openWhatsApp),
                const Divider(height: 1, color: ManagerColors.gray_divedr,endIndent: 25,indent: 25,),
                _RowTile(title: 'البريد الإلكتروني', rightIcon: ManagerImages.emailCirc, onTap: controller.mailUs),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.title, required this.rightIcon, this.subtitle, this.onTap});
  final String title;
  final String rightIcon;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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

          SvgPicture.asset(ManagerImages.arrow_left, width: 22, height: 22),
          const SizedBox(width: 22),
        ]),
      ),
    );
  }
}
