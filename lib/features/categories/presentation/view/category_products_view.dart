import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_icons.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../core/widgets/product_item.dart';
import '../../../../core/widgets/text_field.dart';
import '../controller/category_products_controller.dart';
import '../widget/category_tile.dart';
import '../widget/sort_option_tile.dart';
class CategoryProductsView extends StatefulWidget {
  const CategoryProductsView({super.key});

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  final items = [
    (ManagerImages.skin, 'العناية بالشفاه'),
    (ManagerImages.skin, 'العناية بالعيون'),
    (ManagerImages.skin, 'ترطيب الوجه'),
    (ManagerImages.skin, 'جميع المنتجات'),
  ];



  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductsController>(
      builder: (c) {
        final bool isArabic = Get.locale?.languageCode == 'ar';

        return Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: ManagerColors.white,
          appBar:
          AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.transparent,
            notificationPredicate: (notification) => false,

            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark
                .copyWith(statusBarColor: Colors.white),

            flexibleSpace: const SizedBox.expand(
              child: ColoredBox(color: Colors.white),
            ),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: () => Get.back(),
                    child: SvgPicture.asset(isArabic ?ManagerImages.arrows:ManagerImages.arrow_left)),
                Text(
                  c.categoryName.isEmpty ? ManagerStrings.products : c.categoryName,
                  style: getBoldTextStyle(fontSize: 20, color: ManagerColors.black),
                ),
                IconButton(
                  icon: SvgPicture.asset(ManagerImages.filter),
                  onPressed: () => openFilterSheet(context, c, onApplied: (_) {
                  }),
                  tooltip: 'فلتر',
                ),
              ],
            ),


            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
            ),
            automaticallyImplyLeading: false,
            leadingWidth: 0,
          ),



          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubTabsBar(
                tabs: c.subTabs,
                selectedIndex: c.selectedSubTab,
                onSelect: c.selectSubTab,
              ),

              if (c.brands.isNotEmpty)
                SizedBox(
                  height: 138,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) => CategoryTile(
                      iconAsset: items[i].$1,
                      title: items[i].$2,
                      onTap: () {},
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: items.length,
                  ),
                ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
                  child: c.isLoading
                      ? const Center(child: CircularProgressIndicator(strokeWidth: 2.5))
                      : _ProductsGridOrEmpty(controller: c),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void openFilterSheet(
      BuildContext context,
      CategoryProductsController c, {
        void Function(ProductSort?)? onApplied,
      })
  {
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
            final bool isArabic = Get.locale?.languageCode == 'ar';

            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            ManagerStrings.filter
                            ,
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s16,
                              color: ManagerColors.black,
                            ),
                          ),
                          Align(
                            alignment:isArabic? Alignment.centerLeft:Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => setModalState(() => localSort = null),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(44, 44),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                ManagerStrings.reset,
                                style: getRegularTextStyle(
                                  color: ManagerColors.color,
                                  fontSize: ManagerFontSize.s12,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment:isArabic? Alignment.centerRight:Alignment.centerLeft,

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

                    SortOptionTile(
                      title: ManagerStrings.popularity,
                      groupValue: localSort,
                      value: ProductSort.popular,
                      onChanged: (v) => setModalState(() => localSort = v),
                    ),
                    SortOptionTile(
                      title: ManagerStrings.newFirst,
                      groupValue: localSort,
                      value: ProductSort.newest,
                      onChanged: (v) => setModalState(() => localSort = v),
                    ),
                    SortOptionTile(
                      title: ManagerStrings.newFirst,
                      groupValue: localSort,
                      value: ProductSort.offersFirst,
                      onChanged: (v) => setModalState(() => localSort = v),
                    ),
                    SortOptionTile(
                      title: ManagerStrings.highPriceToLow,
                      groupValue: localSort,
                      value: ProductSort.priceHighLow,
                      onChanged: (v) => setModalState(() => localSort = v),
                    ),
                    SortOptionTile(
                      title: ManagerStrings.lowPriceToHigh,
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
                          c.setSort(localSort);
                          Navigator.pop(context);
                          onApplied?.call(localSort);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ManagerColors.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          ManagerStrings.apply,
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
            );
          },
        );
      },
    );
  }


}
class _SubTabsBar extends StatelessWidget {
  const _SubTabsBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return InkWell(
            onTap: () => onSelect(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  tabs[i],
                  style: getBoldTextStyle(
                    fontSize: 14,
                    color: selected ? ManagerColors.color : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2.2,
                  width: selected ? 78 : 0,
                  color: selected ? ManagerColors.color : Colors.transparent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BrandsStrip extends StatelessWidget {
  const _BrandsStrip({
    required this.brands,
    required this.selectedId,
    required this.onTap,
    this.itemWidth = 110,
    this.cardHeight = 56,
    this.popAmount = 12,
    this.logoHeight = 18,
    this.gap = 10,
    this.radius = 16,
  });

  final List<BrandChipModel> brands;
  final String? selectedId;
  final ValueChanged<String> onTap;

  final double itemWidth;
  final double cardHeight;
  final double popAmount;
  final double logoHeight;
  final double gap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final listHeight = popAmount + cardHeight + gap + logoHeight;

    return SizedBox(
      height: listHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final b = brands[i];
          final selected = b.id == selectedId;

          return SizedBox(
            width: itemWidth,
            height: listHeight,
            child: _BrandTile(
              productImage: b.productImage,
              brandName: b.name,
              brandLogo: b.logo,
              selected: selected,
              onTap: () => onTap(b.id),
              radius: radius,
              cardHeight: cardHeight,
              popAmount: popAmount,
              logoHeight: logoHeight,
              gap: gap,
            ),
          );
        },
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({
    required this.productImage,
    required this.brandName,
    this.brandLogo,
    required this.onTap,
    required this.selected,
    this.radius = 16,
    this.cardHeight = 56,
    this.popAmount = 12,
    this.logoHeight = 44,
    this.gap = 10,
  });

  final String productImage;
  final String? brandLogo;
  final String brandName;
  final VoidCallback onTap;
  final bool selected;

  final double radius;
  final double cardHeight;
  final double popAmount;
  final double logoHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final totalHeight = popAmount + cardHeight + gap + logoHeight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: totalHeight,
        child: Container(
          child:
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: popAmount,
                left: 0,
                right: 0,
                height: cardHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A424A),
                    borderRadius: BorderRadius.circular(radius),
                    boxShadow: selected
                        ? [BoxShadow(color: const Color(0xFF7B61FF).withOpacity(.25), blurRadius: 8)]
                        : const [],
                  ),
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: cardHeight,
                child: Center(
                  child: Image.asset(productImage, height: 44,width: 26.95,),
                ),
              ),

              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                height: logoHeight,
                child:
                Center(
                  child: brandLogo != null && brandLogo!.isNotEmpty
                      ? Image.asset(brandLogo!, height: logoHeight, fit: BoxFit.contain)
                      : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      brandName,
                      style: getBoldTextStyle(fontSize: 12, color: Colors.black87)
                          .copyWith(height: 1.0),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductsGridOrEmpty extends StatelessWidget {
  const _ProductsGridOrEmpty({required this.controller});
  final CategoryProductsController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.filteredProducts();
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(ManagerImages.product, ),
            const SizedBox(height: 8),
            Text(
                ManagerStrings.noProducts, style: getBoldTextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      );
    }
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: .60,
      ),
      itemBuilder: (context, index) => productItem(model: items[index]),
    );
  }
}

