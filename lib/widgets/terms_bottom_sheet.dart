import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottomSheetWithWebView extends StatefulWidget {
  final String url;

  const BottomSheetWithWebView({super.key, required this.url});

  @override
  State<BottomSheetWithWebView> createState() => _BottomSheetWithWebViewState();
}

class _BottomSheetWithWebViewState extends State<BottomSheetWithWebView> {
  late final WebViewController controller;
  RxInt loadingProgress = 0.obs; // Track loading progress

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                loadingProgress.value = progress; // Update progress bar
              },
              onPageFinished: (String url) {
                loadingProgress.value = 100; // Loading complete
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url)); // Load dynamic URL
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Draggable Scrollable Bottom Sheet
        DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ), // Rounded corners
                ),
                child: Column(
                  children: [
                    // Progress Bar
                    if (loadingProgress.value < 100)
                      LinearProgressIndicator(
                        value: loadingProgress.value / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),

                    // Scrollable WebView
                    Expanded(
                      child: NotificationListener<
                        OverscrollIndicatorNotification
                      >(
                        onNotification: (overscroll) {
                          overscroll
                              .disallowIndicator(); // Hide glow effect on scroll
                          return true;
                        },
                        child: SingleChildScrollView(
                          controller: scrollController, // Allow scrolling
                          child: SizedBox(
                            height:
                                MediaQuery.of(context).size.height *
                                0.9, // Set height
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: WebViewWidget(controller: controller),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Close Button (Floating Above Bottom Sheet)
        Positioned(
          top: 40, // Position outside the bottom sheet
          right: 16,
          child: InkWell(
            onTap: () => Get.back(),
            child: CircleAvatar(
              backgroundColor: Colors.black54.withValues(alpha: 0.5),
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
