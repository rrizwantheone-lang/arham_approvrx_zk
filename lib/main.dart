import 'dart:ui';

import 'package:arham_b2c/app/app_theme.dart' show AppTheme;
import 'package:arham_b2c/app/app_theme_controller.dart';
import 'package:arham_b2c/bindings/app_binding.dart';
import 'package:arham_b2c/screens/home/home_screen.dart';
import 'package:arham_b2c/screens/home/home_view.dart';
import 'package:arham_b2c/screens/login/login_view.dart';
import 'package:arham_b2c/screens/shop/distributor/distributor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:provider/provider.dart';

import 'app/app_routes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //AppStatusBar.setStatusBarStyle(statusBarColor: AppColors.teal.shade900);

  // if (PreferenceUtils.getIsLogin()) {
  //   Get.offAll(() => HomeView());
  // } else {
  //   Get.offAll(() => LoginView());
  // }

  //runApp(MyApp());

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<AppThemeController>(context);

    // Get.put(DistributorController(), permanent: true);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ApproveRx',
      //theme: AppTheme.themeData,
      themeMode: themeController.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // initialRoute: _getInitialRoute(),
      // initialBinding: AppBinding(),
      getPages: AppRoutes.pages,
      home: PreferenceUtils.getIsLogin() ? HomeScreen() : LoginView(),
    );
  }
}


// TODO: ApproveRx APP Point:
// Android Mobile - All Fine
// Chorme, Edge Browser(Web) - Singup Not Create - Issue
// Window Deskstop - Teams & Condition , Privacy Policy - Issue
// IOS Mobile - Pending
// IOS Deskstop - Pending
// IOS Safari Browser (Web)- Pending