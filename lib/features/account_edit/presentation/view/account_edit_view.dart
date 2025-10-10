import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_images.dart';
import '../controller/account_edit_controller.dart';

class AccountEditView extends GetView<AccountEditController> {
  const AccountEditView({super.key});

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
              GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(ManagerImages.arrows)),
              Text('تعديل الحسابء', style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
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
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            _SectionCard(
              title: 'معلومات الحساب',
              items: [
                _Item(
                  icon: ManagerImages.outline_edit,
                  label: 'تعديل الاسم',
                  onTap: controller.onEditName,
                ),
                _Item(
                  icon: ManagerImages.lock,
                  label: 'تغيير كلمة المرور',
                  onTap: controller.onChangePassword,
                ),
                _Item(
                  icon: ManagerImages.phone,
                  label: 'رقم الهاتف',
                  onTap: controller.onChangePhone,
                ),
                _Item(
                  icon: ManagerImages.mail_outline,
                  label: 'تغيير البريد الإلكتروني',
                  onTap: controller.onChangeEmail,
                ),
              ],
            ),

            const SizedBox(height: 16),

            _SectionCard(
              title: 'معلومات شخصية',
              items: [
                _Item(icon: ManagerImages.gender, label: 'الجنس', onTap: controller.onGender),
                _Item(icon: ManagerImages.cake, label: 'تاريخ الميلاد', onTap: controller.onBirthday),
                _Item(icon: ManagerImages.height, label: 'طولك', onTap: controller.onHeight),
                _Item(icon: ManagerImages.weight, label: 'وزنك', onTap: controller.onWeight),
                _Item(icon: ManagerImages.colors, label: 'لون البشرة', onTap: controller.onSkinTone),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () => controller.onDeleteAccount(Get.context!),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(ManagerImages.fluent_delete),
                        Row(children: [
                          const SizedBox(width: 4),
                          Text('حذف الحساب',
                              style: getBoldTextStyle(
                                  fontSize: 16, color: ManagerColors.like)),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'يمكنك إلغاء طلب الحذف عن طريق إعادة تنشيط حسابك\n خلال 30 يوماً',
                    style: getRegularTextStyle(
                        fontSize: 12, color: ManagerColors.bongrey),
                  ),
                  const SizedBox(height: 30),

                ],
              ),
            ),
            const SizedBox(height: 30)

          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.items});

  final String title;
  final List<_Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Text(title,
                textAlign: TextAlign.start,
                style: getBoldTextStyle(color: Colors.black, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 15),

        Container(
          decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: List.generate(items.length, (i) {
                    final it = items[i];
                    return Column(
                      children: [
                        _Tile(
                          icon: it.icon,
                          label: it.label,
                          onTap: it.onTap,
                        ),
                        if (i != items.length - 1)
                          const Divider(
                              height: 1, thickness: 1, color: Color(0xFFF1F1F4)),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Item {
  final String icon;
  final String label;
  final VoidCallback onTap;
  _Item({required this.icon, required this.label, required this.onTap});
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.onTap});

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const SizedBox(width: 6),
              SvgPicture.asset(icon, width: 22, height: 22, color: Colors.black87),
              const SizedBox(width: 10),
              Text(label,
                  style: getRegularTextStyle(fontSize: 18, color: Colors.black)),
            ]),
            SvgPicture.asset(ManagerImages.arrow_left),
          ],
        ),
      ),
    );
  }
}
