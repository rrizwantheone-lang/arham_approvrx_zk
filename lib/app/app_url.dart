class AppURL {
  //ClientUsername : 1 9173919797/9033881931
  //ClientPassword : 1

  // static const String baseClientURL =
  //     "http://192.168.1.12:4002/api/client/"; //TODO : Local
  //
  // static const String baseURL = "http://192.168.1.12:4002/api/"; //TODO: Local

  // static const String baseClientURL =
  //     "https://apidev.arhamcorp.in/api/client/"; //TODO : Stage
  //
  // static const String baseURL =
  //     "https://apidev.arhamcorp.in/api/"; //TODO : Stage

  static const String baseClientURL =
      "https://api.arhamcorp.in/api/client/"; //TODO : Production

  static const String baseURL =
      "https://api.arhamcorp.in/api/"; //TODO : Production

  //Start region

  static String loginWithMobileURL = "${baseClientURL}login-mobile";
  static String loginWithMobileVerifyOTPURL =
      "${baseClientURL}verify-otp-mobile";
  static String loginURL = "${baseClientURL}login";
  static String signUPURL = "${baseClientURL}signup";
  static String verifyOTPURL = "${baseClientURL}verify-otp";
  static String resendOTPURL = "${baseClientURL}resend-otp";
  static String isVerifiedOTPURL = "${baseClientURL}isverified";
  static String forgotPasswordURL = "${baseClientURL}forgot-password";
  static String resetPasswordURL = "${baseClientURL}reset-password";
  static String changePasswordURL = "${baseClientURL}change-password";
  static String checkUserURL = "${baseClientURL}check-client";
  static String changeFirmURL = "${baseClientURL}change-firm";

  static String getFirmURL = "${baseClientURL}sc-firm";
  static String distributorFirmURL = "${baseClientURL}firm-list";
  static String sendRequest = "${baseClientURL}request-firm";
  static String dropdownFirmURL = "${baseClientURL}firm";
  static String departmentURL = "${baseClientURL}dept";
  static String dashboardURL = "${baseURL}dashboard-images";

  static String accountLedgerReportURL =
      "${baseClientURL}reports/account-ledger";
  static String outstandingReportURL =
      "${baseClientURL}reports/party-outstanding-report";
  static String saleRegisterReportURL =
      "${baseClientURL}reports/sales-register-report";
  static String orderReportURL = "${baseClientURL}reports/orders";
  static String partyWiseItemWiseSalesReportURL =
      "${baseClientURL}reports/party-wise-item-sale-report";
  static String partyWiseItemWiseOrderReportURL =
      "${baseClientURL}reports/party-wise-item-order";

  //static String orderProductURL = "${baseClientURL}products";
  static String orderProductURL = "${baseClientURL}productsb2c";
  static String orderCartURL = "${baseClientURL}cart";
  static String orderOrderURL = "${baseClientURL}orders";

  static String profileURL = "${baseClientURL}profile";
  static String logoutURL = "${baseURL}logout";

  static String generateReferralCodeURL = "${baseURL}referral/generate-code";

  //end region
}
