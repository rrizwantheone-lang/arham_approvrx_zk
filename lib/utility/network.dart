import 'dart:io' show InternetAddress, Platform;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum NetworkSpeed { unknown, slow, moderate, fast }

class Network {
  static Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // ✅ Check for Web platform (dart:io not available)
    // if (kIsWeb) { // Trick to detect Flutter Web
    //   var networkSpeed = _inferNetworkSpeed();
    //   return networkSpeed == NetworkSpeed.fast || networkSpeed == NetworkSpeed.moderate;
    // }

    // ✅ Check for Android & iOS
    if (kIsWeb ||
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      var networkSpeed = _inferNetworkSpeed();
      return networkSpeed == NetworkSpeed.fast ||
          networkSpeed == NetworkSpeed.moderate;
    }

    // ✅ Check for Windows
    if (Platform.isWindows) {
      return await _checkInternetWindows();
    }

    return false;
  }

  // 🖥️ **For Windows: Uses InternetAddress.lookup**
  static Future<bool> _checkInternetWindows() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // 📶 **Network Speed Check**
  static NetworkSpeed _inferNetworkSpeed() {
    if (Duration.zero < const Duration(milliseconds: 500)) {
      return NetworkSpeed.fast;
    } else if (const Duration(milliseconds: 500) <
        const Duration(milliseconds: 1500)) {
      return NetworkSpeed.moderate;
    } else {
      return NetworkSpeed.slow;
    }
  }
}

class Network1 {
  static Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // If there's no Wi-Fi or mobile connection, return false
    //connectivityResult.contains(ConnectivityResult.wifi)
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    // Check actual internet access by pinging a website
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet is working
      }
    } catch (e) {
      return false; // No internet access
    }

    return false; // Default to no internet if unknown
  }
}
