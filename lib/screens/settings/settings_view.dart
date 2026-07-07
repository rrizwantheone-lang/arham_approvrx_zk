import 'package:arham_b2c/app/app_routes.dart';
import 'package:arham_b2c/screens/home/home_screen.dart';
import 'package:arham_b2c/screens/profile/profile_new_view.dart';
import 'package:arham_b2c/widgets/common_app_bar.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app/app_font_weight.dart';
import '../../app/app_theme_controller.dart';
import '../../widgets/common_material_dialog.dart';
import '../../widgets/common_text_button.dart';
import '../change_password/change_view.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';
import '../shop/distributor/distributor_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Person Name: ${controller.personNmController.value.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Settings',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Obx(
                    () => GestureDetector(
                  onTap: (){
                    Get.to(() => ProfileNewView());
                  },
                  child: Card(
                    elevation: 1,
                    shadowColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white60
                        : Colors.grey[850],
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]!
                            : Colors.grey[50]!,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // Icon(Icons.person, size: 35,),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[150],
                              child: Icon(Icons.person, size: 35,),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(text: '${controller.personNmController.value.text}', fontSize: 15, fontWeight: FontWeight.bold,),
                                CommonText(text: '${controller.selectedBusinessType.value}'),
                              ],
                            ),
                            Spacer(),
                            CommonText(text: '${controller.firmNameController.value.text}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              // CommonText(text: 'Theme', fontWeight: FontWeight.w600,),
              // SizedBox(height: 5,),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(() => ChangeView(), transition: Transition.rightToLeftWithFade);
                    },
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15,),

              Row(
                children: [
                  Text("Referral Code:", style: TextStyle(fontWeight: FontWeight.bold),),
                  Spacer(),
                  TextButton(
                    onPressed: (){
                      Get.toNamed(AppRoutes.referral);
                    },
                    child: Row(
                      children: [
                        Text("Generate Code"),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(height: 15,),

              Consumer<AppThemeController>(
                builder: (context, controller, _) {
                  // return ListTile(
                  //   dense: true,
                  //   visualDensity: VisualDensity(vertical: -4),
                  //   title: CommonText(
                  //     text: "Theme Mode",
                  //     fontWeight: AppFontWeight.w600,
                  //   ),
                  //   trailing: buildThemeToggle(controller, context),
                  // );
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: 'Theme Mode',
                        fontWeight: AppFontWeight.w600,
                        fontSize: 17,
                      ),
                      buildThemeToggle(controller, context),
                    ],
                  );
                },
              ),

              SizedBox(height: 15,),

              InkWell(
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

                        BottomNavController bottomNavController = Get.find<BottomNavController>();
                        bottomNavController.selectedIndex.value = 0;

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
                      isLoading: Get.put(HomeController()).isLogoutLoading,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF004881),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CommonText(text: 'Logout', color: Colors.white, textAlign: TextAlign.center,),
                ),
              )

            ],
          ),
        ),
      ),
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

// import 'package:arham_b2c/screens/change_password/change_view.dart';
// import 'package:arham_b2c/screens/home/home_screen.dart';
// import 'package:arham_b2c/screens/profile/profile_new_view.dart';
// import 'package:arham_b2c/widgets/common_app_bar.dart';
// import 'package:arham_b2c/widgets/common_button.dart';
// import 'package:arham_b2c/widgets/common_text.dart';
// import 'package:arham_b2c/widgets/common_text_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
//
// import '../../app/app_font_weight.dart';
// import '../../app/app_theme_controller.dart';
// import '../../widgets/common_material_dialog.dart';
// import '../home/home_controller.dart';
// import '../profile/profile_controller.dart';
// import '../settings/settings_controller.dart';
//
// class SettingsView extends StatefulWidget {
//   const SettingsView({super.key});
//
//   @override
//   State<SettingsView> createState() => _SettingsViewState();
// }
//
// class _SettingsViewState extends State<SettingsView> {
//   // final ProfileController controller = Get.put(ProfileController());
//
//   late final SettingsController controller;
//   final ProfileController profileController = Get.put(ProfileController());
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller = Get.put(SettingsController());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(
//         title: 'Settings',
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Obx(
//                 () => GestureDetector(
//                   onTap: (){
//                     Get.to(() => ProfileNewView());
//                   },
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           // Icon(Icons.person, size: 35,),
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Colors.grey[150],
//                             child: Icon(Icons.person, size: 35,),
//                           ),
//                           SizedBox(width: 10,),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CommonText(text: controller.personName.value, fontSize: 15, fontWeight: FontWeight.bold,),
//                               CommonText(text: profileController.selectedBusinessType.value),
//                             ],
//                           ),
//                           Spacer(),
//                           CommonText(text: controller.firmName.value),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//             ),
//             SizedBox(height: 15,),
//             // CommonText(text: 'Theme', fontWeight: FontWeight.w600,),
//             // SizedBox(height: 5,),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 CommonTextButton(
//                   onPressed: (){
//                     Get.to(() => ChangeView(), transition: Transition.rightToLeftWithFade);
//                   },
//                   title: 'Change Password',
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 15,),
//
//             Consumer<AppThemeController>(
//               builder: (context, controller, _) {
//                 // return ListTile(
//                 //   dense: true,
//                 //   visualDensity: VisualDensity(vertical: -4),
//                 //   title: CommonText(
//                 //     text: "Theme Mode",
//                 //     fontWeight: AppFontWeight.w600,
//                 //   ),
//                 //   trailing: buildThemeToggle(controller, context),
//                 // );
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CommonText(
//                       text: 'Theme Mode',
//                       fontWeight: AppFontWeight.w600,
//                       fontSize: 17,
//                     ),
//                     buildThemeToggle(controller, context),
//                   ],
//                 );
//               },
//             ),
//
//             SizedBox(height: 15,),
//
//             InkWell(
//               onTap: () {
//                 Get.dialog(
//                   CommonMaterialDialog(
//                     title: 'Logout',
//                     message: 'Are you sure you want to\nlogout?',
//                     yesButtonText: 'Yes',
//                     noButtonText: 'No',
//                     onConfirm: () {
//                       HomeController controller = Get.find<HomeController>();
//                       controller.performLogout();
//
//                       BottomNavController bottomNavController = Get.find<BottomNavController>();
//                       bottomNavController.selectedIndex.value = 0;
//
//                       // PreferenceUtils.setIsLogin(false).then((_) {
//                       //   PreferenceUtils.setAuthToken('');
//                       //   PreferenceUtils.setLoginUserCode('');
//                       //   PreferenceUtils.setLoginUserName('');
//                       //   PreferenceUtils.setLoginCustID('');
//                       //   PreferenceUtils.setLoginUserRole('');
//                       //   PreferenceUtils.setLoginUserPassword('');
//                       //   PreferenceUtils.setLoginMobileNO('');
//                       //   PreferenceUtils.clearAllPreferences();
//                       //
//                       //   Get.offAll(() => LoginView());
//                       //
//                       //   AppSnackBar.showGetXCustomSnackBar(
//                       //     message: 'Logout successfully',
//                       //     backgroundColor: Colors.green,
//                       //   );
//                       // });
//                     },
//                     onCancel: () {
//                       Get.back();
//                     },
//                     isLoading: Get.put(HomeController()).isLogoutLoading,
//                   ),
//                 );
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF004881),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: CommonText(text: 'Logout', color: Colors.white, textAlign: TextAlign.center,),
//               ),
//             )
//
//           ],
//         ),
//       ),
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
