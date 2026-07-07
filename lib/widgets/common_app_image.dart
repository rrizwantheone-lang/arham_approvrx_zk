import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/app_images.dart';
import 'common_shimmer.dart';

/// Common app image which handles network, assets, local file paths, and SVGs
class CommonAppImage extends StatelessWidget {
  final String imagePath;
  final double radius;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isCircle;
  final Color? color;

  const CommonAppImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.radius = 0,
    this.isCircle = false,
    this.fit = BoxFit.cover,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: isCircle ? null : BorderRadius.circular(radius),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child:
          imagePath.isEmpty
              ? Image.asset(
                AppImages.icBackGround,
                height: height,
                width: width,
              )
              : _buildImageWidget(),
    );
  }

  // Widget _buildImageWidget1() {
  //   if (imagePath.startsWith('http')) {
  //     // Handle network images (both raster and SVG)
  //     if (imagePath.endsWith('.svg')) {
  //       return SvgPicture.network(
  //         imagePath,
  //         height: height,
  //         width: width,
  //         fit: fit,
  //         colorFilter: ColorFilter.mode(
  //           color ?? Colors.transparent,
  //           BlendMode.srcIn, // Use a blend mode as per your requirement
  //         ),
  //         placeholderBuilder: (context) => CommonAppShimmer.rectangular(
  //           height: height ?? 50,
  //         ),
  //       );
  //     }
  //     return CachedNetworkImage(
  //       imageUrl: imagePath,
  //       height: height,
  //       width: width,
  //       fit: fit,
  //       color: color,
  //       placeholder: (context, url) => CommonAppShimmer.rectangular(
  //         height: height ?? 50,
  //       ),
  //       errorWidget: (context, url, error) => Image.asset(
  //         AppImages.icBackGround,
  //         height: height,
  //         width: width,
  //       ),
  //     );
  //   } else if (imagePath.contains('assets')) {
  //     // Handle asset images (both raster and SVG)
  //     if (imagePath.endsWith('.svg')) {
  //       return SvgPicture.asset(
  //         imagePath,
  //         height: height,
  //         width: width,
  //         fit: fit,
  //         colorFilter: ColorFilter.mode(
  //           color ?? Colors.transparent,
  //           BlendMode.srcIn, // Use a blend mode as per your requirement
  //         ),
  //       );
  //     }
  //     return Image.asset(
  //       imagePath,
  //       height: height,
  //       width: width,
  //       fit: fit,
  //       color: color,
  //     );
  //   } else {
  //     // Handle local file paths
  //     if (imagePath.endsWith('.svg')) {
  //       return SvgPicture.file(
  //         File(imagePath),
  //         height: height,
  //         width: width,
  //         fit: fit,
  //         colorFilter: ColorFilter.mode(
  //           color ?? Colors.transparent,
  //           BlendMode.srcIn, // Use a blend mode as per your requirement
  //         ),
  //       );
  //     }
  //     return Image.file(
  //       File(imagePath),
  //       height: height,
  //       width: width,
  //       fit: fit,
  //       color: color,
  //     );
  //   }
  // }

  Widget _buildImageWidget() {
    if (imagePath.startsWith('http')) {
      // Handle network images (both raster and SVG)
      if (imagePath.endsWith('.svg')) {
        return SvgPicture.network(
          imagePath,
          height: height,
          width: width,
          fit: fit,
          colorFilter: ColorFilter.mode(
            color ?? Colors.transparent,
            BlendMode.srcIn, // Use a blend mode as per your requirement
          ),
          placeholderBuilder:
              (context) => CommonAppShimmer.rectangular(height: height ?? 50),
        );
      }
      return CachedNetworkImage(
        imageUrl: imagePath,
        height: height,
        width: width,
        fit: fit,
        color: color,
        placeholder:
            (context, url) =>
                CommonAppShimmer.rectangular(height: height ?? 50),
        errorWidget:
            (context, url, error) => Image.asset(
              AppImages.icBackGround,
              height: height,
              width: width,
            ),
      );
    } else if (imagePath.contains('assets')) {
      // Handle asset images (both raster and SVG)
      if (imagePath.endsWith('.svg')) {
        return SvgPicture.asset(
          imagePath,
          height: height,
          width: width,
          fit: fit,
          colorFilter: ColorFilter.mode(
            color ?? Colors.transparent,
            BlendMode.srcIn, // Use a blend mode as per your requirement
          ),
        );
      }
      return Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        color: color,
      );
    }

    // Default widget in case none of the conditions match
    return const SizedBox(); // or any default widget
  }
}
