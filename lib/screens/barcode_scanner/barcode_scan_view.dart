import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerView extends StatefulWidget {
  final bool isMultipleScan;

  const BarcodeScannerView({super.key, this.isMultipleScan = false});

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView>
    with SingleTickerProviderStateMixin {
  var _isScanned = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final Set<String> _scannedCodes = {};
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Safer barcode handling
  Future<void> _handleBarcodeScan(BarcodeCapture capture) async {
    for (final barcode in capture.barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty && !_scannedCodes.contains(code)) {
        print('Barcode scanned: $code');
        setState(() {
          _scannedCodes.add(code);
        });

        try {
          await _audioPlayer.play(AssetSource('sounds/short_beep.mp3'));
        } catch (e) {
          debugPrint("Audio error: $e");
        }

        if (!widget.isMultipleScan && !_isScanned) {
          _isScanned = true;

          // Small delay to prevent animation issues
          await Future.delayed(const Duration(milliseconds: 300));

          if (mounted) {
            Navigator.pop(context, code);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double scanBoxSize = 250;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcodeScan),
          Center(
            child: Container(
              width: scanBoxSize,
              height: scanBoxSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value * scanBoxSize,
                        left: 0,
                        right: 0,
                        child: Container(height: 2, color: Colors.red),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (widget.isMultipleScan)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scanned Barcodes:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._scannedCodes.map(
                      (barcode) => Text(
                        barcode,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          widget.isMultipleScan
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context, _scannedCodes.toList());
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.check),
              )
              : null,
    );
  }
}
