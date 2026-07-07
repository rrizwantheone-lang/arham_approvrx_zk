import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../app/app_colors.dart';

/// Common shimmer view
class CommonAppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  /// Get rectangular shimmer
  const CommonAppShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  /// Get circular shimmer
  const CommonAppShimmer.circular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppColors.colorCBCBCB,
    highlightColor: AppColors.colorCBCBCB,
    period: const Duration(seconds: 2),
    child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: AppColors.colorCBCBCB,
        shape: shapeBorder,
      ),
    ),
  );
}
