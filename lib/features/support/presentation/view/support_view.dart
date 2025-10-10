import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../controller/support_controller.dart';


class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

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
  const _RowTile({
    required this.title,
    required this.rightIcon,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String rightIcon;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // جهّز الرقم بصيغة صحيحة
    final displaySubtitle = subtitle == null
        ? null
        : subtitle!.toLatinDigits().formatIntlSpace(); // +966 588986285

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 22),

            SvgPicture.asset(rightIcon),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
              ),
            ),
            const SizedBox(width: 16),

            if (displaySubtitle != null)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      displaySubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(width: 18),

            // سهم النهاية (أقصى اليسار)
            SvgPicture.asset(ManagerImages.arrow_left, width: 22, height: 22),
            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }
}

extension PhoneFmt on String {
  /// يحافظ على +XXX مسافة ثم الباقي
  String formatIntlSpace() {
    final m = RegExp(r'^\+?(\d{1,3})(\d+)$').firstMatch(replaceAll(' ', ''));
    if (m == null) return this;
    return '+${m.group(1)!} ${m.group(2)!}';
  }

  /// يحوّل الأرقام العربية إلى لاتينية إن لزم
  String toLatinDigits() {
    const arabic = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    const latin  = ['0','1','2','3','4','5','6','7','8','9'];
    var s = this;
    for (var i = 0; i < arabic.length; i++) {
      s = s.replaceAll(arabic[i], latin[i]);
    }
    return s;
  }
}
