import 'package:arham_b2c/app/app_images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'common_app_image.dart';

class CommonCarouselBanner extends StatefulWidget {
  final List<String> images;
  final double? height;
  final BoxFit? fit;

  const CommonCarouselBanner({
    super.key,
    required this.images,
    this.height,
    this.fit,
  });

  @override
  State<CommonCarouselBanner> createState() => _CommonCarouselBannerState();
}

class _CommonCarouselBannerState extends State<CommonCarouselBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double dynamicHeight =
        widget.height ?? MediaQuery.of(context).size.height * 0.3;
    BoxFit imageFit = widget.fit ?? BoxFit.contain;

    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.primary.withValues(alpha: 0.4);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CarouselSlider.builder(
              itemCount: widget.images.isNotEmpty ? widget.images.length : 1,
              options: CarouselOptions(
                height: dynamicHeight,
                autoPlay: widget.images.isNotEmpty,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  child: CommonAppImage(
                    imagePath:
                        widget.images.isNotEmpty
                            ? widget.images[index]
                            : AppImages.icArhamLogin,
                    height: dynamicHeight,
                    width: double.infinity,
                    fit: imageFit,
                  ),
                );
              },
            ),
            // Custom page indicators
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: _currentIndex == index ? 6.0 : 4.0,
                    width: _currentIndex == index ? 16.0 : 12.0,
                    decoration: BoxDecoration(
                      // color:
                      //     _currentIndex == index
                      //         ? Colors.white.withValues(alpha: 0.9)
                      //         : Colors.white.withValues(alpha: 0.5),

                      color: _currentIndex == index
                          ? activeColor
                          : inactiveColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
