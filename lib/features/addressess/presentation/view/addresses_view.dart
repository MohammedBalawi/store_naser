// lib/features/addressess/presentation/view/addresses_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../domain/model/address.dart';
import '../controller/addresses_controller.dart';
import '../controller/add_address_controller.dart';
import '../widget/address_card.dart';
import '../widget/confirm_dialog.dart';
import 'add_address_view.dart';

class AddressesView extends GetView<AddressesController> {
  const AddressesView({super.key});

  Future<void> _gotoAdd() async {
    // الانتقال لصفحة إضافة عنوان مع Bindings نظيفة
    final result = await Get.to<Address?>(
          () =>  AddAddressView(),
      binding: BindingsBuilder(
            () => Get.lazyPut<AddAddressController>(() => AddAddressController()),
      ),
    );

    if (result != null) {
      controller.add(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                child: SvgPicture.asset(ManagerImages.arrows),
              ),
              Text(
                'عناويني',
                style: getBoldTextStyle(color: Colors.black, fontSize: 20),
              ),
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

        body: Obx(() {
          final items = controller.items;

          // الحالة الفارغة
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  SvgPicture.asset(ManagerImages.weui_location),
                    const SizedBox(height: 22),
                    Text(
                      'لا يوجد عناوين',
                      style:
                      getMediumTextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'إضغط على "إضافة عنوان" لإضافة عنوان التسليم',
                      textAlign: TextAlign.center,
                      style: getRegularTextStyle(
                        fontSize: 12,
                        color: ManagerColors.bongrey,
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _gotoAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ManagerColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 0,
                        ),
                        child: Text(
                          'إضافة عنوان',
                          style: getBoldTextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // القائمة
          return ListView(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            children: [
              // إضافة عنوان جديد
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: _gotoAdd,
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: Text(
                        'إضافة عنوان جديد',
                        style: getBoldTextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // بطاقات العناوين
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final a = entry.value;

                return AddressCard(
                  address: a,
                  highlight: index == 0, // الأولى بمحيط بنفسجي
                  onEdit: () async {
                    final edited = await Get.to<Address?>(
                          () =>  AddAddressView(),
                      binding: BindingsBuilder(
                            () => Get.lazyPut<AddAddressController>(
                              () => AddAddressController(),
                        ),
                      ),
                      arguments: {'address': a},
                    );
                    if (edited != null) controller.updateAddress(edited);
                  },
                  onDelete: () async {
                    final ok = await showConfirmDialog(
                      context: context,
                      message: 'هل أنت متأكد أنك تريد\nحذف عنوانك؟',
                      positive: 'حذف',
                      negative: 'إلغاء',
                    );
                    if (ok == true) controller.remove(a.id);
                  },
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
