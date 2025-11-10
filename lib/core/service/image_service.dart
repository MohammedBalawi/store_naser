import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_images.dart';

class ImageService {
  static Widget networkImage(
      {required String path,
      String? defaultImage,
      double? width,
      double? height}) {
    return (path == "NO_IMAGE" || path.isEmpty)
        ? Image.asset(
            defaultImage ?? ManagerImages.logo,
            fit: BoxFit.fill,
            width: width,
            height: height,
          )
        : CachedNetworkImage(
            imageUrl: path,
      fit: BoxFit.fill,

            progressIndicatorBuilder: (
              context,
              url,
              downloadProgress,
            ) =>
                CircularProgressIndicator(
                  color: ManagerColors.primaryColor,
              value: downloadProgress.progress,
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
            ),
            // fit: BoxFit.fill,
          );
  }

  static networkImageContainer({
    required String path,
    String? defaultImage,
  }) {
    return path == "NO_IMAGE"
        ? AssetImage(
            defaultImage ?? ManagerImages.logo,
          )
        : CachedNetworkImageProvider(
            path,
            // imageUrl: path,
            //
            // progressIndicatorBuilder: (
            //   context,
            //   url,
            //   downloadProgress,
            // ) =>
            //     CircularProgressIndicator(
            //   value: downloadProgress.progress,
            // ),
            // errorWidget: (context, url, error) => const Icon(
            //   Icons.error,
            // ),
            // fit: BoxFit.fill,
          );
  }
}
