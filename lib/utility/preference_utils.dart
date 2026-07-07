import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance ??= await SharedPreferences.getInstance();
    return _prefsInstance!;
  }

  static Future<void> clearAllPreferences() async {
    await _prefsInstance?.clear();
  }

  static Future<bool> setString(String key, String value) {
    return _prefsInstance!.setString(key, value);
  }

  static String getString(String key) {
    return _prefsInstance?.getString(key) ?? '';
  }

  static bool containsKey(String key) {
    return _prefsInstance?.containsKey(key) ?? false;
  }

  static bool getIsTheme() {
    return _prefsInstance?.getBool(Constants.isThemePref) ?? false;
  }

  static Future<bool> setIsTheme(bool isTheme) {
    ArgumentError.checkNotNull(isTheme, Constants.isThemePref);
    return _prefsInstance!.setBool(Constants.isThemePref, isTheme);
  }

  static String getFCMId() {
    return _prefsInstance?.getString(Constants.fcmIdPref) ?? '';
  }

  static Future<bool> setFCMId(String fcmId) {
    ArgumentError.checkNotNull(fcmId, Constants.fcmIdPref);
    return _prefsInstance!.setString(Constants.fcmIdPref, fcmId);
  }

  static bool getIsLogin() {
    return _prefsInstance?.getBool(Constants.isLoginPref) ?? false;
  }

  static Future<bool> setIsLogin(bool isLogin) {
    ArgumentError.checkNotNull(isLogin, Constants.isLoginPref);
    return _prefsInstance!.setBool(Constants.isLoginPref, isLogin);
  }

  static String getAuthToken() {
    return _prefsInstance?.getString(Constants.authTokenPref) ?? '';
  }

  static Future<bool> setAuthToken(String authToken) {
    ArgumentError.checkNotNull(authToken, Constants.authTokenPref);
    return _prefsInstance!.setString(Constants.authTokenPref, authToken);
  }

  static String getDeviceID() {
    return _prefsInstance?.getString(Constants.deviceIDPref) ?? '';
  }

  static Future<bool> setDeviceID(String deviceIDPref) {
    ArgumentError.checkNotNull(deviceIDPref, Constants.deviceIDPref);
    return _prefsInstance!.setString(Constants.deviceIDPref, deviceIDPref);
  }

  static String getLoginUserRole() {
    return _prefsInstance?.getString(Constants.loginUserRolePref) ?? '';
  }

  static Future<bool> setLoginUserRole(String loginUserRole) {
    ArgumentError.checkNotNull(loginUserRole, Constants.loginUserRolePref);
    return _prefsInstance!.setString(
      Constants.loginUserRolePref,
      loginUserRole,
    );
  }

  static String getLoginUserName() {
    return _prefsInstance?.getString(Constants.loginUserNamePref) ?? '';
  }

  static Future<bool> setLoginUserName(String loginUserNamePref) {
    ArgumentError.checkNotNull(loginUserNamePref, Constants.loginUserNamePref);
    return _prefsInstance!.setString(
      Constants.loginUserNamePref,
      loginUserNamePref,
    );
  }

  static String getLoginUserPassword() {
    return _prefsInstance?.getString(Constants.loginUserPasswordPref) ?? '';
  }

  static Future<bool> setLoginUserPassword(String loginUserPasswordPref) {
    ArgumentError.checkNotNull(
      loginUserPasswordPref,
      Constants.loginUserPasswordPref,
    );
    return _prefsInstance!.setString(
      Constants.loginUserPasswordPref,
      loginUserPasswordPref,
    );
  }

  static String getLoginMobileNO() {
    return _prefsInstance?.getString(Constants.loginMobileNOPref) ?? '';
  }

  static Future<bool> setLoginMobileNO(String loginMobileNOPref) {
    ArgumentError.checkNotNull(loginMobileNOPref, Constants.loginMobileNOPref);
    return _prefsInstance!.setString(
      Constants.loginMobileNOPref,
      loginMobileNOPref,
    );
  }

  static String getLoginUserCode() {
    return _prefsInstance?.getString(Constants.loginUserCodePref) ?? '';
  }

  static Future<bool> setLoginUserCode(String loginUserCodePref) {
    ArgumentError.checkNotNull(loginUserCodePref, Constants.loginUserCodePref);
    return _prefsInstance!.setString(
      Constants.loginUserCodePref,
      loginUserCodePref,
    );
  }

  static String getLoginCustID() {
    return _prefsInstance?.getString(Constants.loginCustIDPref) ?? '';
  }

  static Future<bool> setLoginCustID(String loginCustIDPref) {
    ArgumentError.checkNotNull(loginCustIDPref, Constants.loginCustIDPref);
    return _prefsInstance!.setString(
      Constants.loginCustIDPref,
      loginCustIDPref,
    );
  }

  static bool getIsRemember() {
    return _prefsInstance?.getBool(Constants.isRememberPref) ?? false;
  }

  static Future<bool> setIsRemember(bool isRememberPref) {
    ArgumentError.checkNotNull(isRememberPref, Constants.isRememberPref);
    return _prefsInstance!.setBool(Constants.isRememberPref, isRememberPref);
  }

  static String getUserCD() {
    return _prefsInstance?.getString(Constants.userCodePref) ?? '';
  }

  static Future<bool> setUserCD(String userCodePref) {
    ArgumentError.checkNotNull(userCodePref, Constants.userCodePref);
    return _prefsInstance!.setString(Constants.userCodePref, userCodePref);
  }

  static String getFirmID() {
    return _prefsInstance?.getString(Constants.firmIDPref) ?? '';
  }

  static Future<bool> setFirmID(String firmIDPref) {
    ArgumentError.checkNotNull(firmIDPref, Constants.firmIDPref);
    return _prefsInstance!.setString(Constants.firmIDPref, firmIDPref);
  }

  static String getCustID() {
    return _prefsInstance?.getString(Constants.custIDPref) ?? '';
  }

  static Future<bool> setCustID(String custIDPref) {
    ArgumentError.checkNotNull(custIDPref, Constants.custIDPref);
    return _prefsInstance!.setString(Constants.custIDPref, custIDPref);
  }

  static String getSyncID() {
    return _prefsInstance?.getString(Constants.syncIDPref) ?? '';
  }

  static Future<bool> setSyncID(String syncIDPref) {
    ArgumentError.checkNotNull(syncIDPref, Constants.syncIDPref);
    return _prefsInstance!.setString(Constants.syncIDPref, syncIDPref);
  }

  static String getFirmName() {
    return _prefsInstance?.getString(Constants.firmNamePref) ?? '';
  }

  static Future<bool> setFirmName(String firmNamePref) {
    ArgumentError.checkNotNull(firmNamePref, Constants.firmNamePref);
    return _prefsInstance!.setString(Constants.firmNamePref, firmNamePref);
  }

  static String getFirmGSTType() {
    return _prefsInstance?.getString(Constants.firmGSTTypePref) ?? '';
  }

  static Future<bool> setFirmGSTType(String firmGSTTypePref) {
    ArgumentError.checkNotNull(firmGSTTypePref, Constants.firmGSTTypePref);
    return _prefsInstance!
        .setString(Constants.firmGSTTypePref, firmGSTTypePref);
  }

  static String getFirmStateCD() {
    return _prefsInstance?.getString(Constants.firmStateCDPref) ?? '';
  }

  static Future<bool> setFirmStateCD(String firmStateCDPref) {
    ArgumentError.checkNotNull(firmStateCDPref, Constants.firmStateCDPref);
    return _prefsInstance!
        .setString(Constants.firmStateCDPref, firmStateCDPref);
  }

  static String getFirmStateName() {
    return _prefsInstance?.getString(Constants.firmStateNamePref) ?? '';
  }

  static Future<bool> setFirmStateName(String firmStateNamePref) {
    ArgumentError.checkNotNull(firmStateNamePref, Constants.firmStateNamePref);
    return _prefsInstance!
        .setString(Constants.firmStateNamePref, firmStateNamePref);
  }

  static String getFirmObject() {
    return _prefsInstance?.getString(Constants.firmObjectPref) ?? '';
  }

  static Future<bool> setFirmObject(String firmObjectPref) {
    ArgumentError.checkNotNull(firmObjectPref, Constants.firmObjectPref);
    return _prefsInstance!.setString(Constants.firmObjectPref, firmObjectPref);
  }
}
