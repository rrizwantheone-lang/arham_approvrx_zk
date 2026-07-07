import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/order_report/order_report_expand_response.dart';
import 'package:arham_b2c/screens/order_report/order_report_expand_vocuh_response.dart';
import 'package:arham_b2c/screens/order_report/order_report_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utility/network.dart';

class OrderReportController extends GetxController {
  var isLoading = false.obs;
  var isPageLoading = false.obs;
  var isExpandWithoutVouchLoading = false.obs;
  var isExpandWithVouchLoading = false.obs;

  var radioCheck = 1.obs;

  RxBool isFilterVisible = false.obs;

  Rx<OrderReportResponse> mainList = OrderReportResponse().obs;
  RxList<OrderReportModel> searchList =
      <OrderReportModel>[].obs; // List to store all groups

  Rx<OrderReportExpandResponse> leaderExpandWithoutVocuhList =
      OrderReportExpandResponse().obs;
  RxList<OrderReportExpandModel> searchExpandWithoutVocuhList =
      <OrderReportExpandModel>[].obs;

  Rx<OrderReportExpandVouchResponse> leaderExpandWithVocuhList =
      OrderReportExpandVouchResponse().obs;
  RxList<OrderReportExpandVocuhModel> searchExpandWithVocuhList =
      <OrderReportExpandVocuhModel>[].obs;

  RxString errorMsg = ''.obs;

  var isDropdownFirmLoading = false.obs;
  Rx<FirmResponse> firmList = FirmResponse().obs;
  final Rx<FirmModel?> selectedDropdownFirm = Rx<FirmModel?>(null);
  RxString selectedDropdownFirmName = ''.obs;
  RxString selectedDropdownFirmCode = ''.obs;

  Rx<TextEditingController> searchGroupController = TextEditingController().obs;
  FocusNode searchGroupFocus = FocusNode();
  RxString searchQuery = ''.obs; // Holds the search query

  Rx<TextEditingController> searchGroupExpandController =
      TextEditingController().obs;
  FocusNode searchGroupExpandFocus = FocusNode();
  RxString searchExpandQuery = ''.obs; // Holds the search query

  Rx<TextEditingController> fromDateController = TextEditingController().obs;
  Rx<TextEditingController> toDateController = TextEditingController().obs;
  Rx<TextEditingController> firmController = TextEditingController().obs;

  FocusNode fromDtFocus = FocusNode();
  FocusNode toDtFocus = FocusNode();
  FocusNode firmFocus = FocusNode();

  var status = 'A'.obs;

  // var page = 1;
  // final int limit = 10; // Set your desired limit per page
  // var hasMoreData = true.obs;
  // var isLoadMore = false.obs;
  // ScrollController scrollController = ScrollController();
  var currentPage = 1.obs;
  var currentPageLimit = 8.obs;     // you can change this value
  var totalCount = 0.obs;
  var totalPages = 1.obs;
  var grandTotal = 0.0.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    scrollController.addListener(_scrollListener);

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //
    //     if (!isLoading.value &&
    //         currentPage.value < totalPages.value) {
    //
    //       currentPage.value++;
    //       fetchOrder(isPagination: true);
    //     }
    //   }
    // });

    fromDateController.value.text = AppDatePicker.last7DaysDate();
    //toDateController.value.text = AppDatePicker.lastDayFinancialYear();
    toDateController.value.text = AppDatePicker.currentDate();
    fetchOrder();
    fetchFirm();

  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  // void _scrollListener() {
  //   if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
  //     if (hasMoreData.value && !isLoadMore.value && !isLoading.value) {
  //       page++;
  //       fetchOrder(isLoadMoreReq: true);
  //     }
  //   }
  // }
  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100 &&
        !isPageLoading.value &&
        !isLoading.value &&
        currentPage.value <= totalPages.value) {
      fetchOrder(isPagination: true);
    }
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
              fetchOrder();
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
          AppSnackBar.showGetXCustomSnackBar(
            message: 'No distributor record found',
          );
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(e);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isDropdownFirmLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  // Future<void> fetchOrder({bool isLoadMoreReq = false}) async {
  //   if (await Network.isConnected()) {
  //     try {
  //       if (isLoadMoreReq) {
  //         isLoadMore(true);
  //       } else {
  //         // Reset pagination for fresh fetch
  //         page = 1;
  //         hasMoreData(true);
  //         isLoading(true);
  //         mainList.value.data?.clear();
  //         searchList.clear();
  //         mainList.refresh();
  //       }
  //
  //       // Add page and limit to your API parameters
  //       Map<String, dynamic> param = {
  //         "fromDate": AppDatePicker.convertDateTimeFormat(
  //           fromDateController.value.text,
  //           'dd-MM-yyyy',
  //           'yyyy-MM-dd',
  //         ),
  //         "toDate": AppDatePicker.convertDateTimeFormat(
  //           toDateController.value.text,
  //           'dd-MM-yyyy',
  //           'yyyy-MM-dd',
  //         ),
  //         "syncId": selectedDropdownFirmCode.value,
  //         "filterOrderType": radioCheck.value.toString(),
  //         "page": page.toString(),
  //         "limit": limit.toString(),
  //       };
  //
  //
  //
  //       var response = await DioClient().getQueryParam(
  //         AppURL.orderReportURL,
  //         queryParams: param,
  //       );
  //
  //       var newData = OrderReportResponse.fromJson(response);
  //
  //       debugPrint("API returned: ${newData.data?.length}");
  //       debugPrint("Current page: $page");
  //
  //       if (newData.data != null && newData.data!.isNotEmpty) {
  //         if (newData.message == 'Data fetch successfully') {
  //           if (isLoadMoreReq) {
  //             // Append data if it's a pagination request
  //             mainList.value.data!.addAll(newData.data!);
  //             searchList.addAll(newData.data!);
  //           } else {
  //             // Replace data if it's a fresh request
  //             mainList.value = newData;
  //             searchList.value = newData.data!;
  //           }
  //
  //           // Check if we received less data than the limit, meaning no more pages
  //           if (newData.data!.length < limit) {
  //             hasMoreData(false);
  //           }
  //
  //           filterData();
  //         } else {
  //           AppSnackBar.showGetXCustomSnackBar(
  //             message: response.data['message'],
  //           );
  //         }
  //       } else {
  //         hasMoreData(false);
  //         if (!isLoadMoreReq) {
  //           errorMsg.value = 'No record found.';
  //         }
  //       }
  //     } catch (e) {
  //       Utils.handleException(e);
  //     } finally {
  //       isLoading(false);
  //       isLoadMore(false);
  //       mainList.refresh();
  //     }
  //   } else {
  //     AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
  //   }
  // }

  Future<void> fetchOrder({bool isPagination = false}) async {
    if (!(await Network.isConnected())) {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      return;
    }

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
        "syncId": selectedDropdownFirmCode.value,
        "filterOrderType": radioCheck.value.toString(),
        "page": currentPage.value.toString(),
        "limit": currentPageLimit.value.toString(),
        // "search": searchQuery.value.trim(),     // ← add if backend supports
      };

      var response = await DioClient().getQueryParam(
        AppURL.orderReportURL,
        queryParams: param,
      );

      var newData = OrderReportResponse.fromJson(response);

      if (!isPagination) {
        grandTotal.value = newData.grandTotal ?? 0.0;
      }

      if (newData.data != null && newData.data!.isNotEmpty) {
        mainList.value.data ??= [];

        if (isPagination) {
          mainList.value.data!.addAll(newData.data!);
          searchList.addAll(newData.data!);
        } else {
          mainList.value = newData;
          searchList.value = newData.data!;
        }

        // ── Updated pagination logic ───────────────────────────────────────
        if (newData.pagination != null) {
          totalCount.value = newData.pagination!.totalRecords ?? 0;
          totalPages.value = newData.pagination!.totalPages ?? 1;
          // Optional: you can also store/use hasNextPage if you prefer it over totalPages comparison
        } else {
          // fallback if pagination somehow missing
          totalCount.value = mainList.value.data?.length ?? 0;
          totalPages.value = 1;
        }

        currentPage.value++; // increment AFTER successful append

        filterData();
      } else {
        if (!isPagination) {
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
        // Optional: totalPages.value = currentPage.value; // or similar
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
      isPageLoading(false);
      mainList.refresh();
    }
  }

  // Fetch API Data
  // Future<void> fetchOrder() async {
  //   if (await Network.isConnected()) {
  //     try {
  //       isLoading(true);
  //
  //       // Clear lists before fetching new data
  //       mainList.value.data?.clear();
  //       searchList.clear();
  //       mainList.refresh();
  //
  //       Map<String, dynamic> param = {
  //         "fromDate": AppDatePicker.convertDateTimeFormat(
  //           fromDateController.value.text,
  //           'dd-MM-yyyy',
  //           'yyyy-MM-dd',
  //         ),
  //         "toDate": AppDatePicker.convertDateTimeFormat(
  //           toDateController.value.text,
  //           'dd-MM-yyyy',
  //           'yyyy-MM-dd',
  //         ),
  //         "syncId": selectedDropdownFirmCode.value,
  //         "filterOrderType": radioCheck.value.toString(),
  //       };
  //
  //       var response = await DioClient().getQueryParam(
  //         AppURL.orderReportURL,
  //         queryParams: param,
  //       );
  //
  //       var newData = OrderReportResponse.fromJson(response);
  //
  //       if (newData.data != null && newData.data!.isNotEmpty) {
  //         if (newData.message == 'Data fetch successfully') {
  //           mainList.value = newData;
  //           searchList.value = newData.data!;
  //           filterData();
  //         } else {
  //           AppSnackBar.showGetXCustomSnackBar(
  //             message: response.data['message'],
  //           );
  //         }
  //       } else {
  //         errorMsg.value = 'No record found.';
  //         //AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
  //       }
  //     } catch (e) {
  //       Utils.handleException(e);
  //       //Utils.handleException(Exception(e.toString()));
  //     } finally {
  //       isLoading(false);
  //       mainList.refresh();
  //     }
  //   } else {
  //     AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
  //   }
  // }

  // Filter Data based on search
  void filterData() {
    List<OrderReportModel> filteredList = List.from(searchList); // Start with full list

    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase();
      filteredList =
          filteredList.where((group) {
            return (group.bILLNO != null &&
                    group.bILLNO!.toString().toLowerCase().contains(query)) ||
                (group.oId != null &&
                    group.oId!.toString().toLowerCase().contains(query));
          }).toList();

      if (filteredList.isEmpty) {
        mainList.value.data = [];
        mainList.refresh();
        return;
      }
    }

    mainList.value.data = filteredList;
    mainList.refresh();
  }

  void showBottomSheetDialogExpandPaymentWithoutVocuhNoTable1(
    BuildContext context,
    List<Ordritms> list,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        bool isDark = Theme.of(context).brightness == Brightness.dark;

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            // Separate scroll controllers for vertical and horizontal scrolling
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.drag_handle, size: 30)),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 25.0,
                          border: TableBorder.all(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          columns: [
                            DataColumn(label: CommonText(text: 'Item Name')),
                            DataColumn(label: CommonText(text: 'Batch No/MRP')),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Qty',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Free Qty',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Rate',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Amount',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(label: CommonText(text: 'Remarks')),
                          ],
                          rows:
                              list.map((purchase) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      CommonText(
                                        text: purchase.item?.iTEMNAME ?? '',
                                      ),
                                    ),
                                    DataCell(
                                      CommonText(
                                        text: purchase.item?.lASTSIZE ?? '',
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CommonText(
                                          text:
                                              purchase.qUANTITY?.toString() ??
                                              '',
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CommonText(
                                          text: purchase.oTHERDESC ?? '',
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CommonText(
                                          text: Utils.formatRate(
                                            purchase.rATE?.toString() ?? '',
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CommonText(
                                          text: Utils.formatIndianAmount(
                                            double.parse(
                                              purchase.aMOUNT?.toString() ??
                                                  '0',
                                            ),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      CommonText(
                                        text: purchase.fLD5?.toString() ?? '',
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(
    BuildContext context,
    List<Ordritms> list,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        bool isDark = Theme.of(context).brightness == Brightness.dark;

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            // Separate scroll controllers for vertical and horizontal scrolling
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            // Calculate totals
            // ignore: unused_local_variable
            double totalQty = 0;
            // ignore: unused_local_variable
            double totalFreeQty = 0;
            double totalAmount = 0;

            for (var item in list) {
              totalQty +=
                  double.tryParse(item.qUANTITY?.toString() ?? '0') ?? 0;
              totalFreeQty +=
                  double.tryParse(item.oTHERDESC?.toString() ?? '0') ?? 0;
              // totalAmount +=
              //     double.tryParse(item.aMOUNT?.toString() ?? '0') ?? 0;
              totalAmount += Utils.convertToDouble(
                item.aMOUNT?.toString() ?? '0',
              );
            }

            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.drag_handle, size: 30)),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 25.0,
                          border: TableBorder.all(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          columns: [
                            DataColumn(label: CommonText(text: 'Item Name')),
                            //DataColumn(label: CommonText(text: 'Batch No/MRP')),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Qty',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Free Qty',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Rate',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Amount',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(label: CommonText(text: 'Remarks')),
                          ],
                          rows: [
                            ...list.map((purchase) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    CommonText(
                                      text: purchase.item?.iTEMNAME ?? '',
                                    ),
                                  ),
                                  // DataCell(
                                  //   CommonText(
                                  //     text: purchase.item?.lASTSIZE ?? '',
                                  //   ),
                                  // ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: CommonText(
                                        text: Utils.formatRate(
                                          purchase.qUANTITY?.toString() ?? '',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: CommonText(
                                        text: purchase.oTHERDESC ?? '',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: CommonText(
                                        text: Utils.formatRate(
                                          purchase.rATE?.toString() ?? '',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: CommonText(
                                        text: Utils.formatIndianAmount(
                                          double.parse(
                                            purchase.aMOUNT?.toString() ?? '0',
                                          ),
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    CommonText(
                                      text: purchase.fLD5?.toString() ?? '',
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),

                            // ✅ Add Total Row
                            DataRow(
                              cells: [
                                DataCell(
                                  CommonText(
                                    text: 'Total',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                DataCell(CommonText(text: '')),
                                //DataCell(CommonText(text: '')),
                                // DataCell(
                                //   Align(
                                //     alignment: Alignment.centerRight,
                                //     child: CommonText(
                                //       text: totalQty.toStringAsFixed(2),
                                //       fontWeight: FontWeight.bold,
                                //       textAlign: TextAlign.right,
                                //     ),
                                //   ),
                                // ),
                                DataCell(CommonText(text: '')),

                                // DataCell(
                                //   Align(
                                //     alignment: Alignment.centerRight,
                                //     child: CommonText(
                                //       text: totalFreeQty.toStringAsFixed(2),
                                //       fontWeight: FontWeight.bold,
                                //       textAlign: TextAlign.right,
                                //     ),
                                //   ),
                                // ),
                                DataCell(CommonText(text: '')),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CommonText(
                                      text: Utils.formatIndianAmount(
                                        totalAmount,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                DataCell(CommonText(text: '')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showBottomSheetDialogExpandPaymentWithVocuhNoTable1(
    BuildContext context,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        bool isDark = Theme.of(context).brightness == Brightness.dark;

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            // Separate scroll controllers for vertical and horizontal scrolling
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.drag_handle, size: 30)),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 25,
                          border: TableBorder.all(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          columns: [
                            DataColumn(label: CommonText(text: 'Book Cd')),
                            DataColumn(label: CommonText(text: 'Vouch Dt')),
                            DataColumn(label: CommonText(text: 'Bill No')),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Bill Amt',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Bill Paid Amt',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                          rows:
                              leaderExpandWithVocuhList.value.data?.map((
                                purchase,
                              ) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      CommonText(text: purchase.bLBOOKCD ?? ''),
                                    ),
                                    DataCell(
                                      CommonText(text: purchase.bLVDT ?? ''),
                                    ),
                                    DataCell(
                                      CommonText(text: purchase.bLBILLNO ?? ''),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CommonText(
                                          text: Utils.formatIndianAmount(
                                            double.parse(
                                              purchase.bLAMOUNT?.toString() ??
                                                  '0',
                                            ),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CommonText(
                                          text: Utils.formatIndianAmount(
                                            double.parse(
                                              purchase.bLPAID?.toString() ??
                                                  '0',
                                            ),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showBottomSheetDialogExpandPaymentWithVocuhNoTable(
    BuildContext context,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        bool isDark = Theme.of(context).brightness == Brightness.dark;

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            final purchases = leaderExpandWithVocuhList.value.data ?? [];

            final totalAmount = purchases.fold<double>(0, (sum, item) {
              return sum +
                  (double.tryParse(item.bLAMOUNT?.toString() ?? '0') ?? 0);
            });

            final totalPaid = purchases.fold<double>(0, (sum, item) {
              return sum +
                  (double.tryParse(item.bLPAID?.toString() ?? '0') ?? 0);
            });

            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.drag_handle, size: 30)),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 25,
                          border: TableBorder.all(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          columns: [
                            DataColumn(label: CommonText(text: 'Book Cd')),
                            DataColumn(label: CommonText(text: 'Vouch Dt')),
                            DataColumn(label: CommonText(text: 'Bill No')),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Bill Amt',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: CommonText(
                                  text: 'Bill Paid Amt',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            ...purchases.map((purchase) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    CommonText(text: purchase.bLBOOKCD ?? ''),
                                  ),
                                  DataCell(
                                    CommonText(text: purchase.bLVDT ?? ''),
                                  ),
                                  DataCell(
                                    CommonText(text: purchase.bLBILLNO ?? ''),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: CommonText(
                                        text: Utils.formatIndianAmount(
                                          double.tryParse(
                                            purchase.bLAMOUNT?.toString() ??
                                                '0',
                                          ),
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: CommonText(
                                        text: Utils.formatIndianAmount(
                                          double.tryParse(
                                            purchase.bLPAID?.toString() ?? '0',
                                          ),
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            DataRow(
                              cells: [
                                DataCell(
                                  CommonText(
                                    text: 'Total',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                DataCell(CommonText(text: '')),
                                DataCell(CommonText(text: '')),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CommonText(
                                      text: Utils.formatIndianAmount(
                                        totalAmount,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CommonText(
                                      text: Utils.formatIndianAmount(totalPaid),
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
