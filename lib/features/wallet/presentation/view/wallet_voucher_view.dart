import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/wallet_controller.dart';
import '../widget/top_banner.dart';

class WalletVoucherView extends GetView<WalletController> {
  const WalletVoucherView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WalletController>();
    final textController = TextEditingController(text: 'NSA-FSZ4IYLW'); // مثل الصورة
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar:
      AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,        // يمنع تأثير الـ tint
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,   // لا تضيف طبقة لونية
        shadowColor: Colors.transparent,  // حتى لو حاول يعمل ظل/تيـنت
        notificationPredicate: (notification) => false,

        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: Colors.white),

        flexibleSpace: const SizedBox.expand(
          child: ColoredBox(color: Colors.white), // يلوّن خلف شريط الحالة بالكامل
        ),

        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(isArabic?ManagerImages.arrows:ManagerImages.arrow_left)),
            Text(ManagerStrings.addCredit,style: getBoldTextStyle(fontSize: 20, color: ManagerColors.black),),
            const SizedBox(width: 42),
          ],
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
      ),

      body: Column(
        children: [
          const TopBanner(), // يظهر خطأ أو نجاح فوق كما بالصور
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0,2))]
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ManagerStrings.voucherNumber, style: getBoldTextStyle(color: ManagerColors.black,fontSize: 12)),
                  // const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.end,
                      style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black),
                      controller: textController,
                      onChanged: (v) => c.voucherCode.value = v,
                      decoration:  InputDecoration(

                        hintText: 'NMiD25',
                        hintStyle: getRegularTextStyle(fontSize: 14, color: ManagerColors.gray_3),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 12.0,left: 18,right: 18,bottom: 25),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: Obx(() {
                final bg = c.bannerState.value == VoucherBanner.invalid
                    ? ManagerColors.color
                    : ManagerColors.color.withOpacity(0.5);
                return ElevatedButton(
                  onPressed: () async {
                    await c.redeemVoucher();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child:  Text(ManagerStrings.confirm,style: getBoldTextStyle(fontSize: 16, color: ManagerColors.white),),
                );
              }),
            ),
          ),
          SizedBox(height: 25,)
        ],
      ),
    );
  }
}
