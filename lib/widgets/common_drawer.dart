import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_images.dart';
import 'package:arham_b2c/app/app_theme_controller.dart';
import 'package:arham_b2c/screens/account_ledger/account_ledger_view.dart';
import 'package:arham_b2c/screens/firm/firm_view.dart';
import 'package:arham_b2c/screens/home/home_controller.dart';
import 'package:arham_b2c/screens/home/home_view.dart';
import 'package:arham_b2c/screens/order_report/order_report_view.dart';
import 'package:arham_b2c/screens/outstanding/outstanding_view.dart';
import 'package:arham_b2c/screens/profile/profile_new_view.dart';
import 'package:arham_b2c/screens/re_order/re_order_view.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_view.dart';
import 'package:arham_b2c/screens/shop/shop_view.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_view.dart';
import 'package:arham_b2c/widgets/common_app_image.dart';
import 'package:arham_b2c/widgets/common_material_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'common_text.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // DrawerHeader(
            //   decoration: BoxDecoration(color: Colors.teal),
            //   child: Text(
            //     'Navigation',
            //     style: TextStyle(color: Colors.white, fontSize: 24),
            //   ),
            // ),
            DrawerHeader(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              // decoration: BoxDecoration(
              //   color:
              //       PreferenceUtils.getIsTheme()
              //           ? AppColors.colorBlack
              //           : AppColors
              //               .colorWhite, // Set the background color to white
              // ),
              child: const CommonAppImage(
                imagePath: AppImages.icArhamLogo,
                fit: BoxFit.fill, // Keep BoxFit as per your requirement
              ),
      
              // child:  CommonAppImage(
              //   imagePath: AppImages.icAppLogo,
              //   //height: MediaQuery.sizeOf(context).height * 0.3,
              //   fit: BoxFit.contain,
              //   //width: MediaQuery.sizeOf(context).width * 0.8,
              // ),
            ),
            ListTile(
              title: CommonText(text: 'Dashboard'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.back();
                Get.offAll(() => HomeView());
              },
            ),
            ListTile(
              title: CommonText(text: 'Profile'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                //Get.to(() => ProfileView());
                Get.back();
                Get.to(() => ProfileNewView());
              },
            ),
            ListTile(
              title: CommonText(text: 'Add Distributor'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.back();
                Get.to(() => FirmView());
              },
            ),
            ListTile(
              title: CommonText(text: 'Shop'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                //Get.to(() => ShopView());
                Get.back();
                Get.to(() => ShopView());
              },
            ),
      
            ListTile(
              title: CommonText(text: 'Re-Order'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.back();
                Get.to(() => ReOrderView());
              },
            ),
            ListTile(
              title: CommonText(text: 'Shopping Cart'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.back();
                Get.to(
                      () => CartView(),
                  arguments: {
                    'isSales': 'Home',
                  },
                );
              },
            ),
            ListTile(
              title: CommonText(text: 'Order Report'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.back();
                Get.to(() => OrderReportView());
              },
            ),
      
            ListTile(
              title: CommonText(text: 'Account Ledger Report'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.back();
                Get.to(() => AccountLedgerView());
              },
            ),
      
            ListTile(
              title: CommonText(text: 'Outstanding Report'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.back();
                Get.to(() => OutstandingView());
              },
            ),
      
            ListTile(
              title: CommonText(text: 'Sales Register Report'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.back();
                Get.to(() => SalesRegisterView());
              },
            ),
      
            Consumer<AppThemeController>(
              builder: (context, controller, _) {
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  title: CommonText(
                    text: "Theme Mode",
                    fontWeight: AppFontWeight.w600,
                  ),
                  trailing: buildThemeToggle(controller, context),
                );
              },
            ),
      
            ListTile(
              title: CommonText(text: 'Logout'),
              dense: true,
              // reduces vertical space
              visualDensity: VisualDensity(vertical: -4),
              onTap: () {
                Get.dialog(
                  CommonMaterialDialog(
                    title: 'Logout',
                    message: 'Are you sure you want to\nlogout?',
                    yesButtonText: 'Yes',
                    noButtonText: 'No',
                    onConfirm: () {
                      HomeController controller = Get.find<HomeController>();
                      controller.performLogout();
      
                      // PreferenceUtils.setIsLogin(false).then((_) {
                      //   PreferenceUtils.setAuthToken('');
                      //   PreferenceUtils.setLoginUserCode('');
                      //   PreferenceUtils.setLoginUserName('');
                      //   PreferenceUtils.setLoginCustID('');
                      //   PreferenceUtils.setLoginUserRole('');
                      //   PreferenceUtils.setLoginUserPassword('');
                      //   PreferenceUtils.setLoginMobileNO('');
                      //   PreferenceUtils.clearAllPreferences();
                      //
                      //   Get.offAll(() => LoginView());
                      //
                      //   AppSnackBar.showGetXCustomSnackBar(
                      //     message: 'Logout successfully',
                      //     backgroundColor: Colors.green,
                      //   );
                      // });
                    },
                    onCancel: () {
                      Get.back();
                    },
                    isLoading: Get.find<HomeController>().isLogoutLoading,
                  ),
                );
      
                //Get.to(() => const LoginScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget buildThemeToggle(AppThemeController controller, BuildContext context) {
    final selectedIndex = controller.appThemeMode.index;
    final theme = Theme.of(context);

    return Transform.scale(
      scale: 0.8,
      child: ToggleButtons(
        isSelected: List.generate(3, (i) => i == selectedIndex),
        onPressed: (index) {
          controller.setThemeMode(AppThemeMode.values[index]);
        },
        borderRadius: BorderRadius.circular(20),
        selectedColor: theme.colorScheme.onPrimary,
        fillColor: theme.colorScheme.primary,
        color: theme.colorScheme.primary,
        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
        children: const [
          Icon(Icons.wb_sunny), // Light
          Icon(Icons.smartphone), // System
          Icon(Icons.nights_stay), // Dark
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:arham_b2c/app/app_font_weight.dart';
// import 'package:arham_b2c/app/app_images.dart';
// import 'package:arham_b2c/app/app_theme_controller.dart';
// import 'package:arham_b2c/screens/account_ledger/account_ledger_view.dart';
// import 'package:arham_b2c/screens/firm/firm_view.dart';
// import 'package:arham_b2c/screens/home/home_controller.dart';
// import 'package:arham_b2c/screens/home/home_view.dart';
// import 'package:arham_b2c/screens/order_report/order_report_view.dart';
// import 'package:arham_b2c/screens/outstanding/outstanding_view.dart';
// import 'package:arham_b2c/screens/profile/profile_new_view.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_view.dart';
// import 'package:arham_b2c/screens/shop/shop_view.dart';
// import 'package:arham_b2c/widgets/common_app_image.dart';
// import 'package:arham_b2c/widgets/common_material_dialog.dart';
// import 'common_text.dart';
//
// class CommonDrawer extends StatelessWidget {
//   const CommonDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     // Auto resize drawer width between 250 - 400 based on screen width
//     double drawerWidth = (screenWidth * 0.28).clamp(280.0, 400.0);
//
//     return SizedBox(
//       width: drawerWidth,
//       child: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
//               child: const CommonAppImage(
//                 imagePath: AppImages.icArhamLogo,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             _buildTile(context, 'Dashboard', () => Get.offAll(() => HomeView())),
//             _buildTile(context, 'Profile', () => Get.to(() => ProfileNewView())),
//             _buildTile(context, 'Add Distributor', () => Get.to(() => FirmView())),
//             _buildTile(context, 'Shop', () => Get.to(() => ShopView())),
//             _buildTile(context, 'Order Report', () => Get.to(() => OrderReportView())),
//             _buildTile(context, 'Account Ledger Report', () => Get.to(() => AccountLedgerView())),
//             _buildTile(context, 'Outstanding Report', () => Get.to(() => OutstandingView())),
//             _buildTile(context, 'Sales Register Report', () => Get.to(() => SalesRegisterView())),
//
//             Consumer<AppThemeController>(
//               builder: (context, controller, _) {
//                 return ListTile(
//                   dense: true,
//                   visualDensity: const VisualDensity(vertical: -4),
//                   title: CommonText(
//                     text: "Theme Mode",
//                     fontWeight: AppFontWeight.w600,
//                   ),
//                   trailing: buildThemeToggle(controller, context),
//                 );
//               },
//             ),
//
//             _buildTile(context, 'Logout', () {
//               Get.dialog(
//                 CommonMaterialDialog(
//                   title: 'Logout',
//                   message: 'Are you sure you want to\nlogout?',
//                   yesButtonText: 'Yes',
//                   noButtonText: 'No',
//                   onConfirm: () {
//                     HomeController controller = Get.find<HomeController>();
//                     controller.performLogout();
//                   },
//                   onCancel: () {
//                     Get.back();
//                   },
//                   isLoading: Get.find<HomeController>().isLogoutLoading,
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTile(BuildContext context, String title, VoidCallback onTap) {
//     return ListTile(
//       title: CommonText(text: title),
//       dense: true,
//       visualDensity: const VisualDensity(vertical: -4),
//       onTap: () {
//         Get.back(); // Close drawer
//         onTap();
//       },
//     );
//   }
//
//   Widget buildThemeToggle(AppThemeController controller, BuildContext context) {
//     final selectedIndex = controller.appThemeMode.index;
//     final theme = Theme.of(context);
//
//     return Transform.scale(
//       scale: 0.8,
//       child: ToggleButtons(
//         isSelected: List.generate(3, (i) => i == selectedIndex),
//         onPressed: (index) {
//           controller.setThemeMode(AppThemeMode.values[index]);
//         },
//         borderRadius: BorderRadius.circular(20),
//         selectedColor: theme.colorScheme.onPrimary,
//         fillColor: theme.colorScheme.primary,
//         color: theme.colorScheme.primary,
//         constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
//         children: const [
//           Icon(Icons.wb_sunny), // Light
//           Icon(Icons.smartphone), // System
//           Icon(Icons.nights_stay), // Dark
//         ],
//       ),
//     );
//   }
// }

