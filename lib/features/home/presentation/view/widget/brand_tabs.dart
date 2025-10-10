import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../controller/home_controller.dart';
import 'package:flutter/material.dart';
class BrandTabs extends StatelessWidget {
  BrandTabs({Key? key}) : super(key: key);

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return SizedBox(
          height: 220, // ارتفاع يكفي سطرين
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,          // سطرين
              mainAxisSpacing: 1,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,     // نسبة العرض للارتفاع
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
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
