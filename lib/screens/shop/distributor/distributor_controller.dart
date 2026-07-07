import 'dart:async';

import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/department_response.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/shop/distributor/distributor_response.dart';
import 'package:arham_b2c/screens/shop/shop_controller.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistributorController extends GetxController {
  var isLoading = false.obs;
  var isDeleteLoading = false.obs;

  Rx<DistributorResponse> mainList = DistributorResponse().obs;
  RxList<DistributorModel> searchList =
      <DistributorModel>[].obs; // List to store all groups

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

  var isDropdownDeptLoading = false.obs;
  Rx<DepartmentResponse> deptList = DepartmentResponse().obs;
  final Rx<DepartmentModel?> selectedDropdownDept = Rx<DepartmentModel?>(null);
  RxString selectedDropdownDeptName = ''.obs;
  RxString selectedDropdownDeptCode = ''.obs;
  Rx<TextEditingController> deptController = TextEditingController().obs;
  FocusNode deptFocus = FocusNode();

  Rx<TextEditingController> fromDateController = TextEditingController().obs;
  Rx<TextEditingController> toDateController = TextEditingController().obs;

  FocusNode fromDtFocus = FocusNode();
  FocusNode toDtFocus = FocusNode();

  var quantity = 1.obs;
  late TextEditingController quantityController;
  var requestStatus = <String, String>{}.obs;
  final cartList = <CartModel>[].obs; // ✅ List to store multiple cart items

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    fetchFirm();

    fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
    toDateController.value.text = AppDatePicker.lastDayFinancialYear();

    quantityController = TextEditingController(text: quantity.value.toString());

    // Keep text field in sync with quantity
    ever(quantity, (val) {
      quantityController.text = val.toString();
    });

    //fetchProduct();

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
  }

  @override
  void onClose() {
    quantityController.dispose();
    super.onClose();
  }

  Future<void> fetchProduct() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);

        // Clear productList and searchList before making a new request
        mainList.value.data?.clear();
        searchList.clear();
        mainList.refresh();

        Map<String, dynamic> param = {
          "syncId": selectedDropdownFirmCode.value,
          "deptCd": selectedDropdownDeptCode.value,
          "items_per_page": "",
          "page": "-1",
          "search": "",
        };

        var response = await DioClient().getQueryParam(
          AppURL.orderProductURL,
          queryParams: param,
        );

        print(response);

        var newData = DistributorResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          mainList.value = newData;
          searchList.value = newData.data!;

          // Apply initial filtering based on searchQuery if any
          filterData();

          // if (newData.message == 'Data fetch successfully') {
          //   mainList.value = newData;
          //   searchList.value = newData.data!;
          //
          //   // Apply initial filtering based on searchQuery if any
          //   filterData();
          // } else {
          //   AppSnackBar.showGetXCustomSnackBar(
          //     message: response.data['message'],
          //   );
          // }

          print("All Distributor Length : ${mainList.value.data!.length}");
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isLoading(false);
        mainList.refresh(); // Ensure UI updates
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  Future<void> fetchProduct1() async {
    if (!await Network.isConnected()) {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      return;
    }

    try {
      int page = 1;
      const int batchSize = 1000;
      bool hasMore = true;

      // Clear only once before starting batch fetch
      mainList.value.data?.clear();
      searchList.clear();
      mainList.refresh();

      while (hasMore) {
        // ✅ Show loader only on first page
        if (page == 1) isLoading(true);

        Map<String, dynamic> param = {
          "syncId": selectedDropdownFirmCode.value,
          "deptCd": selectedDropdownDeptCode.value,
          "items_per_page": batchSize.toString(),
          "page": page.toString(),
          "search": "",
        };

        var response = await DioClient().getQueryParam(
          AppURL.orderProductURL,
          queryParams: param,
        );

        print(response);

        var newData = DistributorResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          mainList.value.data ??= [];
          mainList.value.data!.addAll(newData.data!);
          searchList.addAll(newData.data!);
          mainList.refresh();

          print("Batch $page: ${newData.data!.length} records fetched");

          if (newData.data!.length < batchSize) {
            hasMore = false;
            print("All data fetched. Total: ${mainList.value.data!.length}");
          } else {
            page++;
          }
        } else {
          hasMore = false;
          if (page == 1) {
            errorMsg.value = 'No record found.';
            //AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
          }
        }

        // ✅ Hide loader only after first batch
        if (page == 2) isLoading(false);
      }

      filterData();
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
      isLoading(false); // In case of error on first batch
    } finally {
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
                (group.iTEMSNAME?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false) ||
                (group.iTEMLNAME?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false) ||
                (group.iTEMCD?.toString().contains(searchQuery.value) ?? false);
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

              //fetchProduct();
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

  Future<void> fetchDept() async {
    if (await Network.isConnected()) {
      try {
        isDropdownDeptLoading(true);

        Map<String, dynamic> param = {"syncId": selectedDropdownFirmCode.value};

        var response = await DioClient().getQueryParam(
          AppURL.departmentURL,
          queryParams: param,
        );

        deptList.value = DepartmentResponse.fromJson(response);
        if (deptList.value.data!.isNotEmpty) {
          if (deptList.value.message == 'Data fetched successfully') {
            if (deptList.value.data!.length == 1) {
              var selectedFirm = deptList.value.data!.first;
              selectedDropdownDept.value = selectedFirm;
              selectedDropdownDeptCode.value =
                  selectedFirm.dEPTCD.toString().trim();
              deptController.value.text =
                  selectedFirm.dEPTNAME.toString().trim();
              Utils.closeKeyboard(Get.context!);
              deptFocus.unfocus();

              //clearField();

              //fetchProduct();
            }
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No department found');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isDropdownDeptLoading(false);
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
          // CartModel cartItem = CartModel.fromJson(responseData['data']);
          // cartList.add(cartItem); // ✅ Store only 'data' part in the list

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
        isLoading(true);
        mainList.value.data?.clear();
        searchList.clear();

        //Map<String, dynamic> param = {"search": searchQuery.value.trim()};

        Map<String, dynamic> param = {
          "syncId": selectedDropdownFirmCode.value,
          "deptCd": selectedDropdownDeptCode.value,
          "items_per_page": "",
          "page": "-1",
          "search": searchQuery.value.trim(),
        };

        var response = await DioClient().getQueryParam(
          AppURL.orderProductURL,
          queryParams: param,
        );

        print(response);

        var newData = DistributorResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
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
        isLoading(false);
        mainList.refresh();
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void resetDistributorState() {
    selectedDropdownFirm.value = null;
    selectedDropdownFirmName.value = '';
    selectedDropdownFirmCode.value = '';
    firmController.value.clear();

    selectedDropdownDept.value = null;
    selectedDropdownDeptName.value = '';
    selectedDropdownDeptCode.value = '';
    deptController.value.clear();

    searchGroupController.value.clear();
    searchQuery.value = '';

    mainList.value.data?.clear();
    searchList.clear();
    mainList.refresh();
  }

  void showBottomSheetMenu(BuildContext context) {
    var controller = TextEditingController().obs;
    final focusNode = FocusNode();

    var filteredPartyList = RxList<DepartmentModel>();
    controller.value.clear();
    filteredPartyList.value = List.from(deptList.value.data ?? []);

    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: false,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(focusNode);
        });

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        bool isDark = Theme.of(context).brightness == Brightness.dark;

        return SafeArea(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: 'Select Department : ',
                      fontSize: AppDimensions.fontSizeLarge,
                      fontWeight: AppFontWeight.w600,
                    ).paddingOnly(bottom: 10),
                    CupertinoSearchTextField(
                      focusNode: focusNode,
                      //keyboardType: TextInputType.text,
                      // onSubmitted: (_) {
                      //   focusNode.unfocus();
                      // },
                      controller: controller.value,
                      padding: const EdgeInsets.all(12),
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      prefixIcon: Icon(Icons.search, size: 24),
                      suffixIcon: Icon(Icons.close, size: 24),
                      cursorColor: colorScheme.primary,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          filteredPartyList.value = List.from(
                            deptList.value.data ?? [],
                          );
                        } else {
                          filteredPartyList.value =
                              deptList.value.data!
                                  .where(
                                    (party) =>
                                        party.dEPTNAME!.toLowerCase().contains(
                                          value.toLowerCase(),
                                        ) ||
                                        party.dEPTCD!.toLowerCase().contains(
                                          value.toLowerCase(),
                                        ),
                                  )
                                  .toList();
                        }
                      },
                    ).paddingOnly(bottom: 10),
                    Expanded(
                      child: Obx(
                        () =>
                            filteredPartyList.isEmpty &&
                                    controller.value.text.isNotEmpty
                                ? Center(
                                  child: CommonText(
                                    text: "No Search Dept Found",
                                  ),
                                )
                                : filteredPartyList.isEmpty
                                ? Center(
                                  child: CommonText(text: "No Dept List Found"),
                                )
                                : ListView.builder(
                                  itemCount: filteredPartyList.length,
                                  itemBuilder: (context, index) {
                                    var selectedParty =
                                        filteredPartyList[index];

                                    return InkWell(
                                      onTap: () {
                                        selectedDropdownDept.value =
                                            selectedParty;
                                        selectedDropdownDeptName.value =
                                            selectedParty.dEPTNAME!.trim();
                                        selectedDropdownDeptCode.value =
                                            selectedParty.dEPTCD!.trim();

                                        deptController.value.text =
                                            "${selectedParty.dEPTNAME}";

                                        Navigator.pop(Get.context!);

                                        fetchProduct();
                                      },
                                      child: ListTile(
                                        leading: CommonText(
                                          text: "${index + 1}",
                                        ),
                                        title: CommonText(
                                          text:
                                              "(${selectedParty.dEPTCD}) ${selectedParty.dEPTNAME}",
                                        ),
                                        dense: true,
                                        visualDensity: VisualDensity(
                                          vertical: -4,
                                          horizontal: -4,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
