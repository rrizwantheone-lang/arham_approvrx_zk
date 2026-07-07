import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common_text.dart';

class AppHints {
  static final reportsFilterHintShown = false.obs;
}

const double bubbleWidth = 320.0;
class FilterHintBubble extends StatelessWidget {
  final VoidCallback onClose;
  final double arrowLeft; // 👈 dynamic horizontal position

  const FilterHintBubble({
    required this.onClose,
    required this.arrowLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Stack(
        clipBehavior: Clip.none,
        children: [
          // Bubble
          Container(
            width: bubbleWidth,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF004881),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonText(
                    text:
                    'Use the date filter to change the date range for the reports.',
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Triangle (positioned manually)
          Positioned(
            top: 0,
            left: arrowLeft,
            child: CustomPaint(
              size: const Size(20, 10),
              painter: TrianglePainter(Color(0xFF004881)),
            ),
          ),
        ],
      );
    });
  }
}


class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



class SimpleFilterHintBubble extends StatelessWidget {
  final VoidCallback onClose;

  const SimpleFilterHintBubble({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            CustomPaint(
              size: const Size(24, 12),   // width 24, height 12
              painter: TrianglePainter(const Color(0xFF004881)),
            ),
            SizedBox(width: 10,),
          ],
        ),
        Container(
          width: 350,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF004881),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommonText(
                  text: 'Use the date filter & search to refine your reports.',
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}