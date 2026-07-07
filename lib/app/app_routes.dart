import 'package:arham_b2c/bindings/reports_binding.dart';
import 'package:arham_b2c/screens/account_ledger/account_ledger_view.dart';
import 'package:arham_b2c/screens/firm/firm_view.dart';
import 'package:arham_b2c/screens/home/home_view.dart';
import 'package:arham_b2c/screens/outstanding/outstanding_view.dart';
import 'package:arham_b2c/screens/profile/profile_new_view.dart';
import 'package:arham_b2c/screens/profile/profile_view.dart';
import 'package:arham_b2c/screens/referral/referral_view.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_view.dart';
import 'package:get/get.dart';

import 'package:arham_b2c/screens/login/login_view.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String customers = '/customers';
  static const String accounts = '/accounts';
  static const String deliverymen = '/deliverymen';
  static const String suppliers = '/suppliers';
  static const String settings = '/settings';
  static const String shop = '/shop';
  static const String cart = '/cart';
  static const String firm = '/firm';
  static const String accountLedger = '/account-ledger';
  static const String outstanding = '/outstanding-report';
  static const String profile = '/profile';
  static const String referral = '/referral';

  static final List<GetPage> pages = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: home, page: () => HomeView()),
    GetPage(name: firm, page: () => FirmView()),
    GetPage(
      name: accountLedger,
      page: () => AccountLedgerView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: outstanding,
      page: () => OutstandingView(),
      binding: ReportsBinding(),
    ),
    GetPage(name: profile, page: () => ProfileNewView()),
    GetPage(
      name: cart,
      page: () => CartView(),
      arguments: {'isSales': 'Sales'},
    ),
    GetPage(name: referral, page: () => ReferralView()),
  ];
}
