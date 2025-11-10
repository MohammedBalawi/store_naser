import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../controller/home_controller.dart';

class BrandTabs extends StatelessWidget {
  BrandTabs({Key? key}) : super(key: key);

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return GetBuilder<HomeController>(
      builder: (_) {
        // تحميل
        if (controller.isLoadingCategories) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // خطأ
        if (controller.categoriesError != null) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'فشل تحميل الأصناف',
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.red_info,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: controller.fetchCategoriesFromApi,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        // لا توجد أصناف
        if (controller.categories.isEmpty) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Text(
                'لا توجد أصناف حالياً',
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.grey_2,
                ),
              ),
            ),
          );
        }

        // عرض الشبكة
        return SizedBox(
          height: 220,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];

              return Padding(
                padding: isArabic
                    ? const EdgeInsets.only(right: 15.0)
                    : const EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 58,
                          width: 107,
                          decoration: BoxDecoration(
                            color: ManagerColors.grey_1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: (category.image ?? '').isNotEmpty
                                ? Image.network(
                              category.image!,
                              height: 60,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                                color: ManagerColors.primaryColor,
                              ),
                            )
                                : const Icon(
                              Icons.image,
                              size: 40,
                              color: ManagerColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
