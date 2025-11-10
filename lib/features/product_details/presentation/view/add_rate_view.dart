// lib/features/product_details/presentation/view/add_rate_view.dart
import 'dart:io';
import 'package:app_mobile/core/cache/app_cache.dart';
import 'package:app_mobile/core/service/image_service.dart';
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


  int? _sentimentTab = 0;
  int? _starsFilter;

  final List<Map<String, dynamic>> _localRates = [];

  final List<Map<String, dynamic>> _serverRates = [];

  @override
  void initState() {
    super.initState();
    productId = CacheData.productId;
    productImage = CacheData.image;

    final c = Get.find<AddRateController>();
    c.resetForm();
  }

  String _labelFor(int r) {
    switch (r) {
      case 5:
        return 'رائع';
      case 4:
        return 'جيد جدًا';
      case 3:
        return 'لقد كان جيدا';
      case 2:
        return 'ليس جيداً جداً';
      case 1:
        return 'مُخيب للآمال';
      default:
        return '';
    }
  }

  List<Map<String, dynamic>> get _allRates => [
    ..._localRates,
    ..._serverRates,
  ];

  List<Map<String, dynamic>> get _filteredRates {
    Iterable<Map<String, dynamic>> list = _allRates;

    if (_starsFilter != null) {
      list = list.where((e) => (e['rate'] ?? 0) == _starsFilter);
      return list.toList();
    }

    if (_sentimentTab == 1) {
      list = list.where((e) => (e['rate'] ?? 0) >= 3); // إيجابية: 3-5
    } else if (_sentimentTab == 2) {
      list = list.where((e) => (e['rate'] ?? 0) <= 2); // سلبية: 1-2
    }

    return list.toList();
  }

  double get _avg => _allRates.isEmpty
      ? 0
      : _allRates.fold<double>(
      0, (s, e) => s + ((e['rate'] ?? 0) as num).toDouble()) /
      _allRates.length;

  void _openAddSheet() {
    final c = Get.find<AddRateController>();
    c.resetForm();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (_) {
        return GetBuilder<AddRateController>(
          builder: (c) {
            final counter = c.comment.text.characters.length;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: ManagerColors.backg,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: SvgPicture.asset(ManagerImages.cansel_icon),
                            splashRadius: 22,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 140,
                            width: 140,
                            child: ImageService.networkImage(path: productImage),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'اسم المنتج ',
                          textAlign: TextAlign.center,
                          style: getBoldTextStyle(
                            fontSize: 16,
                            color: ManagerColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),

                        RatingBar(
                          itemSize: 25,
                          ignoreGestures: false,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 6),
                          initialRating: c.rate,
                          minRating: 0.5,
                          ratingWidget: RatingWidget(
                            full: SvgPicture.asset(ManagerImages.star),
                            half: SvgPicture.asset(ManagerImages.empty_star),
                            empty: SvgPicture.asset(ManagerImages.star_solid),
                          ),
                          onRatingUpdate: c.changeRate,
                          allowHalfRating: false,
                        ),
                        const SizedBox(height: 10),

                        Text(
                          _labelFor(c.rate.round()),
                          style: getBoldTextStyle(
                            fontSize: 18,
                            color: ManagerColors.black,
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'أخبرنا المزيد',
                            style: getBoldTextStyle(
                              fontSize: 16,
                              color: ManagerColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: c.comment,
                          maxLines: 5,
                          maxLength: 500,
                          decoration: InputDecoration(
                            hintStyle: getRegularTextStyle(
                              fontSize: 14,
                              color: ManagerColors.textColorProfile,
                            ),
                            hintText:
                            'اكتب مراجعة لمساعدة الآخرين على معرفة ما هو جيد',
                            counterText: '$counter/500',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: ManagerColors.primaryColor,
                                width: 1.6,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                          onChanged: (_) => c.update(),
                        ),
                        const SizedBox(height: 8),

                        Row(

                          children: [

                            if (c.selectedImages.length < 3) ...[
                              Material(
                                color: Colors.white,
                                shape: const RoundedRectangleBorder(),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: c.pickImages,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(ManagerImages.add_image,height: 50,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: c.selectedImages.length,
                                  separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                                  itemBuilder: (_, i) {
                                    final file = c.selectedImages[i];
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          child: Image.file(
                                            File(file.path),
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: -6,
                                          left: -6,
                                          child: GestureDetector(
                                            onTap: () async {
                                              final ok =
                                              await confirmDeleteImageDialog(
                                                  context);
                                              if (ok) c.removeImageAt(i);
                                            },
                                            child: Container(
                                              width: 22,
                                              height: 22,
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: c.checkButtonEnabled()
                                ? () {
                              final review = c.buildLocalReview();
                              Navigator.pop(context, review);
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.checkButtonEnabled()
                                  ? ManagerColors.color
                                  : ManagerColors.color_off,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white,
                              disabledBackgroundColor: ManagerColors.color_off,
                            ),
                            child: Text(
                              'أرسال',
                              style: getBoldTextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result is Map<String, dynamic>) {
        setState(() {
          _localRates.insert(0, result);
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () => Get.back(),
                child: SvgPicture.asset(ManagerImages.arrows)),
            Text('آراء العملاء',
                style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(width: 42),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
              height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
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

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3ECFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                            (i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.5),
                          child: SvgPicture.asset(ManagerImages.star, height: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _avg.toStringAsFixed(1),
                      style: getRegularTextStyle(
                          fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: _openAddSheet,
                  child: Row(
                    children: [
                      const Icon(Icons.add,
                          color: ManagerColors.color, size: 22),
                      const SizedBox(width: 8),
                      Text('تقييم المنتج',
                          style: getRegularTextStyle(
                              fontSize: 12, color: ManagerColors.color)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          _FiltersBar(
            tab: _sentimentTab,
            onTabChanged: (t) => setState(() {
              _sentimentTab = t;
              _starsFilter = null;
            }),
            stars: _starsFilter,
            onStarsChanged: (s) => setState(() {
              if (_sentimentTab == 0) return;
              _starsFilter = s;
              _sentimentTab = null;
            }),
          ),

          const SizedBox(height: 12),

          if (_filteredRates.isEmpty)
            _EmptyReviews()
          else
            Column(
              children:
              _filteredRates.map((m) => ReviewTile(m: m)).toList(),
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.tab,
    required this.onTabChanged,
    required this.stars,
    required this.onStarsChanged,
  });

  final int? tab;
  final ValueChanged<int> onTabChanged;
  final int? stars;
  final ValueChanged<int?> onStarsChanged;

  @override
  Widget build(BuildContext context) {
    Widget _tab(String t, int i) {
      final selected = tab == i;
      return InkWell(
        onTap: () => onTabChanged(i),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t,
                style: selected
                    ? getBoldTextStyle(
                    fontSize: 16, color: ManagerColors.color)
                    : getMediumTextStyle(
                    fontSize: 16, color: ManagerColors.black),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: 36,
                color:
                selected ? ManagerColors.color : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    Widget _starChip(int v) {
      final bool disabled = tab == 0;
      final bool selected = stars == v;

      final chip = Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Text(
              '$v',
              style: getBoldTextStyle(
                fontSize: 16,
                color: disabled
                    ? Colors.black26
                    : (selected
                    ? ManagerColors.color
                    : ManagerColors.black),
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              ManagerImages.star,
              color: disabled
                  ? Colors.black26
                  : (selected
                  ? ManagerColors.color
                  : ManagerColors.star),
            ),
          ],
        ),
      );

      if (disabled) {
        return Opacity(opacity: .5, child: IgnorePointer(child: chip));
      }
      return InkWell(
        onTap: () => onStarsChanged(selected ? null : v),
        child: chip,
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom:
            BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
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
          const SizedBox(height: 28),
          SvgPicture.asset(ManagerImages.statrs),
          const SizedBox(height: 20),
          Text('لا توجد مراجعات حتى الآن',
              style:
              getBoldTextStyle(fontSize: 18, color: ManagerColors.black)),
          const SizedBox(height: 20),
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
    final String date =
        (widget.m['created_at'] ?? DateTime.now().toString())
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(
                  children: List.generate(
                    r,
                        (_) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 4),
                        child: SvgPicture.asset(ManagerImages.star)),
                  ),
                ),
              ],
            ),

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
                          Text(
                            '$likes',
                            style: getBoldTextStyle(
                              fontSize: 14,
                              color: ManagerColors.black,
                            ),
                          ),
                          const SizedBox(width: 6),
                          liked ?
                          Image.asset(
                              ManagerImages.like_3
                            ,height: 15,

                          ):
                          Image.asset(

                              ManagerImages.like_1
                                  ,height: 15,
                          ),
                          // Icon(
                          //   liked
                          //       ? Icons.thumb_up_alt
                          //       : Icons.thumb_up_alt_outlined,
                          //   size: 20,
                          //   color: liked
                          //       ? ManagerColors.color
                          //       : Colors.black54,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            if (photos.isNotEmpty)
              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(width: 10),
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
                        borderRadius: BorderRadius.circular(8),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: SizedBox(
              height: 72,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.photos.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final p = widget.photos[i];
                      final selected = i == _index;
                      return GestureDetector(
                        onTap: () {
                          _pc.animateToPage(i,
                              duration:
                              const Duration(milliseconds: 250),
                              curve: Curves.easeOut);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selected
                                  ? Colors.white
                                  : Colors.transparent,
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Text(
                'هل أنت متأكد أنك تريد حذف\nهذا العنصر؟',
                textAlign: TextAlign.center,
                style: getBoldTextStyle(
                    fontSize: 16, color: ManagerColors.black),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManagerColors.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize:
                        const Size.fromHeight(48),
                        elevation: 0,
                      ),
                      child: Text('إلغاء',
                          style: getBoldTextStyle(
                              fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManagerColors.like,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize:
                        const Size.fromHeight(48),
                        elevation: 0,
                      ),
                      child: Text('حذف',
                          style: getBoldTextStyle(
                              fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return result == true;
}
