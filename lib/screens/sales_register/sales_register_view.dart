import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/screens/report/report_controller.dart'; // UPDATED IMPORT
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_no_message.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:arham_b2c/widgets/common_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesRegisterView extends StatelessWidget {
  SalesRegisterView({super.key});

  // Use Get.find because ReportView put it
  final ReportController controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column( // Removed Scaffold/AppBar/Inputs
        children: [
          Expanded(
            child: _getView(context),
          ),
          // Bottom Bar (Total Amount)
          Obx(() {
            final cartData = controller.salesMainList.value.data ?? []; // Updated Variable Name

            if (cartData.isEmpty) return const SizedBox.shrink();

            final totalVouchAmount = cartData.fold<double>(
              0,
                  (sum, item) =>
              sum +
                  (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0.0),
            );
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Card(
                margin: const EdgeInsets.only(top: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CommonText(
                                text:
                                'Total Amt: ₹ ${Utils.formatIndianAmount(totalVouchAmount)}',
                                fontWeight: AppFontWeight.w600,
                                fontSize: AppDimensions.fontSizeRegular,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(bottom: 20),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _getView(BuildContext context) {
    return controller.isLoading.isTrue
        ? Utils.buildShimmerList()
        : (controller.salesMainList.value.data == null ||
        controller.salesMainList.value.data!.isEmpty)
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CommonNoMessage(
                    searchQuery: controller.searchQuery.value,
                    errorMessage: controller.errorMsg.value,
                  ),
            ),
          ],
        )
        : Padding(
          padding: const EdgeInsets.all(10),
          child: _listUI(context),
        );
  }

  Widget _listUI(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ListView.builder(
      itemCount: controller.salesMainList.value.data!.length,
      itemBuilder: (context, index) {
        final ledgers = controller.salesMainList.value.data![index];

        final isSalesReturn = ledgers.bOOKCD == 'SR';

        String amount =
        ledgers.vOUCHAMT != null
            ? Utils.formatIndianAmount(
          double.parse(ledgers.vOUCHAMT?.toString() ?? '0'),
        )
            : "0.00";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.black12,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.brightness == Brightness.dark
                      ? Colors.grey[850]!
                      : Colors.white,
                  theme.brightness == Brightness.dark
                      ? Colors.grey[900]!
                      : Colors.grey[50]!,
                ],
              ),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: isSalesReturn ? Colors.red : Colors.green,
                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: '# ${ledgers.pARTYBL}',
                            fontSize: AppDimensions.fontSizeMedium,
                            fontWeight: FontWeight.bold,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 5,),
                              CommonText(
                                text: '${ledgers.vOUCHDT}',
                                fontSize: AppDimensions.fontSizeSmall,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 10),
                              CommonText(
                                text: 'Book: ${ledgers.bOOKCD}',
                                fontSize: AppDimensions.fontSizeSmall,
                                fontWeight: AppFontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (isSalesReturn ? Colors.red : Colors.green)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: (isSalesReturn ? Colors.red : Colors.green)
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: CommonText(
                            text: 'Amt: ₹$amount',
                            fontSize: 13,
                            fontWeight: AppFontWeight.w700,
                            color: isSalesReturn ? Colors.red[700] : Colors.green[700],

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CommonText(
                        text: '${ledgers.account!.aCCNAME.toString().capitalize}',
                        fontSize: 15,
                        fontWeight: AppFontWeight.w700,
                        maxLine: 3,
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          CommonText(
                            text: 'View Details',
                            fontSize: 13,
                            fontWeight: AppFontWeight.w700,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                      onTap: () {
                        controller.selectedSalesRecord.value = ledgers;
                        // NOTE: Implement fetchExpandPayment... in ReportController
                        // I've stubbed one in the controller code.
                        // For brevity I'm keeping the method names identical to your old controller
                        if (ledgers.bOOKCD! == 'RC' ||
                            ledgers.bOOKCD! == 'PY' ||
                            ledgers.bOOKCD! == 'EP' ||
                            ledgers.bOOKCD! == 'IC' ||
                            ledgers.bOOKCD! == 'JV') {
                          // Call fetchExpandWithVouch on ReportController
                          controller.fetchExpandPaymentWithVouchSales(
                            'full',
                            ledgers.bOOKCD!,
                            ledgers.vOUCHDT!.isNotEmpty
                                ? AppDatePicker.convertToFormat(
                              ledgers.vOUCHDT!,
                              'yyyy-MM-dd',
                            )
                                : AppDatePicker.currentYYYYMMDDDate(),
                            ledgers.pARTYCD!,
                            ledgers.vOUCHNO!,
                          );
                        } else {
                          controller.fetchExpandPaymentWithoutVouchSales(
                            'full',
                            ledgers.bOOKCD!,
                            ledgers.vOUCHDT!.isNotEmpty
                                ? AppDatePicker.convertToFormat(
                              ledgers.vOUCHDT!,
                              'yyyy-MM-dd',
                            )
                                : AppDatePicker.currentYYYYMMDDDate(),
                            ledgers.pARTYCD!,
                            ledgers.vOUCHNO.toString(),
                          );
                        }
                      },
                    ),

                  ],
                ),
                if ((ledgers.nARRATION ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_note,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: CommonText(
                            text: ledgers.nARRATION ?? '',
                            fontSize: 11,
                            fontWeight: AppFontWeight.w400,
                            color: Colors.grey[600],
                            maxLine: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}















// import 'package:arham_b2c/app/app_date_format.dart';
// import 'package:arham_b2c/app/app_dimensions.dart';
// import 'package:arham_b2c/app/app_font_weight.dart';
// import 'package:arham_b2c/models/firm_response.dart';
// import 'package:arham_b2c/screens/report/report_controller.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_controller.dart';
// import 'package:arham_b2c/utility/utils.dart';
// import 'package:arham_b2c/widgets/common_app_bar.dart';
// import 'package:arham_b2c/widgets/common_app_input.dart';
// import 'package:arham_b2c/widgets/common_date_picker.dart';
// import 'package:arham_b2c/widgets/common_no_message.dart';
// import 'package:arham_b2c/widgets/common_text.dart';
// import 'package:arham_b2c/widgets/common_text_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
//
// import '../reports/reports_filter_controller.dart';
//
// class SalesRegisterView extends StatefulWidget {
//   final bool showCommonAppBar;
//   SalesRegisterView({super.key, this.showCommonAppBar = true});
//
//   @override
//   State<SalesRegisterView> createState() => _SalesRegisterViewState();
// }
//
// class _SalesRegisterViewState extends State<SalesRegisterView> {
//   // final SalesRegisterController controller = Get.put(SalesRegisterController());
//
//   final ReportController controller = Get.find<ReportController>();
//
//   final filterCtrl = Get.find<ReportsFilterController>();
//
//   @override
//   void initState() {
//     super.initState();
//     // Get.put(ReportsFilterController());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ReportsFilterController? reportFilter =
//     Get.isRegistered<ReportsFilterController>()
//         ? Get.find<ReportsFilterController>()
//         : null;
//
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return PopScope(
//       canPop: true,
//       onPopInvokedWithResult: (bool didPop, Object? result) {
//         return;
//       },
//       child: Scaffold(
//         appBar: widget.showCommonAppBar
//             ? CommonAppBar(
//           title: 'Sales Register',
//           actions: [
//             Obx(() => IconButton(
//               onPressed: (){
//                 filterCtrl.toggleFilterSection();
//               },
//               icon: Icon(filterCtrl.showFilterSection.value ? CupertinoIcons.slider_horizontal_3 : CupertinoIcons.slider_horizontal_3),
//               tooltip: 'Filter',
//             )),
//           ],
//         )
//             : null,
//         // appBar: CommonAppBar(title: 'Sales Register',),
//         body: SafeArea(
//           child: Obx(
//                 () => Container(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 16),
//                   controller.isDropdownFirmLoading.isTrue
//                       ? Center(child: Utils.commonCircularProgress())
//                       : (controller.firmList.value.data == null ||
//                       controller.firmList.value.data!.isEmpty)
//                       ? Container()
//                       : TypeAheadField<FirmModel>(
//                     // controller: controller.firmController.value,
//                     controller: reportFilter?.firmTextController
//                         ?? controller.firmController.value,
//                     focusNode: controller.firmFocus,
//                     suggestionsCallback: (pattern) async {
//                       return controller.firmList.value.data?.where((item) {
//                         return item.firmName
//                             .toString()
//                             .trim()
//                             .toLowerCase()
//                             .contains(pattern.toLowerCase());
//                       }).toList();
//                     },
//                     itemBuilder: (context, FirmModel suggestion) {
//                       return ListTile(
//                         visualDensity: const VisualDensity(
//                           horizontal: -2.0,
//                           vertical: -4.0,
//                         ),
//                         title: CommonText(
//                           text:
//                           suggestion.mobile1 != null &&
//                               suggestion.mobile1!.trim().isNotEmpty
//                               ? "${suggestion.firmName.trim()} | ${suggestion.mobile1!.trim()}"
//                               : suggestion.firmName.trim(),
//                           fontWeight: AppFontWeight.w400,
//                           fontSize: 14,
//                         ),
//                       );
//                     },
//                     onSelected: (FirmModel selectedItem) {
//                       if (reportFilter != null) {
//                         // 🔗 Shared (Reports Tab)
//                         reportFilter.setFirm(selectedItem);
//                       } else {
//                         // 🧍 Standalone
//                         controller.selectedDropdownFirm.value = selectedItem;
//                         controller.selectedDropdownFirmCode.value =
//                             selectedItem.syncId.toString().trim();
//                         controller.firmController.value.text =
//                             selectedItem.firmName.trim();
//
//                         Get.find<ReportsFilterController>().showFilterSection.value = true;
//                       }
//
//                       Utils.closeKeyboard(Get.context!);
//                       controller.firmFocus.unfocus();
//                       controller.fetchSalesRegister();
//                     },
//                     builder: (context, textController, focusNode) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 15),
//                         child: TextField(
//                           controller: textController,
//                           focusNode: focusNode,
//                           textInputAction: TextInputAction.next,
//                           decoration: InputDecoration(
//                             counter: const Offstage(),
//                             suffixIcon: Padding(
//                               padding: const EdgeInsets.only(right: 10),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       if (reportFilter != null) {
//                                         reportFilter.clearFirm();
//                                       } else {
//                                         controller.firmController.value.clear();
//                                         controller.selectedDropdownFirm.value = null;
//                                         controller.selectedDropdownFirmName.value = '';
//                                         controller.selectedDropdownFirmCode.value = '';
//                                       }
//
//                                       controller.firmFocus.unfocus();
//                                       Utils.closeKeyboard(Get.context!);
//
//                                       controller.salesMainList.value.data?.clear();
//                                       controller.salesSearchList.clear();
//                                       controller.salesMainList.refresh();
//
//                                       Get.find<SalesRegisterController>()
//                                           .mainList
//                                           .value
//                                           .data
//                                           ?.clear();
//                                       Get.find<SalesRegisterController>()
//                                           .searchList
//                                           .clear();
//                                       Get.find<SalesRegisterController>()
//                                           .mainList
//                                           .refresh();
//                                       // Get.find<OrderReportController>()
//                                       //      .fetchPayment();
//                                     },
//                                     child: const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Icon(Icons.close, size: 20),
//                                     ),
//                                   ),
//                                   const Icon(
//                                     size: 20,
//                                     Icons.keyboard_arrow_down,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             labelText: 'Select Distributor',
//                             isDense: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(4.0),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: colorScheme.outline,
//                                 // Default themed outline color
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(4.0),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: colorScheme.primary,
//                                 // Highlight color when focused
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(4.0),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: 10.0,
//                               horizontal: 10.0,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   Obx(() => AnimatedSize(
//                     duration: const Duration(milliseconds: 280),
//                     curve: Curves.easeInOut,
//                     child: reportFilter?.showFilterSection.value == true
//                         ? Column(
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CommonDatePickerInput(
//                                 controller: controller.fromDateController.value,
//                                 hintText: "From Date",
//                                 isEnabled:
//                                 (reportFilter?.selectedFirmCode.value
//                                     ?? controller.selectedDropdownFirmCode.value)
//                                     .isNotEmpty,
//                                 // controller.selectedDropdownFirmCode.isNotEmpty,
//                                 onTap: () async {
//                                   Utils.closeKeyboard(context);
//                                   DateTime? selectedDate =
//                                   await AppDatePicker.allDateEnable(
//                                     context,
//                                     controller.fromDateController.value,
//                                   );
//
//                                   if (selectedDate != null &&
//                                       controller
//                                           .selectedDropdownFirmCode
//                                           .isNotEmpty) {
//                                     String formattedDate = AppDatePicker.formatDate(
//                                       selectedDate,
//                                     );
//                                     //if (controller.toDateController.value.text != formattedDate) {
//                                     // controller.fromDateController.value.text =
//                                     //      formattedDate;
//                                     // controller.fetchSalesRegister();
//                                     final reportFilter = Get.find<ReportsFilterController>();
//                                     reportFilter.setFromDate(formattedDate);
//                                   }
//                                 },
//                                 // enabledBorderColor: Colors.teal,
//                                 // disabledBorderColor: Colors.grey.shade400,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: CommonDatePickerInput(
//                                 controller: controller.toDateController.value,
//                                 hintText: "To Date",
//                                 isEnabled:
//                                 (reportFilter?.selectedFirmCode.value
//                                     ?? controller.selectedDropdownFirmCode.value)
//                                     .isNotEmpty,
//                                 // controller.selectedDropdownFirmCode.isNotEmpty,
//                                 onTap: () async {
//                                   Utils.closeKeyboard(context);
//                                   DateTime? selectedDate =
//                                   await AppDatePicker.allDateEnable(
//                                     context,
//                                     controller.toDateController.value,
//                                   );
//
//                                   if (selectedDate != null &&
//                                       controller
//                                           .selectedDropdownFirmCode
//                                           .isNotEmpty) {
//                                     String formattedDate = AppDatePicker.formatDate(
//                                       selectedDate,
//                                     );
//                                     final reportFilter = Get.find<ReportsFilterController>();
//                                     reportFilter.setToDate(formattedDate);
//                                   }
//                                 },
//                                 // enabledBorderColor: Colors.teal,
//                                 // disabledBorderColor: Colors.grey.shade400,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         if((reportFilter?.selectedFirmCode.value
//                             ?? controller.selectedDropdownFirmCode.value)
//                             .isNotEmpty)
//                         // if (controller.selectedDropdownFirmCode.isNotEmpty)
//                           CommonAppInput(
//                             textInputAction: TextInputAction.done,
//                             textEditingController:
//                             controller.searchGroupController.value,
//                             //prifixIcon: Icons.search,
//                             suffixIcon:
//                             controller.searchQuery.value.isNotEmpty
//                                 ? Icons.close
//                                 : null,
//                             hintText: "Search here.. (i.e, Bill No, Account Name)",
//                             maxLength: 40,
//                             focusNode: controller.searchGroupFocus,
//                             onChanged: (text) {
//                               controller.searchQuery.value =
//                                   text; // Update the search query
//                               //controller.filterData(); // Restore the original data
//                               controller.filterData();
//
//                               //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
//                             },
//                             onSuffixClick: () {
//                               controller.searchGroupController.value.clear();
//                               Utils.closeKeyboard(context);
//                               controller.searchQuery.value = '';
//                               //controller.filterData(); // Restore the original data
//                               controller.filterData();
//
//                               //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
//                             },
//                           ),
//                         if((reportFilter?.selectedFirmCode.value
//                             ?? controller.selectedDropdownFirmCode.value)
//                             .isNotEmpty)
//                         // if (controller.selectedDropdownFirmCode.isNotEmpty)
//                           const SizedBox(height: 10),
//                       ],
//                     )
//                         : const SizedBox.shrink(),
//                   )),
//                   Expanded(
//                     child:
//                     (reportFilter?.selectedFirmCode.value
//                         ?? controller.selectedDropdownFirmCode.value)
//                         .isNotEmpty
//                     // controller.selectedDropdownFirmCode.isNotEmpty
//                         ? _getView(context)
//                         : Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.info_outline,),
//                           CommonText(
//                             text: ' Please Select Distributor first',
//                             fontSize: AppDimensions.fontSizeLarge,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: Obx(() {
//           final cartData = controller.salesMainList.value.data ?? [];
//
//           if (cartData.isEmpty) return const SizedBox.shrink();
//
//           final totalVouchAmount = cartData.fold<double>(
//             0,
//                 (sum, item) =>
//             sum +
//                 (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0.0),
//           );
//
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Card(
//               margin: const EdgeInsets.only(top: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(6),
//                   topRight: Radius.circular(6),
//                 ),
//               ),
//               child: SafeArea(
//                 top: false,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: CommonText(
//                               text:
//                               'Total Amt: ₹ ${Utils.formatIndianAmount(totalVouchAmount)}',
//                               fontWeight: AppFontWeight.w600,
//                               fontSize: AppDimensions.fontSizeRegular,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ).paddingOnly(bottom: 20),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _getView(BuildContext context) {
//     return controller.isLoading.isTrue
//         ? Utils.buildShimmerList()
//         : (controller.salesMainList.value.data == null ||
//         controller.salesMainList.value.data!.isEmpty)
//         ? CommonNoMessage(
//       searchQuery: controller.searchQuery.value,
//       errorMessage: controller.errorMsg.value,
//     )
//         : _listUI(context);
//   }
//
//   Widget _listUI(BuildContext context) {
//     return ListView.builder(
//       itemCount: controller.salesMainList.value.data!.length,
//       itemBuilder: (context, index) {
//         final ledgers = controller.salesMainList.value.data![index];
//
//         String amount =
//         ledgers.vOUCHAMT != null
//             ? Utils.formatIndianAmount(
//           double.parse(ledgers.vOUCHAMT?.toString() ?? '0'),
//         )
//             : "0.00";
//
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(6), // 👈 Customize the radius
//           ),
//           elevation: 1,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // Align content to the left
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CommonText(
//                         text: 'BK: ${ledgers.bOOKCD}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(
//                         text: 'Dt: ${ledgers.vOUCHDT}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(
//                         text: 'Bill No: ${ledgers.pARTYBL}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 CommonText(
//                   text: 'ACC Name : ${ledgers.account?.aCCNAME ?? ''}',
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: CommonText(
//                         text: 'Amt : ₹$amount',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     Expanded(
//                       child: CommonText(
//                         text: 'Narration : ${ledgers.nARRATION}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: CommonTextButton(
//                     title: 'View Details',
//                     onPressed: () {
//                       if (ledgers.bOOKCD! == 'RC' ||
//                           ledgers.bOOKCD! == 'PY' ||
//                           //accounts.bOOKCD! == 'PU' ||
//                           ledgers.bOOKCD! == 'EP' ||
//                           ledgers.bOOKCD! == 'IC' ||
//                           ledgers.bOOKCD! == 'JV') {
//                         controller.fetchExpandPaymentWithVouch(
//                           'full',
//                           ledgers.bOOKCD!,
//                           ledgers.vOUCHDT!.isNotEmpty
//                               ? AppDatePicker.convertToFormat(
//                             ledgers.vOUCHDT!,
//                             'yyyy-MM-dd',
//                           )
//                               : AppDatePicker.currentYYYYMMDDDate(),
//                           ledgers.pARTYCD!,
//                         );
//                       } else {
//                         controller.fetchExpandPaymentWithoutVouchSales(
//                           'full',
//                           ledgers.bOOKCD!,
//                           ledgers.vOUCHDT!.isNotEmpty
//                               ? AppDatePicker.convertToFormat(
//                             ledgers.vOUCHDT!,
//                             'yyyy-MM-dd',
//                           )
//                               : AppDatePicker.currentYYYYMMDDDate(),
//                           ledgers.pARTYCD!,
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }












// import 'package:arham_b2c/app/app_date_format.dart';
// import 'package:arham_b2c/app/app_dimensions.dart';
// import 'package:arham_b2c/app/app_font_weight.dart';
// import 'package:arham_b2c/models/firm_response.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_controller.dart';
// import 'package:arham_b2c/utility/utils.dart';
// import 'package:arham_b2c/widgets/common_app_bar.dart';
// import 'package:arham_b2c/widgets/common_app_input.dart';
// import 'package:arham_b2c/widgets/common_date_picker.dart';
// import 'package:arham_b2c/widgets/common_no_message.dart';
// import 'package:arham_b2c/widgets/common_text.dart';
// import 'package:arham_b2c/widgets/common_text_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
//
// import '../reports/reports_filter_controller.dart';
//
// class SalesRegisterView extends StatefulWidget {
//   final bool showCommonAppBar;
//   SalesRegisterView({super.key, this.showCommonAppBar = true});
//
//   @override
//   State<SalesRegisterView> createState() => _SalesRegisterViewState();
// }
//
// class _SalesRegisterViewState extends State<SalesRegisterView> {
//   final SalesRegisterController controller = Get.put(SalesRegisterController());
//
//   final filterCtrl = Get.find<ReportsFilterController>();
//
//   @override
//   void initState() {
//     super.initState();
//     // Get.put(ReportsFilterController());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ReportsFilterController? reportFilter =
//     Get.isRegistered<ReportsFilterController>()
//         ? Get.find<ReportsFilterController>()
//         : null;
//
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return PopScope(
//       canPop: true,
//       onPopInvokedWithResult: (bool didPop, Object? result) {
//         return;
//       },
//       child: Scaffold(
//         appBar: widget.showCommonAppBar
//             ? CommonAppBar(
//           title: 'Sales Register',
//           actions: [
//             Obx(() => IconButton(
//               onPressed: (){
//                 filterCtrl.toggleFilterSection();
//               },
//               icon: Icon(filterCtrl.showFilterSection.value ? CupertinoIcons.slider_horizontal_3 : CupertinoIcons.slider_horizontal_3),
//               tooltip: 'Filter',
//             )),
//           ],
//         )
//             : null,
//         // appBar: CommonAppBar(title: 'Sales Register',),
//         body: SafeArea(
//           child: Obx(
//                 () => Container(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 16),
//                   controller.isDropdownFirmLoading.isTrue
//                       ? Center(child: Utils.commonCircularProgress())
//                       : (controller.firmList.value.data == null ||
//                       controller.firmList.value.data!.isEmpty)
//                       ? Container()
//                       : TypeAheadField<FirmModel>(
//                     // controller: controller.firmController.value,
//                     controller: reportFilter?.firmTextController
//                         ?? controller.firmController.value,
//                     focusNode: controller.firmFocus,
//                     suggestionsCallback: (pattern) async {
//                       return controller.firmList.value.data?.where((item) {
//                         return item.firmName
//                             .toString()
//                             .trim()
//                             .toLowerCase()
//                             .contains(pattern.toLowerCase());
//                       }).toList();
//                     },
//                     itemBuilder: (context, FirmModel suggestion) {
//                       return ListTile(
//                         visualDensity: const VisualDensity(
//                           horizontal: -2.0,
//                           vertical: -4.0,
//                         ),
//                         title: CommonText(
//                           text:
//                           suggestion.mobile1 != null &&
//                               suggestion.mobile1!.trim().isNotEmpty
//                               ? "${suggestion.firmName.trim()} | ${suggestion.mobile1!.trim()}"
//                               : suggestion.firmName.trim(),
//                           fontWeight: AppFontWeight.w400,
//                           fontSize: 14,
//                         ),
//                       );
//                     },
//                     onSelected: (FirmModel selectedItem) {
//                       if (reportFilter != null) {
//                         // 🔗 Shared (Reports Tab)
//                         reportFilter.setFirm(selectedItem);
//                       } else {
//                         // 🧍 Standalone
//                         controller.selectedDropdownFirm.value = selectedItem;
//                         controller.selectedDropdownFirmCode.value =
//                             selectedItem.syncId.toString().trim();
//                         controller.firmController.value.text =
//                             selectedItem.firmName.trim();
//
//                         Get.find<ReportsFilterController>().showFilterSection.value = true;
//                       }
//
//                       Utils.closeKeyboard(Get.context!);
//                       controller.firmFocus.unfocus();
//                       controller.fetchSalesRegister();
//                     },
//                     builder: (context, textController, focusNode) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 15),
//                         child: TextField(
//                           controller: textController,
//                           focusNode: focusNode,
//                           textInputAction: TextInputAction.next,
//                           decoration: InputDecoration(
//                             counter: const Offstage(),
//                             suffixIcon: Padding(
//                               padding: const EdgeInsets.only(right: 10),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       if (reportFilter != null) {
//                                         reportFilter.clearFirm();
//                                       } else {
//                                         controller.firmController.value.clear();
//                                         controller.selectedDropdownFirm.value = null;
//                                         controller.selectedDropdownFirmName.value = '';
//                                         controller.selectedDropdownFirmCode.value = '';
//                                       }
//
//                                       controller.firmFocus.unfocus();
//                                       Utils.closeKeyboard(Get.context!);
//
//                                       controller.mainList.value.data?.clear();
//                                       controller.searchList.clear();
//                                       controller.mainList.refresh();
//
//                                       Get.find<SalesRegisterController>()
//                                           .mainList
//                                           .value
//                                           .data
//                                           ?.clear();
//                                       Get.find<SalesRegisterController>()
//                                           .searchList
//                                           .clear();
//                                       Get.find<SalesRegisterController>()
//                                           .mainList
//                                           .refresh();
//                                       // Get.find<OrderReportController>()
//                                       //      .fetchPayment();
//                                     },
//                                     child: const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Icon(Icons.close, size: 20),
//                                     ),
//                                   ),
//                                   const Icon(
//                                     size: 20,
//                                     Icons.keyboard_arrow_down,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             labelText: 'Select Distributor',
//                             isDense: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(4.0),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: colorScheme.outline,
//                                 // Default themed outline color
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(4.0),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: colorScheme.primary,
//                                 // Highlight color when focused
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(4.0),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: 10.0,
//                               horizontal: 10.0,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   Obx(() => AnimatedSize(
//                     duration: const Duration(milliseconds: 280),
//                     curve: Curves.easeInOut,
//                     child: reportFilter?.showFilterSection.value == true
//                         ? Column(
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CommonDatePickerInput(
//                                 controller: controller.fromDateController.value,
//                                 hintText: "From Date",
//                                 isEnabled:
//                                 (reportFilter?.selectedFirmCode.value
//                                     ?? controller.selectedDropdownFirmCode.value)
//                                     .isNotEmpty,
//                                 // controller.selectedDropdownFirmCode.isNotEmpty,
//                                 onTap: () async {
//                                   Utils.closeKeyboard(context);
//                                   DateTime? selectedDate =
//                                   await AppDatePicker.allDateEnable(
//                                     context,
//                                     controller.fromDateController.value,
//                                   );
//
//                                   if (selectedDate != null &&
//                                       controller
//                                           .selectedDropdownFirmCode
//                                           .isNotEmpty) {
//                                     String formattedDate = AppDatePicker.formatDate(
//                                       selectedDate,
//                                     );
//                                     //if (controller.toDateController.value.text != formattedDate) {
//                                     // controller.fromDateController.value.text =
//                                     //      formattedDate;
//                                     // controller.fetchSalesRegister();
//                                     final reportFilter = Get.find<ReportsFilterController>();
//                                     reportFilter.setFromDate(formattedDate);
//                                   }
//                                 },
//                                 // enabledBorderColor: Colors.teal,
//                                 // disabledBorderColor: Colors.grey.shade400,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: CommonDatePickerInput(
//                                 controller: controller.toDateController.value,
//                                 hintText: "To Date",
//                                 isEnabled:
//                                 (reportFilter?.selectedFirmCode.value
//                                     ?? controller.selectedDropdownFirmCode.value)
//                                     .isNotEmpty,
//                                 // controller.selectedDropdownFirmCode.isNotEmpty,
//                                 onTap: () async {
//                                   Utils.closeKeyboard(context);
//                                   DateTime? selectedDate =
//                                   await AppDatePicker.allDateEnable(
//                                     context,
//                                     controller.toDateController.value,
//                                   );
//
//                                   if (selectedDate != null &&
//                                       controller
//                                           .selectedDropdownFirmCode
//                                           .isNotEmpty) {
//                                     String formattedDate = AppDatePicker.formatDate(
//                                       selectedDate,
//                                     );
//                                     final reportFilter = Get.find<ReportsFilterController>();
//                                     reportFilter.setToDate(formattedDate);
//                                   }
//                                 },
//                                 // enabledBorderColor: Colors.teal,
//                                 // disabledBorderColor: Colors.grey.shade400,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         if((reportFilter?.selectedFirmCode.value
//                             ?? controller.selectedDropdownFirmCode.value)
//                             .isNotEmpty)
//                         // if (controller.selectedDropdownFirmCode.isNotEmpty)
//                           CommonAppInput(
//                             textInputAction: TextInputAction.done,
//                             textEditingController:
//                             controller.searchGroupController.value,
//                             //prifixIcon: Icons.search,
//                             suffixIcon:
//                             controller.searchQuery.value.isNotEmpty
//                                 ? Icons.close
//                                 : null,
//                             hintText: "Search here.. (i.e, Bill No, Account Name)",
//                             maxLength: 40,
//                             focusNode: controller.searchGroupFocus,
//                             onChanged: (text) {
//                               controller.searchQuery.value =
//                                   text; // Update the search query
//                               //controller.filterData(); // Restore the original data
//                               controller.filterData();
//
//                               //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
//                             },
//                             onSuffixClick: () {
//                               controller.searchGroupController.value.clear();
//                               Utils.closeKeyboard(context);
//                               controller.searchQuery.value = '';
//                               //controller.filterData(); // Restore the original data
//                               controller.filterData();
//
//                               //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
//                             },
//                           ),
//                         if((reportFilter?.selectedFirmCode.value
//                             ?? controller.selectedDropdownFirmCode.value)
//                             .isNotEmpty)
//                         // if (controller.selectedDropdownFirmCode.isNotEmpty)
//                           const SizedBox(height: 10),
//                       ],
//                     )
//                         : const SizedBox.shrink(),
//                   )),
//                   Expanded(
//                     child:
//                     (reportFilter?.selectedFirmCode.value
//                         ?? controller.selectedDropdownFirmCode.value)
//                         .isNotEmpty
//                     // controller.selectedDropdownFirmCode.isNotEmpty
//                         ? _getView(context)
//                         : Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.info_outline,),
//                           CommonText(
//                             text: ' Please Select Distributor first',
//                             fontSize: AppDimensions.fontSizeLarge,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: Obx(() {
//           final cartData = controller.mainList.value.data ?? [];
//
//           if (cartData.isEmpty) return const SizedBox.shrink();
//
//           final totalVouchAmount = cartData.fold<double>(
//             0,
//                 (sum, item) =>
//             sum +
//                 (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0.0),
//           );
//
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Card(
//               margin: const EdgeInsets.only(top: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(6),
//                   topRight: Radius.circular(6),
//                 ),
//               ),
//               child: SafeArea(
//                 top: false,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: CommonText(
//                               text:
//                               'Total Amt: ₹ ${Utils.formatIndianAmount(totalVouchAmount)}',
//                               fontWeight: AppFontWeight.w600,
//                               fontSize: AppDimensions.fontSizeRegular,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ).paddingOnly(bottom: 20),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _getView(BuildContext context) {
//     return controller.isLoading.isTrue
//         ? Utils.buildShimmerList()
//         : (controller.mainList.value.data == null ||
//         controller.mainList.value.data!.isEmpty)
//         ? CommonNoMessage(
//       searchQuery: controller.searchQuery.value,
//       errorMessage: controller.errorMsg.value,
//     )
//         : _listUI(context);
//   }
//
//   Widget _listUI(BuildContext context) {
//     return ListView.builder(
//       itemCount: controller.mainList.value.data!.length,
//       itemBuilder: (context, index) {
//         final ledgers = controller.mainList.value.data![index];
//
//         String amount =
//         ledgers.vOUCHAMT != null
//             ? Utils.formatIndianAmount(
//           double.parse(ledgers.vOUCHAMT?.toString() ?? '0'),
//         )
//             : "0.00";
//
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(6), // 👈 Customize the radius
//           ),
//           elevation: 1,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // Align content to the left
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CommonText(
//                         text: 'BK: ${ledgers.bOOKCD}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(
//                         text: 'Dt: ${ledgers.vOUCHDT}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(
//                         text: 'Bill No: ${ledgers.pARTYBL}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 CommonText(
//                   text: 'ACC Name : ${ledgers.account?.aCCNAME ?? ''}',
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: CommonText(
//                         text: 'Amt : ₹$amount',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     Expanded(
//                       child: CommonText(
//                         text: 'Narration : ${ledgers.nARRATION}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: CommonTextButton(
//                     title: 'View Details',
//                     onPressed: () {
//                       if (ledgers.bOOKCD! == 'RC' ||
//                           ledgers.bOOKCD! == 'PY' ||
//                           //accounts.bOOKCD! == 'PU' ||
//                           ledgers.bOOKCD! == 'EP' ||
//                           ledgers.bOOKCD! == 'IC' ||
//                           ledgers.bOOKCD! == 'JV') {
//                         controller.fetchExpandPaymentWithVouch(
//                           'full',
//                           ledgers.bOOKCD!,
//                           ledgers.vOUCHDT!.isNotEmpty
//                               ? AppDatePicker.convertToFormat(
//                             ledgers.vOUCHDT!,
//                             'yyyy-MM-dd',
//                           )
//                               : AppDatePicker.currentYYYYMMDDDate(),
//                           ledgers.pARTYCD!,
//                         );
//                       } else {
//                         controller.fetchExpandPaymentWithoutVouch(
//                           'full',
//                           ledgers.bOOKCD!,
//                           ledgers.vOUCHDT!.isNotEmpty
//                               ? AppDatePicker.convertToFormat(
//                             ledgers.vOUCHDT!,
//                             'yyyy-MM-dd',
//                           )
//                               : AppDatePicker.currentYYYYMMDDDate(),
//                           ledgers.pARTYCD!,
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }










// import 'package:arham_b2c/app/app_date_format.dart';
// import 'package:arham_b2c/app/app_dimensions.dart';
// import 'package:arham_b2c/app/app_font_weight.dart';
// import 'package:arham_b2c/models/firm_response.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_controller.dart';
// import 'package:arham_b2c/utility/utils.dart';
// import 'package:arham_b2c/widgets/common_app_bar.dart';
// import 'package:arham_b2c/widgets/common_app_input.dart';
// import 'package:arham_b2c/widgets/common_date_picker.dart';
// import 'package:arham_b2c/widgets/common_no_message.dart';
// import 'package:arham_b2c/widgets/common_text.dart';
// import 'package:arham_b2c/widgets/common_text_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
//
// import '../reports/reports_filter_controller.dart';
//
// class SalesRegisterView extends StatelessWidget {
//   final bool showCommonAppBar;
//   SalesRegisterView({super.key, this.showCommonAppBar = true});
//
//   final SalesRegisterController controller = Get.put(SalesRegisterController());
//
//   @override
//   Widget build(BuildContext context) {
//     final ReportsFilterController? reportFilter =
//     Get.isRegistered<ReportsFilterController>()
//         ? Get.find<ReportsFilterController>()
//         : null;
//
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return PopScope(
//       canPop: true,
//       onPopInvokedWithResult: (bool didPop, Object? result) {
//         return;
//       },
//       child: Scaffold(
//         appBar: showCommonAppBar
//         ? CommonAppBar(title: 'Sales Register')
//         : null,
//         // appBar: CommonAppBar(title: 'Sales Register',),
//         body: SafeArea(
//           child: Obx(
//             () => Container(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 16),
//                   Visibility(
//                     visible: false,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: InkWell(
//                             onTap: () async {
//                               Utils.closeKeyboard(context);
//                               DateTime? selectedDate =
//                                   await AppDatePicker.allDateEnable(
//                                     context,
//                                     controller.fromDateController.value,
//                                   );
//
//                               if (selectedDate != null &&
//                                   controller
//                                       .selectedDropdownFirmCode
//                                       .isNotEmpty) {
//                                 String formattedDate = AppDatePicker.formatDate(
//                                   selectedDate,
//                                 );
//                                 //if (controller.toDateController.value.text != formattedDate) {
//                                 // controller.fromDateController.value.text =
//                                 //     formattedDate;
//                                 // controller.fetchSalesRegister();
//                                 final reportFilter = Get.find<ReportsFilterController>();
//                                 reportFilter.setFromDate(formattedDate);
//                               }
//                             },
//                             child: CommonAppInput(
//                               textEditingController:
//                                   controller.fromDateController.value,
//                               hintText: "From Date",
//                               suffixIcon: Icons.calendar_month,
//                               focusNode: controller.fromDtFocus,
//                               // labelStyle: const TextStyle(
//                               //   color:
//                               //       AppColors
//                               //           .colorDarkGray, // Label color changed to gray
//                               // ),
//                               // hintStyle: const TextStyle(
//                               //   color:
//                               //       AppColors
//                               //           .colorBlack, // Hint color changed to black
//                               // ),
//                               isDateField: true,
//                               isEnable: false,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () async {
//                               Utils.closeKeyboard(context);
//                               DateTime? selectedDate =
//                                   await AppDatePicker.allDateEnable(
//                                     context,
//                                     controller.toDateController.value,
//                                   );
//
//                               if (selectedDate != null &&
//                                   controller
//                                       .selectedDropdownFirmCode
//                                       .isNotEmpty) {
//                                 String formattedDate = AppDatePicker.formatDate(
//                                   selectedDate,
//                                 );
//                                 //if (controller.toDateController.value.text != formattedDate) {
//                                 // controller.toDateController.value.text =
//                                 //     formattedDate;
//                                 // controller.fetchSalesRegister();
//                                 final reportFilter = Get.find<ReportsFilterController>();
//                                 reportFilter.setFromDate(formattedDate);
//                               }
//                             },
//                             child: CommonAppInput(
//                               textEditingController:
//                                   controller.toDateController.value,
//                               hintText: "To Date",
//                               suffixIcon: Icons.calendar_month,
//                               focusNode: controller.toDtFocus,
//                               // labelStyle: const TextStyle(
//                               //   color:
//                               //       AppColors
//                               //           .colorDarkGray, // Label color changed to gray
//                               // ),
//                               // hintStyle: const TextStyle(
//                               //   color:
//                               //       AppColors
//                               //           .colorBlack, // Hint color changed to black
//                               // ),
//                               isDateField: true,
//                               isEnable: false,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CommonDatePickerInput(
//                           controller: controller.fromDateController.value,
//                           hintText: "From Date",
//                           isEnabled:
//                           (reportFilter?.selectedFirmCode.value
//                               ?? controller.selectedDropdownFirmCode.value)
//                               .isNotEmpty,
//                               // controller.selectedDropdownFirmCode.isNotEmpty,
//                           onTap: () async {
//                             Utils.closeKeyboard(context);
//                             DateTime? selectedDate =
//                                 await AppDatePicker.allDateEnable(
//                                   context,
//                                   controller.fromDateController.value,
//                                 );
//
//                             if (selectedDate != null &&
//                                 controller
//                                     .selectedDropdownFirmCode
//                                     .isNotEmpty) {
//                               String formattedDate = AppDatePicker.formatDate(
//                                 selectedDate,
//                               );
//                               //if (controller.toDateController.value.text != formattedDate) {
//                               // controller.fromDateController.value.text =
//                               //     formattedDate;
//                               // controller.fetchSalesRegister();
//                               final reportFilter = Get.find<ReportsFilterController>();
//                               reportFilter.setFromDate(formattedDate);
//                             }
//                           },
//                           // enabledBorderColor: Colors.teal,
//                           // disabledBorderColor: Colors.grey.shade400,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: CommonDatePickerInput(
//                           controller: controller.toDateController.value,
//                           hintText: "To Date",
//                           isEnabled:
//                           (reportFilter?.selectedFirmCode.value
//                               ?? controller.selectedDropdownFirmCode.value)
//                               .isNotEmpty,
//                               // controller.selectedDropdownFirmCode.isNotEmpty,
//                           onTap: () async {
//                             Utils.closeKeyboard(context);
//                             DateTime? selectedDate =
//                                 await AppDatePicker.allDateEnable(
//                                   context,
//                                   controller.toDateController.value,
//                                 );
//
//                             if (selectedDate != null &&
//                                 controller
//                                     .selectedDropdownFirmCode
//                                     .isNotEmpty) {
//                               String formattedDate = AppDatePicker.formatDate(
//                                 selectedDate,
//                               );
//                               //if (controller.toDateController.value.text != formattedDate) {
//                               // controller.toDateController.value.text =
//                               //     formattedDate;
//                               // controller.fetchSalesRegister();
//                               final reportFilter = Get.find<ReportsFilterController>();
//                               reportFilter.setToDate(formattedDate);
//                             }
//                           },
//                           // enabledBorderColor: Colors.teal,
//                           // disabledBorderColor: Colors.grey.shade400,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   controller.isDropdownFirmLoading.isTrue
//                       ? Center(child: Utils.commonCircularProgress())
//                       : (controller.firmList.value.data == null ||
//                           controller.firmList.value.data!.isEmpty)
//                       ? Container()
//                       : TypeAheadField<FirmModel>(
//                         // controller: controller.firmController.value,
//                     controller: reportFilter?.firmTextController
//                         ?? controller.firmController.value,
//                         focusNode: controller.firmFocus,
//                         suggestionsCallback: (pattern) async {
//                           return controller.firmList.value.data?.where((item) {
//                             return item.firmName
//                                 .toString()
//                                 .trim()
//                                 .toLowerCase()
//                                 .contains(pattern.toLowerCase());
//                           }).toList();
//                         },
//                         itemBuilder: (context, FirmModel suggestion) {
//                           return ListTile(
//                             visualDensity: const VisualDensity(
//                               horizontal: -2.0,
//                               vertical: -4.0,
//                             ),
//                             title: CommonText(
//                               text:
//                                   suggestion.mobile1 != null &&
//                                           suggestion.mobile1!.trim().isNotEmpty
//                                       ? "${suggestion.firmName.trim()} | ${suggestion.mobile1!.trim()}"
//                                       : suggestion.firmName.trim(),
//                               fontWeight: AppFontWeight.w400,
//                               fontSize: 14,
//                             ),
//                           );
//                         },
//                         onSelected: (FirmModel selectedItem) {
//                           if (reportFilter != null) {
//                             // 🔗 Shared (Reports Tab)
//                             reportFilter.setFirm(selectedItem);
//                           } else {
//                             // 🧍 Standalone
//                             controller.selectedDropdownFirm.value = selectedItem;
//                             controller.selectedDropdownFirmCode.value =
//                                 selectedItem.syncId.toString().trim();
//                             controller.firmController.value.text =
//                                 selectedItem.firmName.trim();
//                           }
//
//                           Utils.closeKeyboard(Get.context!);
//                           controller.firmFocus.unfocus();
//                           controller.fetchSalesRegister();
//                         },
//                         // onSelected: (FirmModel selectedItem) {
//                         //   controller.selectedDropdownFirm.value = selectedItem;
//                         //   controller.selectedDropdownFirmCode.value =
//                         //       selectedItem.syncId.toString().trim();
//                         //   controller.firmController.value.text =
//                         //       selectedItem.firmName.trim();
//                         //   Utils.closeKeyboard(Get.context!);
//                         //   controller.firmFocus.unfocus();
//                         //   controller.fetchSalesRegister();
//                         // },
//                         builder: (context, textController, focusNode) {
//                           return TextField(
//                             controller: textController,
//                             focusNode: focusNode,
//                             textInputAction: TextInputAction.next,
//                             decoration: InputDecoration(
//                               counter: const Offstage(),
//                               // suffixIconConstraints: const BoxConstraints(
//                               //   minWidth: 16,
//                               //   minHeight: 39,
//                               // ),
//                               suffixIcon: Padding(
//                                 padding: const EdgeInsets.only(right: 10),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         // controller.clear();
//                                         // Get.find<SalesRegisterController>()
//                                         //     .firmFocus
//                                         //     .unfocus();
//                                         // Get.find<SalesRegisterController>()
//                                         //     .selectedDropdownFirm
//                                         //     .value = null;
//                                         // Get.find<SalesRegisterController>()
//                                         //     .selectedDropdownFirmName
//                                         //     .value = '';
//                                         // Get.find<SalesRegisterController>()
//                                         //     .selectedDropdownFirmCode
//                                         //     .value = '';
//                                         if (reportFilter != null) {
//                                           reportFilter.clearFirm();
//                                         } else {
//                                           controller.firmController.value.clear();
//                                           controller.selectedDropdownFirm.value = null;
//                                           controller.selectedDropdownFirmName.value = '';
//                                           controller.selectedDropdownFirmCode.value = '';
//                                         }
//
//                                         controller.firmFocus.unfocus();
//                                         Utils.closeKeyboard(Get.context!);
//
//                                         controller.mainList.value.data?.clear();
//                                         controller.searchList.clear();
//                                         controller.mainList.refresh();
//
//                                         Get.find<SalesRegisterController>()
//                                             .mainList
//                                             .value
//                                             .data
//                                             ?.clear();
//                                         Get.find<SalesRegisterController>()
//                                             .searchList
//                                             .clear();
//                                         Get.find<SalesRegisterController>()
//                                             .mainList
//                                             .refresh();
//                                         // Get.find<OrderReportController>()
//                                         //     .fetchPayment();
//                                       },
//                                       child: const Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Icon(Icons.close, size: 20),
//                                       ),
//                                     ),
//                                     const Icon(
//                                       size: 20,
//                                       Icons.keyboard_arrow_down,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               labelText: 'Select Distributor',
//                               isDense: true,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(4.0),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: colorScheme.outline,
//                                   // Default themed outline color
//                                   width: 1,
//                                 ),
//                                 borderRadius: BorderRadius.circular(4.0),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: colorScheme.primary,
//                                   // Highlight color when focused
//                                   width: 1,
//                                 ),
//                                 borderRadius: BorderRadius.circular(4.0),
//                               ),
//                               contentPadding: EdgeInsets.symmetric(
//                                 vertical: 10.0,
//                                 horizontal: 10.0,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//
//                   const SizedBox(height: 16),
//                   if((reportFilter?.selectedFirmCode.value
//                       ?? controller.selectedDropdownFirmCode.value)
//                       .isNotEmpty)
//                   // if (controller.selectedDropdownFirmCode.isNotEmpty)
//                     CommonAppInput(
//                       textInputAction: TextInputAction.done,
//                       textEditingController:
//                           controller.searchGroupController.value,
//                       //prifixIcon: Icons.search,
//                       suffixIcon:
//                           controller.searchQuery.value.isNotEmpty
//                               ? Icons.close
//                               : null,
//                       hintText: "Search here.. (i.e, Bill No, Account Name)",
//                       maxLength: 40,
//                       focusNode: controller.searchGroupFocus,
//                       onChanged: (text) {
//                         controller.searchQuery.value =
//                             text; // Update the search query
//                         //controller.filterData(); // Restore the original data
//                         controller.filterData();
//
//                         //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
//                       },
//                       onSuffixClick: () {
//                         controller.searchGroupController.value.clear();
//                         Utils.closeKeyboard(context);
//                         controller.searchQuery.value = '';
//                         //controller.filterData(); // Restore the original data
//                         controller.filterData();
//
//                         //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
//                       },
//                     ),
//                   if((reportFilter?.selectedFirmCode.value
//                       ?? controller.selectedDropdownFirmCode.value)
//                       .isNotEmpty)
//                   // if (controller.selectedDropdownFirmCode.isNotEmpty)
//                     const SizedBox(height: 10),
//
//                   Expanded(
//                     child:
//                     (reportFilter?.selectedFirmCode.value
//                         ?? controller.selectedDropdownFirmCode.value)
//                         .isNotEmpty
//                         // controller.selectedDropdownFirmCode.isNotEmpty
//                             ? _getView(context)
//                             : Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.info_outline, color: Colors.red,),
//                                   CommonText(
//                                     text: ' Please Select Distributor first',
//                                     fontSize: AppDimensions.fontSizeLarge,
//                                     color: Colors.red,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: Obx(() {
//           final cartData = controller.mainList.value.data ?? [];
//
//           if (cartData.isEmpty) return const SizedBox.shrink();
//
//           final totalVouchAmount = cartData.fold<double>(
//             0,
//             (sum, item) =>
//                 sum +
//                 (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0.0),
//           );
//
//           // final totalNetAmount = cartData.fold<double>(
//           //   0,
//           //       (sum, item) =>
//           //   sum + (double.tryParse(item.nETAMT?.toString() ?? '0') ?? 0.0),
//           // );
//
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Card(
//               margin: const EdgeInsets.only(top: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(6),
//                   topRight: Radius.circular(6),
//                 ),
//               ),
//               child: SafeArea(
//                 top: false,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: CommonText(
//                               text:
//                                   'Total Amt: ₹ ${Utils.formatIndianAmount(totalVouchAmount)}',
//                               fontWeight: AppFontWeight.w600,
//                               fontSize: AppDimensions.fontSizeRegular,
//                             ),
//                           ),
//                           // CommonText(
//                           //   text: '|',
//                           //   fontWeight: AppFontWeight.w600,
//                           //   fontSize: AppDimensions.fontSizeRegular,
//                           //   color: Colors.red,
//                           // ),
//                           // Expanded(
//                           //   child: CommonText(
//                           //     text:
//                           //     'Total Bill Amt: ₹ ${Utils.formatIndianAmount(totalNetAmount)}',
//                           //     fontWeight: AppFontWeight.w600,
//                           //     fontSize: AppDimensions.fontSizeRegular,
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ],
//                   ).paddingOnly(bottom: 20),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _getView(BuildContext context) {
//     return controller.isLoading.isTrue
//         ? Utils.buildShimmerList()
//         : (controller.mainList.value.data == null ||
//             controller.mainList.value.data!.isEmpty)
//         ? CommonNoMessage(
//           searchQuery: controller.searchQuery.value,
//           errorMessage: controller.errorMsg.value,
//         )
//         : _listUI(context);
//   }
//
//   Widget _listUI(BuildContext context) {
//     return ListView.builder(
//       itemCount: controller.mainList.value.data!.length,
//       itemBuilder: (context, index) {
//         final ledgers = controller.mainList.value.data![index];
//
//         String amount =
//             ledgers.vOUCHAMT != null
//                 ? Utils.formatIndianAmount(
//                   double.parse(ledgers.vOUCHAMT?.toString() ?? '0'),
//                 )
//                 : "0.00";
//
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(6), // 👈 Customize the radius
//           ),
//           elevation: 1,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // Align content to the left
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CommonText(
//                         text: 'BK: ${ledgers.bOOKCD}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(
//                         text: 'Dt: ${ledgers.vOUCHDT}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(
//                         text: 'Bill No: ${ledgers.pARTYBL}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 CommonText(
//                   text: 'ACC Name : ${ledgers.account?.aCCNAME ?? ''}',
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: CommonText(
//                         text: 'Amt : ₹$amount',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                     Expanded(
//                       child: CommonText(
//                         text: 'Narration : ${ledgers.nARRATION}',
//                         fontSize: AppDimensions.fontSizeSmall,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: CommonTextButton(
//                     title: 'View Details',
//                     onPressed: () {
//                       if (ledgers.bOOKCD! == 'RC' ||
//                           ledgers.bOOKCD! == 'PY' ||
//                           //accounts.bOOKCD! == 'PU' ||
//                           ledgers.bOOKCD! == 'EP' ||
//                           ledgers.bOOKCD! == 'IC' ||
//                           ledgers.bOOKCD! == 'JV') {
//                         controller.fetchExpandPaymentWithVouch(
//                           'full',
//                           ledgers.bOOKCD!,
//                           ledgers.vOUCHDT!.isNotEmpty
//                               ? AppDatePicker.convertToFormat(
//                                 ledgers.vOUCHDT!,
//                                 'yyyy-MM-dd',
//                               )
//                               : AppDatePicker.currentYYYYMMDDDate(),
//                           ledgers.pARTYCD!,
//                         );
//                       } else {
//                         controller.fetchExpandPaymentWithoutVouch(
//                           'full',
//                           ledgers.bOOKCD!,
//                           ledgers.vOUCHDT!.isNotEmpty
//                               ? AppDatePicker.convertToFormat(
//                                 ledgers.vOUCHDT!,
//                                 'yyyy-MM-dd',
//                               )
//                               : AppDatePicker.currentYYYYMMDDDate(),
//                           ledgers.pARTYCD!,
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 // TextButton(
//                 //   style: TextButton.styleFrom(
//                 //     padding: EdgeInsets.zero, // Remove default padding
//                 //   ),
//                 //   onPressed: () {
//                 //     if (ledgers.bOOKCD! == 'RC' ||
//                 //         ledgers.bOOKCD! == 'PY' ||
//                 //         //accounts.bOOKCD! == 'PU' ||
//                 //         ledgers.bOOKCD! == 'EP' ||
//                 //         ledgers.bOOKCD! == 'IC' ||
//                 //         ledgers.bOOKCD! == 'JV') {
//                 //       controller.fetchExpandPaymentWithVouch(
//                 //         'full',
//                 //         ledgers.bOOKCD!,
//                 //         ledgers.vOUCHDT!.isNotEmpty
//                 //             ? AppDatePicker.convertDateTimeFormat(
//                 //               ledgers.vOUCHDT!,
//                 //               'dd-MM-yyyy',
//                 //               'yyyy-MM-dd',
//                 //             )
//                 //             : AppDatePicker.currentYYYYMMDDDate(),
//                 //         ledgers.pARTYCD!,
//                 //       );
//                 //     } else {
//                 //       controller.fetchExpandPaymentWithoutVouch(
//                 //         'full',
//                 //         ledgers.bOOKCD!,
//                 //         ledgers.vOUCHDT!.isNotEmpty
//                 //             ? AppDatePicker.convertDateTimeFormat(
//                 //               ledgers.vOUCHDT!,
//                 //               'dd-MM-yyyy',
//                 //               'yyyy-MM-dd',
//                 //             )
//                 //             : AppDatePicker.currentYYYYMMDDDate(),
//                 //         ledgers.pARTYCD!,
//                 //       );
//                 //     }
//                 //   },
//                 //   child: Text(
//                 //     'View Details',
//                 //     style: TextStyle(color: AppColors.teal, fontSize: 12),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
