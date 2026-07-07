import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/screens/barcode_scanner/barcode_scan_view.dart';
import 'package:arham_b2c/screens/shop/distributor/distributor_controller.dart';
import 'package:arham_b2c/screens/shop/product/product_controller.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final ProductController productController = Get.put(ProductController());
  final DistributorController distributorController = Get.put(
    DistributorController(),
  );

  RxList<CartModel> cartItems1 = <CartModel>[].obs; // ✅ Combined cart list

  var isLoading = false.obs;
  Rx<CartResponse> cartList = CartResponse().obs;
  RxList<CartModel> searchList = <CartModel>[].obs; // List to store all groups

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    // ✅ Update cartItems when product or distributor cart changes
    //ever(productController.cartList, (_) => updateCart());
    //ever(distributorController.cartList, (_) => updateCart());

    //updateCart(); // Initial load

    tabController.addListener(() {
      if (tabController.indexIsChanging) return;

      if (tabController.index == 0) {
        // Distributor tab selected
        distributorController.fetchFirm();
      } else if (tabController.index == 1) {
        // Product tab selected
        productController.currentPage.value = 1;
        productController.mainList.value.data?.clear();
        productController.fetchProduct();
      }
    });

    fetchCart();
  }

  void updateCart() {
    cartItems1.clear();
    cartItems1.addAll(productController.cartList);
    cartItems1.addAll(distributorController.cartList);
    cartItems1.refresh();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchCart() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);

        // 🔁 Clear existing data before fetching new
        cartList.value = CartResponse(data: []);
        searchList.clear();

        var response = await DioClient().getQueryParam(AppURL.orderCartURL);

        cartList.value = CartResponse.fromJson(response);
        print(cartList.value.data!.length);

        if (cartList.value.data!.isNotEmpty) {
          if (cartList.value.message == 'Data fetch successfully') {
            searchList.value = cartList.value.data!;
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          // Optional: Show "no data" message
          // AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        print(e);
        Utils.handleException(e, stackTrace);
      } finally {
        isLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  // Future<void> scanHeaderBarcode(BuildContext context) async {
  //   final String? scannedHeaderBarcode = await Get.to(
  //     () => const BarcodeScannerView(),
  //   );
  //
  //   // if (scannedHeaderBarcode != null && scannedHeaderBarcode.isNotEmpty) {
  //   //   fetchProductBySearch(scannedHeaderBarcode.toString());
  //   // }
  //   if (scannedHeaderBarcode != null && scannedHeaderBarcode.isNotEmpty) {
  //     final itemCode = scannedHeaderBarcode.split(' ').first.trim();
  //
  //     final controller = Get.find<ProductController>();
  //
  //     controller.searchQuery.value = itemCode;
  //     await controller.fetchProductBySearch();
  //   }
  // }
  Future<void> scanHeaderBarcode(BuildContext context) async {
    final String? scannedHeaderBarcode = await Get.to(
      () => const BarcodeScannerView(),
    );

    if (scannedHeaderBarcode == null || scannedHeaderBarcode.isEmpty) {
      return;
    }

    final itemCode = scannedHeaderBarcode.split(RegExp(r'\s+')).first.trim();

    print("Current Tab Index: ${tabController.index}");
    print("Scanned Item Code: $itemCode");

    // Distributor Tab
    if (tabController.index == 0) {
      distributorController.searchGroupController.value.text = itemCode;

      distributorController.searchQuery.value = itemCode;

      print("Firm: ${distributorController.selectedDropdownFirmCode.value}");
      print("Dept: ${distributorController.selectedDropdownDeptCode.value}");
      print("Search: ${distributorController.searchQuery.value}");

      await distributorController.fetchProductBySearch();
    }
    // Product Tab
    else {
      productController.searchGroupController.value.text = itemCode;

      productController.searchQuery.value = itemCode;

      await productController.fetchProductBySearch();
    }
  }
}
