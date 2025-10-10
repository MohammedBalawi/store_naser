

import 'dart:convert';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/fonse/add_product_dialog.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/product_item.dart';
import '../../../categories/presentation/controller/category_products_controller.dart';
import '../../../categories/presentation/widget/sort_option_tile.dart';
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
    final CategoryProductsController c = Get.find<CategoryProductsController>();

    return FutureBuilder<bool>(
      future: homeController.checkIfAdmin(),
      builder: (context, snapshot) {
        final bool isAdmin = snapshot.data ?? false;

        return Builder(
          builder: (context) {
            return Scaffold(
              appBar: mainAppBar(
                title: title.isEmpty ? ManagerStrings.outBoardingTitle1 : title,
                actions: [
                  IconButton(
                    icon: SvgPicture.asset(ManagerImages.filter),
                    onPressed: () =>_openFilterSheet(context, c, onApplied: (_) {
                     // أعد البناء لاعتماد الفرز
                    }),
                    tooltip: 'فلتر',
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
                        :  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(ManagerImages.nuull),
                            SizedBox(height: 5,),
                            Text(ManagerStrings.noProductsOrData, style: getMediumTextStyle(fontSize:ManagerFontSize.s14, color: ManagerColors.black)),
                          ],
                        ),
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
                            mainAxisExtent: 320,
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
          }
        );
      },
    );
  }
  List<dynamic> _applySort(List<dynamic> list, ProductSort? sort) {
    final items = List.of(list); // لا تعدّل الأصل

    int _cmpNum(num? a, num? b) => (a ?? 0).compareTo(b ?? 0);
    int _cmpDate(String? a, String? b) {
      final da = a != null ? DateTime.tryParse(a) : null;
      final db = b != null ? DateTime.tryParse(b) : null;
      return (da ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(db ?? DateTime.fromMillisecondsSinceEpoch(0));
    }

    num _priceOf(Map m) => (m['price'] ?? m['finalPrice'] ?? m['amount'] ?? 0) as num;
    bool _hasOffer(Map m) {
      final price = _priceOf(m);
      final old = (m['oldPrice'] ?? m['originalPrice'] ?? 0) as num;
      final disc = (m['discount'] ?? m['discountPercent'] ?? 0) as num;
      return (old is num && old > price) || (disc is num && disc > 0) || (m['isOffer'] == true);
    }

    switch (sort) {
      case ProductSort.popular:
        items.sort((a, b) {
          final ma = a.toJson() as Map<String, dynamic>;
          final mb = b.toJson() as Map<String, dynamic>;
          // محاولات متعددة للمقياس: orders > views > favorites
          final pa = (ma['orders'] ?? ma['purchases'] ?? ma['views'] ?? ma['favorites'] ?? 0) as num;
          final pb = (mb['orders'] ?? mb['purchases'] ?? mb['views'] ?? mb['favorites'] ?? 0) as num;
          return _cmpNum(pb, pa); // تنازلي
        });
        break;

      case ProductSort.newest:
        items.sort((a, b) {
          final ma = a.toJson() as Map<String, dynamic>;
          final mb = b.toJson() as Map<String, dynamic>;
          final da = (ma['createdAt'] ?? ma['created_at'] ?? ma['date']) as String?;
          final db = (mb['createdAt'] ?? mb['created_at'] ?? mb['date']) as String?;
          return _cmpDate(db, da); // الأحدث أولًا
        });
        break;

      case ProductSort.offersFirst:
        items.sort((a, b) {
          final ma = a.toJson() as Map<String, dynamic>;
          final mb = b.toJson() as Map<String, dynamic>;
          final oa = _hasOffer(ma) ? 1 : 0;
          final ob = _hasOffer(mb) ? 1 : 0;
          if (ob != oa) return ob.compareTo(oa); // العروض أولًا
          // ثم الأرخص داخل كل مجموعة
          return _cmpNum(_priceOf(ma), _priceOf(mb));
        });
        break;

      case ProductSort.priceHighLow:
        items.sort((a, b) {
          final ma = a.toJson() as Map<String, dynamic>;
          final mb = b.toJson() as Map<String, dynamic>;
          return _cmpNum(_priceOf(mb), _priceOf(ma));
        });
        break;

      case ProductSort.priceLowHigh:
        items.sort((a, b) {
          final ma = a.toJson() as Map<String, dynamic>;
          final mb = b.toJson() as Map<String, dynamic>;
          return _cmpNum(_priceOf(ma), _priceOf(mb));
        });
        break;

      case null:
      // بدون فرز
        break;
    }
    return items;
  }

  void _openFilterSheet(
      BuildContext context,
      CategoryProductsController c, {
        void Function(ProductSort?)? onApplied,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        var localSort = c.sort;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // الهيدر
                      SizedBox(
                        height: 48,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              'الفلاتر',
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s16,
                                color: ManagerColors.black,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () => setModalState(() => localSort = null),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(44, 44),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'مسح',
                                  style: getRegularTextStyle(
                                    color: ManagerColors.color,
                                    fontSize: ManagerFontSize.s12,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close_rounded, size: 24),
                                splashRadius: 22,
                                color: ManagerColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(height: 1, color: ManagerColors.gray_divedr),
                      const SizedBox(height: 8),

                      // الخيارات (نستخدم localSort ليتغير فورًا)
                      SortOptionTile(
                        title: 'الأكثر شعبية',
                        groupValue: localSort,
                        value: ProductSort.popular,
                        onChanged: (v) => setModalState(() => localSort = v),
                      ),
                      SortOptionTile(
                        title: 'الجديد أولاً',
                        groupValue: localSort,
                        value: ProductSort.newest,
                        onChanged: (v) => setModalState(() => localSort = v),
                      ),
                      SortOptionTile(
                        title: 'العروض أولاً',
                        groupValue: localSort,
                        value: ProductSort.offersFirst,
                        onChanged: (v) => setModalState(() => localSort = v),
                      ),
                      SortOptionTile(
                        title: 'السعر الأعلى إلى الأدنى',
                        groupValue: localSort,
                        value: ProductSort.priceHighLow,
                        onChanged: (v) => setModalState(() => localSort = v),
                      ),
                      SortOptionTile(
                        title: 'السعر الأدنى إلى الأعلى',
                        groupValue: localSort,
                        value: ProductSort.priceLowHigh,
                        onChanged: (v) => setModalState(() => localSort = v),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            c.setSort(localSort); // اعتماد الاختيار
                            Navigator.pop(context);
                            onApplied?.call(localSort); // أعِد البناء في الصفحة
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ManagerColors.color,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            'تطبيق',
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}



