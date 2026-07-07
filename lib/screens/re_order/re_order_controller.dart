import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/screens/re_order/order_base/order_base_controller.dart';
import 'package:arham_b2c/screens/re_order/sales_base/sales_base_controller.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final OrderBaseController orderBaseController = Get.put(
    OrderBaseController(),
  );
  final SalesBaseController salesBaseController = Get.put(SalesBaseController());

  RxList<CartModel> cartItems1 = <CartModel>[].obs; // ✅ Combined cart list

  var isLoading = false.obs;
  Rx<CartResponse> cartList = CartResponse().obs;
  RxList<CartModel> searchList = <CartModel>[].obs; // List to store all groups

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    // ✅ Lazily initialize each tab's APIs only when the tab is first opened
    tabController.addListener(() {
      if (tabController.indexIsChanging) return;
      if (tabController.index == 0) {
        orderBaseController.initIfNeeded();
      } else if (tabController.index == 1) {
        salesBaseController.initIfNeeded();
      }
    });

    // ✅ Initialize the first tab (Order Base) immediately since it's shown by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderBaseController.initIfNeeded();
    });

    fetchCart();
  }

  void updateCart() {
    cartItems1.clear();
    cartItems1.addAll(salesBaseController.cartList);
    cartItems1.addAll(orderBaseController.cartList);
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
}
