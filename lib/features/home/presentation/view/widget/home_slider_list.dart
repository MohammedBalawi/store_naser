import 'package:app_mobile/features/home/domain/model/home_banner_model.dart';
import 'package:flutter/material.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_width.dart';

Widget homeSliderList({
  required List<HomeBannerModel> sliders,
}) {
  return SizedBox(
    height: ManagerHeight.h160,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: sliders.length,
      itemBuilder: (context, index) {
        final banner = sliders[index];
        return Container(
          width: ManagerWidth.w315,
          height: ManagerHeight.h150,
          margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ManagerRadius.r10,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ManagerRadius.r10),
            child: Image.network(
              banner.imageUrl!,
              fit: BoxFit.fill,
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
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        );
      },
    ),
  );
}
