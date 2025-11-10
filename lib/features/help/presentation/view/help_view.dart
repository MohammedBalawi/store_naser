import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../controller/help_controller.dart';

class _C {
  static const bg = Color(0xFFF7F7FA);
  static const card = Colors.white;
  static const divider = Color(0xFFEDEDED);
}

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

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
                child: SvgPicture.asset(isArabic ?ManagerImages.arrows:ManagerImages.arrow_left)),
            Text(ManagerStrings.help,
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
        if (controller.isLoading.value) {
          return const _HelpSkeleton();
        }
        if (controller.isError.value && controller.items.isEmpty) {
          return _ErrorRetry(onRetry: controller.fetchItems);
        }
        return ListView(
          children: [
            const SizedBox(height: 14),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                child: Column(
                  children: [
                    for (int i = 0; i < controller.items.length; i++) ...[
                      _HelpTile(
                        title: controller.titleOf(controller.items[i]),
                        rightIcon: _mapIcon(controller.items[i].iconAsset),
                        // onTap: () => controller.onTapItem(controller.items[i]),
                      ),
                      if (i != controller.items.length - 1)
                         Divider(height: 1, color:ManagerColors.gray_divedr,indent: 25,endIndent: 25,),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // يربط اسم الأيقونة القادمة من الـ API بـ ManagerImages
  String _mapIcon(String name) {
    switch (name) {
      case 'search':
        return ManagerImages.search;
      case 'target':
        return ManagerImages.target;
      case 'privacy':
        return ManagerImages.privacy;
      default:
        return ManagerImages.search; // fallback
    }
  }
}

/// عنصر سطر مطابق للصور: سهم يسار، عنوان بالوسط، أيقونة يمين
class _HelpTile extends StatelessWidget {
  const _HelpTile({
    required this.title,
    required this.rightIcon,
    this.onTap,
  });

  final String title;
  final String rightIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 22),
            SvgPicture.asset(rightIcon, width: 24, height: 24),
            const SizedBox(width: 16),

            Expanded(
                child: Text(
                  title,
                  style: getRegularTextStyle(
                    fontSize: 18,
                    color: ManagerColors.black,
                  ),
                ),
            ),
            const SizedBox(width: 12),
            isArabic ?
            SvgPicture.asset(ManagerImages.arrow_left, width: 22, height: 22):
            SvgPicture.asset(ManagerImages.arrow_en, width: 22, height: 22),
            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }
}

class _HelpSkeleton extends StatelessWidget {
  const _HelpSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget bar() => Container(
      height: 56,
      color: Colors.transparent,
      child: Row(children: [
        const SizedBox(width: 12),
        Container(width: 22, height: 22, color: Colors.black12),
        const SizedBox(width: 12),
        Expanded(
          child: Center(
            child: Container(width: 160, height: 16, color: Colors.black12),
          ),
        ),
        const SizedBox(width: 12),
        Container(width: 24, height: 24, color: Colors.black12),
        const SizedBox(width: 16),
      ]),
    );

    return ListView(
      children: [
        const SizedBox(height: 14),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              bar(),
              const Divider(height: 1, color: _C.divider),
              bar(),
              const Divider(height: 1, color: _C.divider),
              bar(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('حدث خطأ في التحميل',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
          ],
        ),
      ),
    );
  }
}
