import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/main_button.dart';
import '../controller/checkout_controller.dart';
import '../widgets/checkout_stepper.dart';

class CheckoutAddressView extends StatelessWidget {
  const CheckoutAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CheckoutController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: GetBuilder<CheckoutController>(
          builder: (c) {
            return Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: Get.back,
                        child: const Icon(Icons.arrow_forward_ios_outlined, textDirection: TextDirection.ltr),
                      ),
                      const Spacer(),
                      Text("طلب الدفع",
                          style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s20, color: ManagerColors.black)),
                      const Spacer(),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),

                // stepper (الخطوة 1: عنوان الشحن)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CheckoutStepper(step: 0), // يظهر اليسار كـ تم ✓ والوسط نشط
                ),

                const SizedBox(height: 12),

                // زر إضافة عنوان جديد
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: c.addNewAddress,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: ManagerColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:  [
                          Icon(Icons.add, color: ManagerColors.color),
                          SizedBox(width: 8),

                          Text("إضافة عنوان جديد",
                              style: TextStyle(
                                color: ManagerColors.color,
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: c.addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final a = c.addresses[i];
                      final selected = c.selectedAddress == i;
                      return _AddressCard(
                        name: a.name,
                        address: a.addressLine,
                        phone: a.phone,
                        selected: selected,
                        onTap: () => c.selectAddress(i),
                        onEdit: () => c.editAddress(i),
                        onDelete: () => c.deleteAddress(i),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(ManagerWidth.w16),
          child: mainButton(
            buttonName: "التالي",
          color: ManagerColors.greens,
            // backgroundColor: const Color(0xFF6CC000),
            onPressed: () => Get.find<CheckoutController>().goNextFromAddress(),
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            height: 56,
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String name, address, phone;
  final bool selected;
  final VoidCallback onTap, onEdit, onDelete;

  const _AddressCard({
    required this.name, required this.address, required this.phone,
    required this.selected, required this.onTap, required this.onEdit, required this.onDelete, super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? ManagerColors.color : ManagerColors.white,
            width: selected ? 1.6 : 1,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 6, offset: const Offset(0,1))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: getBoldTextStyle(fontSize: ManagerFontSize.s16, color: ManagerColors.black)),
            const SizedBox(height: 6),
            Text(address, textAlign: TextAlign.right,
                style: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.grey)),
            const SizedBox(height: 6),
            Text(phone, style: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.black)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.grey.shade200),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(onPressed: onEdit, child:  Text("تعديل", style: getBoldTextStyle(color: ManagerColors.color, fontSize: 12)) ),
                const SizedBox(width: 8),
                TextButton(onPressed: onDelete, child:  Text("حذف", style: getBoldTextStyle(color: ManagerColors.color,fontSize: 12 )) ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
