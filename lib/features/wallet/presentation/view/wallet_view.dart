import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/wallet/presentation/view/wallet_voucher_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar:AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        notificationPredicate: (notification) => false,

        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: Colors.white),

        flexibleSpace: const SizedBox.expand(
          child: ColoredBox(color: Colors.white),
        ),

        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(isArabic?ManagerImages.arrows:ManagerImages.arrow_left)),
            Text(ManagerStrings.balance,style: getBoldTextStyle(fontSize: 20, color: ManagerColors.black),),

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
          const TopBanner(),
          WalletHeaderCard(
            onAddBalance: () => Get.to(() => const WalletVoucherView()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Align(
              alignment:isArabic? Alignment.centerRight:Alignment.centerLeft,
              child: Text(ManagerStrings.lastTranscations, style: getBoldTextStyle(fontSize: 16, color: ManagerColors.black)),
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
                    padding: const EdgeInsets.only(left: 16,right: 16),
                    child: TxItem(tx: list[i])),
              );
            }),
          ),
        ],
      ),
    );
  }
}
