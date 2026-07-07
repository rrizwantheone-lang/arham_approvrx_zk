import 'dart:async';

import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/shop/product/product_response.dart';
import 'package:arham_b2c/screens/shop/shop_controller.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var isDeleteLoading = false.obs;

  Rx<ProductResponse> mainList = ProductResponse().obs;
  RxList<ProductModel> searchList =
      <ProductModel>[].obs; // List to store all groups

  RxString errorMsg = ''.obs;

  Rx<TextEditingController> searchGroupController = TextEditingController().obs;
  FocusNode searchGroupFocus = FocusNode();
  RxString searchQuery = ''.obs; // Holds the search query
  Timer? debounce;

  var moduleNo = ''.obs;
  var readRight = false.obs;
  var writeRights = false.obs;
  var updateRights = false.obs;
  var deleteRights = false.obs;
  var printRights = false.obs;

  var isDropdownFirmLoading = false.obs;
  Rx<FirmResponse> firmList = FirmResponse().obs;
  final Rx<FirmModel?> selectedDropdownFirm = Rx<FirmModel?>(null);
  RxString selectedDropdownFirmName = ''.obs;
  RxString selectedDropdownFirmCode = ''.obs;
  Rx<TextEditingController> firmController = TextEditingController().obs;
  FocusNode firmFocus = FocusNode();

  Rx<TextEditingController> fromDateController = TextEditingController().obs;
  Rx<TextEditingController> toDateController = TextEditingController().obs;

  FocusNode fromDtFocus = FocusNode();
  FocusNode toDtFocus = FocusNode();

  var quantity = 1.obs;
  var requestStatus = <String, String>{}.obs;
  final cartList = <CartModel>[].obs; // ✅ List to store multiple cart items

  var currentPage = 1.obs;
  var totalCount = 0.obs;
  var totalPages = 1.obs;

  Rx<CartResponse> cartList1 = CartResponse().obs;
  RxList<CartModel> searchList1 = <CartModel>[].obs; // List to store all groups

  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoading.value &&
        currentPage.value <= totalPages.value) {
      fetchProduct(); // Fetch next page
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
    toDateController.value.text = AppDatePicker.lastDayFinancialYear();

    scrollController.addListener(scrollListener);

    fetchProduct();
  }

  @override
  void onClose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchProduct() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);

        //Map<String, dynamic> param = {"page": currentPage.toString()};

        Map<String, dynamic> param = {
          "syncId": "",
          "deptCd": "",
          "items_per_page": "",
          "page": currentPage.toString(),
          "search": "",
        };

        var response = await DioClient().getQueryParam(
          AppURL.orderProductURL,
          queryParams: param,
        );

        print("[Product] $response");

        var newData = ProductResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          if (currentPage.value == 1) {
            mainList.value = newData;
            searchList.value = newData.data!;
          } else {
            mainList.value.data?.addAll(newData.data!);
            searchList.addAll(newData.data!);
          }

          filterData();

          totalCount.value = newData.payload?.pagination?.total ?? 0;
          totalPages.value = newData.payload?.pagination?.lastPage ?? 1;
          currentPage.value++;
        } else {
          if (currentPage.value == 1) {
            AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
          }
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isLoading(false);
        mainList.refresh();
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
      // mainList.value.data =
      //     searchList.where((group) {
      //       return (group.iTEMNAME?.toLowerCase().contains(
      //                 searchQuery.value.toLowerCase(),
      //               ) ??
      //               false) ||
      //           (group.iTEMSNAME?.toLowerCase().contains(
      //                 searchQuery.value.toLowerCase(),
      //               ) ??
      //               false) ||
      //           (group.iTEMLNAME?.toLowerCase().contains(
      //                 searchQuery.value.toLowerCase(),
      //               ) ??
      //               false) ||
      //           (group.iTEMCD2?.toString().contains(searchQuery.value) ??
      //               false) ||
      //           (group.iTEMCD?.toString().contains(searchQuery.value) ?? false);
      //     }).toList();

      mainList.value.data =
          searchList.where((group) {
            final query = searchQuery.value.toLowerCase();
            return (group.iTEMNAME ?? '').toLowerCase().contains(query) ||
                (group.iTEMSNAME ?? '').toLowerCase().contains(query) ||
                (group.iTEMLNAME ?? '').toLowerCase().contains(query) ||
                (group.iTEMCD ?? '').toLowerCase().contains(query);
          }).toList();
    }

    mainList.refresh(); // Trigger UI update
  }

  Future<void> fetchFirm() async {
    if (await Network.isConnected()) {
      try {
        isDropdownFirmLoading(true);

        var response = await DioClient().get(AppURL.dropdownFirmURL);

        firmList.value = FirmResponse.fromJson(response);
        if (firmList.value.data!.isNotEmpty) {
          if (firmList.value.message == 'Data fetched successfully') {
            if (firmList.value.data!.length == 1) {
              var selectedFirm = firmList.value.data!.first;
              selectedDropdownFirm.value = selectedFirm;
              selectedDropdownFirmCode.value =
                  selectedFirm.syncId.toString().trim();
              firmController.value.text = selectedFirm.firmName.trim();
              Utils.closeKeyboard(Get.context!);
              firmFocus.unfocus();
              //clearField();
              fetchProduct();
            }
            // if (vouchNo.value.isNotEmpty) {
            //   var groupCdFromArgs = Get.arguments?['PartyCD'];
            //
            //   // Filter the list to find the subgroup that matches the GroupCD
            //   var selectedGroup = partyList.value.data!.firstWhere(
            //         (group) => group.aCCCD == groupCdFromArgs,
            //     orElse: () => PartyModel(), // Default to the first if not found
            //   );
            //
            //   // Set the selected values
            //   selectedDropdownParty.value = selectedGroup;
            //   selectedDropdownPartyName.value =
            //       selectedGroup.aCCNAME.toString().trim();
            //   selectedDropdownPartyCode.value =
            //       selectedGroup.aCCCD.toString().trim();
            //   partyController.value.text =
            //       selectedGroup.aCCNAME.toString().trim();
            // }
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No distributor found');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isDropdownFirmLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  Future<void> sendCart(String itemCd, int qty, String syncId) async {
    if (requestStatus[itemCd] == 'loading') return;

    requestStatus[itemCd] = 'loading';
    requestStatus.refresh(); // ✅ Force UI update

    try {
      var response = await DioClient().post(AppURL.orderCartURL, {
        'itemCd': itemCd,
        'qty': qty,
        'syncId': syncId,
        "moduleNo": '205',
      });

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null && responseData['data'] != null) {
          requestStatus[itemCd] = 'success';

          ShopController shopController = Get.find<ShopController>();
          shopController.fetchCart();
        } else {
          requestStatus[itemCd] = 'error';
        }
      } else {
        requestStatus[itemCd] = 'error';
      }
    } catch (e, stackTrace) {
      requestStatus[itemCd] = 'error';
      Utils.handleException(e, stackTrace);
    } finally {
      requestStatus.refresh(); // ✅ Ensure UI updates
      cartList.refresh(); // ✅ Notify UI about cart updates
      if (kDebugMode) {
        print(cartList.map((e) => e.toJson()).toList());
      } // ✅ Debug print cart items
    }
  }

  Future<void> fetchProductBySearch() async {
    if (await Network.isConnected()) {
      try {
        //TODO : Show Loader Uncomment
        // isLoading(true);
        // mainList.value.data?.clear();
        // searchList.clear();

        //Map<String, dynamic> param = {"search": searchQuery.value.trim()};

        Map<String, dynamic> param = {
          "syncId": "",
          "deptCd": "",
          "items_per_page": "",
          "page": "-1",
          "search": searchQuery.value.trim(),
        };

        var response = await DioClient().getQueryParam(
          AppURL.orderProductURL,
          queryParams: param,
        );

        print(response);

        var newData = ProductResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          // if (currentPage.value == 1) {
          //   mainList.value.data?.clear();
          //   searchList.clear();
          // }
          //
          // mainList.value.data?.addAll(newData.data!);
          // searchList.addAll(newData.data!);
          //
          // filterData();

          // if (currentPage.value == 1) {
          //   mainList.value.data = newData.data!;
          // } else {
          //   mainList.value.data?.addAll(newData.data!);
          // }
          // searchList.value = List.from(mainList.value.data!);

          mainList.value.data?.clear(); //TODO : Show Loader Comment Line
          searchList.clear(); //TODO : Show Loader Comment Line
          mainList.value.data?.addAll(newData.data!);
          searchList.addAll(newData.data!);
          filterData();
        } else {
          mainList.value.data?.clear();
          searchList.clear();
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        //isLoading(false);
        mainList.refresh();
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }
}
