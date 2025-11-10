import 'package:flutter/material.dart';

class BrandBanners extends StatelessWidget {
  const BrandBanners({
    super.key,
    required this.images,
    this.radius = 4,
    this.spacing = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.aspectRatio = 2.2,
    this.onTap,
  });

  final List<String> images;
  final double radius;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final double aspectRatio;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(images.length, (i) {
          final url = images[i];
          return Padding(
            padding: EdgeInsets.only(bottom: i == images.length - 1 ? 0 : spacing),
            child: _BannerCard(
              url: url,
              radius: radius,
              aspectRatio: aspectRatio,
              onTap: () => onTap?.call(i),
            ),
          );
        }),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.url,
    required this.radius,
    required this.aspectRatio,
    this.onTap,
  });

  final String url;
  final double radius;
  final double aspectRatio;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: const Color(0xFFE6E6E6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Image.asset(
                url,
                fit: BoxFit.cover,
                // loadingBuilder: (c, w, p) =>
                // p == null ? w : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                // errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
