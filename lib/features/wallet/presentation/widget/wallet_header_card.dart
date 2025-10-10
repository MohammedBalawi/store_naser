import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../domain/entities/transaction.dart';
import '../controller/wallet_controller.dart';

class WalletHeaderCard extends StatelessWidget {
  final VoidCallback onAddBalance;
  const WalletHeaderCard({super.key, required this.onAddBalance});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WalletController>();

    return Container(
      height: 144,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ManagerColors.color.withOpacity(0.85),
            ManagerColors.color, // البنفسجي الأغمق
          ],
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Tabs
            Obx(() => Row(
              children: [
                _TabChip(
                  label: 'المجموع',
                  selected: c.currentTab.value == WalletTab.total,
                  onTap: () => c.changeTab(WalletTab.total),
                ),
                _TabChip(
                  label: 'رصيدي',
                  selected: c.currentTab.value == WalletTab.credit,
                  onTap: () => c.changeTab(WalletTab.credit),
                ),
                _TabChip(
                  label: 'رصيد مكافئة',
                  selected: c.currentTab.value == WalletTab.debit,
                  onTap: () => c.changeTab(WalletTab.debit),
                ),
              ],
            )),
            const SizedBox(height: 12),
            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final amount = switch (c.currentTab.value) {
                    WalletTab.total  => c.balanceTotal.value,
                    WalletTab.credit => c.balanceCredit.value,
                    WalletTab.debit  => c.balanceDebit.value,
                  };
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' ${amount.toStringAsFixed(0)} ر.س ',
                          style: getBoldTextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          )),
                      const SizedBox(height: 6),
                      Text('إجمالي الإيداع',
                          style: getBoldTextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14
                          )),
                    ],
                  );
                }),
                const SizedBox(width: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onAddBalance,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ManagerColors.color,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child:  Text('إضافة رصيد',style: getRegularTextStyle(fontSize: 16, color: ManagerColors.color),),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.22) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: selected ? Border.all(color: Colors.white, width: 1.2) : null,
        ),
        child: Text(label, style: getBoldTextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}
