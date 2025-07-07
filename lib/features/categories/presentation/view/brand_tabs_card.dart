import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../core/fonse/add_category_dialog.dart';
import '../../../../core/routes/routes.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../../../products/presentation/view/products_view.dart'; // تأكد من وجود هذا الملف

class BrandTabsCard extends StatelessWidget {
  BrandTabsCard({Key? key}) : super(key: key);

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        if (controller.isLoadingCategories) {
          return  Center(child: CircularProgressIndicator(color: ManagerColors.primaryColor));
        }

        if (controller.categories.isEmpty) {
          return FutureBuilder<bool>(
            future: controller.checkIfAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(
                  color: ManagerColors.primaryColor,
                ));
              }

              if (snapshot.hasData && snapshot.data == true) {
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: () => AddCategoryDialog(context).show(),
                    icon: const Icon(Icons.add, color: ManagerColors.white),
                    label:  Text(
                      ManagerStrings.addCategories,
                      style: TextStyle(color: ManagerColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: ManagerColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              } else {
                return  Center(
                  child: Text(
                    ManagerStrings.thereAreNoCategories,
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
            },
          );
        }


        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: GridView.builder(
            itemCount: controller.categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:  2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent:  260,
            ),
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return GestureDetector(
                onTap: () async {
                  await controller.fetchProducts();
                  Get.to(() => ProductsView(
                    title: category.name,
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ManagerColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ManagerColors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Container(
                        height:  ManagerHeight.h150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ManagerColors.grey,
                          image: category.image != null && category.image!.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(category.image!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: (category.image == null || category.image!.isEmpty)
                            ? const Icon(Icons.image, size: 40, color: ManagerColors.primaryColor)
                            : null,
                      ),
                       SizedBox(height: ManagerHeight.h18),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: getMediumTextStyle(
                          color: ManagerColors.primaryColor,
                          fontSize:  ManagerFontSize.s18,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );


      },
    );
  }
}
