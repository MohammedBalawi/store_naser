import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../controller/home_controller.dart';

class BrandTabs extends StatelessWidget {
  BrandTabs({Key? key}) : super(key: key);

  final HomeController controller = Get.find<HomeController>();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        // if (controller.categories.isEmpty) {
        //   return const Center(child: CircularProgressIndicator(
        //     color: ManagerColors.primaryColor,
        //   ));
        // }

        return SizedBox(
          height: 120,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: ManagerColors.greyAccent,
                            backgroundImage: (category.image ?? '').isNotEmpty
                                ? NetworkImage(category.image!)
                                : null,
                            child: (category.image ?? '').isEmpty
                                ? const Icon(Icons.image, size: 30, color: ManagerColors.primaryColor)
                                : null,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.name,
                            style:  getRegularTextStyle(
                              fontSize: ManagerFontSize.s12,
                              color: ManagerColors.primaryColor,
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
              ),

            ],
          ),
        );
      },
    );
  }
}
