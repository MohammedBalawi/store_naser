import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/wallet_controller.dart';

class TopBanner extends StatelessWidget {
  const TopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WalletController>();

    return Obx(() {
      if (c.bannerState.value == VoucherBanner.none) return const SizedBox.shrink();

      final isError = c.bannerState.value == VoucherBanner.invalid;
      final bg  = isError ? Colors.white : Colors.white;
      final brd = isError ? Colors.red : Colors.green;
      final icn = isError ? Icons.error_outline : Icons.check_circle;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: brd),
            boxShadow: [BoxShadow(color: brd.withOpacity(0.08), blurRadius: 8, offset: const Offset(0,2))],
          ),
          child: Row(
            children: [
              Icon(icn, color: brd),
              const SizedBox(width: 8),
              Expanded(child: Text(c.bannerText.value, style:getRegularTextStyle(fontSize: 12, color: ManagerColors.red))),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: c.dismissBanner,
              ),
            ],
          ),
        ),
      );
    });
  }
}
