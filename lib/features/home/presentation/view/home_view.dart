import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/home_app_bar.dart';
import 'package:app_mobile/features/home/presentation/controller/home_controller.dart';
import 'package:app_mobile/features/home/presentation/model/products_list_item_model.dart';
import 'package:app_mobile/features/home/presentation/view/widget/favorites_list.dart';
import 'package:app_mobile/features/home/presentation/view/widget/home_banner_slider.dart';
import 'package:app_mobile/features/home/presentation/view/widget/brand_tabs.dart';
import 'package:app_mobile/features/home/presentation/view/widget/products_list.dart';
import 'package:app_mobile/features/main/presentation/view/widget/drawer_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/fonse/add_category_dialog.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/widgets/text_field.dart';
import '../../../main/presentation/controller/main_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          if (controller.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(
                color: ManagerColors.primaryColor,
              )),
            );
          }

          return Scaffold(
            backgroundColor: ManagerColors.scaffoldBackgroundColor,
            extendBody: true,
            appBar: homeAppBar(title: ManagerStrings.home),
            drawer: DrawerView(),
            body: RefreshIndicator(
              backgroundColor: Colors.transparent,
              elevation: 0,
              color: ManagerColors.primaryColor,
              onRefresh: () async {
                await controller.homeRequest();
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.search),
                    child: AbsorbPointer(
                      child: textField(
                        fillColor: ManagerColors.textFieldFillColor,
                        hintText: ManagerStrings.searchProductName,
                        controller: TextEditingController(),
                        onChange: (_) {},
                        validator: (_) => null,
                        textInputType: TextInputType.text,
                        radius: ManagerRadius.r10,
                        suffixIcon: const Icon(
                          Icons.search,
                          size: 30,
                          color: ManagerColors.black,
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth:  double.infinity,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: ManagerColors.black.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ManagerStrings.kira,
                                  style:  getBoldTextStyle(
                                    fontSize: 16,
                                    color: ManagerColors.primaryColor,
                                  ),
                                ),
                                Text(
                                  ManagerStrings.offers,
                                  style:  getBoldTextStyle(
                                    fontSize: 20,
                                    color: ManagerColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            FavoritesListWheel(items: controller.featuredProducts),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ManagerStrings.wishlist,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s18,
                          color: ManagerColors.primaryColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              FutureBuilder<bool>(
                                future:
                                    Get.find<HomeController>().checkIfAdmin(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox();
                                  }
                                  if (snapshot.hasData &&
                                      snapshot.data == true) {
                                    return IconButton(
                                      icon: const Icon(Icons.add,
                                          color: ManagerColors.primaryColor),
                                      onPressed: () =>
                                          AddCategoryDialog(context).show(),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.find<MainController>().navigate(1);
                                },
                                child: Text(
                                  ManagerStrings.viewAll,
                                  style: getRegularTextStyle(
                                    fontSize: ManagerFontSize.s12,
                                    color: ManagerColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  BrandTabs(),
                  // const SizedBox(height: 12),
                  HomeBannerSlider(banners: controller.banners),
                  productsList(
                    model: ProductsListItemModel(
                      title: ManagerStrings.products,
                      items: controller.featuredProducts,
                      route: 'route',
                    ),
                  ),
                  productsList(
                    model: ProductsListItemModel(
                      title: ManagerStrings.best,
                      items: controller.topRatedProducts,
                      route: 'route',
                    ),
                  ),
                  productsList(
                    model: ProductsListItemModel(
                      title: ManagerStrings.sale,
                      items: controller.productsWithDiscount,
                      route: 'route',
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
