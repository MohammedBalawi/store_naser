import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/model/product_model.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_styles.dart';

class FavoritesCarousel extends StatefulWidget {
  final List<ProductModel> items;
  final double height;
  final Duration autoPlayInterval;

  const FavoritesCarousel({
    super.key,
    required this.items,
    this.height = 190,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<FavoritesCarousel> createState() => _FavoritesCarouselState();
}

class _FavoritesCarouselState extends State<FavoritesCarousel> {
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // السلايد نفسه
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            controller: _page,
            padEnds: false,
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
        const SizedBox(height: 10),
        _Dots(length: items.length, index: _index),
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
      final h = c.maxHeight;                  // ارتفاع السلايد (للتناسب)
      final big = (h * 0.27).clamp(34, 56);   // حجم % (مرن)
      final word = (h * 0.20).clamp(26, 44);  // حجم كلمة خصم
      final sub = (h * 0.09).clamp(12, 18);   // حجم السطر الثاني

      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5B7C5), Color(0xFFFFFFFF)], // وردي → أبيض
          ),
        ),
        child: Stack(
          children: [
            // صورة على الأسفل يسار (تشبه اللقطة)
            Positioned(
              left: 8,
              bottom: 0,
              child: SizedBox(
                width: h * 1.45,               // عرض مناسب للصورة
                height: h * 0.85,
                child: imageUrl.isEmpty
                    ? const SizedBox.shrink()
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),

            // النص على اليمين
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 18, 0),
                child: Row(
                  children: [
                    const Spacer(), // يدفع المحتوى لليمين
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 30% خصم
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percent%',
                              textAlign: TextAlign.right,
                              style: getBoldTextStyle(
                                fontSize: big.toDouble(),
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              title, // "خصم"
                              textAlign: TextAlign.right,
                              style: getRegularTextStyle(
                                fontSize: word.toDouble(),
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.02),
                        Text(
                          subtitle,
                          textAlign: TextAlign.right,
                          style: getRegularTextStyle(
                            fontSize: sub.toDouble(),
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
