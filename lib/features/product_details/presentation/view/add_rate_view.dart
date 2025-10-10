// lib/features/product_details/presentation/view/add_rate_view.dart
import 'dart:io';
import 'package:app_mobile/core/cache/app_cache.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/service/image_service.dart';
import 'package:app_mobile/core/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/libs/rating/rating.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_width.dart';
import '../controller/add_rate_controller.dart';

class AddRateView extends StatefulWidget {
  const AddRateView({super.key});

  @override
  State<AddRateView> createState() => _AddRateViewState();
}

class _AddRateViewState extends State<AddRateView> {
  late int productId;
  late String productImage;

  // فلاتر أعلى القائمة
  int _sentimentTab = 0; // 0 الكل | 1 الإيجابية | 2 السلبية
  int? _starsFilter;     // null = الكل, وإلا 5..1

  /// مراجعات محلية فقط (بدون باك-إند)
  final List<Map<String, dynamic>> _localRates = [];

  /// إن أردت دمج مراجعات السيرفر لاحقًا، ضيفها هنا:
  final List<Map<String, dynamic>> _serverRates = [];

  @override
  void initState() {
    super.initState();
    productId = CacheData.productId;
    productImage = CacheData.image;

    // اربط الكنترولر بالمنتج (لو محتاجه لاحقًا)
    final c = Get.find<AddRateController>();
    c.resetForm();
  }
  String _labelFor(int r) {
    switch (r) {
      case 5: return 'رائع';
      case 4: return 'جيد جدًا';
      case 3: return 'لقد كان جيدا';
      case 2: return 'ليس جيداً جداً';
      case 1: return 'مُخيب للآمال';
      default: return '';
    }
  }


  List<Map<String, dynamic>> get _allRates => [
    ..._localRates,  // الأحدث أولًا
    ..._serverRates,
  ];

  List<Map<String, dynamic>> get _filteredRates {
    Iterable<Map<String, dynamic>> list = _allRates;

    // تبويب الإيجابية/السلبية
    if (_sentimentTab == 1) {
      list = list.where((e) => (e['rate'] ?? 0) >= 4);
    } else if (_sentimentTab == 2) {
      list = list.where((e) => (e['rate'] ?? 0) <= 2);
    }

    // تبويب النجوم
    if (_starsFilter != null) {
      list = list.where((e) => (e['rate'] ?? 0) == _starsFilter);
    }

    return list.toList();
  }

  double get _avg =>
      _allRates.isEmpty
          ? 0
          : _allRates.fold<double>(0, (s, e) => s + ((e['rate'] ?? 0) as num).toDouble()) /
          _allRates.length;

  void _openAddSheet() {
    final c = Get.find<AddRateController>();
    c.resetForm();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: GetBuilder<AddRateController>(
            builder: (c) {
              final counter = c.comment.text.characters.length;
              return Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // شريط سحب
                      Container(
                        width: 42,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      // زر إغلاق
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          splashRadius: 22,
                        ),
                      ),

                      // صورة المنتج
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: ImageService.networkImage(path: productImage),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // اسم المنتج
                      Text(
                        'اسم المنتج ',
                        // CacheData.productName ?? 'name product',
                        textAlign: TextAlign.center,
                        style: getBoldTextStyle(
                          fontSize: 16,
                          color: ManagerColors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // النجوم
                      // النجوم (اختيار التقييم)
                      RatingBar(
                        itemSize: 28,
                        ignoreGestures: false,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 6),
                        initialRating: c.rate,
                        minRating: 1,
                        ratingWidget: RatingWidget(
                          full: const Icon(Icons.star, color: Color(0xFFFFC107)),
                          half: const Icon(Icons.star, color: Color(0xFFFFC107)),
                          empty: const Icon(Icons.star_border, color: Colors.black54),
                        ),
                        onRatingUpdate: c.changeRate,
                        allowHalfRating: false,
                      ),
                      const SizedBox(height: 10),

// التسمية أسفل النجوم — تتغير حسب الاختيار
                      Text(
                        _labelFor(c.rate.round()),

                        style: getBoldTextStyle(fontSize: 18, color: ManagerColors.black),
                      ),
                      const SizedBox(height: 18),

                      const SizedBox(height: 18),

                      // العنوان الفرعي
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('أخبرنا المزيد',
                            style: getBoldTextStyle(
                                fontSize: 16, color: ManagerColors.black)),
                      ),
                      const SizedBox(height: 10),

                      // حقل النص + العداد
                      TextField(
                        controller: c.comment,
                        maxLines: 5,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: 'اكتب مراجعة لمساعدة الآخرين على معرفة ما هو جيد',
                          counterText: '$counter/500',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: ManagerColors.primaryColor, width: 1.6),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        onChanged: (_) => c.update(),
                      ),
                      const SizedBox(height: 8),

                      // زر رفع الصور + معاينة
                      Row(
                        children: [
                          // معاينة
                          Expanded(
                            child: SizedBox(
                              height: 64,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: c.selectedImages.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (_, i) {
                                  final file = c.selectedImages[i];
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          File(file.path),
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: -6,
                                        left: -6,
                                        child: GestureDetector(
                                          onTap: () async {
                                            final ok = await confirmDeleteImageDialog(context);
                                            if (ok) {
                                              c.removeImageAt(i);
                                            }
                                          },
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close,
                                                size: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // زر إضافة
                          Material(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: c.selectedImages.length >= c.maxImages
                                  ? null
                                  : c.pickImages,
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, color: ManagerColors.color),
                                    SizedBox(width: 4),
                                    Icon(Icons.image_outlined,
                                        color: ManagerColors.color),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // زر إرسال — يرجّع مراجعة محلية ويضيفها للسّكreen
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: c.checkButtonEnabled()
                              ? () {
                            final review = c.buildLocalReview();
                            Navigator.pop(context, review);
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ManagerColors.color
                                .withOpacity(c.checkButtonEnabled() ? 1 : .35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text('إرسال',
                              style: getBoldTextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 18),

                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).then((result) {
      if (result is Map<String, dynamic>) {
        setState(() {
          _localRates.insert(0, result); // أضف في الأعلى مباشرة
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      appBar: mainAppBar(title: 'آراء العملاء'),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
          children: [
            // بطاقة المنتج في الأعلى (صورة + اسم)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 96,
                      height: 72,
                      child: ImageService.networkImage(path: productImage),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'كريم سيتافيل المرطب - 450 جرام',
                      // CacheData.productName ?? ManagerStrings.product,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularTextStyle(
                          fontSize: 16, color: ManagerColors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // الشريط البنفسجي: تقييم المنتج + | متوسط التقييم
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3ECFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        _avg.toStringAsFixed(1),
                        style: getBoldTextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(width: 6),
                      Row(
                        children: List.generate(
                          5,
                              (i) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.5),
                            child: Icon(Icons.star,
                                size: 20, color: Color(0xFFFFC107)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: _openAddSheet,
                    child: Row(
                      children: [
                        Text('تقييم المنتج',
                            style: getBoldTextStyle(
                                fontSize: 16, color: ManagerColors.color)),
                        const SizedBox(width: 8),
                        const Icon(Icons.add,
                            color: ManagerColors.color, size: 22),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // الفلاتر
            _FiltersBar(
              tab: _sentimentTab,
              onTabChanged: (t) => setState(() => _sentimentTab = t),
              stars: _starsFilter,
              onStarsChanged: (s) => setState(() => _starsFilter = s),
            ),

            const SizedBox(height: 12),

            // القائمة / الحالة الفارغة
            if (_filteredRates.isEmpty)
              _EmptyReviews()
            else
              Column(
                children: _filteredRates
                    .map((m) => ReviewTile(m: m))
                    .toList(),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ---------------- UI widgets ----------------

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.tab,
    required this.onTabChanged,
    required this.stars,
    required this.onStarsChanged,
  });

  final int tab; // 0 الكل | 1 الإيجابية | 2 السلبية
  final ValueChanged<int> onTabChanged;
  final int? stars; // 5..1 أو null
  final ValueChanged<int?> onStarsChanged;

  @override
  Widget build(BuildContext context) {
    Widget _tab(String t, int i) {
      final selected = tab == i;
      return InkWell(
        onTap: () => onTabChanged(i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t,
                style: getBoldTextStyle(
                  fontSize: 16,
                  color: selected ? ManagerColors.color : ManagerColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: 36,
                color: selected ? ManagerColors.color : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    Widget _starChip(int v) {
      final selected = stars == v;
      return InkWell(
        onTap: () => onStarsChanged(selected ? null : v),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Text(
                '$v',
                style: getBoldTextStyle(
                  fontSize: 16,
                  color: selected ? ManagerColors.color : ManagerColors.black,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.star,
                size: 18,
                color: selected ? ManagerColors.color : Colors.black54,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl, // حتى يبدأ السحب من اليمين
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _tab('الكل', 0),
              _tab('الإيجابية', 1),
              _tab('السلبية', 2),
              const SizedBox(width: 16),
              _starChip(5),
              _starChip(4),
              _starChip(3),
              _starChip(2),
              _starChip(1),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}


class _EmptyReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const SizedBox(height: 12),
          SvgPicture.asset(ManagerImages.statrs),
          const SizedBox(height: 12),
          Text('لا توجد مراجعات حتى الآن',
              style: getBoldTextStyle(
                  fontSize: 18, color: ManagerColors.black)),
          const SizedBox(height: 8),
          Text(
            'كن أول من يشارك تجربتك ويساعد الآخرين\n على اتخاذ خيار أفضل.',
            textAlign: TextAlign.center,
            style: getRegularTextStyle(
                fontSize: 14, color: ManagerColors.grey),
          ),
        ],
      ),
    );
  }
}
bool _isNetwork(String s) {
  final l = s.toLowerCase();
  return l.startsWith('http://') || l.startsWith('https://');
}

ImageProvider _providerFrom(String path) {
  if (_isNetwork(path)) return NetworkImage(path);
  if (path.startsWith('file://')) {
    return FileImage(File(Uri.parse(path).toFilePath()));
  }
  return FileImage(File(path));
}



class ReviewTile extends StatefulWidget {
  const ReviewTile({super.key, required this.m});

  /// شكل المراجعة:
  /// {
  ///  'rate': 1..5 (int),
  ///  'username': 'Guest',
  ///  'created_at': '2025-09-13T12:34:56',
  ///  'comment': 'نص التعليق',
  ///  'likes': 1,
  ///  'liked': false,
  ///  'photos': ['local path' أو 'http url', ...]
  /// }
  final Map<String, dynamic> m;

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  late int likes;
  late bool liked;

  @override
  void initState() {
    super.initState();
    likes = (widget.m['likes'] ?? 0) as int;
    liked = (widget.m['liked'] ?? false) as bool;
  }

  void _toggleLike() {
    setState(() {
      liked = !liked;
      likes += liked ? 1 : -1;
      widget.m['likes'] = likes;
      widget.m['liked'] = liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int r = (widget.m['rate'] ?? 0) is int
        ? widget.m['rate'] as int
        : ((widget.m['rate'] ?? 0).toDouble()).round();

    final String user = (widget.m['username'] ?? 'Guest').toString();
    final String date = (widget.m['created_at'] ?? DateTime.now().toString())
        .toString()
        .split('T')
        .first;
    final String comment = (widget.m['comment'] ?? '').toString();
    final List<String> photos =
        (widget.m['photos'] as List?)?.cast<String>() ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // العنوان: الاسم/التاريخ يمين — النجوم يسار
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // يمين: الاسم + التاريخ
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user,
                        style: getBoldTextStyle(
                            fontSize: 16, color: ManagerColors.black)),
                    const SizedBox(height: 4),
                    Text(date,
                        style: getRegularTextStyle(
                            fontSize: 12, color: ManagerColors.black)),
                  ],
                ),
                const Spacer(),
                // يسار: النجوم
                Row(
                  children: List.generate(
                    r,
                        (_) => const Padding(
                      padding: EdgeInsetsDirectional.only(end: 4),
                      child: Icon(Icons.star,
                          size: 18, color: Color(0xFFFFC107)),
                    ),
                  ),
                ),
              ],
            ),

            // التعليق + زر الإعجاب بجواره
            if (comment.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      comment,
                      textAlign: TextAlign.right,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _toggleLike,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            liked
                                ? Icons.thumb_up_alt
                                : Icons.thumb_up_alt_outlined,
                            size: 20,
                            color:
                            liked ? ManagerColors.color : Colors.black54,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$likes',
                            style: getBoldTextStyle(
                              fontSize: 14,
                              color: ManagerColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // شريط الصور (قابل للتمرير أفقيًا)
            if (photos.isNotEmpty)
              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final p = photos[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PhotoViewer(
                              photos: photos,
                              initialIndex: i,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: _providerFrom(p),
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============ شاشة معاينة الصور ============
class PhotoViewer extends StatefulWidget {
  const PhotoViewer({super.key, required this.photos, this.initialIndex = 0});

  final List<String> photos;
  final int initialIndex;

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late final PageController _pc;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.photos.length - 1);
    _pc = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_index + 1}/${widget.photos.length}'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pc,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: widget.photos.length,
            itemBuilder: (_, i) {
              final p = widget.photos[i];
              return Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image(
                    image: _providerFrom(p),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          // شريط مصغّرات للتنقّل
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: SizedBox(
              height: 72,
              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final p = widget.photos[i];
                      final selected = i == _index;
                      return GestureDetector(
                        onTap: () {
                          _pc.animateToPage(i,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                              selected ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: _providerFrom(p),
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Future<bool> confirmDeleteImageDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        backgroundColor: ManagerColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Text(
                'هل أنت متأكد أنك تريد حذف\nهذا العنصر؟',
                textAlign: TextAlign.center,
                style: getBoldTextStyle(fontSize: 16, color: ManagerColors.black),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManagerColors.color, // بنفسجي تطبيقك
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(48),
                        elevation: 0,
                      ),
                      child: Text('إلغاء',
                          style: getBoldTextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManagerColors.like, // لون قريب من لقطة الشاشة
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(48),
                        elevation: 0,
                      ),
                      child: Text('حذف',
                          style: getBoldTextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  // زر إلغاء
                ],
              ),
            ],
          )
        ),
      );
    },
  );
  return result == true;
}

