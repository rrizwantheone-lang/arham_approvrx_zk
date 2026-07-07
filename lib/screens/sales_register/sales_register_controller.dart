// import 'package:arham_b2c/api/dio_client.dart';
// import 'package:arham_b2c/app/app_date_format.dart';
// import 'package:arham_b2c/app/app_snack_bar.dart';
// import 'package:arham_b2c/app/app_url.dart';
// import 'package:arham_b2c/models/firm_response.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_expand_response.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_expand_vocuh_response.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_response.dart';
// import 'package:arham_b2c/utility/constants.dart';
// import 'package:arham_b2c/utility/utils.dart';
// import 'package:arham_b2c/widgets/common_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../utility/network.dart';
// import '../reports/reports_controller.dart';
//
// class SalesRegisterController extends GetxController {
//   var isLoading = false.obs;
//   var isExpandWithoutVouchLoading = false.obs;
//   var isExpandWithVouchLoading = false.obs;
//
//   Rx<SalesRegisterResponse> mainList = SalesRegisterResponse().obs;
//   RxList<SalesRegisterModel> searchList =
//       <SalesRegisterModel>[].obs; // List to store all groups
//
//   Rx<SalesRegisterExpandResponse> leaderExpandWithoutVocuhList =
//       SalesRegisterExpandResponse().obs;
//   RxList<SalesRegisterExpandModel> searchExpandWithoutVocuhList =
//       <SalesRegisterExpandModel>[].obs;
//
//   Rx<SalesRegisterExpandVouchResponse> leaderExpandWithVocuhList =
//       SalesRegisterExpandVouchResponse().obs;
//   RxList<SalesRegisterExpandVocuhModel> searchExpandWithVocuhList =
//       <SalesRegisterExpandVocuhModel>[].obs;
//
//   RxString errorMsg = ''.obs;
//
//   var isDropdownFirmLoading = false.obs;
//   Rx<FirmResponse> firmList = FirmResponse().obs;
//   final Rx<FirmModel?> selectedDropdownFirm = Rx<FirmModel?>(null);
//   RxString selectedDropdownFirmName = ''.obs;
//   RxString selectedDropdownFirmCode = ''.obs;
//
//   Rx<TextEditingController> searchGroupController = TextEditingController().obs;
//   FocusNode searchGroupFocus = FocusNode();
//   RxString searchQuery = ''.obs; // Holds the search query
//
//   Rx<TextEditingController> searchGroupExpandController =
//       TextEditingController().obs;
//   FocusNode searchGroupExpandFocus = FocusNode();
//   RxString searchExpandQuery = ''.obs; // Holds the search query
//
//   Rx<TextEditingController> fromDateController = TextEditingController().obs;
//   Rx<TextEditingController> toDateController = TextEditingController().obs;
//   Rx<TextEditingController> firmController = TextEditingController().obs;
//
//   FocusNode fromDtFocus = FocusNode();
//   FocusNode toDtFocus = FocusNode();
//   FocusNode firmFocus = FocusNode();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Listen to shared changes
//     ever(Get.find<ReportsController>().selectedDropdownFirmCode, (_) {
//       if (Get.find<ReportsController>().selectedDropdownFirmCode.isNotEmpty) {
//         fetchSalesRegister();
//       }
//     });
//   }
//
//   Future<void> fetchSalesRegister() async {
//     final reportsCtrl = Get.find<ReportsController>();
//     if (reportsCtrl.selectedDropdownFirmCode.isEmpty) return;
//
//     if (await Network.isConnected()) {
//       try {
//         isLoading(true);
//         mainList.value.data?.clear();
//         searchList.clear();
//         mainList.refresh();
//
//         Map<String, dynamic> param = {
//           "fromDate": AppDatePicker.convertDateTimeFormat(
//             reportsCtrl.fromDateController.value.text,
//             'dd-MM-yyyy',
//             'yyyy-MM-dd',
//           ),
//           "toDate": AppDatePicker.convertDateTimeFormat(
//             reportsCtrl.toDateController.value.text,
//             'dd-MM-yyyy',
//             'yyyy-MM-dd',
//           ),
//           "syncId": reportsCtrl.selectedDropdownFirmCode.value,
//         };
//
//         // Rest of the API call remains the same...
//       } catch (e) {
//         Utils.handleException(e);
//       } finally {
//         isLoading(false);
//         mainList.refresh();
//       }
//     } else {
//       AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
//     }
//   }
//
//   // @override
//   // void onInit() {
//   //   // TODO: implement onInit
//   //   super.onInit();
//   //   fetchFirm();
//   //
//   //   fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
//   //   //toDateController.value.text = AppDatePicker.lastDayFinancialYear();
//   //   toDateController.value.text = AppDatePicker.currentDate();
//   // }
//   //
//   // Future<void> fetchFirm() async {
//   //   if (await Network.isConnected()) {
//   //     try {
//   //       isDropdownFirmLoading(true);
//   //
//   //       var response = await DioClient().get(AppURL.dropdownFirmURL);
//   //
//   //       firmList.value = FirmResponse.fromJson(response);
//   //       if (firmList.value.data!.isNotEmpty) {
//   //         if (firmList.value.message == 'Data fetch successfully') {
//   //           if (firmList.value.data!.length == 1) {
//   //             var selectedFirm = firmList.value.data!.first;
//   //             selectedDropdownFirm.value = selectedFirm;
//   //             selectedDropdownFirmCode.value =
//   //                 selectedFirm.syncId.toString().trim();
//   //             firmController.value.text = selectedFirm.firmName.trim();
//   //             Utils.closeKeyboard(Get.context!);
//   //             firmFocus.unfocus();
//   //             fetchSalesRegister();
//   //           }
//   //           // if (vouchNo.value.isNotEmpty) {
//   //           //   var groupCdFromArgs = Get.arguments?['PartyCD'];
//   //           //
//   //           //   // Filter the list to find the subgroup that matches the GroupCD
//   //           //   var selectedGroup = partyList.value.data!.firstWhere(
//   //           //         (group) => group.aCCCD == groupCdFromArgs,
//   //           //     orElse: () => PartyModel(), // Default to the first if not found
//   //           //   );
//   //           //
//   //           //   // Set the selected values
//   //           //   selectedDropdownParty.value = selectedGroup;
//   //           //   selectedDropdownPartyName.value =
//   //           //       selectedGroup.aCCNAME.toString().trim();
//   //           //   selectedDropdownPartyCode.value =
//   //           //       selectedGroup.aCCCD.toString().trim();
//   //           //   partyController.value.text =
//   //           //       selectedGroup.aCCNAME.toString().trim();
//   //           // }
//   //         } else {
//   //           AppSnackBar.showGetXCustomSnackBar(
//   //             message: response.data['message'],
//   //           );
//   //         }
//   //       } else {
//   //         AppSnackBar.showGetXCustomSnackBar(message: 'No distributor found');
//   //       }
//   //     } catch (e) {
//   //       Utils.handleException(e);
//   //       //Utils.handleException(Exception(e.toString()));
//   //     } finally {
//   //       isDropdownFirmLoading(false);
//   //     }
//   //   } else {
//   //     AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
//   //   }
//   // }
//   //
//   // Future<void> fetchSalesRegister() async {
//   //   if (await Network.isConnected()) {
//   //     try {
//   //       isLoading(true);
//   //
//   //       // Clear productList and searchList before making a new request
//   //       mainList.value.data?.clear();
//   //       searchList.clear();
//   //       mainList.refresh();
//   //
//   //       Map<String, dynamic> param = {
//   //         "fromDate": AppDatePicker.convertDateTimeFormat(
//   //           fromDateController.value.text,
//   //           'dd-MM-yyyy',
//   //           'yyyy-MM-dd',
//   //         ),
//   //         "toDate": AppDatePicker.convertDateTimeFormat(
//   //           toDateController.value.text,
//   //           'dd-MM-yyyy',
//   //           'yyyy-MM-dd',
//   //         ),
//   //         "syncId": selectedDropdownFirmCode.value,
//   //       };
//   //
//   //       var response = await DioClient().getQueryParam(
//   //         AppURL.saleRegisterReportURL,
//   //         queryParams: param,
//   //       );
//   //
//   //       var newData = SalesRegisterResponse.fromJson(response);
//   //
//   //       if (newData.data != null && newData.data!.isNotEmpty) {
//   //         if (newData.message == 'Data fetch successfully') {
//   //           mainList.value = newData;
//   //           searchList.value = newData.data!;
//   //
//   //           // Apply initial filtering based on searchQuery if any
//   //           filterData();
//   //         } else {
//   //           AppSnackBar.showGetXCustomSnackBar(
//   //             message: response.data['message'],
//   //           );
//   //         }
//   //       } else {
//   //         errorMsg.value = 'No record found.';
//   //         //AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
//   //       }
//   //     } catch (e) {
//   //       Utils.handleException(e);
//   //     } finally {
//   //       isLoading(false);
//   //       mainList.refresh(); // Ensure UI updates
//   //     }
//   //   } else {
//   //     AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
//   //   }
//   // }
//
//   void filterData() {
//     List<SalesRegisterModel> filteredList = searchList; // Start with full list
//
//     // Apply Search Query Filtering
//     if (searchQuery.value.isNotEmpty) {
//       String query = searchQuery.value.toLowerCase();
//       filteredList =
//           filteredList.where((group) {
//             return (group.account!.aCCNAME != null &&
//                 group.account!.aCCNAME!.toLowerCase().contains(query)) ||
//                 (group.pARTYBL != null &&
//                     group.pARTYBL!.toString().toLowerCase().contains(query)) ||
//                 (group.pARTYCD != null &&
//                     group.pARTYCD!.toString().toLowerCase().contains(query));
//           }).toList();
//
//       // If search results are empty, show "No records found"
//       if (filteredList.isEmpty) {
//         mainList.value.data = [];
//         mainList.refresh();
//         return;
//       }
//     }
//
//     // Update the payment list
//     mainList.value.data = filteredList;
//     mainList.refresh(); // Update UI
//   }
//
//   Future<void> fetchExpandPaymentWithoutVouch(
//       String type,
//       String bookCD,
//       String vouchDt,
//       String partyCd,
//       ) async {
//     if (await Network.isConnected()) {
//       try {
//         print('call api 1');
//         isExpandWithoutVouchLoading(true);
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
//           // "fromDate": AppDatePicker.convertDateTimeFormat(fromDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
//           // "toDate": AppDatePicker.convertDateTimeFormat(toDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
//           "syncId": selectedDropdownFirmCode.value,
//           "type": type,
//           "bookCd": bookCD,
//           "vouchDt": vouchDt,
//           "partyCd": partyCd,
//           // if (bookCD == 'RC' ||
//           //     bookCD == 'PY' ||
//           //     //bookCD == 'PU' ||
//           //     bookCD == 'EP' ||
//           //     bookCD == 'IC' ||
//           //     bookCD == 'JV')
//           //   "vouchNo": vouchNo,
//         };
//
//         var response = await DioClient().getQueryParam(
//           AppURL.saleRegisterReportURL,
//           queryParams: param,
//         );
//
//         leaderExpandWithoutVocuhList
//             .value = SalesRegisterExpandResponse.fromJson(response);
//
//         if (leaderExpandWithoutVocuhList.value.data!.isNotEmpty &&
//             leaderExpandWithoutVocuhList.value.message ==
//                 'Data fetch successfully') {
//           searchExpandWithoutVocuhList.value =
//           leaderExpandWithoutVocuhList.value.data!;
//
//           filterExpandDataWithoutVouch();
//
//           //showBottomSheetDialogExpandPaymentWithoutVocuhNo(Get.context!);
//           showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(Get.context!);
//         } else {
//           AppSnackBar.showGetXCustomSnackBar(
//             //message: response['message'] ?? 'No record found.',
//             message: 'No record found.',
//           );
//         }
//       } catch (e) {
//         Utils.handleException(e);
//       } finally {
//         isExpandWithoutVouchLoading(false);
//       }
//     } else {
//       AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
//     }
//   }
//
//   void filterExpandDataWithoutVouch() {
//     if (searchExpandQuery.value.isEmpty) {
//       // No search query, show all data
//       leaderExpandWithoutVocuhList.value.data = searchExpandWithoutVocuhList;
//     } else {
//       leaderExpandWithoutVocuhList.value.data =
//           searchExpandWithoutVocuhList.where((group) {
//             return group.iTEMCD!.toLowerCase().contains(
//               searchExpandQuery.value.toLowerCase(),
//             );
//           }).toList();
//     }
//
//     mainList.refresh(); // This is the correct way to trigger the update
//   }
//
//   void showBottomSheetDialogExpandPaymentWithoutVocuhNoTable1(
//       BuildContext context,
//       ) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       useSafeArea: true,
//       enableDrag: true,
//       isDismissible: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.5,
//           minChildSize: 0.3,
//           maxChildSize: 0.9,
//           builder: (context, scrollController) {
//             // Separate scroll controllers for vertical and horizontal scrolling
//             ScrollController verticalScrollController = ScrollController();
//             ScrollController horizontalScrollController = ScrollController();
//
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(child: Icon(Icons.drag_handle, size: 30)),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       controller: verticalScrollController,
//                       scrollDirection: Axis.vertical,
//                       child: SingleChildScrollView(
//                         controller: horizontalScrollController,
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columnSpacing: 25.0,
//                           border: TableBorder.all(
//                             color: isDark ? Colors.white : Colors.black,
//                           ),
//                           columns: [
//                             //DataColumn(label: CommonText(text: 'Item CD')),
//                             DataColumn(label: CommonText(text: 'Item Name')),
//                             DataColumn(label: CommonText(text: 'Batch No')),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Qty',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Free Qty',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Rate',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Amount',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                           ],
//                           rows:
//                           leaderExpandWithoutVocuhList.value.data?.map((
//                               purchase,
//                               ) {
//                             return DataRow(
//                               cells: [
//                                 // DataCell(
//                                 //   CommonText(text: purchase.iTEMCD ?? ''),
//                                 // ),
//                                 DataCell(
//                                   CommonText(
//                                     text: purchase.item?.iTEMNAME ?? '',
//                                   ),
//                                 ),
//                                 DataCell(
//                                   CommonText(text: purchase.sIZECD ?? ''),
//                                 ),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text:
//                                       purchase.qUANTITY?.toString() ??
//                                           '',
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text: purchase.oTHERDESC ?? '',
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text: purchase.rATE?.toString() ?? '',
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text: Utils.formatIndianAmount(
//                                         double.parse(
//                                           purchase.vOUCHAMT?.toString() ??
//                                               '0',
//                                         ),
//                                       ),
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }).toList() ??
//                               [],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(
//       BuildContext context,
//       ) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       useSafeArea: true,
//       enableDrag: true,
//       isDismissible: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.5,
//           minChildSize: 0.3,
//           maxChildSize: 0.9,
//           builder: (context, scrollController) {
//             ScrollController verticalScrollController = ScrollController();
//             ScrollController horizontalScrollController = ScrollController();
//
//             final purchases = leaderExpandWithoutVocuhList.value.data ?? [];
//
//             final totalAmount = purchases.fold<double>(0, (sum, item) {
//               final amt =
//                   double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0;
//               return sum + amt;
//             });
//
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(child: Icon(Icons.drag_handle, size: 30)),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       controller: verticalScrollController,
//                       scrollDirection: Axis.vertical,
//                       child: SingleChildScrollView(
//                         controller: horizontalScrollController,
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columnSpacing: 25.0,
//                           border: TableBorder.all(
//                             color: isDark ? Colors.white : Colors.black,
//                           ),
//                           columns: [
//                             DataColumn(label: CommonText(text: 'Item Name')),
//                             DataColumn(label: CommonText(text: 'Batch No')),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Qty',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Free Qty',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Rate',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Amount',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                           ],
//                           rows: [
//                             ...purchases.map((purchase) {
//                               return DataRow(
//                                 cells: [
//                                   DataCell(
//                                     CommonText(
//                                       text: purchase.item?.iTEMNAME ?? '',
//                                     ),
//                                   ),
//                                   DataCell(
//                                     CommonText(text: purchase.sIZECD ?? ''),
//                                   ),
//                                   DataCell(
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: CommonText(
//                                         text: Utils.formatRate(
//                                           purchase.qUANTITY?.toString() ?? '',
//                                         ),
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ),
//                                   ),
//                                   DataCell(
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: CommonText(
//                                         text: purchase.oTHERDESC ?? '',
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ),
//                                   ),
//                                   DataCell(
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: CommonText(
//                                         text: Utils.formatRate(
//                                           purchase.rATE != null
//                                               ? purchase.rATE!.toString()
//                                               : '',
//                                         ),
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ),
//                                   ),
//                                   DataCell(
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: CommonText(
//                                         text: Utils.formatIndianAmount(
//                                           double.tryParse(
//                                             purchase.vOUCHAMT?.toString() ??
//                                                 '0',
//                                           ),
//                                         ),
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }),
//                             DataRow(
//                               cells: [
//                                 DataCell(
//                                   CommonText(
//                                     text: 'Total',
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 DataCell(CommonText(text: '')),
//                                 DataCell(CommonText(text: '')),
//                                 DataCell(CommonText(text: '')),
//                                 DataCell(CommonText(text: '')),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text: Utils.formatIndianAmount(
//                                         totalAmount,
//                                       ),
//                                       fontWeight: FontWeight.bold,
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> fetchExpandPaymentWithVouch(
//       String type,
//       String bookCD,
//       String vouchDt,
//       String partyCd,
//       ) async {
//     if (await Network.isConnected()) {
//       try {
//         print('call api 2');
//         isExpandWithVouchLoading(true);
//
//         //TODO: This Type BookCd [SA/SR/PU/PR/SO/SI/WS] Not Bind Vouch No
//         //TODO: This Type BookCd [RC/PY/EP/IC/JV] Bind Vouch No
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
//           // "fromDate": AppDatePicker.convertDateTimeFormat(fromDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
//           // "toDate": AppDatePicker.convertDateTimeFormat(toDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
//           "syncId": selectedDropdownFirmCode.value,
//           "type": type,
//           "bookCd": bookCD,
//           "vouchDt": vouchDt,
//           "partyCd": partyCd,
//           // if (bookCD == 'RC' ||
//           //     bookCD == 'PY' ||
//           //     //bookCD == 'PU' ||
//           //     bookCD == 'EP' ||
//           //     bookCD == 'IC' ||
//           //     bookCD == 'JV')
//           //   "vouchNo": vouchNo,
//         };
//
//         var response = await DioClient().getQueryParam(
//           AppURL.saleRegisterReportURL,
//           queryParams: param,
//         );
//
//         leaderExpandWithVocuhList
//             .value = SalesRegisterExpandVouchResponse.fromJson(response);
//
//         if (leaderExpandWithVocuhList.value.data!.isNotEmpty) {
//           if (leaderExpandWithVocuhList.value.message ==
//               'Data fetch successfully') {
//             // Data fetched successfully, no further action needed
//             // Store the original data in searchList for filtering
//             searchExpandWithVocuhList.value =
//             leaderExpandWithVocuhList.value.data!;
//
//             // Apply initial filtering based on the search query if any
//             filterExpandDataWithVouch();
//
//             //showBottomSheetDialogExpandPaymentWithVocuhNo(Get.context!);
//             showBottomSheetDialogExpandPaymentWithVocuhNoTable(Get.context!);
//           } else {
//             // Show failure message based on the response
//             AppSnackBar.showGetXCustomSnackBar(
//               //message: response.data['message'],
//               //message: response['message'],
//               message: 'No record found.',
//             );
//           }
//         } else {
//           // Handle empty data response
//           AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
//         }
//       } catch (e) {
//         Utils.handleException(e);
//         //Utils.handleException(Exception(e.toString()));
//       } finally {
//         isExpandWithVouchLoading(false);
//       }
//     } else {
//       AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
//     }
//   }
//
//   void filterExpandDataWithVouch() {
//     if (searchExpandQuery.value.isEmpty) {
//       // No search query, show all data
//       leaderExpandWithoutVocuhList.value.data = searchExpandWithoutVocuhList;
//     } else {
//       leaderExpandWithoutVocuhList.value.data =
//           searchExpandWithoutVocuhList.where((group) {
//             return group.iTEMCD!.toLowerCase().contains(
//               searchExpandQuery.value.toLowerCase(),
//             );
//           }).toList();
//     }
//
//     mainList.refresh(); // This is the correct way to trigger the update
//   }
//
//   void showBottomSheetDialogExpandPaymentWithVocuhNoTable1(
//       BuildContext context,
//       ) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       useSafeArea: true,
//       enableDrag: true,
//       isDismissible: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.5,
//           minChildSize: 0.3,
//           maxChildSize: 0.9,
//           builder: (context, scrollController) {
//             // Separate scroll controllers for vertical and horizontal scrolling
//             ScrollController verticalScrollController = ScrollController();
//             ScrollController horizontalScrollController = ScrollController();
//
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(child: Icon(Icons.drag_handle, size: 30)),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       controller: verticalScrollController,
//                       scrollDirection: Axis.vertical,
//                       child: SingleChildScrollView(
//                         controller: horizontalScrollController,
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columnSpacing: 25,
//                           border: TableBorder.all(
//                             color: isDark ? Colors.white : Colors.black,
//                           ),
//                           columns: [
//                             DataColumn(label: CommonText(text: 'Book Cd')),
//                             DataColumn(label: CommonText(text: 'Vouch Dt')),
//                             DataColumn(label: CommonText(text: 'Bill No')),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Bill Amt',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Bill Paid Amt',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                           ],
//                           rows:
//                           leaderExpandWithVocuhList.value.data?.map((
//                               purchase,
//                               ) {
//                             return DataRow(
//                               cells: [
//                                 DataCell(
//                                   CommonText(text: purchase.bLBOOKCD ?? ''),
//                                 ),
//                                 DataCell(
//                                   CommonText(text: purchase.bLVDT ?? ''),
//                                 ),
//                                 DataCell(
//                                   CommonText(text: purchase.bLBILLNO ?? ''),
//                                 ),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text: Utils.formatIndianAmount(
//                                         double.parse(
//                                           purchase.bLAMOUNT?.toString() ??
//                                               '0',
//                                         ),
//                                       ),
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text: Utils.formatIndianAmount(
//                                         double.parse(
//                                           purchase.bLPAID?.toString() ??
//                                               '0',
//                                         ),
//                                       ),
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }).toList() ??
//                               [],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void showBottomSheetDialogExpandPaymentWithVocuhNoTable(
//       BuildContext context,
//       ) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       useSafeArea: true,
//       enableDrag: true,
//       isDismissible: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.5,
//           minChildSize: 0.3,
//           maxChildSize: 0.9,
//           builder: (context, scrollController) {
//             ScrollController verticalScrollController = ScrollController();
//             ScrollController horizontalScrollController = ScrollController();
//
//             final purchases = leaderExpandWithVocuhList.value.data ?? [];
//
//             final totalAmount = purchases.fold<double>(0, (sum, item) {
//               return sum +
//                   (double.tryParse(item.bLAMOUNT?.toString() ?? '0') ?? 0);
//             });
//
//             final totalPaid = purchases.fold<double>(0, (sum, item) {
//               return sum +
//                   (double.tryParse(item.bLPAID?.toString() ?? '0') ?? 0);
//             });
//
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(child: Icon(Icons.drag_handle, size: 30)),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       controller: verticalScrollController,
//                       scrollDirection: Axis.vertical,
//                       child: SingleChildScrollView(
//                         controller: horizontalScrollController,
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columnSpacing: 25,
//                           border: TableBorder.all(
//                             color: isDark ? Colors.white : Colors.black,
//                           ),
//                           columns: [
//                             DataColumn(label: CommonText(text: 'Book Cd')),
//                             DataColumn(label: CommonText(text: 'Vouch Dt')),
//                             DataColumn(label: CommonText(text: 'Bill No')),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Bill Amt',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CommonText(
//                                   text: 'Bill Paid Amt',
//                                   textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                           ],
//                           rows: [
//                             ...purchases.map((purchase) {
//                               return DataRow(
//                                 cells: [
//                                   DataCell(
//                                     CommonText(text: purchase.bLBOOKCD ?? ''),
//                                   ),
//                                   DataCell(
//                                     CommonText(text: purchase.bLVDT ?? ''),
//                                   ),
//                                   DataCell(
//                                     CommonText(text: purchase.bLBILLNO ?? ''),
//                                   ),
//                                   DataCell(
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: CommonText(
//                                         text: Utils.formatIndianAmount(
//                                           double.tryParse(
//                                             purchase.bLAMOUNT?.toString() ??
//                                                 '0',
//                                           ),
//                                         ),
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ),
//                                   ),
//                                   DataCell(
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: CommonText(
//                                         text: Utils.formatIndianAmount(
//                                           double.tryParse(
//                                             purchase.bLPAID?.toString() ?? '0',
//                                           ),
//                                         ),
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }),
//                             DataRow(
//                               cells: [
//                                 DataCell(
//                                   CommonText(
//                                     text: 'Total',
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 DataCell(CommonText(text: '')),
//                                 DataCell(CommonText(text: '')),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text: Utils.formatIndianAmount(
//                                         totalAmount,
//                                       ),
//                                       fontWeight: FontWeight.bold,
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: CommonText(
//                                       text: Utils.formatIndianAmount(totalPaid),
//                                       fontWeight: FontWeight.bold,
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//




import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_expand_response.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_expand_vocuh_response.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_response.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utility/network.dart';
import '../reports/reports_filter_controller.dart';

class SalesRegisterController extends GetxController {
  var isLoading = false.obs;
  var isExpandWithoutVouchLoading = false.obs;
  var isExpandWithVouchLoading = false.obs;

  Rx<SalesRegisterResponse> mainList = SalesRegisterResponse().obs;
  RxList<SalesRegisterModel> searchList =
      <SalesRegisterModel>[].obs; // List to store all groups

  Rx<SalesRegisterExpandResponse> leaderExpandWithoutVocuhList =
      SalesRegisterExpandResponse().obs;
  RxList<SalesRegisterExpandModel> searchExpandWithoutVocuhList =
      <SalesRegisterExpandModel>[].obs;

  Rx<SalesRegisterExpandVouchResponse> leaderExpandWithVocuhList =
      SalesRegisterExpandVouchResponse().obs;
  RxList<SalesRegisterExpandVocuhModel> searchExpandWithVocuhList =
      <SalesRegisterExpandVocuhModel>[].obs;

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

  bool isDataOutdated = false; // Tracks if we need to fetch new data
  final int myTabIndex = 0;    // 0 for Sales, 1 for Outstanding, 2 for Ledger

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchFirm();

    fromDateController.value.text = AppDatePicker.firstDayFinancialYear();
    //toDateController.value.text = AppDatePicker.lastDayFinancialYear();
    toDateController.value.text = AppDatePicker.currentDate();

    // 🔗 Listen to shared Reports filter (only when inside Reports tabs)
    if (Get.isRegistered<ReportsFilterController>()) {
      final reportFilter = Get.find<ReportsFilterController>();

      // ever<FirmModel?>(reportFilter.selectedFirm, (firm) {
      //   if (firm != null) {
      //     selectedDropdownFirm.value = firm;
      //     selectedDropdownFirmCode.value =
      //         firm.syncId.toString().trim();
      //     firmController.value.text =
      //         firm.firmName.trim();
      //
      //     fetchSalesRegister(); // auto load data
      //   }
      // });
      //
      // // 🔗 from date listener
      // ever<String>(reportFilter.fromDate, (date) {
      //   fromDateController.value.text = date;
      //   if (selectedDropdownFirmCode.isNotEmpty) {
      //     fetchSalesRegister();
      //   }
      // });
      //
      // // 🔗 to date listener
      // ever<String>(reportFilter.toDate, (date) {
      //   toDateController.value.text = date;
      //   if (selectedDropdownFirmCode.isNotEmpty) {
      //     fetchSalesRegister();
      //   }
      // });
      // LISTENER 1: When Firm/Date changes (Visual Sync + Conditional Fetch)
      ever<FirmModel?>(reportFilter.selectedFirm, (firm) {
        if (firm != null) {
          // 1. VISUAL SYNC: Always update the text controller immediately
          // This ensures if you go to the Ledger tab later, the text is already correct.
          selectedDropdownFirm.value = firm;
          selectedDropdownFirmCode.value = firm.syncId.toString().trim();
          firmController.value.text = firm.firmName.trim();

          // 2. CONDITIONAL FETCH: Fetch only if this tab is active
          _attemptFetch(reportFilter);
        }
      });

      // Same logic for Dates
      ever<String>(reportFilter.fromDate, (date) {
        fromDateController.value.text = date;
        if (selectedDropdownFirmCode.isNotEmpty) _attemptFetch(reportFilter);
      });

      ever<String>(reportFilter.toDate, (date) {
        toDateController.value.text = date;
        if (selectedDropdownFirmCode.isNotEmpty) _attemptFetch(reportFilter);
      });

      // LISTENER 2: When Tab Changes (Lazy Load)
      ever<int>(reportFilter.currentTabIndex, (index) {
        // If user switches TO this tab AND data is old, fetch now.
        if (index == myTabIndex && isDataOutdated) {
          fetchSalesRegister();
          isDataOutdated = false; // Mark as clean
        }
      });
    }
  }

  // Helper function to decide whether to fetch
  void _attemptFetch(ReportsFilterController filterCtrl) {
    if (filterCtrl.currentTabIndex.value == myTabIndex) {
      // Tab is visible -> Fetch API immediately
      fetchSalesRegister();
      isDataOutdated = false;
    } else {
      // Tab is hidden -> Do NOT fetch, just mark as dirty
      isDataOutdated = true;
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
              fetchSalesRegister();
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

  Future<void> fetchSalesRegister() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);

        // Clear productList and searchList before making a new request
        mainList.value.data?.clear();
        searchList.clear();
        mainList.refresh();

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
        };

        var response = await DioClient().getQueryParam(
          AppURL.saleRegisterReportURL,
          queryParams: param,
        );

        var newData = SalesRegisterResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          if (newData.message == 'Data fetch successfully') {
            mainList.value = newData;
            searchList.value = newData.data!;

            // Apply initial filtering based on searchQuery if any
            filterData();
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          errorMsg.value = 'No record found.';
          //AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isLoading(false);
        mainList.refresh(); // Ensure UI updates
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void filterData() {
    List<SalesRegisterModel> filteredList = searchList; // Start with full list

    // Apply Search Query Filtering
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase();
      filteredList =
          filteredList.where((group) {
            return (group.account!.aCCNAME != null &&
                    group.account!.aCCNAME!.toLowerCase().contains(query)) ||
                (group.pARTYBL != null &&
                    group.pARTYBL!.toString().toLowerCase().contains(query)) ||
                (group.pARTYCD != null &&
                    group.pARTYCD!.toString().toLowerCase().contains(query));
          }).toList();

      // If search results are empty, show "No records found"
      if (filteredList.isEmpty) {
        mainList.value.data = [];
        mainList.refresh();
        return;
      }
    }

    // Update the payment list
    mainList.value.data = filteredList;
    mainList.refresh(); // Update UI
  }

  Future<void> fetchExpandPaymentWithoutVouch(
    String type,
    String bookCD,
    String vouchDt,
    String partyCd,
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
          // "fromDate": AppDatePicker.convertDateTimeFormat(fromDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          // "toDate": AppDatePicker.convertDateTimeFormat(toDateController.value.text, 'dd-MM-yyyy', 'yyyy-MM-dd'),
          "syncId": selectedDropdownFirmCode.value,
          "type": type,
          "bookCd": bookCD,
          "vouchDt": vouchDt,
          "partyCd": partyCd,
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

        leaderExpandWithoutVocuhList
            .value = SalesRegisterExpandResponse.fromJson(response);

        if (leaderExpandWithoutVocuhList.value.data!.isNotEmpty &&
            leaderExpandWithoutVocuhList.value.message ==
                'Data fetch successfully') {
          searchExpandWithoutVocuhList.value =
              leaderExpandWithoutVocuhList.value.data!;

          filterExpandDataWithoutVouch();

          //showBottomSheetDialogExpandPaymentWithoutVocuhNo(Get.context!);
          showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(Get.context!);
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            //message: response['message'] ?? 'No record found.',
            message: 'No record found.',
          );
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

  void filterExpandDataWithoutVouch() {
    if (searchExpandQuery.value.isEmpty) {
      // No search query, show all data
      leaderExpandWithoutVocuhList.value.data = searchExpandWithoutVocuhList;
    } else {
      leaderExpandWithoutVocuhList.value.data =
          searchExpandWithoutVocuhList.where((group) {
            return group.iTEMCD!.toLowerCase().contains(
              searchExpandQuery.value.toLowerCase(),
            );
          }).toList();
    }

    mainList.refresh(); // This is the correct way to trigger the update
  }

  void showBottomSheetDialogExpandPaymentWithoutVocuhNoTable1(
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
          initialChildSize: 0.9,
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
                              leaderExpandWithoutVocuhList.value.data?.map((
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

  void showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(
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
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            ScrollController verticalScrollController = ScrollController();
            ScrollController horizontalScrollController = ScrollController();

            final purchases = leaderExpandWithoutVocuhList.value.data ?? [];

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

  Future<void> fetchExpandPaymentWithVouch(
    String type,
    String bookCD,
    String vouchDt,
    String partyCd,
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

        leaderExpandWithVocuhList
            .value = SalesRegisterExpandVouchResponse.fromJson(response);

        if (leaderExpandWithVocuhList.value.data!.isNotEmpty) {
          if (leaderExpandWithVocuhList.value.message ==
              'Data fetch successfully') {
            // Data fetched successfully, no further action needed
            // Store the original data in searchList for filtering
            searchExpandWithVocuhList.value =
                leaderExpandWithVocuhList.value.data!;

            // Apply initial filtering based on the search query if any
            filterExpandDataWithVouch();

            //showBottomSheetDialogExpandPaymentWithVocuhNo(Get.context!);
            showBottomSheetDialogExpandPaymentWithVocuhNoTable(Get.context!);
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

  void filterExpandDataWithVouch() {
    if (searchExpandQuery.value.isEmpty) {
      // No search query, show all data
      leaderExpandWithoutVocuhList.value.data = searchExpandWithoutVocuhList;
    } else {
      leaderExpandWithoutVocuhList.value.data =
          searchExpandWithoutVocuhList.where((group) {
            return group.iTEMCD!.toLowerCase().contains(
              searchExpandQuery.value.toLowerCase(),
            );
          }).toList();
    }

    mainList.refresh(); // This is the correct way to trigger the update
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
