import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shop/distributor/distributor_controller.dart';
import '../shop/product/product_controller.dart';

class CartController extends GetxController {

  final ProductController productController = Get.put(ProductController());
  final DistributorController distributorController = Get.put(
    DistributorController(),
  );

  var isLoading = false.obs;
  var isLoadingOrderNow = false.obs;
  var isDisableOrderNow = false.obs;
  var isDeleteLoading = false.obs;

  RxString errorMsg = ''.obs;

  Rx<TextEditingController> searchGroupController = TextEditingController().obs;
  FocusNode searchGroupFocus = FocusNode();
  RxString searchQuery = ''.obs; // Holds the search query

  var moduleNo = ''.obs;
  var readRight = false.obs;
  var writeRights = false.obs;
  var updateRights = false.obs;
  var deleteRights = false.obs;
  var printRights = false.obs;

  Rx<TextEditingController> fromDateController = TextEditingController().obs;
  Rx<TextEditingController> toDateController = TextEditingController().obs;

  FocusNode fromDtFocus = FocusNode();
  FocusNode toDtFocus = FocusNode();

  Rx<CartResponse> mainList = CartResponse().obs;
  RxList<CartModel> searchList = <CartModel>[].obs; // List to store all groups

  Rx<TextEditingController> narrationController = TextEditingController().obs;
  FocusNode narrationFocus = FocusNode();

  var isSales = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isSales.value = Get.arguments?['isSales'] ?? "";

    // final List<CartModel>? receivedCartItems = Get.arguments?['cartItems'];
    //
    // if (receivedCartItems != null) {
    //   cartItems1.assignAll(
    //     receivedCartItems,
    //   ); // ✅ Correct way to update observable list
    // }

    //fetchFirm();

    fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
    toDateController.value.text = AppDatePicker.lastDayFinancialYear();

    //fetchProduct();

    fetchCart();
  }

  Future<void> fetchCart() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);

        // 🔁 Clear existing data before fetching new
        mainList.value = CartResponse(data: []);
        searchList.clear();

        var response = await DioClient().getQueryParam(AppURL.orderCartURL);

        mainList.value = CartResponse.fromJson(response);

        if (mainList.value.message == 'Data fetch successfully') {
          if (mainList.value.data!.isNotEmpty) {
            searchList.value = mainList.value.data!;
            filterData();
          } else {
            errorMsg.value = 'No record found';
            // AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
          }
        } else {
          errorMsg.value = response.data['message'];
        }

        // if (mainList.value.data!.isNotEmpty) {
        //   if (mainList.value.message == 'Data fetch successfully') {
        //     searchList.value = mainList.value.data!;
        //     filterData();
        //   } else {
        //     AppSnackBar.showGetXCustomSnackBar(
        //       message: response.data['message'],
        //     );
        //   }
        // } else {
        //   errorMsg.value = 'No record found';
        //   // AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        // }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void filterData() {
    if (searchQuery.value.isEmpty) {
      // If no search query, show all data
      mainList.value.data = List.from(searchList);
    } else {
      mainList.value.data =
          searchList.where((group) {
            return (group.item!.iTEMNAME?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false) ||
                (group.item!.iTEMLNAME?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false) ||
                (group.item!.iTEMSNAME?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false) ||
                (group.item!.iTEMCD2?.toString().contains(searchQuery.value) ??
                    false) ||
                (group.iTEMCD?.toString().contains(searchQuery.value) ?? false);
          }).toList();
    }

    mainList.refresh(); // Trigger UI update
  }

  Future<void> updateCart(
    String itemCd,
    int qty,
    String syncId,
    String cId,
  ) async {
    try {
      var response = await DioClient().put(AppURL.orderCartURL, {
        'itemCd': itemCd,
        'qty': qty,
        'syncId': syncId,
        'cId': cId,
        "moduleNo": '205',
      });

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null && responseData['data'] != null) {
          if (kDebugMode) {
            print(responseData);
          }
        } else {}
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendOrder1(String remarks) async {
    try {
      isLoadingOrderNow(true);
      isDisableOrderNow(true);

      var response = await DioClient().post(AppURL.orderOrderURL, {
        'narration': remarks,
        "moduleNo": '205',
      });

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null && responseData['data'] != null) {
          if (kDebugMode) {
            print(responseData);
          }

          // AppSnackBar.showGetXCustomSnackBar(
          //   message: 'Order placed successfully',
          //   backgroundColor: AppColors.colorGreen,
          // );
        } else {}
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoadingOrderNow(false);
      isDisableOrderNow(false);
    }
  }

  Future<bool> sendOrder(String remarks) async {
    try {
      isLoadingOrderNow(true);
      isDisableOrderNow(true);

      var response = await DioClient().post(AppURL.orderOrderURL, {
        'narration': remarks,
        "moduleNo": '205',
      });

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null && responseData['data'] != null) {
          if (kDebugMode) print(responseData);
          return true; // SUCCESS
        } else {
          return false; // invalid response
        }
      } else {
        return false; // non-200 response
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return false; // exception
    } finally {
      isLoadingOrderNow(false);
      isDisableOrderNow(false);
    }
  }

  Future<void> deleteProduct(String cId) async {
    try {
      isDeleteLoading(true);

      // Check if network is available
      if (await Network.isConnected()) {
        String url = '${AppURL.orderCartURL}/$cId';

        // Make the network request
        var response = await DioClient().delete(url);

        // Check if the response status code is 200 (OK) & 201
        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.back();
          AppSnackBar.showGetXCustomSnackBar(
            message: response.data['message'],
            backgroundColor: AppColors.colorGreen,
          );
          fetchCart();
        } else {
          // Handle non-200 status codes (if any)
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      // Handle any errors during the request
      Utils.handleException(e, stackTrace);
      //Utils.handleException(Exception(e.toString()));
    } finally {
      // Reset loading and disable state
      isDeleteLoading(false);
    }
  }

  void updateQty(CartModel product, int qty) {
    product.qUANTITY.value = qty;
    product.quantityController.text = qty.toString();

    final double rate = Utils.convertToDouble(product.rATE ?? '0');
    product.aMOUNT.value = (qty * rate);
  }
}
