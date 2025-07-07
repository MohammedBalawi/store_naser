import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/core/widgets/text_field.dart';
import 'package:app_mobile/features/categories/domain/di/categories_di.dart';
import 'package:app_mobile/features/categories/presentation/controller/category_products_controller.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_icons.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/product_item.dart';

class CategoryProductsView extends StatefulWidget {
  const CategoryProductsView({super.key});

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductsController>(
      builder: (controller) {
        return Scaffold(
          appBar: mainAppBar(
            title: ManagerStrings.products,
          ),
          backgroundColor: ManagerColors.background,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(
                  ManagerHeight.h16,
                ),
                child: Text(
                  controller.categoryName,
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s24,
                      color: ManagerColors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: ManagerWidth.w16,
                  right: ManagerWidth.w16,
                ),
                child: textField(
                  hintText: ManagerStrings.search,
                  controller: controller.searchController,
                  onChange: (value) {
                    controller.changeSearch(value);
                  },
                  suffixIcon: Icon(
                    ManagerIcons.search,
                  ),
                  radius: ManagerRadius.r16,
                ),
              ),
              SizedBox(
                height: ManagerHeight.h20,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(
                    ManagerHeight.h8,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: controller.filteredProducts().length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust the number of items per row
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio:
                          0.6, // Adjust the height/width ratio of the items
                    ),
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts()[index];
                      return productItem(
                        model: product,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    disposeCategoryProducts();
    super.dispose();
  }
}
