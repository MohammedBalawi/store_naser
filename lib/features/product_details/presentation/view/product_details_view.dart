import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_icon_size.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/service/image_service.dart';
import '../../../../core/service/notifications_service.dart';
import '../../../../core/widgets/rating_header_bar.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../../../../../core/widgets/main_button.dart';
import '../../../home/presentation/model/products_list_item_model.dart';
import '../../../home/presentation/view/widget/brand_banners.dart';
import '../../../home/presentation/view/widget/products_list.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  bool isLoading = true;

  late int id;
  late String name;
  late String image;
  late int price;
  late int rate;
  late int rateCount;
  late int favorite;
  late int availableQuantity;
  late String sku;
  late String type;
  late String color;
  late String size;
  late int sellingPrice;
  late int discountRatio;
  late int sentence;
  late String priceExpiry;

  // حالات العرض
  bool showAllComments = false;
  bool isWholesaler = false;
  Timer? _timer;

  final List<Shade> _shades = const [
    Shade(Color(0xFFD1A07E), 'بني 4'),
    Shade(Color(0xFFC48A63), 'بني 6'),
    Shade(Color(0xFFEFC1A8), 'وردي 8'),
    Shade(Color(0xFFE7A487), 'وردي 10'),
    Shade(Color(0xFFE9B39B), 'وردي 12'),
    Shade(Color(0xFFB16136), 'بني فاتح'),
    Shade(Color(0xFF6B2C1E), 'بني'),
    Shade(Color(0xFFD0834E), 'متوسط'),
  ];
  int _shadeIdx = 3;
  final List<String> _volumes = ['50ml','90ml'];
  int _volIdx = 0;
  final List<String> _sizes = ['56','54','52','50','60','58'];
  String _sizeSel = '50';

  final _page = PageController();
  int _pageIndex = 0;
  final bannerImages = [
    ManagerImages.f_1,
    ManagerImages.f_2,
    ManagerImages.f_1,
    ManagerImages.f_2,
  ];

  int _tab = 0;

  final _scroll = ScrollController();
  final _nameKey = GlobalKey();
  double _triggerOffset = 280;
  bool _showTitle = false;

  void _onScroll() {
    final v = _scroll.offset >= _triggerOffset;
    if (v != _showTitle && mounted) setState(() => _showTitle = v);
  }

  void _calcTrigger() {
    final ctx = _nameKey.currentContext;
    final ro = ctx?.findRenderObject() as RenderBox?;
    if (ro == null) return;
    final pos = ro.localToGlobal(Offset.zero); // موضع الاسم على الشاشة
    _triggerOffset = (_scroll.offset + pos.dy) - kToolbarHeight - 8;
    _onScroll();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('product_id') ?? 0;
    name = prefs.getString('product_name') ?? '';
    image = prefs.getString('product_image') ?? '';
    price = prefs.getInt('product_price') ?? 0;
    rate = prefs.getInt('product_rate') ?? 0;
    rateCount = prefs.getInt('product_rate_count') ?? 0;
    favorite = prefs.getInt('product_favorite') ?? 0;
    availableQuantity = prefs.getInt('product_quantity') ?? 0;
    sku = prefs.getString('product_sku') ?? '';
    type = prefs.getString('product_type') ?? '';
    sellingPrice = prefs.getInt('product_selling_price') ?? 0;
    discountRatio = prefs.getInt('product_discount_Ratio') ?? 0;
    color = prefs.getString('product_color') ?? '';
    size = prefs.getString('product_size') ?? '';
    sentence = prefs.getInt('product_sentence') ?? 0;
    // isWholesaler = await Get.find<HomeController>().checkIfWholesale();

    setState(() => isLoading = false);
  }

  Future<void> fetchProductDataFromSupabase() async {
    final supabase = Supabase.instance.client;
    final res = await supabase
        .from('products')
        .select(
      'name,image,price,price_expiry,rate,selling_price,available_quantity,sku,type,discount_ratio,color,size,sentence',
    )
        .eq('id', id)
        .maybeSingle();

    if (res != null && mounted) {
      priceExpiry = res['price_expiry']?.toString() ?? '';
      DateTime? expiry = res['price_expiry'] != null
          ? DateTime.tryParse(res['price_expiry'])
          : null;
      final isExpired = expiry != null ? DateTime.now().isAfter(expiry) : false;

      setState(() {
        name = res['name'] ?? '';
        image = res['image'] ?? '';
        price = (res['price'] ?? 0).toInt();
        rate = (res['rate'] ?? 0).toInt();
        availableQuantity = (res['available_quantity'] ?? 0).toInt();
        sku = res['sku'] ?? '';
        type = res['type'] ?? '';
        discountRatio = (res['discount_ratio'] ?? 0).toInt();
        color = res['color'] ?? '';
        size = res['size'] ?? '';
        sellingPrice = (res['selling_price'] ?? 0).toInt();
        sentence = (res['sentence'] ?? 0).toInt();
      });

      if (isExpired && res['selling_price'] != 0) {
        await supabase.from('products').update({'selling_price': 0}).eq('id', id);
      }
      if (expiry != null && !isExpired) {
        final d = expiry.difference(DateTime.now());
        _timer?.cancel();
        _timer = Timer(d, fetchProductDataFromSupabase);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    loadData().then((_) async {
      await fetchProductDataFromSupabase();
      WidgetsBinding.instance.addPostFrameCallback((_) => _calcTrigger());
    });
  }

  @override
  void dispose() {
    _page.dispose();
    _timer?.cancel();
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: ManagerColors.primaryColor),
        ),
      );
    }
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        centerTitle: true,
        systemOverlayStyle:
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(
            isArabic ? ManagerImages.arrows : ManagerImages.arrow_left,
          ),
        ),
        title: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _showTitle ? 1 : 0,
          child: Text(
            sku,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldTextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 56,
      ),

      body: ListView(
        controller: _scroll,
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        children: [
          SizedBox(height: ManagerHeight.h16),

          SizedBox(
            height: 340,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _page,
                  itemCount: 3,
                  onPageChanged: (i) => setState(() => _pageIndex = i),
                  itemBuilder: (_, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageService.networkImage(path: image),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: ManagerHeight.h20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final isActive = _pageIndex == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? ManagerColors.bongrey
                      : ManagerColors.gray_light,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),

          SizedBox(height: ManagerHeight.h10),

          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  name,
                  style: getBoldTextStyle(
                      fontSize: 12, color: ManagerColors.primaryColor),
                ),
              ),
              const SizedBox(width: 35),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ManagerColors.textFieldFillColor,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: const Color(0xFFEEEEEEEE), width: 1),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(ManagerImages.star),
                    const SizedBox(width: 4),
                    Text('4.8',
                        style: getRegularTextStyle(
                            fontSize: 13, color: ManagerColors.grey)),
                    Text(' 100 مراجعة',
                        style: getRegularTextStyle(
                            fontSize: 13, color: ManagerColors.grey)),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  ManagerImages.shares,
                  height: 18,
                  color: ManagerColors.color,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(ManagerImages.favorite),
              ),
            ],
          ),

          SizedBox(height: ManagerHeight.h6),

          Text(
            sku,
            key: _nameKey,
            textAlign: TextAlign.start,
            style: getMediumTextStyle(
                fontSize: ManagerFontSize.s16, color: ManagerColors.black),
          ),

          SizedBox(height: ManagerHeight.h12),

          _BnplCard(
            bg: const Color(0xFFEAF9F2),
            border: const Color(0xFF5BFEAF),
            logoText: 'tabby',
            text: 'حدد تابى عند الدفع لمعرفة المزيد',
            icon: ManagerImages.tabby,
            height: 35,
          ),
          const SizedBox(height: 15),
          _BnplCard(
            bg: const Color(0xFFFAF3E9),
            border: const Color(0xFFF1CB82),
            logoText: 'tamara',
            text: 'اختر تمارا عند الدفع لتعرف على المزيد',
            icon: ManagerImages.tamara,
            height: 45,
          ),

          SizedBox(height: ManagerHeight.h10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: getBoldTextStyle(
                          fontSize: 16, color: ManagerColors.black),
                      children: [
                        const TextSpan(text: 'اللون : '),
                        TextSpan(
                          text: _shades[_shadeIdx].label,
                          style: getBoldTextStyle(
                              fontSize: 18, color: ManagerColors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(_shades.length, (i) {
                  final shade = i == 1
                      ? Shade(_shades[i].color, _shades[i].label,
                      available: false)
                      : _shades[i];
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12),
                    child: _shadeDot(
                      shade: shade,
                      selected: _shadeIdx == i,
                      onTap: shade.available
                          ? () => setState(() => _shadeIdx = i)
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: getBoldTextStyle(
                          fontSize: 16, color: ManagerColors.black),
                      children: [
                        const TextSpan(text: 'الحجم : '),
                        TextSpan(
                          text: _volumes[_volIdx],
                          style: getBoldTextStyle(
                              fontSize: 18, color: ManagerColors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: List.generate(_volumes.length, (i) {
                    final sel = _volIdx == i;
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _volIdx = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: sel
                              ? const Color(0xFFF3F0F7)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                            sel ? Colors.transparent : Colors.black12,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _volumes[i],
                          style: getBoldTextStyle(
                            fontSize: 16,
                            color: sel
                                ? ManagerColors.color
                                : ManagerColors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: getBoldTextStyle(
                          fontSize: 16, color: ManagerColors.black),
                      children: [
                        const TextSpan(text: 'المقاس : '),
                        TextSpan(
                          text: _sizeSel,
                          style: getBoldTextStyle(
                              fontSize: 18, color: ManagerColors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _sizes.map((s) {
                    final sel = _sizeSel == s;
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => _sizeSel = s),
                      child: Container(
                        width: 74,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sel
                              ? const Color(0xFFF3F0F7)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                            sel ? Colors.transparent : Colors.black12,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          s,
                          style: getBoldTextStyle(
                            fontSize: 16,
                            color: sel
                                ? ManagerColors.color
                                : ManagerColors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),

          const SizedBox(height: 10),

          _PriceBlock(
            price: price,
            sellingPrice: sellingPrice,
            discountRatio: discountRatio,
            isWholesaler: isWholesaler,
            sentence: sentence,
          ),

          SizedBox(height: ManagerHeight.h10),
          Text(
            'شامل ضريبة القيمة المضافة',
            style: getRegularTextStyle(
                fontSize: 14, color: ManagerColors.black),
          ),
          SizedBox(height: ManagerHeight.h12),

          mainButton(
            onPressed: () => _addToCart(),
            buttonName: 'أضف إلى حقيبتي',
            color: ManagerColors.color,
            image: ManagerImages.shopping_bag,
          ),

          const SizedBox(height: 46),

          _TabsHeader(
            tab: _tab,
            onChanged: (t) => setState(() => _tab = t),
          ),
          const SizedBox(height: 10),
          if (_tab == 0)
            _DescriptionSection()
          else
            _SpecsSection(sku: sku, type: type, color: name),

          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: ManagerColors.color,
                      size: 20,
                    ),
                  ),
                  Text(
                    'عرض المزيد',
                    style: getRegularTextStyle(
                        fontSize: 14, color: ManagerColors.color),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _ReviewsSection(productId: id, onSeeAll: () {}),
          const SizedBox(height: 16),

          RatingHeaderBar(
            average: 5.0,
            count: 3242,
            onRateTap: () {
              CacheData.productId = id;
              CacheData.image = image;
              Get.offNamed(Routes.addRate);
            },
          ),
          const SizedBox(height: 16),
          _NoReviewsHint(productId: id, onSeeAll: () {}),
          const SizedBox(height: 16),

          Center(
            child: Text(
              'تمت مشاهدته مؤخرًا',
              style: getBoldTextStyle(
                  fontSize: 20, color: ManagerColors.black),
            ),
          ),
          const SizedBox(height: 16),

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
                  SingleChildScrollView(
                    child: BrandBanners(
                      images: bannerImages,
                      aspectRatio: 3.2,
                      radius: 16,
                      spacing: 12,
                      onTap: (i) {},
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _addToCart() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      Get.snackbar('خطأ', 'يجب تسجيل الدخول');
      return;
    }
    final existing = await supabase
        .from('cart_items')
        .select()
        .eq('user_id', userId)
        .eq('product_id', id)
        .maybeSingle();

    if (existing != null) {
      final currentQty = (existing['quantity'] ?? 1) as int;
      await supabase
          .from('cart_items')
          .update({'quantity': currentQty + 1})
          .eq('id', existing['id']);
    } else {
      await supabase.from('cart_items').insert({
        'user_id': userId,
        'product_id': id,
        'quantity': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
    Get.snackbar('تم', 'تمت الإضافة إلى السلة');
    await addNotification(
      title: 'السلة',
      description: 'تمت إضافة منتج إلى سلة التسوق',
    );
  }
}


class _BnplCard extends StatelessWidget {
  const _BnplCard({
    required this.bg,
    required this.border,
    required this.logoText,
    required this.text,
    required this.icon,
    required this.height,
  });

  final Color bg, border;
  final double height;
  final String logoText, text,icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 6),

          Image.asset(icon,height: height,),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                textAlign: TextAlign.right,
                style: getRegularTextStyle(fontSize: 13, color: ManagerColors.black)),
          ),
          const SizedBox(width: 8),
SvgPicture.asset(ManagerImages.arrow_left,height: 15,),

          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({
    required this.price,
    required this.sellingPrice,
    required this.discountRatio,
    required this.isWholesaler,
    required this.sentence,
  });

  final int price, sellingPrice, discountRatio, sentence;
  final bool isWholesaler;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = !isWholesaler && sellingPrice > 0;
    return Row(
      children: [
        if (isWholesaler) ...[
          Text('$sentence',
              style: getBoldTextStyle(fontSize: 18, color: ManagerColors.greenShade)),
          const SizedBox(width: 8),
          Text('جملة', style: getBoldTextStyle(fontSize: 16, color: ManagerColors.primaryColor)),
        ] else if (hasDiscount) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('$price',
                      style: getRegularTextStyle(fontSize: 16, color: ManagerColors.grey)
                          .copyWith(decoration: TextDecoration.lineThrough)),
                  SizedBox(width: 5,),
                  Image.asset(ManagerImages.ra,height: 15, color: ManagerColors.grey),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(

                  children: [
                    Text('$sellingPrice', style: getBoldTextStyle(fontSize: 20, color: ManagerColors.like)),

                    Image.asset(ManagerImages.ra,height: 15, color: ManagerColors.like),

                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAE5EE),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${discountRatio > 0 ? '$discountRatio%' : 'خصم'}',
                        style: getBoldTextStyle(fontSize: 16, color: ManagerColors.like),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ] else ...[
          Text('$price', style: getBoldTextStyle(fontSize: 20, color: ManagerColors.black)),
          const SizedBox(width: 6),
          Image.asset(ManagerImages.ra,height: 15, color: ManagerColors.black),
        ],

      ],
    );
  }
}

class _TabsHeader extends StatelessWidget {
  const _TabsHeader({required this.tab, required this.onChanged});
  final int tab;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget _item(String title, int idx) {
      final selected = tab == idx;
      return InkWell(
        onTap: () => onChanged(idx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: getMediumTextStyle(
                  fontSize: 16,
                  color: selected ? ManagerColors.color : ManagerColors.black,
                )),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 44,
              color: selected ? ManagerColors.color : Colors.transparent,
            )
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _item('الوصف', 0),
        const SizedBox(width: 22),
        _item('المواصفات', 1),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = getRegularTextStyle(fontSize: 14, color: ManagerColors.black);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('كريم للبشرة شديدة الجفاف والحساسة لترطيب مثالي.',
            style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black)),
        const SizedBox(height: 4),
        Text('تركيبة تحتوي على زيت اللوز الحلو، نياسيناميد، وفيتامين هـ.',
            style: p),
        const SizedBox(height: 4),
        Text('يمنحك راحة فورية وترطيبًا يدوم حتى 48 ساعة.',
            style: p),
        const SizedBox(height: 4),
        Text('يستعيد حاجز الرطوبة الطبيعي للبشرة في أسبوع واحد .',
            style: p),
      ],
    );
  }
}

class _SpecsSection extends StatelessWidget {
  const _SpecsSection({
    required this.sku,
    required this.type,
    required this.color,
  });

  final String sku, type, color;

  @override
  Widget build(BuildContext context) {
    const double labelWidth = 90;
    const double gap = 86;

    Widget specRow(String title, String value) {
      final String v = (value.isEmpty) ? '-' : value;
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: labelWidth,
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: getMediumTextStyle(
                  fontSize: 14,
                  color: ManagerColors.black,
                ),
              ),
            ),
            const SizedBox(width: gap),

            Expanded(
              child: Text(
                v,
                textAlign: TextAlign.right,
                style: getMediumTextStyle(
                  fontSize: 14,
                  color: ManagerColors.gray_taxt,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        specRow('الرعاية', type),
        const SizedBox(height: 15),
        specRow('صياغة', color),
        const SizedBox(height: 15),
        specRow('الباركود', sku),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.productId, required this.onSeeAll});
  final int productId;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Supabase.instance.client
          .from('product_rates')
          .select('rate,title,comment,created_at,username')
          .eq('product_id', productId)
          .order('created_at', ascending: false),
      builder: (_, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final rates = s.data ?? [];
        final shown = rates.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('المراجعات',
                    style: getBoldTextStyle(fontSize: 18, color: ManagerColors.black)),
                TextButton(
                  onPressed: onSeeAll,
                  child: Text('',
                      style: getBoldTextStyle(
                          fontSize: 14, color: ManagerColors.primaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...shown.map((m) => _ReviewCard(m: m)),
          ],
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.m});
  final Map<String, dynamic> m;

  @override
  Widget build(BuildContext context) {
    final title = (m['username'] ?? 'Shreef').toString();
    final date = (m['created_at'] ?? DateTime.now().toString()).toString().split('T').first;
    final comment = (m['comment'] ?? 'جيد جدًا').toString();
    final r = (m['rate'] ?? 5) as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              r,
                  (_) => SvgPicture.asset(ManagerImages.star)
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: getBoldTextStyle(fontSize: 14, color: ManagerColors.black)),
              Text(date, style: getRegularTextStyle(fontSize: 12, color: ManagerColors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          Text(comment, textAlign: TextAlign.right, style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black)),
        ],
      ),
    );
  }
}

class _RecentlyViewedGrid extends StatelessWidget {
  const _RecentlyViewedGrid({required this.mainAxisExtent});
  final double mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: (_, i) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: ManagerColors.background,
                      child: const Center(child: Icon(Icons.image)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE6E6E6), width: 1.2),
                ),
                child: Center(child: SvgPicture.asset(ManagerImages.bag)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Qu Cream',
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldTextStyle(fontSize: 14, color: ManagerColors.black)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('63', style: getBoldTextStyle(fontSize: 14, color: ManagerColors.black)),
                        const SizedBox(width: 4),
                        SvgPicture.asset(ManagerImages.shekelIcon, width: 14, height: 14),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('57%', style: getBoldTextStyle(fontSize: 10, color: ManagerColors.red)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Shade {
  final Color color;
  final String label;
  final bool available;
  const Shade(this.color, this.label, {this.available = true});
}
Widget _shadeDot({
  required Shade shade,
  required bool selected,
  required VoidCallback? onTap,
}) {

  final ring = Container(
    width: 28, height: 28,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: selected ? ManagerColors.color : Colors.transparent,
        width: 2.5,
      ),
    ),
    alignment: Alignment.center,
    child: Container(
      width: 22, height: 22,
      decoration: BoxDecoration(
        color: shade.color,
        shape: BoxShape.circle,
      ),
      child: !shade.available
          ? Center(child: Icon(Icons.close, size: 14, color: Colors.black))
          : null,
    ),
  );

  if (!shade.available) {
    return Opacity(opacity: .8, child: ring);
  }
  return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: ring);
}
class _NoReviewsHint extends StatelessWidget {
  const _NoReviewsHint({required this.productId, required this.onSeeAll});
  final int productId;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase
          .from('product_rates')
          .select('id')
          .eq('product_id', productId)
          .limit(1),
      builder: (_, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        final hasAny = (s.data?.isNotEmpty ?? false);
        if (hasAny) return const SizedBox.shrink();
        return const _NoReviewsIllustration();
      },
    );
  }
}

class _NoReviewsIllustration extends StatelessWidget {
  const _NoReviewsIllustration();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
   SvgPicture.asset(ManagerImages.statrs),

                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'لا توجد مراجعات حتى الآن',
              textAlign: TextAlign.center,
              style: getBoldTextStyle(fontSize: 16, color: ManagerColors.black),
            ),
            const SizedBox(height: 22),
            Text(
              'كن أول من يشارك تجربتك ويساعد الآخرين\nعلى اتخاذ خيار أفضل.',
              textAlign: TextAlign.center,
              style: getRegularTextStyle(
                  fontSize: 16, color: ManagerColors.black),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () {
              },
              child: Text(
                'شاهد جميع المراجعات',
                style: getBoldTextStyle(
                    fontSize: 16, color: ManagerColors.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
