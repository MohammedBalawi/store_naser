

import 'dart:convert';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/fonse/add_product_dialog.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/product_item.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../../../product_details/presentation/controller/product_details_controller.dart';
import '../../../product_details/presentation/view/product_details_view.dart';

class ProductsView extends StatelessWidget {
  final String title;

  const ProductsView({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return FutureBuilder<bool>(
      future: homeController.checkIfAdmin(),
      builder: (context, snapshot) {
        final bool isAdmin = snapshot.data ?? false;

        return Scaffold(
          appBar: mainAppBar(
            title: title.isEmpty ? ManagerStrings.outBoardingTitle1 : title,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: ManagerColors.primaryColor),
                onPressed: () {
                  homeController.fetchProductss();
                },
              ),
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.add, color: ManagerColors.primaryColor),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AddProductDialog(),
                    );
                  },
                ),
            ],
          ),
          backgroundColor: ManagerColors.white,
          body: Obx(() {
            final allProducts = homeController.products
                .where((product) => product.type == title || title.isEmpty)
                .toList();
            // final allProducts = homeController.products;

            if (allProducts.isEmpty) {
              return Center(
                child: snapshot.connectionState == ConnectionState.waiting
                    ?  const CircularProgressIndicator(color: ManagerColors.primaryColor,)
                    : isAdmin
                    ? ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AddProductDialog(),
                    );
                    homeController.fetchProductss();
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label:  Text(ManagerStrings.addProduct, style: getMediumTextStyle(color: ManagerColors.white, fontSize: ManagerFontSize.s14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
                    :  Text(ManagerStrings.noProductsOrData, style: getMediumTextStyle(fontSize:ManagerFontSize.s14, color: ManagerColors.black)),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 50.0,
                        childAspectRatio: 0.7,
                      ),

                      itemBuilder: (context, index) {
                        final product = allProducts[index];
                        return InkWell(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('selected_product', jsonEncode(product.toJson()));

                            Get.lazyPut(() => ProductDetailsController());
                            Get.to(() => const ProductDetailsView());
                          },
                          child: productItem(
                            model: product,
                            enableCart: false,
                          ),
                        );



                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}



