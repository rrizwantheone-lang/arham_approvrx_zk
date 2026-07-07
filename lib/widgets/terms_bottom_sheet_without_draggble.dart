import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottomSheetWithWebViewWithoutDraggable extends StatefulWidget {
  final String url;

  const BottomSheetWithWebViewWithoutDraggable({super.key, required this.url});

  @override
  State<BottomSheetWithWebViewWithoutDraggable> createState() =>
      _BottomSheetWithWebViewWithoutDraggableState();
}

class _BottomSheetWithWebViewWithoutDraggableState
    extends State<BottomSheetWithWebViewWithoutDraggable> {
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
    return Container(
      height:
          MediaQuery.of(context).size.height * 0.85, // Set bottom sheet height
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ), // Rounded corners
      ),
      child: Column(
        children: [
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Get.back(),
            ),
          ),

          // Progress Bar
          Obx(
            () =>
                loadingProgress.value < 100
                    ? LinearProgressIndicator(
                      value: loadingProgress.value / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    )
                    : SizedBox(),
          ),

          // WebView inside Expanded for proper scrolling
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
