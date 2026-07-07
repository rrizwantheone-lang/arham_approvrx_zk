import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_expand_response.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_expand_vocuh_response.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_response.dart';
import 'package:arham_b2c/screens/outstanding/outstanding_expand_response.dart';
import 'package:arham_b2c/screens/outstanding/outstanding_expand_vocuh_response.dart';
import 'package:arham_b2c/screens/outstanding/outstanding_response.dart';
import 'package:arham_b2c/screens/account_ledger/account_ledger_expand_response.dart';
import 'package:arham_b2c/screens/account_ledger/account_ledger_expand_vocuh_response.dart';
import 'package:arham_b2c/screens/account_ledger/account_ledger_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utility/network.dart';
import '../account_ledger/account_ledger_details/ledger_details_view.dart';
import '../outstanding/outstanding_details/outstanding_details_view.dart';
import '../sales_register/sales_register_details/sales_details_view.dart';

class ReportController extends GetxController with GetSingleTickerProviderStateMixin {
  // Tab Controller
  late TabController tabController;
  var currentTabIndex = 0.obs;

  // UI Visibility Toggle
  var isFilterVisible = true.obs;

  // Shared Loading States
  var isLoading = false.obs;
  var isExpandWithoutVouchLoading = false.obs;
  var isExpandWithVouchLoading = false.obs;
  var isDropdownFirmLoading = false.obs;
  RxString errorMsg = ''.obs;

  // Shared Inputs
  Rx<FirmResponse> firmList = FirmResponse().obs;
  final Rx<FirmModel?> selectedDropdownFirm = Rx<FirmModel?>(null);
  RxString selectedDropdownFirmName = ''.obs;
  RxString selectedDropdownFirmCode = ''.obs;

  Rx<TextEditingController> searchGroupController = TextEditingController().obs;
  FocusNode searchGroupFocus = FocusNode();
  RxString searchQuery = ''.obs;

  Rx<TextEditingController> fromDateController = TextEditingController().obs;
  Rx<TextEditingController> toDateController = TextEditingController().obs;
  Rx<TextEditingController> firmController = TextEditingController().obs;

  FocusNode fromDtFocus = FocusNode();
  FocusNode toDtFocus = FocusNode();
  FocusNode firmFocus = FocusNode();

  // --- SALES REGISTER DATA ---
  Rx<SalesRegisterResponse> salesMainList = SalesRegisterResponse().obs;
  RxList<SalesRegisterModel> salesSearchList = <SalesRegisterModel>[].obs;
  Rx<SalesRegisterExpandResponse> salesExpandWithoutVocuhList = SalesRegisterExpandResponse().obs;
  RxList<SalesRegisterExpandModel> salesSearchExpandWithoutVocuhList = <SalesRegisterExpandModel>[].obs;
  Rx<SalesRegisterExpandVouchResponse> salesExpandWithVocuhList = SalesRegisterExpandVouchResponse().obs;
  RxList<SalesRegisterExpandVocuhModel> salesSearchExpandWithVocuhList = <SalesRegisterExpandVocuhModel>[].obs;

  Rx<SalesRegisterModel?> selectedSalesRecord = Rx<SalesRegisterModel?>(null);

  // --- OUTSTANDING DATA ---
  Rx<OutstandingResponse> outstandingMainList = OutstandingResponse().obs;
  RxList<OutstanidngModel> outstandingSearchList = <OutstanidngModel>[].obs;
  Rx<OutstandingExpandResponse> outstandingExpandWithoutVocuhList = OutstandingExpandResponse().obs;
  RxList<OutstandingExpandModel> outstandingSearchExpandWithoutVocuhList = <OutstandingExpandModel>[].obs;
  Rx<OutstandingExpandVouchResponse> outstandingExpandWithVocuhList = OutstandingExpandVouchResponse().obs;
  RxList<OutstandingExpandVocuhModel> outstandingSearchExpandWithVocuhList = <OutstandingExpandVocuhModel>[].obs;

  Rx<OutstanidngModel?> selectedOutstandingRecord = Rx<OutstanidngModel?>(null);


  // --- ACCOUNT LEDGER DATA ---
  Rx<AccountLedgerResponse> ledgerMainList = AccountLedgerResponse().obs;
  RxList<AccountLedgerModel> ledgerSearchList = <AccountLedgerModel>[].obs;
  Rx<AccountLedgerExpandResponse> ledgerExpandWithoutVocuhList = AccountLedgerExpandResponse().obs;
  RxList<AccountLedgerExpandModel> ledgerSearchExpandWithoutVocuhList = <AccountLedgerExpandModel>[].obs;
  Rx<AccountLedgerExpandVouchResponse> ledgerExpandWithVocuhList = AccountLedgerExpandVouchResponse().obs;
  RxList<AccountLedgerExpandVocuhModel> ledgerSearchExpandWithVocuhList = <AccountLedgerExpandVocuhModel>[].obs;

  Rx<AccountLedgerModel?> selectedLedgerRecord = Rx<AccountLedgerModel?>(null);

  // Search Logic for Expand
  Rx<TextEditingController> searchGroupExpandController = TextEditingController().obs;
  FocusNode searchGroupExpandFocus = FocusNode();
  RxString searchExpandQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);

    // Listen to tab changes
    tabController.addListener(() {
      // if (!tabController.indexIsChanging) {  //If you add swipe between tabs
      if (tabController.indexIsChanging) {
        currentTabIndex.value = tabController.index;
        // Optional: Trigger fetch if data is missing when tab changes
        if(selectedDropdownFirmCode.isNotEmpty) {
          triggerActiveTabFetch();
        }
      }
    });

    fetchFirm();
    fromDateController.value.text = AppDatePicker.last1MonthDate();
    toDateController.value.text = AppDatePicker.currentDate();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // Master method to call specific API based on active tab
  void triggerActiveTabFetch() {
    if (selectedDropdownFirmCode.value.isEmpty) return;

    switch (currentTabIndex.value) {
      case 0:
        fetchSalesRegister();
        break;
      case 1:
        fetchOutstanding();
        break;
      case 2:
        fetchLedger();
        break;
    }
  }

  void clearAllData() {
    salesMainList.value.data?.clear();
    salesSearchList.clear();
    outstandingMainList.value.data?.clear();
    outstandingSearchList.clear();
    ledgerMainList.value.data?.clear();
    ledgerSearchList.clear();
    salesMainList.refresh();
    outstandingMainList.refresh();
    ledgerMainList.refresh();
  }

  // --- COMMON LOGIC ---

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
              selectedDropdownFirmCode.value = selectedFirm.syncId.toString().trim();
              firmController.value.text = selectedFirm.firmName.trim();
              Utils.closeKeyboard(Get.context!);
              firmFocus.unfocus();
              triggerActiveTabFetch(); // Call API for the default tab
            }
          } else {
            AppSnackBar.showGetXCustomSnackBar(message: response['message']);
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No distributor found');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isDropdownFirmLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void filterData() {
    // Sales Logic
    if (currentTabIndex.value == 0) {
      List<SalesRegisterModel> filteredList = salesSearchList;
      if (searchQuery.value.isNotEmpty) {
        String query = searchQuery.value.toLowerCase();
        filteredList = filteredList.where((group) {
          return (group.account!.aCCNAME != null && group.account!.aCCNAME!.toLowerCase().contains(query)) ||
              (group.pARTYBL != null && group.pARTYBL!.toString().toLowerCase().contains(query)) ||
              (group.pARTYCD != null && group.pARTYCD!.toString().toLowerCase().contains(query));
        }).toList();
      }
      salesMainList.value.data = filteredList;
      salesMainList.refresh();
    }
    // Outstanding Logic
    else if (currentTabIndex.value == 1) {
      List<OutstanidngModel> filteredList = outstandingSearchList;
      if (searchQuery.value.isNotEmpty) {
        String query = searchQuery.value.toLowerCase();
        filteredList = filteredList.where((group) {
          return (group.pARTYBL != null && group.pARTYBL!.toLowerCase().contains(query)) ||
              (group.oSAMT != null && group.oSAMT!.toString().toLowerCase().contains(query)) ||
              (group.vOUCHNO != null && group.vOUCHNO!.toString().toLowerCase().contains(query));
        }).toList();
      }
      outstandingMainList.value.data = filteredList;
      outstandingMainList.refresh();
    }
    // Ledger Logic
    else if (currentTabIndex.value == 2) {
      List<AccountLedgerModel> filteredList = ledgerSearchList;
      if (searchQuery.value.isNotEmpty) {
        String query = searchQuery.value.toLowerCase();
        filteredList = filteredList.where((group) {
          return (group.aCCNAME != null && group.aCCNAME!.toLowerCase().contains(query)) ||
              (group.bILLNO != null && group.bILLNO!.toString().toLowerCase().contains(query)) ||
              (group.vOUCHNO != null && group.vOUCHNO!.toString().toLowerCase().contains(query));
        }).toList();
      }
      ledgerMainList.value.data = filteredList;
      ledgerMainList.refresh();
    }
  }

  // --- SALES REGISTER API LOGIC ---

  Future<void> fetchSalesRegister() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);
        salesMainList.value.data?.clear();
        salesSearchList.clear();
        salesMainList.refresh();

        Map<String, dynamic> param = {
          "fromDate": AppDatePicker.convertDateTimeFormat(fromDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          "toDate": AppDatePicker.convertDateTimeFormat(toDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          "syncId": selectedDropdownFirmCode.value,
        };
        var response = await DioClient().getQueryParam(AppURL.saleRegisterReportURL, queryParams: param);
        var newData = SalesRegisterResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          if (newData.message == 'Data fetch successfully') {
            salesMainList.value = newData;
            salesSearchList.value = newData.data!;
            filterData();
          } else {
            AppSnackBar.showGetXCustomSnackBar(message: response.data['message']);
          }
        } else {
          errorMsg.value = 'No record found from\n${fromDateController.value.text} to ${toDateController.value.text}.';
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isLoading(false);
        salesMainList.refresh();
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  Future<void> fetchExpandPaymentWithoutVouchSales(
      String type,
      String bookCD,
      String vouchDt,
      String partyCd,
      String vouchNo,
      ) async {
    // Copied logic from SalesRegisterController using shared loading/lists
    if (await Network.isConnected()) {
      try {
        isExpandWithoutVouchLoading(true);
        Map<String, dynamic> param = {
          "fromDate": AppDatePicker.convertDateTimeFormat(fromDateController.value.text,'dd-MM-yyyy','yyyy-MM-dd'),
          "toDate": AppDatePicker.convertDateTimeFormat(toDateController.value.text,'dd-MM-yyyy','yyyy-MM-dd'),
          "syncId": selectedDropdownFirmCode.value,
          "type": type, "bookCd": bookCD, "vouchDt": vouchDt, "partyCd": partyCd, "vouchNo": vouchNo,
        };
        var response = await DioClient().getQueryParam(AppURL.saleRegisterReportURL, queryParams: param);
        salesExpandWithoutVocuhList.value = SalesRegisterExpandResponse.fromJson(response);
        if (salesExpandWithoutVocuhList.value.data!.isNotEmpty && salesExpandWithoutVocuhList.value.message == 'Data fetch successfully') {
          salesSearchExpandWithoutVocuhList.value = salesExpandWithoutVocuhList.value.data!;
          // filterExpandDataWithoutVouch(); // Implement if needed
          // showBottomSheetDialog...
          filterExpandDataWithoutVouchSales();
          Get.to(() => SalesDetailsView(
            isWithVouch: false,
            partyCD: partyCd,
            bookCD: bookCD,
            date: vouchDt,), transition: Transition.rightToLeftWithFade,
          );
          // showBottomSheetDialogExpandPaymentWithoutVocuhNoTableSales(Get.context!);
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isExpandWithoutVouchLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  //Self implement
  void filterExpandDataWithoutVouchSales() {
    if (searchExpandQuery.value.isEmpty) {
      // No search query, show all data
      salesExpandWithoutVocuhList.value.data = salesSearchExpandWithoutVocuhList;
    } else {
      salesExpandWithoutVocuhList.value.data =
          salesSearchExpandWithoutVocuhList.where((group) {
            return group.iTEMCD!.toLowerCase().contains(
              searchExpandQuery.value.toLowerCase(),
            );
          }).toList();
    }

    salesMainList.refresh(); // This is the correct way to trigger the update
  }

  //Self implement
  void showBottomSheetDialogExpandPaymentWithoutVocuhNoTable1(
      BuildContext context,
      ) {
    showModalBottomSheet(
      backgroundColor:
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]!
          : Colors.white,
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
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 0.95,
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
                            //DataColumn(label: CommonText(text: 'Item CD')),
                            DataColumn(label: CommonText(text: 'Item Name')),
                            DataColumn(label: CommonText(text: 'Batch No')),
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
                          ],
                          rows:
                          salesExpandWithoutVocuhList.value.data?.map((
                              purchase,
                              ) {
                            return DataRow(
                              cells: [
                                // DataCell(
                                //   CommonText(text: purchase.iTEMCD ?? ''),
                                // ),
                                DataCell(
                                  CommonText(
                                    text: purchase.item?.iTEMNAME ?? '',
                                  ),
                                ),
                                DataCell(
                                  CommonText(text: purchase.sIZECD ?? ''),
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
                                      text: purchase.rATE?.toString() ?? '',
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
                                          purchase.vOUCHAMT?.toString() ??
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

  //Self implement
  void showBottomSheetDialogExpandPaymentWithoutVocuhNoTableSales(
      BuildContext context,
      ) {
    showModalBottomSheet(
      backgroundColor:
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]!
          : Colors.white,
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
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            final purchases = salesExpandWithoutVocuhList.value.data ?? [];

            final totalAmount = purchases.fold<double>(0, (sum, item) {
              final amt =
                  double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0;
              return sum + amt;
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
                          columnSpacing: 25.0,
                          border: TableBorder.all(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          columns: [
                            DataColumn(label: CommonText(text: 'Item Name')),
                            DataColumn(label: CommonText(text: 'Batch No')),
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
                          ],
                          rows: [
                            ...purchases.map((purchase) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    CommonText(
                                      text: purchase.item?.iTEMNAME ?? '',
                                    ),
                                  ),
                                  DataCell(
                                    CommonText(text: purchase.sIZECD ?? ''),
                                  ),
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
                                          purchase.rATE != null
                                              ? purchase.rATE!.toString()
                                              : '',
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
                                            purchase.vOUCHAMT?.toString() ??
                                                '0',
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

  void filterExpandDataWithVouchSales() {
    if (searchExpandQuery.value.isEmpty) {
      // No search query, show all data
      salesExpandWithoutVocuhList.value.data = salesSearchExpandWithoutVocuhList;
    } else {
      salesExpandWithoutVocuhList.value.data =
          salesSearchExpandWithoutVocuhList.where((group) {
            return group.iTEMCD!.toLowerCase().contains(
              searchExpandQuery.value.toLowerCase(),
            );
          }).toList();
    }

    salesMainList.refresh(); // This is the correct way to trigger the update
  }


  // Note: Add fetchExpandPaymentWithVouchSales similarly if needed, adhering to strict no change policy unless necessary logic flow.
  Future<void> fetchExpandPaymentWithVouchSales(
      String type,
      String bookCD,
      String vouchDt,
      String partyCd,
      String vouchNo,
      ) async {
    if (await Network.isConnected()) {
      try {
        print('call api 2');
        isExpandWithVouchLoading(true);

        //TODO: This Type BookCd [SA/SR/PU/PR/SO/SI/WS] Not Bind Vouch No
        //TODO: This Type BookCd [RC/PY/EP/IC/JV] Bind Vouch No

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
          // "fromDate": AppDatePicker.convertDateTimeFormat(fromDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          // "toDate": AppDatePicker.convertDateTimeFormat(toDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          "syncId": selectedDropdownFirmCode.value,
          "type": type,
          "bookCd": bookCD,
          "vouchDt": vouchDt,
          "partyCd": partyCd,
          "vouchNo": vouchNo,
          // if (bookCD == 'RC' ||
          //     bookCD == 'PY' ||
          //     //bookCD == 'PU' ||
          //     bookCD == 'EP' ||
          //     bookCD == 'IC' ||
          //     bookCD == 'JV')
          //   "vouchNo": vouchNo,
        };

        var response = await DioClient().getQueryParam(
          AppURL.saleRegisterReportURL,
          queryParams: param,
        );

        salesExpandWithVocuhList
            .value = SalesRegisterExpandVouchResponse.fromJson(response);

        if (salesExpandWithVocuhList.value.data!.isNotEmpty) {
          if (salesExpandWithVocuhList.value.message ==
              'Data fetch successfully') {
            // Data fetched successfully, no further action needed
            // Store the original data in searchList for filtering
            salesSearchExpandWithVocuhList.value =
            salesExpandWithVocuhList.value.data!;

            // Apply initial filtering based on the search query if any
            filterExpandDataWithVouchSales();

            Get.to(() => SalesDetailsView(
              isWithVouch: true,
              partyCD: partyCd,
              bookCD: bookCD,
              date: vouchDt,
            ),
              transition: Transition.rightToLeftWithFade,
            );
            //showBottomSheetDialogExpandPaymentWithVocuhNo(Get.context!);
            // showBottomSheetDialogExpandPaymentWithVocuhNoTableSales(Get.context!);
          } else {
            // Show failure message based on the response
            AppSnackBar.showGetXCustomSnackBar(
              //message: response.data['message'],
              //message: response['message'],
              message: 'No record found.',
            );
          }
        } else {
          // Handle empty data response
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isExpandWithVouchLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void showBottomSheetDialogExpandPaymentWithVocuhNoTableSales(
      BuildContext context,
      ) {
    showModalBottomSheet(
      backgroundColor:
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]!
          : Colors.white,
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
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            final purchases = salesExpandWithVocuhList.value.data ?? [];

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

  // --- OUTSTANDING API LOGIC ---

  int calculateDueDays(String? dueDate) {
    if (dueDate == null) return 0;
    DateTime dueDateTime = DateTime.parse(dueDate);
    DateTime today = DateTime.now();
    return dueDateTime.difference(today).inDays;
  }

  Future<void> fetchOutstanding() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);
        outstandingMainList.value.data?.clear();
        outstandingSearchList.clear();
        outstandingMainList.refresh();

        Map<String, dynamic> param = {
          "fromDate": AppDatePicker.convertDateTimeFormat(fromDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          "toDate": AppDatePicker.convertDateTimeFormat(toDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          "syncId": selectedDropdownFirmCode.value,
        };
        var response = await DioClient().getQueryParam(AppURL.outstandingReportURL, queryParams: param);
        var newData = OutstandingResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          if (newData.message == 'Data fetch successfully') {
            outstandingMainList.value = newData;
            outstandingSearchList.value = newData.data!;
            filterData();
          } else {
            AppSnackBar.showGetXCustomSnackBar(message: response.data['message']);
          }
        } else {
          errorMsg.value = 'No record found.';
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isLoading(false);
        outstandingMainList.refresh();
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  // Add expand methods for Outstanding similarly, pointing to outstandingExpand lists...

  Future<void> fetchExpandPaymentWithoutVouchOutstanding(
      String type,
      String bookCD,
      String vouchDt,
      String partyCd,
      String vouchNo,
      ) async {
    if (await Network.isConnected()) {
      try {
        print('call this api 1');

        isExpandWithoutVouchLoading(true);

        Map<String, dynamic> param = {
          "toDate": AppDatePicker.convertDateTimeFormat(
            toDateController.value.text,
            'dd-MM-yyyy',
            'yyyy-MM-dd',
          ),
          "syncId": selectedDropdownFirmCode.value,
          "type": type,
          "bookCd": bookCD,
          "vouchDt": vouchDt,
          "partyCd": partyCd,
          "vouchNo": vouchNo,
          // if (bookCD == 'RC' ||
          //     bookCD == 'PY' ||
          //     //bookCD == 'PU' ||
          //     bookCD == 'EP' ||
          //     bookCD == 'IC' ||
          //     bookCD == 'JV')
          //   "vouchNo": vouchNo,
        };

        var response = await DioClient().getQueryParam(
          AppURL.outstandingReportURL,
          queryParams: param,
        );

        outstandingExpandWithoutVocuhList
            .value = OutstandingExpandResponse.fromJson(response);

        if (outstandingExpandWithoutVocuhList.value.data!.isNotEmpty) {
          if (outstandingExpandWithoutVocuhList.value.message ==
              'Data fetch successfully') {
            outstandingSearchExpandWithoutVocuhList.value =
            outstandingExpandWithoutVocuhList.value.data!;

            filterExpandDataWithoutVouchOutstanding();

            Get.to(() => OutstandingDetailsView(
              isWithVouch: false,
              // orderNo: vouchNo,
              // invDate: vouchDt,
              // dueDate: partyCd,
              // dueDays: vouchNo,
              // bookCD: bookCD,
            ), transition: Transition.rightToLeftWithFade);

            //showBottomSheetDialogExpandPaymentWithoutVocuhNo(Get.context!);
            // showBottomSheetDialogExpandPaymentWithoutVocuhNoTableOutstanding(Get.context!);
          } else {
            // Show failure message based on the response
            AppSnackBar.showGetXCustomSnackBar(message: response['message']);
          }
        } else {
          // Handle empty data response
          //errorMsg.value = 'No record found.';
          // AppSnackBar.showGetXCustomSnackBar(
          //   message: response['message'] ?? 'No record found.',
          // );
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isExpandWithoutVouchLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void filterExpandDataWithoutVouchOutstanding() {
    if (searchExpandQuery.value.isEmpty) {
      // No search query, show all data
      outstandingExpandWithoutVocuhList.value.data =
          outstandingSearchExpandWithoutVocuhList;
    } else {
      outstandingExpandWithoutVocuhList.value.data =
          outstandingSearchExpandWithoutVocuhList.where((group) {
            return group.iTEMCD!.toLowerCase().contains(
              searchExpandQuery.value.toLowerCase(),
            );
          }).toList();
    }

    outstandingMainList.refresh(); // This is the correct way to trigger the update
  }

  void showBottomSheetDialogExpandPaymentWithoutVocuhNoTableOutstanding(
      BuildContext context,
      ) {
    showModalBottomSheet(
      backgroundColor:
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]!
          : Colors.white,
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
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            final purchases =
                outstandingExpandWithoutVocuhList.value.data ?? [];

            final totalAmount = purchases.fold<double>(0, (sum, item) {
              final amt =
                  double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0;
              return sum + amt;
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
                          columnSpacing: 25.0,
                          border: TableBorder.all(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          columns: [
                            DataColumn(label: CommonText(text: 'Item Name')),
                            DataColumn(label: CommonText(text: 'Batch No')),
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
                          ],
                          rows: [
                            ...purchases.map((purchase) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    CommonText(
                                      text: purchase.item?.iTEMNAME ?? '',
                                    ),
                                  ),
                                  DataCell(
                                    CommonText(text: purchase.sIZECD ?? ''),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: CommonText(
                                        text:
                                        purchase.qUANTITY?.toString() ?? '',
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
                                        text:
                                        purchase.rATE != null
                                            ? purchase.rATE!
                                            .toStringAsFixed(2)
                                            : '',
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
                                            purchase.vOUCHAMT?.toString() ??
                                                '0',
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

  Future<void> fetchExpandPaymentWithVouchOutstanding(
      String type,
      String bookCD,
      String vouchDt,
      String partyCd,
      String vouchNo,
      ) async {
    if (await Network.isConnected()) {
      try {
        print('call this api 2');
        isExpandWithVouchLoading(true);

        //TODO: This Type BookCd [SA/SR/PU/PR/SO/SI/WS] Not Bind Vouch No
        //TODO: This Type BookCd [RC/PY/EP/IC/JV] Bind Vouch No

        Map<String, dynamic> param = {
          //"toDate": AppDatePicker.currentYYYYMMDDDate(),
          "toDate": AppDatePicker.convertDateTimeFormat(
            toDateController.value.text,
            'dd-MM-yyyy',
            'yyyy-MM-dd',
          ),
          "syncId": selectedDropdownFirmCode.value,
          "type": type,
          "bookCd": bookCD,
          "vouchDt": vouchDt,
          "partyCd": partyCd,
          "vouchNo": vouchNo,
          // if (bookCD == 'RC' ||
          //     bookCD == 'PY' ||
          //     //bookCD == 'PU' ||
          //     bookCD == 'EP' ||
          //     bookCD == 'IC' ||
          //     bookCD == 'JV')
          //   "vouchNo": vouchNo,
        };

        var response = await DioClient().getQueryParam(
          AppURL.outstandingReportURL,
          queryParams: param,
        );

        outstandingExpandWithVocuhList
            .value = OutstandingExpandVouchResponse.fromJson(response);

        if (outstandingExpandWithVocuhList.value.data!.isNotEmpty) {
          if (outstandingExpandWithVocuhList.value.message ==
              'Data fetch successfully') {
            // Data fetched successfully, no further action needed
            // Store the original data in searchList for filtering
            outstandingSearchExpandWithVocuhList.value =
            outstandingExpandWithVocuhList.value.data!;

            // Apply initial filtering based on the search query if any
            filterExpandDataWithVouchOutstanding();

            Get.to(() => OutstandingDetailsView(
              isWithVouch: true,
              // orderNo: vouchNo,
              // invDate: vouchDt,
              // dueDate: partyCd,
              // dueDays: vouchNo,
              // bookCD: bookCD,
            ), transition: Transition.rightToLeftWithFade);

            //showBottomSheetDialogExpandPaymentWithVocuhNo(Get.context!);
            // showBottomSheetDialogExpandPaymentWithVocuhNoTableOutstanding(Get.context!);
          } else {
            // Show failure message based on the response
            AppSnackBar.showGetXCustomSnackBar(message: response['message']);
          }
        } else {
          // Handle empty data response
          //errorMsg.value = 'No record found.';
          // AppSnackBar.showGetXCustomSnackBar(
          //   message: response['message'] ?? 'No record found.',
          // );
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isExpandWithVouchLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void filterExpandDataWithVouchOutstanding() {
    if (searchExpandQuery.value.isEmpty) {
      // No search query, show all data
      outstandingExpandWithoutVocuhList.value.data =
          outstandingSearchExpandWithoutVocuhList;
    } else {
      outstandingExpandWithoutVocuhList.value.data =
          outstandingSearchExpandWithoutVocuhList.where((group) {
            return group.iTEMCD!.toLowerCase().contains(
              searchExpandQuery.value.toLowerCase(),
            );
          }).toList();
    }

    outstandingMainList.refresh(); // This is the correct way to trigger the update
  }

  void showBottomSheetDialogExpandPaymentWithVocuhNoTableOutstanding(
      BuildContext context,
      ) {
    showModalBottomSheet(
      backgroundColor:
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]!
          : Colors.white,
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
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            final purchases = outstandingExpandWithVocuhList.value.data ?? [];

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

  // --- ACCOUNT LEDGER API LOGIC ---

  Future<void> fetchLedger() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);
        ledgerMainList.value.data?.clear();
        ledgerSearchList.clear();
        ledgerMainList.refresh();

        Map<String, dynamic> param = {
          "fromDate": AppDatePicker.convertDateTimeFormat(fromDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          "toDate": AppDatePicker.convertDateTimeFormat(toDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          "syncId": selectedDropdownFirmCode.value,
        };
        var response = await DioClient().getQueryParam(AppURL.accountLedgerReportURL, queryParams: param);
        var newData = AccountLedgerResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          if (newData.message == 'Data fetch successfully') {
            ledgerMainList.value = newData;
            ledgerSearchList.value = newData.data!;
            filterData();
          } else {
            AppSnackBar.showGetXCustomSnackBar(message: response.data['message']);
          }
        } else {
          errorMsg.value =
          'No record found from\n${fromDateController.value.text} to ${toDateController.value.text}.';
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isLoading(false);
        ledgerMainList.refresh();
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  Future<void> fetchExpandPaymentWithoutVouchLedger(
      String type,
      String bookCD,
      String vouchDt,
      String partyCd,
      String vouchNo,
      ) async {
    if (await Network.isConnected()) {
      try {
        print('call api 1');
        isExpandWithoutVouchLoading(true);

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
          "type": type,
          "bookCd": bookCD,
          "vouchDt": vouchDt,
          "partyCd": partyCd,
          "vouchNo": vouchNo,
          // if (bookCD == 'RC' ||
          //     bookCD == 'PY' ||
          //     //bookCD == 'PU' ||
          //     bookCD == 'EP' ||
          //     bookCD == 'IC' ||
          //     bookCD == 'JV')
          //   "vouchNo": vouchNo,
        };

        var response = await DioClient().getQueryParam(
          AppURL.accountLedgerReportURL,
          queryParams: param,
        );

        ledgerExpandWithoutVocuhList
            .value = AccountLedgerExpandResponse.fromJson(response);

        if (ledgerExpandWithoutVocuhList.value.data!.isNotEmpty &&
            ledgerExpandWithoutVocuhList.value.message ==
                'Data fetch successfully') {
          ledgerSearchExpandWithoutVocuhList.value =
          ledgerExpandWithoutVocuhList.value.data!;

          filterExpandDataWithoutVouchLedger();

          Get.to(() => LedgerDetailsView(isWithVouch: false), transition: Transition.rightToLeftWithFade);

          //showBottomSheetDialogExpandPaymentWithoutVocuhNo(Get.context!);
          // showBottomSheetDialogExpandPaymentWithoutVocuhNoTableLedger(Get.context!);
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isExpandWithoutVouchLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void filterExpandDataWithoutVouchLedger() {
    if (searchExpandQuery.value.isEmpty) {
      // No search query, show all data
      ledgerExpandWithoutVocuhList.value.data = ledgerSearchExpandWithoutVocuhList;
    } else {
      ledgerExpandWithoutVocuhList.value.data =
          ledgerSearchExpandWithoutVocuhList.where((group) {
            return group.iTEMCD!.toLowerCase().contains(
              searchExpandQuery.value.toLowerCase(),
            );
          }).toList();
    }

    ledgerMainList.refresh(); // This is the correct way to trigger the update
  }

  void showBottomSheetDialogExpandPaymentWithoutVocuhNoTableLedger(
      BuildContext context,
      ) {
    showModalBottomSheet(
      backgroundColor:
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]!
          : Colors.white,
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
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            final purchases = ledgerExpandWithoutVocuhList.value.data ?? [];

            final totalAmount = purchases.fold<double>(0, (sum, item) {
              final amt =
                  double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0;
              return sum + amt;
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
                          columnSpacing: 25.0,
                          border: TableBorder.all(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          columns: [
                            DataColumn(label: CommonText(text: 'Item Name')),
                            DataColumn(label: CommonText(text: 'Batch No')),
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
                          ],
                          rows: [
                            ...purchases.map((purchase) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    CommonText(
                                      text: purchase.item?.iTEMNAME ?? '',
                                    ),
                                  ),
                                  DataCell(
                                    CommonText(text: purchase.sIZECD ?? ''),
                                  ),
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
                                          purchase.rATE != null
                                              ? purchase.rATE!.toStringAsFixed(
                                            2,
                                          )
                                              : '',
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
                                            purchase.vOUCHAMT?.toString() ??
                                                '0',
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

  Future<void> fetchExpandPaymentWithVouchLedger(
      String type,
      String bookCD,
      String vouchDt,
      String partyCd,
      String vouchNo,
      ) async {
    if (await Network.isConnected()) {
      try {
        isExpandWithVouchLoading(true);

        //TODO: This Type BookCd [SA/SR/PU/PR/SO/SI/WS] Not Bind Vouch No
        //TODO: This Type BookCd [RC/PY/EP/IC/JV] Bind Vouch No

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
          "type": type,
          "bookCd": bookCD,
          "vouchDt": vouchDt,
          "partyCd": partyCd,
          "vouchNo": vouchNo,
          // if (bookCD == 'RC' ||
          //     bookCD == 'PY' ||
          //     //bookCD == 'PU' ||
          //     bookCD == 'EP' ||
          //     bookCD == 'IC' ||
          //     bookCD == 'JV')
          //   "vouchNo": vouchNo,
        };

        var response = await DioClient().getQueryParam(
          AppURL.accountLedgerReportURL,
          queryParams: param,
        );

        ledgerExpandWithVocuhList
            .value = AccountLedgerExpandVouchResponse.fromJson(response);

        if (ledgerExpandWithVocuhList.value.data!.isNotEmpty) {
          if (ledgerExpandWithVocuhList.value.message ==
              'Data fetch successfully') {
            // Data fetched successfully, no further action needed
            // Store the original data in searchList for filtering
            ledgerSearchExpandWithVocuhList.value =
            ledgerExpandWithVocuhList.value.data!;

            // Apply initial filtering based on the search query if any
            filterExpandDataWithVouchLedger();

            Get.to(() => LedgerDetailsView(isWithVouch: true), transition: Transition.rightToLeftWithFade);

            //showBottomSheetDialogExpandPaymentWithVocuhNo(Get.context!);
            // showBottomSheetDialogExpandPaymentWithVocuhNoTableLedger(Get.context!);
          } else {
            // Show failure message based on the response

            // AppSnackBar.showGetXCustomSnackBar(
            //   message: response.data['message'],
            // );

            AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
          }
        } else {
          // Handle empty data response
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isExpandWithVouchLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void filterExpandDataWithVouchLedger() {
    if (searchExpandQuery.value.isEmpty) {
      // No search query, show all data
      ledgerExpandWithoutVocuhList.value.data = ledgerSearchExpandWithoutVocuhList;
    } else {
      ledgerExpandWithoutVocuhList.value.data =
          ledgerSearchExpandWithoutVocuhList.where((group) {
            return group.iTEMCD!.toLowerCase().contains(
              searchExpandQuery.value.toLowerCase(),
            );
          }).toList();
    }

    ledgerMainList.refresh(); // This is the correct way to trigger the update
  }

  void showBottomSheetDialogExpandPaymentWithVocuhNoTableLedger(
      BuildContext context,
      ) {
    showModalBottomSheet(
      backgroundColor:
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]!
          : Colors.white,
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
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            final purchases = ledgerExpandWithVocuhList.value.data ?? [];

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


// Add expand methods for Ledger similarly...
// NOTE: For brevity in this response I am not copying the Expand/Bottom Sheet logic for all 3 again
// as it is huge, but in your real file, you MUST copy the 'fetchExpand...' and 'showBottomSheet...'
// methods from the original controllers into this one, renaming the list variables to the specific ones
// defined above (salesExpand..., outstandingExpand..., ledgerExpand...).
}










//=============
// CHATGPT
//=============

// import 'package:arham_b2c/api/dio_client.dart';
// import 'package:arham_b2c/app/app_date_format.dart';
// import 'package:arham_b2c/app/app_snack_bar.dart';
// import 'package:arham_b2c/app/app_url.dart';
// import 'package:arham_b2c/models/firm_response.dart';
// import 'package:arham_b2c/screens/account_ledger/account_ledger_response.dart';
// import 'package:arham_b2c/screens/outstanding/outstanding_response.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_response.dart';
// import 'package:arham_b2c/utility/constants.dart';
// import 'package:arham_b2c/utility/network.dart';
// import 'package:arham_b2c/utility/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ReportController extends GetxController {
//
//   /// ==============================
//   /// COMMON STATE (SHARED IN TABS)
//   /// ==============================
//
//   RxInt selectedTabIndex = 0.obs;
//
//   var isDropdownFirmLoading = false.obs;
//   Rx<FirmResponse> firmList = FirmResponse().obs;
//
//   final Rx<FirmModel?> selectedDropdownFirm = Rx<FirmModel?>(null);
//   RxString selectedDropdownFirmCode = ''.obs;
//
//   Rx<TextEditingController> firmController = TextEditingController().obs;
//   FocusNode firmFocus = FocusNode();
//
//   Rx<TextEditingController> fromDateController = TextEditingController().obs;
//   Rx<TextEditingController> toDateController = TextEditingController().obs;
//
//   FocusNode fromDtFocus = FocusNode();
//   FocusNode toDtFocus = FocusNode();
//
//   Rx<TextEditingController> searchController = TextEditingController().obs;
//   FocusNode searchFocus = FocusNode();
//   RxString searchQuery = ''.obs;
//
//   RxBool showFilters = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _setDefaultDates();
//     fetchFirmList();
//   }
//
//   void _setDefaultDates() {
//     String today = AppDatePicker.currentDate();
//     fromDateController.value.text = today;
//     toDateController.value.text = today;
//   }
//
//   /// ==============================
//   /// SALES REGISTER
//   /// ==============================
//
//   var isSalesLoading = false.obs;
//   Rx<SalesRegisterResponse> salesList = SalesRegisterResponse().obs;
//   RxList<SalesRegisterModel> salesSearchList = <SalesRegisterModel>[].obs;
//
//   Future<void> fetchSalesRegister() async {
//     if (selectedDropdownFirmCode.isEmpty) return;
//
//     if (await Network.isConnected()) {
//       try {
//         isSalesLoading(true);
//
//         Map<String, dynamic> param = {
//           "fromDate": AppDatePicker.convertDateTimeFormat(
//             fromDateController.value.text,
//             'dd-MM-yyyy',
//             'yyyy-MM-dd',
//           ),
//           "toDate": AppDatePicker.convertDateTimeFormat(
//             toDateController.value.text,
//             'dd-MM-yyyy',
//             'yyyy-MM-dd',
//           ),
//           "syncId": selectedDropdownFirmCode.value,
//         };
//
//         var response = await DioClient().getQueryParam(
//           AppURL.saleRegisterReportURL,
//           queryParams: param,
//         );
//
//         salesList.value = SalesRegisterResponse.fromJson(response);
//
//         if (salesList.value.data != null) {
//           salesSearchList.value = salesList.value.data!;
//           filterSalesData();
//         }
//       } catch (e) {
//         Utils.handleException(e);
//       } finally {
//         isSalesLoading(false);
//       }
//     } else {
//       AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
//     }
//   }
//
//   void filterSalesData() {
//     if (searchQuery.value.isEmpty) {
//       salesList.value.data = salesSearchList;
//     } else {
//       salesList.value.data = salesSearchList.where((item) {
//         return (item.account?.aCCNAME ?? '')
//             .toLowerCase()
//             .contains(searchQuery.value.toLowerCase()) ||
//             (item.pARTYBL ?? '')
//                 .toLowerCase()
//                 .contains(searchQuery.value.toLowerCase());
//       }).toList();
//     }
//     salesList.refresh();
//   }
//
//   /// ==============================
//   /// OUTSTANDING
//   /// ==============================
//
//   var isOutstandingLoading = false.obs;
//   Rx<OutstandingResponse> outstandingList = OutstandingResponse().obs;
//   RxList<OutstandingModel> outstandingSearchList =
//       <OutstandingModel>[].obs;
//
//   Future<void> fetchOutstanding() async {
//     if (selectedDropdownFirmCode.isEmpty) return;
//
//     if (await Network.isConnected()) {
//       try {
//         isOutstandingLoading(true);
//
//         Map<String, dynamic> param = {
//           "toDate": AppDatePicker.convertDateTimeFormat(
//             toDateController.value.text,
//             'dd-MM-yyyy',
//             'yyyy-MM-dd',
//           ),
//           "syncId": selectedDropdownFirmCode.value,
//         };
//
//         var response = await DioClient().getQueryParam(
//           AppURL.outstandingReportURL,
//           queryParams: param,
//         );
//
//         outstandingList.value = OutstandingResponse.fromJson(response);
//
//         if (outstandingList.value.data != null) {
//           outstandingSearchList.value = outstandingList.value.data!;
//           filterOutstandingData();
//         }
//       } catch (e) {
//         Utils.handleException(e);
//       } finally {
//         isOutstandingLoading(false);
//       }
//     } else {
//       AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
//     }
//   }
//
//   void filterOutstandingData() {
//     if (searchQuery.value.isEmpty) {
//       outstandingList.value.data = outstandingSearchList;
//     } else {
//       outstandingList.value.data =
//           outstandingSearchList.where((item) {
//             return (item.aCCNAME ?? '')
//                 .toLowerCase()
//                 .contains(searchQuery.value.toLowerCase());
//           }).toList();
//     }
//     outstandingList.refresh();
//   }
//
//   /// ==============================
//   /// ACCOUNT LEDGER
//   /// ==============================
//
//   var isLedgerLoading = false.obs;
//   Rx<AccountLedgerResponse> ledgerList = AccountLedgerResponse().obs;
//   RxList<AccountLedgerModel> ledgerSearchList =
//       <AccountLedgerModel>[].obs;
//
//   Future<void> fetchLedger() async {
//     if (selectedDropdownFirmCode.isEmpty) return;
//
//     if (await Network.isConnected()) {
//       try {
//         isLedgerLoading(true);
//
//         Map<String, dynamic> param = {
//           "fromDate": AppDatePicker.convertDateTimeFormat(
//             fromDateController.value.text,
//             'dd-MM-yyyy',
//             'yyyy-MM-dd',
//           ),
//           "toDate": AppDatePicker.convertDateTimeFormat(
//             toDateController.value.text,
//             'dd-MM-yyyy',
//             'yyyy-MM-dd',
//           ),
//           "syncId": selectedDropdownFirmCode.value,
//         };
//
//         var response = await DioClient().getQueryParam(
//           AppURL.accountLedgerReportURL,
//           queryParams: param,
//         );
//
//         ledgerList.value = AccountLedgerResponse.fromJson(response);
//
//         if (ledgerList.value.data != null) {
//           ledgerSearchList.value = ledgerList.value.data!;
//           filterLedgerData();
//         }
//       } catch (e) {
//         Utils.handleException(e);
//       } finally {
//         isLedgerLoading(false);
//       }
//     } else {
//       AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
//     }
//   }
//
//   void filterLedgerData() {
//     if (searchQuery.value.isEmpty) {
//       ledgerList.value.data = ledgerSearchList;
//     } else {
//       ledgerList.value.data = ledgerSearchList.where((item) {
//         return (item.aCCNAME ?? '')
//             .toLowerCase()
//             .contains(searchQuery.value.toLowerCase());
//       }).toList();
//     }
//     ledgerList.refresh();
//   }
//
//   /// ==============================
//   /// FIRM LIST
//   /// ==============================
//
//   Future<void> fetchFirmList() async {
//     if (await Network.isConnected()) {
//       try {
//         isDropdownFirmLoading(true);
//
//         var response =
//         await DioClient().get(AppURL.dropdownFirmURL);
//
//         firmList.value = FirmResponse.fromJson(response);
//       } catch (e) {
//         Utils.handleException(e);
//       } finally {
//         isDropdownFirmLoading(false);
//       }
//     }
//   }
//
//   /// ==============================
//   /// COMMON FILTER HANDLER
//   /// ==============================
//
//   void onSearchChanged(String value) {
//     searchQuery.value = value;
//
//     if (selectedTabIndex.value == 0) {
//       filterSalesData();
//     } else if (selectedTabIndex.value == 1) {
//       filterOutstandingData();
//     } else {
//       filterLedgerData();
//     }
//   }
//
//   void onDistributorSelected(FirmModel firm) {
//     selectedDropdownFirm.value = firm;
//     selectedDropdownFirmCode.value = firm.syncId.toString();
//     firmController.value.text = firm.firmName ?? '';
//
//     if (selectedTabIndex.value == 0) {
//       fetchSalesRegister();
//     } else if (selectedTabIndex.value == 1) {
//       fetchOutstanding();
//     } else {
//       fetchLedger();
//     }
//   }
// }