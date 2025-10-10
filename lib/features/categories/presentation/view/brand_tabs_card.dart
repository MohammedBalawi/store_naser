import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_radius.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/widgets/text_field.dart';
import '../controller/categories_controller.dart';

class BrandTabsCard extends StatelessWidget {
  BrandTabsCard({super.key});

  final _radius = 10.0;

  final _cats = <({String id, String title, String image})>[
    (id: 'bogo',    title: 'مجّانًا 1 + 1',      image: ManagerImages.make),
    (id: 'offers',  title: 'العروض',             image: ManagerImages.make),
    (id: 'new',     title: 'جديد',               image: ManagerImages.make),
    (id: 'perfume', title: 'عطر',                image: ManagerImages.make),
    (id: 'skin',    title: 'العناية بالبشرة',     image: ManagerImages.make),
    (id: 'makeup',  title: 'مكياج',              image: ManagerImages.make),
    (id: 'lenses',  title: 'العدسات اللاصقة',     image: ManagerImages.make),
    (id: 'bag',     title: 'حقيبة نسائية',       image: ManagerImages.make),
    (id: 'abaya',   title: 'عبايات',             image: ManagerImages.make),
    (id: 'device',  title: 'جهاز تجميلي',        image: ManagerImages.make),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    const Color pageBg = ManagerColors.background; // أخضر فاتح لكل الصفحة

    return GetBuilder<CategoriesController>(
      builder: (c) {
        return ColoredBox(
          color: pageBg, // ← هنا الخلفية الخضراء للصفحة كلها
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _TopSearchBar(radius: _radius)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: _Banner(
                    image:
                    'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=1600&auto=format&fit=crop',
                    height: w * 0.42,
                    radius: _radius,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 12, bottom: 2),
                  child: Text(
                    'التصنيف',
                    style: getBoldTextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 0, bottom: 5),
                  child: const Text(
                    '',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 12,
                    childAspectRatio: .95,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, i) {
                      final it = _cats[i];
                      return _CategoryTileBox(
                        title: it.title,
                        image: it.image,
                        onTap: () => c.navigateToProducts(id: it.id, name: it.title),
                      );
                    },
                    childCount: _cats.length,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: _Banner(
                    image:
                    'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=1600&auto=format&fit=crop',
                    height: w * 0.42,
                    radius: _radius,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '',
                    style: getBoldTextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'العلامات التجارية',
                    style: getBoldTextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 28, 12, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 14,
                    childAspectRatio: .86,
                  ),
                  delegate: SliverChildListDelegate(
                    [
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: ManagerImages.news,
                        brandName: 'CeraVe',
                        onTap: () => c.navigateToProducts(id: 'cerave', name: 'CeraVe'),
                      ),
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: ManagerImages.news,
                        brandName: 'Cetaphil',
                        onTap: () => c.navigateToProducts(id: 'cetaphil', name: 'Cetaphil'),
                      ),
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: ManagerImages.news,
                        brandName: 'Neutrogena',
                        onTap: () => c.navigateToProducts(id: 'neutrogena', name: 'Neutrogena'),
                      ),
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: ManagerImages.news,
                        brandName: 'NOW',
                        onTap: () => c.navigateToProducts(id: 'now', name: 'NOW'),
                      ),
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: null,
                        brandName: 'DERCOS',
                        onTap: () => c.navigateToProducts(id: 'dercos', name: 'DERCOS'),
                      ),
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: ManagerImages.news,
                        brandName: 'Neutrogena',
                        onTap: () => c.navigateToProducts(id: 'neutrogena', name: 'Neutrogena'),
                      ),
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: ManagerImages.news,
                        brandName: 'NOW',
                        onTap: () => c.navigateToProducts(id: 'now', name: 'NOW'),
                      ),
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: null,
                        brandName: 'DERCOS',
                        onTap: () => c.navigateToProducts(id: 'dercos', name: 'DERCOS'),
                      ),
                      _BrandTile(
                        productImage: ManagerImages.make,
                        brandLogo: ManagerImages.news,
                        brandName: 'Neutrogena',
                        onTap: () => c.navigateToProducts(id: 'neutrogena', name: 'Neutrogena'),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const SizedBox(height: 50),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ====================== أجزاء واجهة مُعادة الاستخدام ====================== */

class _TopSearchBar extends StatelessWidget {
  const _TopSearchBar({required this.radius});
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
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
                      prefixIcon: SizedBox(
                        width: 28, height: 28,
                        child: Center(
                          child: SvgPicture.asset(
                            ManagerImages.sarch,
                            width: 25, height: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.favoriteView),
                child: SvgPicture.asset(ManagerImages.love),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.image, required this.height, required this.radius});
  final String image;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AspectRatio(
        aspectRatio: 16 / 7.0,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class _CategoryTileBox extends StatelessWidget {
  const _CategoryTileBox({
    required this.title,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 48,
                width: 107,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE9ECF1)),
                ),
              ),
              Positioned(
                top: -20,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    image,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: getBoldTextStyle(fontSize: 12, color: Colors.black),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
    this.cardColor = const Color(0xFF3A424A),
    this.radius = 18,
    this.cardHeight = 86,
    this.popAmount = 18,
    this.imageHeight = 88,
  });

  final String productImage;
  final String? brandLogo;
  final String brandName;
  final VoidCallback onTap;

  final Color cardColor;
  final double radius;
  final double cardHeight;
  final double popAmount;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Positioned(
                top: -popAmount,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    productImage,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (brandLogo != null && brandLogo!.isNotEmpty)
            Image.asset(brandLogo!, height: 22, fit: BoxFit.contain)
          else
            Text(
              brandName,
              style: getBoldTextStyle(fontSize: 12, color: Colors.black),
            ),
        ],
      ),
    );
  }
}
