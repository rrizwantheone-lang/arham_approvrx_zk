import 'dart:io';

import 'package:flutter/foundation.dart';

class Constants {
  Constants._();

  //TODO : App Constant
  static get deviceTypePlatform =>
      kIsWeb
          ? 'web'
          : Platform.isAndroid
          ? 'android'
          : 'ios'; // used in api calls

  //TODO : Pref Constants
  static const String isThemePref = 'app_theme_mode';
  static const String isLoginPref = 'isLoginPref';
  static const String fcmIdPref = 'fcmIdPref';
  static const String authTokenPref = 'authTokenPref';
  static const String deviceIDPref = 'deviceIDPref';
  static const String isRememberPref = 'isRememberPref';
  static const String loginUserNamePref = 'loginUserIDPref';
  static const String loginUserRolePref = 'loginUserRolePref';
  static const String loginUserPasswordPref = 'loginUserPasswordPref';
  static const String loginUserCodePref = 'loginUserCodePref';
  static const String loginCustIDPref = 'loginCustIDPref';
  static const String loginMobileNOPref = 'loginMobileNOPref';
  static const String userCodePref = 'userCodePref';
  static const String firmIDPref = 'firmIDPref';
  static const String custIDPref = 'custIDPref';
  static const String syncIDPref = 'syncIDPref';
  static const String firmNamePref = 'firmNamePref';
  static const String firmGSTTypePref = 'firmGSTTypePref';
  static const String firmStateCDPref = 'firmStateCDPref';
  static const String firmStateNamePref = 'firmStateNamePref';
  static const String firmObjectPref = 'firmObjectPref';

  //TODO : Msg Show Constants
  static const String contactMsg = 'Please contact to system admin...';
  static const String networkTitleMsg = 'No Internet connection';
  static const String networkMsg =
      'Please check your internet connection and try again';
  static const String networkRestoreMsg =
      'Internet connected click home button data is restore...';
  static const String noDataMsg = 'No record found...';
  static const String internalServer = 'Sorry, internal server error...';
  static const String badRequest = 'Sorry, bad request...';
  static const String unAuthorizes = 'UnAuthorizes error...';
  static const String timeOutMsg =
      'Oops, Sorry time out, please try after some time...';
  static const String somethingWrongMsg =
      'Something went wrong, please try after some time...';
}
