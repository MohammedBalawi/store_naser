import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../domain/model/home_banner_model.dart';

class HomeBannerSlider extends StatelessWidget {
  final List<HomeBannerModel> banners;

  const HomeBannerSlider({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return CarouselSlider.builder(
      itemCount: banners.length,
      itemBuilder: (context, index, realIndex) {
        final banner = banners[index];

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            banner.imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: ManagerColors.primaryColor,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color:ManagerColors.greyAccent,
                child: const Center(
                  child: Icon(Icons.broken_image, size: 50, color: ManagerColors.primaryColor),
                ),
              );
            },
          ),
        );
      },
      options: CarouselOptions(
        height: 160,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}
