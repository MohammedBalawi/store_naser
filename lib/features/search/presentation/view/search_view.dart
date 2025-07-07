import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:app_mobile/features/search/presentation/controller/supabase_product_search.dart';
import 'package:app_mobile/features/search/presentation/view/no_search_view.dart';
import 'package:app_mobile/features/search/presentation/view/widgets/last_search_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_icons.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/product_item.dart';
import '../../../../core/widgets/text_field.dart';
import '../controller/search_controller.dart';

class SearchView extends StatelessWidget {

  const SearchView({super.key});


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AppSearchController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ManagerColors.backgroundForm,
          appBar: mainAppBar(
            title: ManagerStrings.smartSearch,
          ),
          body: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: ManagerHeight.h10,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: ManagerHeight.h16,
                ),

                textField(
                  fillColor: ManagerColors.textFieldFillColor,
                  hintText: ManagerStrings.searchProductName,
                  controller: controller.searchController,
                  onChange: (v) {
                    controller.update();
                    controller.searchProductsInSupabase();
                  },
                  validator: (value) =>
                      controller.validator.validateFullName(value),
                  textInputType: TextInputType.text,
                  radius: ManagerRadius.r10,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.searchRequest();
                      controller.searchProductsInSupabase();
                    },
                    child: Icon(
                      ManagerIcons.search,
                      size: ManagerRadius.r30,
                      color: ManagerColors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: ManagerHeight.h10,
                ),
                if ((!controller.searched) ||
                    controller.searchController.text.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(
                      ManagerHeight.h10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ManagerStrings.lastSearch,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: ManagerColors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.emptySearch();
                          },
                          child: Text(
                            ManagerStrings.clearAll,
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s16,
                              color: ManagerColors.blackAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(
                    ManagerHeight.h12,
                  ),
                  child: (!controller.searched) ||
                          controller.searchController.text.isEmpty
                      ? ListView(
                          shrinkWrap: true,
                          children: controller.searchResults
                              .map(
                                (e) => lastSearchItem(
                                  title: e,
                                  onTap: () {
                                    controller.changeSearchText(
                                      value: e,
                                    );
                                  },
                                  onDeleteTap: () {
                                    controller.deleteSearch(
                                      value: e,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        )
                      : controller.isLoading
                          ?  const Center(
                              child: CircularProgressIndicator(color: ManagerColors.primaryColor,),
                            )
                          : (controller.searched && controller.products.isEmpty)
                              ? const NoSearchView()
                              : Column(
                                  children: [
                                    Text(
                                      ManagerStrings.relatedProducts,
                                      style: getBoldTextStyle(
                                        fontSize: ManagerFontSize.s16,
                                        color: ManagerColors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ManagerHeight.h14,
                                    ),
                                    SizedBox(
                                      height: size.height - ManagerHeight.h340,
                                      width: double.infinity,
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: controller.products.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              2, // Adjust the number of items per row
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                          childAspectRatio:
                                              0.55, // Adjust the height/width ratio of the items
                                        ),
                                        itemBuilder: (context, index) {
                                          final product =
                                              controller.products[index];
                                          return productItem(
                                            model: product,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: ManagerHeight.h50,
                                    ),
                                  ],
                                ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
