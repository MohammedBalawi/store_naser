import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../controller/tickets_controller.dart';

class OpenTicketView extends GetView<TicketsController> {
  const OpenTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController detailsCtrl = TextEditingController();
    detailsCtrl.addListener(() => controller.setDetails(detailsCtrl.text));

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
            Text('فتح تذكرة',
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
      body: Obx(() {
        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    _lineRow(label: 'رقم الطلب', value: controller.orderId.value.isEmpty ? '26579639' : controller.orderId.value),
                    Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 5,indent: 5,),
                    const SizedBox(height: 10),

                    InkWell(
                      onTap: () => _showProblemsSheet(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ما هي مشكلتك؟', style: getBoldTextStyle(fontSize: 12, color: ManagerColors.black)),


                            Row(children: [
                              const SizedBox(width: 12),
                              Text(controller.selectedProblem.value.isEmpty ? 'اختر المشكلة' : controller.selectedProblem.value,
                                  style: getRegularTextStyle(fontSize: 14, color: Colors.black)),
                              const SizedBox(width: 12),

                              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 5,indent: 5,),

                    const SizedBox(height: 16),
                    Text('إضافة التفاصيل', style: getBoldTextStyle(fontSize: 12, color: ManagerColors.black)),
                    const SizedBox(height: 20),
                    _DetailsWithAttach(
                      controller: controller,
                      detailsCtrl: detailsCtrl,
                    ),
                  ]),
                ),
              ],
            ),

            // زر إرسال بأسفل الشاشة (حالة مفعّلة/معطّلة)
            Positioned(
              right: 16, left: 16, bottom: 60,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.canSubmit ? () async {
                    final ok = await controller.submit();
                    if (ok && context.mounted) {
                      _showSuccess(context);
                      Get.back(); // ارجع لقائمة التذاكر
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.color,
                    disabledBackgroundColor: ManagerColors.color.withOpacity(0.35),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: Text('إرسال', style: getBoldTextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showProblemsSheet(BuildContext context) {
    final options = [
      'منتجات مفقودة',
      'منتجات إضافية',
      'تلقيت طلبًا خاطئًا',
      'منتجات تالفة',
      'إرجاع المنتج',
      'آخر',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ العنوان مع زر الإغلاق بالنهاية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // النص بالبداية (يمين في RTL)
                Text(
                  'ما هي المشكلة',
                  style: getBoldTextStyle(
                    fontSize: 16,
                    color: ManagerColors.black,
                  ),
                ),

                // زر الإغلاق بالنهاية (يسار)
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.black),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Text(
              'اختر من الأسباب',
              style: getRegularTextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // ✅ قائمة الخيارات
            for (final o in options) ...[
              _OptionTile(
                text: o,
                onTap: () {
                  Get.back();
                  Get.find<TicketsController>().chooseProblem(o);
                },
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      )

    );
  }

  void _showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.white,
        content: Row(children: [
          const Icon(Icons.check_circle, color: ManagerColors.like),
          const SizedBox(width: 8),
          Text('لقد تم تقديم تذكرتك بنجاح', style: getBoldTextStyle(fontSize: 14, color: ManagerColors.red)),
        ]),
        actions: [
          IconButton(onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), icon: const Icon(Icons.arrow_forward_ios_rounded)),
        ],
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.text, required this.onTap});
  final String text; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: 12),
        height: 55,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
        alignment: Alignment.centerRight,
        child: Text(text, style: getBoldTextStyle(fontSize: 12, color: ManagerColors.black)),
      ),
    );
  }
}

class _DetailsWithAttach extends StatelessWidget {
  const _DetailsWithAttach({required this.controller, required this.detailsCtrl});
  final TicketsController controller;
  final TextEditingController detailsCtrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketsController>(builder: (_) {
      return Stack(
        children: [
          TextField(
            textAlign: TextAlign.start,
            style: getMediumTextStyle(fontSize:12,color: Colors.black),
            controller: detailsCtrl,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'أضف تفاصيل المشكلة وسنتواصل بك',
              hintStyle:  getMediumTextStyle(fontSize:12,color: Colors.black),
              filled: true,
              fillColor:  Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 80, 12),
              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE5E7EB)), borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE5E7EB)), borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Positioned(
            bottom: 8, right: 10,
            child: Column(
              children: [
                // زر اختيار صورة (هنا مثال وهمي يرفق صورة رمادية)
                InkWell(
                  onTap: () {
                    // TODO: استخدم image_picker ثم:
                    controller.attachImage(Uint8List(8));
                  },
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD1D5DB)), borderRadius: BorderRadius.circular(8), color: Colors.white),
                    child: const Icon(Icons.image_outlined, color: Color(0xFF7C3AED)),
                  ),
                ),
                const SizedBox(height: 8),
                if (controller.attachedImage != null)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xFFE5E7EB)),
                      ),
                      Positioned(
                        right: -6, top: -6,
                        child: GestureDetector(
                          onTap: controller.removeImage,
                          child: Container(
                            width: 18, height: 18,
                            decoration: const BoxDecoration(color: Color(0xFFE11D48), shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

Widget _lineRow({required String label, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: getBoldTextStyle(fontSize: 12, color: ManagerColors.black)),
        Text(value, style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black)),
      ],
    ),
  );
}
