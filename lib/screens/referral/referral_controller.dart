import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReferralController extends GetxController {
  var isLoading = false.obs;
  var referralCode = ''.obs;
  var playStoreLink = ''.obs;

  var selectedAppType = 'b2c'.obs;
  final List<String> appTypes = ['oms', 'b2c', 'pos'];

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.arhamcorp.approverx';

  @override
  void onInit() {
    super.onInit();
    generateReferralCode();
  }

  Future<void> generateReferralCode() async {
    isLoading(true);
    try {
      if (await Network.isConnected()) {
        var response = await DioClient().post(AppURL.generateReferralCodeURL, {
          'app_type': selectedAppType.value,
        });

        if (response != null && response.data != null) {
          final data = response.data;

          // The API returns { status: true, data: { CODE: "REF_...", PLAY_STORE_LINK: "...", ... } }
          if (data['data'] is Map && data['data']['CODE'] != null) {
            referralCode.value = data['data']['CODE'].toString();
            // Also store the PLAY_STORE_LINK from API
            if (data['data']['PLAY_STORE_LINK'] != null) {
              playStoreLink.value = data['data']['PLAY_STORE_LINK'].toString();
            }
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: 'Failed to generate referral code',
            );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Failed to generate referral code',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
    }
  }

  void copyReferralCode() {
    if (referralCode.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: referralCode.value));
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Referral code copied to clipboard',
        backgroundColor: Colors.green,
      );
    }
  }

  void shareReferralCode() {
    if (referralCode.value.isNotEmpty) {
      // final link = playStoreLink.value.isNotEmpty
      //     ? playStoreLink.value
      //     : '$playStoreUrl&ref=${referralCode.value}';
      final base =
          playStoreLink.value.isNotEmpty ? playStoreLink.value : playStoreUrl;
      // If server-provided link already contains a referral parameter, use as-is
      final containsRef = base.toLowerCase().contains('ref=');
      final link =
          containsRef
              ? base
              : () {
                final separator = base.contains('?') ? '&' : '?';
                // return '$base${separator}ref=${referralCode.value}';
                return '$base';
              }();
      final appLabel = selectedAppType.value.toUpperCase();
      final message =
          'To register on the ApproveRX app, you may use the following referral code: *${referralCode.value}*\nDownload here: $link';
      Share.share(message);
    }
  }
}
