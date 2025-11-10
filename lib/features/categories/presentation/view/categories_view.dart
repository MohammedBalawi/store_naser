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
    // await Get.find<HomeController>().fetchCategoriess();
    },
        child: willPopScope(
      child: GetBuilder<CategoriesController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: ManagerColors.background,
            extendBody: true,


            body:
            Padding(
              padding: const EdgeInsets.only(left: 5.0,right: 5,top: 50),
              child: BrandTabsCard(),
            ),
          );
        },
      ),
    ));
  }
}
