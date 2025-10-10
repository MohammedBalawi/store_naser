import 'package:flutter/material.dart';
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

    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        backgroundColor: ManagerColors.white,
        elevation: 0,
        centerTitle: true,
        title:
            Text('إضافة رصيد',style: getBoldTextStyle(fontSize: 20, color: ManagerColors.black),),

          leading:   GestureDetector(
            onTap: (){
              Get.back();
            },
              child: SvgPicture.asset(ManagerImages.arrows)),


        // actions: const [Padding(padding: EdgeInsetsDirectional.only(end: 8), child: Icon(Icons.chevron_right))],
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
                  Text('رقم القسيمة', style: getBoldTextStyle(color: ManagerColors.black,fontSize: 12)),
                  // const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.end,
                      style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black),
                      controller: textController,
                      onChanged: (v) => c.voucherCode.value = v,
                      decoration:  InputDecoration(

                        hintText: 'NSA-FSZ4IYLW',
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
          // زر تأكيد بنفس البنفسجي
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: Obx(() {
                // لون زر مطابق لصورتين (البنفسجي الفاتح/الغامق)
                final bg = c.bannerState.value == VoucherBanner.invalid
                    ? ManagerColors.color // عند الخطأ بالصورة البنفسجي الغامق
                    : ManagerColors.color.withOpacity(0.5); // قبل التحقق
                return ElevatedButton(
                  onPressed: () async {
                    // جرّب أولاً بخطأ لإظهار بانر الخطأ (لو أردت) ثم صح…
                    // مباشرة نستدعي:
                    await c.redeemVoucher();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child:  Text('تأكيد',style: getBoldTextStyle(fontSize: 16, color: ManagerColors.white),),
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
