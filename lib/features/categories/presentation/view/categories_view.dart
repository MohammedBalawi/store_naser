import 'package:app_mobile/core/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../../core/fonse/add_category_dialog.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/widgets/pop_cope_widget.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../controller/categories_controller.dart';
import 'brand_tabs_card.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ManagerColors.primaryColor,
      backgroundColor: ManagerColors.transparent,
      elevation: 0,
      onRefresh: () async {
    await Get.find<HomeController>().homeRequest();
    await Get.find<HomeController>().fetchCategoriess();
    },
        child: willPopScope(
      child: GetBuilder<CategoriesController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: ManagerColors.white,
            extendBody: true,
            appBar: AppBar(
              centerTitle: true,
              shadowColor: ManagerColors.grey,
              elevation: 0.2,
              backgroundColor: ManagerColors.white,
              title: Text(
                ManagerStrings.wishlist,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s18,
                  color: ManagerColors.primaryColor,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FutureBuilder<bool>(
                          future: Get.find<HomeController>().checkIfAdmin(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox();
                            }
                            if (snapshot.hasData && snapshot.data == true) {
                              return IconButton(
                                icon: const Icon(Icons.add, color: ManagerColors.primaryColor),
                                onPressed: () => AddCategoryDialog(context).show(),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                GetBuilder<HomeController>(
                  builder: (controller) {
                    return controller.isLoadingCategories
                        ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: ManagerColors.primaryColor,
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ManagerColors.primaryColor),
                          ),
                        ),
                      ),
                    )
                        : IconButton(
                      icon: const Icon(Icons.refresh,
                          color: ManagerColors.primaryColor),
                      tooltip:ManagerStrings.update ,
                      onPressed: () {
                        controller.fetchCategoriess();
                      },
                    );
                  },
                ),
              ],
            ),


            body:
            BrandTabsCard(),
          );
        },
      ),
    ));
  }
}
