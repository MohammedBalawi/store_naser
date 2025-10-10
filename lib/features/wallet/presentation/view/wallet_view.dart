import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/features/wallet/presentation/view/wallet_voucher_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/wallet_controller.dart';
import '../widget/top_banner.dart';
import '../widget/tx_empty.dart';
import '../widget/tx_item.dart';
import '../widget/wallet_header_card.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WalletController());
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        backgroundColor: ManagerColors.white,
        elevation: 0,
        centerTitle: true,
        title:
            Text('الرصيد',style: getBoldTextStyle(fontSize: 20, color: ManagerColors.black),),

          leading:  GestureDetector(
            onTap: (){Get.back();},
              child: SvgPicture.asset(ManagerImages.arrows)),

      ),
      body: Column(
        children: [
          const TopBanner(),
          WalletHeaderCard(
            onAddBalance: () => Get.to(() => const WalletVoucherView()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('المعاملات الأخيرة', style: getBoldTextStyle(fontSize: 16, color: ManagerColors.black)),
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = controller.filtered;
              if (list.isEmpty) return const SingleChildScrollView(child: TxEmpty());
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: list.length,
                itemBuilder: (_, i) => Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.only(left: 16,right: 16),
                    // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2))],

                    // decoration: BoxDecoration(
                    //   // color: Colors.white,
                    //   // borderRadius: BorderRadius.circular(8),
                    //   // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2))],
                    // ),
                    child: TxItem(tx: list[i])),
              );
            }),
          ),
        ],
      ),
    );
  }
}
