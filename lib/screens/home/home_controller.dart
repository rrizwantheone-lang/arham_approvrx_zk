import 'dart:async';

import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/dashboard_image_response.dart';
import 'package:arham_b2c/models/login_firm_response.dart';
import 'package:arham_b2c/screens/home/home_screen.dart';
import 'package:arham_b2c/screens/home/home_view.dart';
import 'package:arham_b2c/screens/login/login_view.dart';
import 'package:arham_b2c/screens/profile/profile_controller.dart';
import 'package:arham_b2c/screens/re_order/order_base/order_base_response.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_date_format.dart';

class HomeController extends GetxController {
  var isDashboardLoading = false.obs;
  var isLoading = false.obs;
  var isDisable = false.obs;
  var isLogoutLoading = false.obs;
  var recentTransactions = <Map<String, dynamic>>[].obs;

  var isDropdownLoading = false.obs;
  var firmDropdownList = LoginFirmResponse().obs;
  var selectedDropdownFirm = Rx<LoginFirmModel?>(null);
  var selectedDropdownFirmName = ''.obs;
  var selectedDropdownFirmID = ''.obs;

  late List<String> bannerListData = [];

  Rx<OrderBaseResponse> mainList = OrderBaseResponse().obs;
  RxList<OrderBaseModel> searchList =
      <OrderBaseModel>[].obs; // List to store all groups
  RxString errorMsg = ''.obs;
  var isPageLoading = false.obs; // pagination loader

  Rx<TextEditingController> searchGroupController = TextEditingController().obs;
  FocusNode searchGroupFocus = FocusNode();
  RxString searchQuery = ''.obs; // Holds the search query
  Timer? debounce;

  Rx<TextEditingController> fromDateController = TextEditingController().obs;
  Rx<TextEditingController> toDateController = TextEditingController().obs;

  FocusNode fromDtFocus = FocusNode();
  FocusNode toDtFocus = FocusNode();

  var quantity = 1.obs;
  late TextEditingController quantityController;
  var requestStatus = <String, String>{}.obs;

  Rx<CartResponse> cartList = CartResponse().obs;
  RxList<CartModel> cartSearchList =
      <CartModel>[].obs; // List to store all groups

  var currentPage = 1.obs;
  var currentPageLimit = 20.obs;
  var totalCount = 0.obs;
  var totalPages = 1.obs;

  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !isPageLoading.value &&
        !isLoading.value &&
        currentPage.value <= totalPages.value) {
      _fetchData(isPagination: true);
    }
  }

  // @override
  // void onInit() async{
  //   super.onInit();
  //   fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
  //   toDateController.value.text = AppDatePicker.lastDayFinancialYear();
  //
  //   quantityController = TextEditingController(text: quantity.value.toString());
  //
  //   searchGroupFocus.addListener(() {
  //     if (searchGroupFocus.hasFocus) {
  //       // Select all text when field is focused
  //       final controllerText = searchGroupController.value;
  //       controllerText.selection = TextSelection(
  //         baseOffset: 0,
  //         extentOffset: controllerText.text.length,
  //       );
  //     }
  //   });
  //
  //   scrollController.addListener(scrollListener);
  //
  //   await allCallAPI();
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   _initializeData();
  // }
  //
  // Future<void> _initializeData() async {
  //   fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
  //   toDateController.value.text = AppDatePicker.lastDayFinancialYear();
  //
  //   quantityController = TextEditingController(text: quantity.value.toString());
  //
  //   searchGroupFocus.addListener(() {
  //     if (searchGroupFocus.hasFocus) {
  //       // Select all text when field is focused
  //       final controllerText = searchGroupController.value;
  //       controllerText.selection = TextSelection(
  //         baseOffset: 0,
  //         extentOffset: controllerText.text.length,
  //       );
  //     }
  //   });
  //
  //   scrollController.addListener(scrollListener);
  //
  //   await allCallAPI();
  // }

  @override
  void onReady() async {
    super.onReady();
    fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
    toDateController.value.text = AppDatePicker.lastDayFinancialYear();

    quantityController = TextEditingController(text: quantity.value.toString());

    searchGroupFocus.addListener(() {
      if (searchGroupFocus.hasFocus) {
        // Select all text when field is focused
        final controllerText = searchGroupController.value;
        controllerText.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controllerText.text.length,
        );
      }
    });

    scrollController.addListener(scrollListener);

    await allCallAPI();

    //_fetchDashboardImage(); // always safe here
  }

  @override
  void onClose() {
    quantityController.dispose();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  Future<void> allCallAPI() async {
    if (await Network.isConnected()) {
      try {
        _fetchFirmDropdown();
        _fetchDashboardImage();
        _fetchData();
        _fetchCart();
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  Future<void> refreshHome() async {
    // optional: clear old data
    mainList.value.data?.clear();
    searchList.clear();
    mainList.refresh();

    // re-call APIs
    await _fetchFirmDropdown();      // if home depends on firm
    await _fetchData();
    await _fetchCart();
    await _fetchDashboardImage();// <-- whatever API loads home cards
  }

  Future<void> refreshAllData() async {
    // Reset pagination if needed
    currentPage.value = 1;
    mainList.value.data?.clear();
    searchList.clear();

    // Call all main data fetching functions
    await Future.wait([
      _fetchFirmDropdown(),
      _fetchDashboardImage(),
      _fetchData(isPagination: false),
      _fetchCart(),
    ]);

    // Optional: small delay to make refresh feel natural
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _fetchFirmDropdown() async {
    try {
      isDropdownLoading(true);

      var response = await DioClient().getQueryParam(AppURL.getFirmURL);

      firmDropdownList.value = LoginFirmResponse.fromJson(response);

      if (firmDropdownList.value.data!.isNotEmpty) {
        if (firmDropdownList.value.message == 'Data fetch successfully') {
          String storedFirmID = PreferenceUtils.getSyncID();

          LoginFirmModel? selectedFirm = firmDropdownList.value.data!
              .firstWhere(
                (firm) => firm.sCSYNCID.toString() == storedFirmID,
                orElse: () => LoginFirmModel(),
              );

          selectedDropdownFirm.value = selectedFirm;
          selectedDropdownFirmName.value = selectedFirm.sCFIRMNAME.toString();
          selectedDropdownFirmID.value = selectedFirm.sCSYNCID.toString();

          //PreferenceUtils.setUserCD(firstFirm.userCD);
          PreferenceUtils.setFirmID(selectedFirm.sCFIRMID!.toString());
          PreferenceUtils.setCustID(selectedFirm.sCCUSTID.toString());
          PreferenceUtils.setSyncID(selectedDropdownFirmID.value);
          PreferenceUtils.setFirmName(selectedFirm.sCFIRMNAME.toString());
          PreferenceUtils.setFirmGSTType(selectedFirm.sCGSTTYPE.toString());
          PreferenceUtils.setFirmStateCD(selectedFirm.sCSTATECODE.toString());
          PreferenceUtils.setFirmStateName(selectedFirm.sCSTATE.toString());

          Utils.storeSelectedFirmObject(selectedFirm);
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: 'No Firms Available');
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isDropdownLoading(false);
    }
  }

  Future<void> changeFirmLogin(String dropdownId) async {
    try {
      isLoading(true);
      isDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'scSyncId': dropdownId};

        var response = await DioClient().post(AppURL.changeFirmURL, param);
        print(response);

        if (response.statusCode == 200) {
          if (response.data['message'] == 'Login Successful') {
            Utils.closeKeyboard(Get.context!);

            String role = response.data['role'];
            String token = response.data['token'];

            PreferenceUtils.setLoginUserRole(role);
            PreferenceUtils.setAuthToken('Bearer $token');

            PreferenceUtils.setIsLogin(true).then((_) {
              // Get.offAll(() => HomeView());
              Get.offAll(() => HomeScreen());
              AppSnackBar.showGetXCustomSnackBar(
                message: 'All Data Updated With SyncId',
                backgroundColor: AppColors.colorGreen,
              );

              allCallAPI();
            });
          } else {
            // Show failure message based on the message from the response
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print('call change firm $e');
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
      isDisable(false);
    }
  }

  Future<void> performLogout() async {
    try {
      isLogoutLoading(true);

      if (await Network.isConnected()) {
        var response = await DioClient().post11(AppURL.logoutURL);

        //User Logout Successfully
        if (response.statusCode == 200) {
          print('success');
          // Utils.closeKeyboard(Get.context!);
          // Get.offAll(() => LoginView());
          //
          // AppSnackBar.showGetXCustomSnackBar(
          //   message: response.data['message'],
          //   backgroundColor: Colors.green,
          // );

          PreferenceUtils.setIsLogin(false).then((_) {
            PreferenceUtils.setAuthToken('');
            PreferenceUtils.setLoginUserCode('');
            PreferenceUtils.setLoginUserName('');
            PreferenceUtils.setLoginCustID('');
            PreferenceUtils.setLoginUserRole('');
            PreferenceUtils.setLoginUserPassword('');
            PreferenceUtils.setLoginMobileNO('');
            PreferenceUtils.setSyncID('');
            PreferenceUtils.setUserCD('');
            PreferenceUtils.clearAllPreferences();

            //Get.deleteAll();
            Get.delete<HomeController>();
            Get.delete<ProfileController>();
            Get.offAll(() => LoginView());

            AppSnackBar.showGetXCustomSnackBar(
              message: 'Logout successfully',
              backgroundColor: Colors.green,
            );
          });
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print(e.toString());
      Utils.handleException(e, stackTrace);
      //Utils.handleException(Exception(e.toString()));
    } finally {
      isLogoutLoading(false);
    }
  }

  Future<void> _fetchDashboardImage() async {
    // if (!await Network.isConnected()) {
    //   AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    //   return;
    // }

    try {
      isDashboardLoading(true);

      final response = await DioClient().get(AppURL.dashboardURL);

      final imageResponse = DashboardImageResponse.fromJson(response);

      if (imageResponse.status == true && imageResponse.images!.isNotEmpty) {
        // Extract IMAGE_URLs
        bannerListData =
            imageResponse.images!
                .map((img) {
                  String url = img.iMAGEURL ?? "";
                  return url;
                })
                .where((url) => url.isNotEmpty)
                .toList();

        // Optional: join all URLs as comma separated string
        //final String bannerListString = bannerListData.join(",");
      } else {
        print("No images found");
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isDashboardLoading(false);
    }
  }

  Future<void> _fetchData({bool isPagination = false}) async {
    // if (!(await Network.isConnected())) {
    //   AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    //   return;
    // }

    try {
      if (isPagination) {
        isPageLoading(true);
      } else {
        isLoading(true);
        currentPage.value = 1;
        mainList.value.data?.clear();
        searchList.clear();
      }

      Map<String, dynamic> param = {
        "fromDate": AppDatePicker.convertDateTimeFormat(
          fromDateController.value.text,
          'dd-MM-yyyy',
          'yyyy-MM-dd',
        ),
        "toDate": AppDatePicker.convertDateTimeFormat(
          toDateController.value.text,
          'dd-MM-yyyy',
          'yyyy-MM-dd',
        ),

        // "syncId": selectedDropdownFirmCode.value,
        // "deptCd": selectedDropdownDeptCode.value,
        // "page": currentPage.value.toString(),
        // "limit": currentPageLimit.value.toString(),
        // "search": searchQuery.value.trim(),
        "syncId": '',
        "deptCd": '',
        "page": '1',
        "limit": '10',
        "search": '',
      };

      var response = await DioClient().getQueryParam(
        AppURL.partyWiseItemWiseOrderReportURL,
        queryParams: param,
      );

      var newData = OrderBaseResponse.fromJson(response);

      if (newData.data != null && newData.data!.isNotEmpty) {
        mainList.value.data ??= [];
        mainList.value.data!.addAll(newData.data!);
        searchList.addAll(newData.data!);

        totalCount.value = newData.totalRecords ?? 0;
        totalPages.value = newData.totalPages ?? 1;

        currentPage.value++; // ✅ increment AFTER success
      } else {
        if (!isPagination) {
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      }

      filterData();
    } catch (e, stackTrace) {
      print('call api $e');
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
      isPageLoading(false);
      mainList.refresh();
    }
  }

  void filterData() {
    if (searchQuery.value.isEmpty) {
      // If no search query, show all data
      mainList.value.data = List.from(searchList);
    } else {
      mainList.value.data =
          searchList.where((group) {
            return (group.iTEMNAME?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false) ||
                (group.iTEMCD?.toString().contains(searchQuery.value) ?? false);
          }).toList();
    }

    mainList.refresh(); // Trigger UI update
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
          // CartModel cartItem = CartModel.fromJson(responseData['data']);
          // cartList.add(cartItem); // ✅ Store only 'data' part in the list

          requestStatus[itemCd] = 'success';

          _fetchCart();
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
    }
  }

  Future<void> _fetchCart() async {
    try {
      isLoading(true);

      // 🔁 Clear existing data before fetching new
      cartList.value = CartResponse(data: []);
      cartSearchList.clear();

      var response = await DioClient().getQueryParam(AppURL.orderCartURL);

      cartList.value = CartResponse.fromJson(response);

      if (cartList.value.data!.isNotEmpty) {
        if (cartList.value.message == 'Data fetch successfully') {
          cartSearchList.value = cartList.value.data!;
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: response.data['message']);
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
  }
}
