import 'dart:async';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/features/home/presentation/controller/home_controller.dart';
import 'package:app_mobile/features/home/presentation/model/products_list_item_model.dart';
import 'package:app_mobile/features/home/presentation/view/widget/brand_banners.dart';
import 'package:app_mobile/features/home/presentation/view/widget/home_banner_slider.dart';
import 'package:app_mobile/features/home/presentation/view/widget/brand_tabs.dart';
import 'package:app_mobile/features/home/presentation/view/widget/products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/widgets/text_field.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final bannerImages = [
    ManagerImages.f_1,
    ManagerImages.f_2,
    ManagerImages.f_1,
    ManagerImages.f_2,
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          if (controller.isLoading) {
            return Scaffold(
              backgroundColor: ManagerColors.background,
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                    color: ManagerColors.primaryColor),
              ),
            );
          }

          return Scaffold(
            backgroundColor: ManagerColors.background,
            body: RefreshIndicator(
              onRefresh: () async => controller.homeRequest(),
              color: ManagerColors.primaryColor,
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderArea(
                      items: controller.featuredProducts,
                      onSearchTap: () => Get.toNamed(Routes.search),
                    ),

                    const SizedBox(height: 50),

                    BrandTabs(),

                    HomeBannerSlider(banners: controller.banners),

                    // القوائم حسب التصنيفات
                    Column(
                      children: controller.categories.map((cat) {
                        return Column(
                          children: [
                            productsList(
                              model: ProductsListItemModel(
                                title: cat.name,
                                items: controller.products,
                                route: Routes.products,
                              ),
                            ),
                            BrandBanners(
                              images: bannerImages,
                              aspectRatio: 3.2,
                              radius: 4,
                              spacing: 12,
                              onTap: (i) {},
                            ),
                          ],
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ===== Header (سيرش كبير + سلايدر عروض مع نقاط Overlay ومن غير Overflow)
class _HeaderArea extends StatelessWidget {
  const _HeaderArea({
    required this.items,
    required this.onSearchTap,
    this.height = 330,
  });

  final List<ProductModel> items;
  final VoidCallback onSearchTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    const double searchHeight = 52;
    const double searchSidePadding = 16;
    const double searchTopPadding = 18;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // سلايدر العروض خلف السيرش
          Positioned.fill(
            child: _FavoritesCarouselNoOverflow(
              items: items,
              height: height - 10,
            ),
          ),

          // تدرّج سفلي ناعم
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 30,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      ManagerColors.background.withOpacity(0.75),
                      ManagerColors.background.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // سيرش كبير RTL داخل SafeArea
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                left: searchSidePadding,
                right: searchSidePadding,
                top: searchTopPadding,
              ),
              child: _BigSearch(
                height: searchHeight,
                onTap: onSearchTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BigSearch extends StatelessWidget {
  const _BigSearch({this.height = 52, required this.onTap});
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: SizedBox(
          height: height,
          child: Directionality( // يخلي الأيقونة يمين مثل اللقطة
            textDirection: TextDirection.rtl,
            child: textField(
              fillColor: ManagerColors.white,
              hintText: ManagerStrings.searchProductName,
              controller: TextEditingController(),
              onChange: (_) {},
              validator: (_) => null,
              textInputType: TextInputType.text,
              radius: ManagerRadius.r10,
              // elevation: 6, // إن كان مدعومًا في ويدجت textField عندك
              prefixIcon: SizedBox(
                width: 28,
                height: 28,
                child: Center(
                  child: SvgPicture.asset(
                    ManagerImages.sarch,
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* =================== Favorites Carousel (بدون Overflow) =================== */

class _FavoritesCarouselNoOverflow extends StatefulWidget {
  final List<ProductModel> items;
  final double height;
  final Duration autoPlayInterval;

  const _FavoritesCarouselNoOverflow({
    super.key,
    required this.items,
    this.height = 190,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<_FavoritesCarouselNoOverflow> createState() => _FavoritesCarouselNoOverflowState();
}

class _FavoritesCarouselNoOverflowState extends State<_FavoritesCarouselNoOverflow> {
  late final PageController _page;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _page = PageController(viewportFraction: 1.0);
    if (widget.items.isNotEmpty) {
      _timer = Timer.periodic(widget.autoPlayInterval, (_) {
        if (!mounted || !_page.hasClients) return;
        _index = (_index + 1) % widget.items.length;
        _page.animateToPage(
          _index,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    // ملاحظة مهمة:
    // بدّلنا الـ Column بـ Stack عشان النقاط تكون Overlay
    // وما نزود الارتفاع ونسبب overflow داخل Positioned.fill.
    return Stack(
      fit: StackFit.expand,
      children: [
        // السلايد نفسه
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            controller: _page,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: items.length,
            itemBuilder: (_, i) => _BannerSlide(
              percent: 30,
              title: 'خصم',
              subtitle: 'عن عطورك المفضلة',
              imageUrl: items[i].image ?? '',
            ),
          ),
        ),

        // النقاط فوق (أسفل الزاوية الوسطى)
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: _Dots(length: items.length, index: _index),
        ),
      ],
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({
    required this.percent,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final int percent;
  final String title;
  final String subtitle;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final h = c.maxHeight;
      final big  = (h * 0.27).clamp(34, 56);
      final word = (h * 0.20).clamp(26, 44);
      final sub  = (h * 0.09).clamp(12, 18);

      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5B7C5), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // صورة العرض كبيرة ومتمددة للأسفل
            Positioned(
              left: -16,
              bottom: -26,
              child: SizedBox(
                width: h * 2.10,
                height: h * 1.30,
                child: imageUrl.isEmpty
                    ? const SizedBox.shrink()
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),

            // النصوص بمحاذاة البداية
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 100, 2, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          '$percent%',
                          style: getBoldTextStyle(
                            fontSize: big.toDouble(),
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          title,
                          style: getRegularTextStyle(
                            fontSize: word.toDouble(),
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: getRegularTextStyle(
                        fontSize: sub.toDouble(),
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.length, required this.index});
  final int length;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (length <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 18 : 8,
          decoration: BoxDecoration(
            color: active ? Colors.black.withOpacity(.65) : Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
