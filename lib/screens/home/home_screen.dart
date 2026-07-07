import 'package:arham_b2c/screens/firm/firm_view.dart';
import 'package:arham_b2c/screens/home/home_view.dart';
import 'package:arham_b2c/screens/settings/settings_view.dart';
import 'package:arham_b2c/screens/shop/shop_view.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_view.dart';
import 'package:arham_b2c/widgets/common_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../firm/firm_controller.dart';
import '../profile/profile_controller.dart';
import '../shop/distributor/distributor_controller.dart';
import '../shop/shop_controller.dart';
import '../shopping_cart/cart_controller.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final BottomNavController controller = Get.put(BottomNavController());

  // final HomeController homeController = Get.find<HomeController>();

  // final List<Widget> pages = [
  //   HomeView(),
  //   ShopView(),
  //   CartView(),
  //   FirmView(),
  //   ProfileNewView(),
  // ];

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return ShopView();
      case 2:
        return CartView();
      case 3:
        return FirmView();
      case 4:
        return SettingsView();
      default:
        return HomeView();
    }
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _getPage(controller.selectedIndex.value),
        bottomNavigationBar: CommonBottomNavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onItemTapped: controller.changeIndex,
        ),
      ),
    );
  }
}

class BottomNavController extends GetxController {
  // @override
  // void onReady() {
  //   // TODO: implement onReady
  //   super.onReady();
  //   Get.find<HomeController>().allCallAPI();
  // }

  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    if (selectedIndex.value == index) return;

    if (index == 0 && Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().allCallAPI();
    }

    if (index == 1 && Get.isRegistered<ShopController>()) {
      Get.find<ShopController>().fetchCart();
    }

    _deleteController(selectedIndex.value);

    selectedIndex.value = index;

    // switch (index) {
    //   case 0:
    //     Get.find<HomeController>().allCallAPI();
    //     break;
    //   case 1:
    //     Get.find<ShopController>().fetchCart();
    //     break;
    //   case 2:
    //     Get.find<CartController>().fetchCart();
    //     break;
    //   case 3:
    //     Get.find<FirmController>().fetchFirm();
    //     break;
    //   case 4:
    //     Get.find<ProfileController>().fetchProfile();
    //     break;
    // }
  }

  void _deleteController(int index) {
    switch (index) {
      case 0:
        // if (Get.isRegistered<HomeController>()) {
        //   Get.delete<HomeController>();
        // }
        break;
      case 1:
        if (Get.isRegistered<DistributorController>()) {
          Get.find<DistributorController>().resetDistributorState();
        }
        if (Get.isRegistered<ShopController>()) {
          Get.delete<ShopController>();
        }
        break;
      case 2:
        if (Get.isRegistered<CartController>()) {
          Get.delete<CartController>();
        }
        break;
      case 3:
        if (Get.isRegistered<FirmController>()) {
          Get.delete<FirmController>();
        }
        break;
      case 4:
        if (Get.isRegistered<ProfileController>()) {
          Get.delete<ProfileController>();
        }
        break;
    }
  }
}
