import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/screens/report/report_controller.dart'; // UPDATED
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_no_message.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:arham_b2c/widgets/common_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountLedgerView extends StatelessWidget {
  AccountLedgerView({super.key});

  final ReportController controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        children: [
          Expanded(child: _getView(context)),
          Obx(() {
            final cartData = controller.ledgerMainList.value.data ?? []; // Updated

            if (cartData.isEmpty) return const SizedBox.shrink();

            final totalCRAmount = cartData.fold<double>(
              0,
                  (sum, item) =>
              sum + (double.tryParse(item.cRAMT?.toString() ?? '0') ?? 0.0),
            );
            final totalDRAmount = cartData.fold<double>(
              0,
                  (sum, item) =>
              sum + (double.tryParse(item.dRAMT?.toString() ?? '0') ?? 0.0),
            );
            final totalCLAmount = totalDRAmount - totalCRAmount;

            final screenWidth = MediaQuery.of(context).size.width;
            final isSmallScreen = screenWidth < 400;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isSmallScreen
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text:
                              'Closing: ₹${Utils.formatIndianAmount(totalCLAmount)} ${totalCLAmount < 0 ? 'Cr' : 'Dr'}',
                              fontWeight: AppFontWeight.w600,
                              fontSize: 12,
                              color: totalCLAmount < 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                CommonText(
                                  text:
                                  'CR: ₹${Utils.formatIndianAmount(totalCRAmount)}',
                                  fontWeight: AppFontWeight.w600,
                                  fontSize: 11,
                                  color: Colors.red,
                                ),
                                CommonText(
                                  text: '|',
                                  fontWeight: AppFontWeight.w600,
                                  fontSize: 11,
                                  color: Colors.grey[400],
                                ),
                                CommonText(
                                  text:
                                  'DR: ₹${Utils.formatIndianAmount(totalDRAmount)}',
                                  fontWeight: AppFontWeight.w600,
                                  fontSize: 11,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        )
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text:
                              'Closing Amount: ₹${Utils.formatIndianAmount(totalCLAmount)} ${totalCLAmount < 0 ? 'Cr' : 'Dr'}',
                              fontWeight: AppFontWeight.w600,
                              fontSize: 13,
                              color: totalCLAmount < 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                CommonText(
                                  text:
                                  'Credit: ₹${Utils.formatIndianAmount(totalCRAmount)}',
                                  fontWeight: AppFontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                                CommonText(
                                  text: '|',
                                  fontWeight: AppFontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                                CommonText(
                                  text:
                                  'Debit: ₹${Utils.formatIndianAmount(totalDRAmount)}',
                                  fontWeight: AppFontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(bottom: 12),
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
        : (controller.ledgerMainList.value.data == null ||
        controller.ledgerMainList.value.data!.isEmpty)
        ? Center(
          child: CommonNoMessage(
                searchQuery: controller.searchQuery.value,
                errorMessage: controller.errorMsg.value,
              ),
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
      itemCount: controller.ledgerMainList.value.data!.length,
      itemBuilder: (context, index) {
        final ledgers = controller.ledgerMainList.value.data![index];

        String creditAmount =
        ledgers.cRAMT != null
            ? Utils.formatIndianAmount(
          double.parse(ledgers.cRAMT?.toString() ?? '0'),
        )
            : "0.00";

        String debitAmount =
        ledgers.dRAMT != null
            ? Utils.formatIndianAmount(
          double.parse(ledgers.dRAMT?.toString() ?? '0'),
        )
            : "0.00";

        String closeAmount =
        ledgers.cLBAL != null
            ? Utils.formatIndianAmount(
          double.parse(ledgers.cLBAL?.toString() ?? '0'),
        )
            : "0.00";

        double crValue = double.tryParse(ledgers.cRAMT?.toString() ?? '0') ?? 0.0;
        double drValue = double.tryParse(ledgers.dRAMT?.toString() ?? '0') ?? 0.0;
        Color indicatorColor;
        if (crValue > 0) {
          indicatorColor = Colors.red;
        } else if (drValue > 0) {
          indicatorColor = Colors.green;
        } else {
          indicatorColor = Colors.grey; // fallback
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
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
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: indicatorColor,
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.numbers,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                CommonText(
                                  text: '${ledgers.bILLNO ?? 'N/A'}',
                                  fontSize: 16,
                                  fontWeight: AppFontWeight.w600,
                                ),
                                // CommonText(
                                //   text: 'Book: ${ledgers.bOOKCD ?? 'N/A'}',
                                //   fontSize: 12,
                                //   color: Colors.black,
                                //   fontWeight: AppFontWeight.w600,
                                // ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                CommonText(
                                  text: ledgers.vOUCHDT ?? '',
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: CommonText(
                                    text: 'Book: ${ledgers.bOOKCD ?? 'N/A'}',
                                    fontSize: 12,
                                    fontWeight: AppFontWeight.w600,
                                    maxLine: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                // Icon(
                                //   Icons.receipt,
                                //   size: 14,
                                //   color: Colors.grey[600],
                                // ),
                                // const SizedBox(width: 4),
                                // Expanded(
                                //   child: CommonText(
                                //     text: 'Bill No: ${ledgers.bILLNO ?? 'N/A'}',
                                //     fontSize: 11,
                                //     fontWeight: AppFontWeight.w600,
                                //     color: Colors.grey[700],
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.green.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: CommonText(
                                  text: 'Dr ₹$debitAmount',
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.w700,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: CommonText(
                                  text: 'Cr ₹$creditAmount',
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.w700,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: CommonText(
                              text: 'Balance ₹$closeAmount',
                              fontSize: 12,
                              fontWeight: AppFontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 1,
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[700]!.withValues(alpha: 0.5)
                        : Colors.grey[300]!.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: colorScheme.primary.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      CommonText(
                        text: ledgers.aCCNAME ?? '',
                        fontSize: 13,
                        maxLine: 3,
                        fontWeight: AppFontWeight.w700,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                      Spacer(),
                      if (ledgers.bOOKCD != 'OP' && ledgers.bOOKCD != 'CO')
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              controller.selectedLedgerRecord.value = ledgers;
                              // Call controller methods
                              if (ledgers.bOOKCD! == 'RC' ||
                              ledgers.bOOKCD! == 'PY' ||
                              //accounts.bOOKCD! == 'PU' ||
                              ledgers.bOOKCD! == 'EP' ||
                              ledgers.bOOKCD! == 'IC' ||
                              ledgers.bOOKCD! == 'JV') {
                            controller.fetchExpandPaymentWithVouchLedger(
                              'full',
                              ledgers.bOOKCD!,
                              ledgers.vOUCHDT!.isNotEmpty
                                  ? AppDatePicker.convertDateTimeFormat(
                                    ledgers.vOUCHDT!,
                                    'dd-MM-yyyy',
                                    'yyyy-MM-dd',
                                  )
                                  : AppDatePicker.currentYYYYMMDDDate(),
                              ledgers.pARTYCD!,
                              ledgers.vOUCHNO.toString(),
                            );
                          } else {
                            controller.fetchExpandPaymentWithoutVouchLedger(
                              'full',
                              ledgers.bOOKCD!,
                              ledgers.vOUCHDT!.isNotEmpty
                                  ? AppDatePicker.convertDateTimeFormat(
                                    ledgers.vOUCHDT!,
                                    'dd-MM-yyyy',
                                    'yyyy-MM-dd',
                                  )
                                  : AppDatePicker.currentYYYYMMDDDate(),
                              ledgers.pARTYCD!,
                              ledgers.vOUCHNO.toString(),
                            );
                          }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                          ),
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
          ),
        );
      },
    );
  }

  // ignore: unused_element
  Widget _listUI1(BuildContext context) {
    final data = controller.ledgerMainList.value.data;
    if (data == null || data.length <= 1) {
      return Center(child: CommonText(text: "No records found after index 0."));
    }

    return ListView.builder(
      itemCount: data.length - 1,
      itemBuilder: (context, index) {
        final ledgers = data[index + 1];

        String creditAmount =
        ledgers.cRAMT != null
            ? Utils.formatIndianAmount(
          double.parse(ledgers.cRAMT?.toString() ?? '0'),
        )
            : "0.00";

        String debitAmount =
        ledgers.dRAMT != null
            ? Utils.formatIndianAmount(
          double.parse(ledgers.dRAMT?.toString() ?? '0'),
        )
            : "0.00";

        String closeAmount =
        ledgers.cLBAL != null
            ? Utils.formatIndianAmount(
          double.parse(ledgers.cLBAL?.toString() ?? '0'),
        )
            : "0.00";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: CommonText(text: 'BK: ${ledgers.bOOKCD}')),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 2,
                      child: CommonText(text: 'Vouch Dt: ${ledgers.vOUCHDT}'),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 2,
                      child: CommonText(text: 'Bill No: ${ledgers.bILLNO}'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: CommonText(text: 'Cr Amt : ₹$creditAmount'),
                    ),
                    const SizedBox(width: 4),
                    Expanded(child: CommonText(text: 'Dr Amt : ₹$debitAmount')),
                    const SizedBox(width: 4),
                    Expanded(
                      child: CommonText(text: 'Closing BL : ₹$closeAmount'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CommonText(text: 'ACC Name : ${ledgers.aCCNAME}'),
                const SizedBox(height: 4),
                CommonText(text: 'Narration : ${ledgers.nARRATION}'),
                Align(
                  alignment: Alignment.centerRight,
                  child: CommonTextButton(
                    title: 'View Details',
                    onPressed: () {
                      // Controller logic

                    },
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
// import 'package:arham_b2c/screens/account_ledger/account_leadger_controller.dart';
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
// class AccountLedgerView extends StatelessWidget {
//   final bool showCommonAppBar;
//   AccountLedgerView({super.key, this.showCommonAppBar = true});
//
//   final AccountLedgerController controller = Get.put(AccountLedgerController());
//
//   final filterCtrl = Get.find<ReportsFilterController>();
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
//             ? CommonAppBar(
//           title: 'Account Ledger',
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
//         // appBar: CommonAppBar(title: 'Account Ledger Report',),
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
//                         // Expanded(
//                         //   child: InkWell(
//                         //     onTap: () async {
//                         //       Utils.closeKeyboard(context);
//                         //       DateTime? selectedDate =
//                         //           await AppDatePicker.allDateEnable(
//                         //             context,
//                         //             controller.fromDateController.value,
//                         //           );
//                         //
//                         //       if (selectedDate != null &&
//                         //           controller
//                         //               .selectedDropdownFirmCode
//                         //               .isNotEmpty) {
//                         //         String formattedDate = AppDatePicker.formatDate(
//                         //           selectedDate,
//                         //         );
//                         //         //if (controller.toDateController.value.text != formattedDate) {
//                         //         controller.fromDateController.value.text =
//                         //             formattedDate;
//                         //         controller
//                         //             .fetchLedger(); // API call only after date change
//                         //         //}
//                         //       }
//                         //     },
//                         //     child: CommonAppInput(
//                         //       textEditingController:
//                         //           controller.fromDateController.value,
//                         //       hintText: "From Date",
//                         //       suffixIcon: Icons.calendar_month,
//                         //       focusNode: controller.fromDtFocus,
//                         //       // labelStyle: const TextStyle(
//                         //       //   color:
//                         //       //       AppColors
//                         //       //           .colorDarkGray, // Label color changed to gray
//                         //       // ),
//                         //       // hintStyle: const TextStyle(
//                         //       //   color:
//                         //       //       AppColors
//                         //       //           .colorBlack, // Hint color changed to black
//                         //       // ),
//                         //       isDateField: true,
//                         //       isEnable: false,
//                         //     ),
//                         //   ),
//                         // ),
//                         // const SizedBox(width: 16),
//                         // Expanded(
//                         //   child: InkWell(
//                         //     onTap: () async {
//                         //       Utils.closeKeyboard(context);
//                         //       DateTime? selectedDate =
//                         //           await AppDatePicker.allDateEnable(
//                         //             context,
//                         //             controller.toDateController.value,
//                         //           );
//                         //
//                         //       if (selectedDate != null &&
//                         //           controller
//                         //               .selectedDropdownFirmCode
//                         //               .isNotEmpty) {
//                         //         String formattedDate = AppDatePicker.formatDate(
//                         //           selectedDate,
//                         //         );
//                         //         //if (controller.toDateController.value.text != formattedDate) {
//                         //         controller.toDateController.value.text =
//                         //             formattedDate;
//                         //         controller.fetchLedger();
//                         //       }
//                         //     },
//                         //     child: CommonAppInput(
//                         //       textEditingController:
//                         //           controller.toDateController.value,
//                         //       hintText: "To Date",
//                         //       suffixIcon: Icons.calendar_month,
//                         //       focusNode: controller.toDtFocus,
//                         //       // labelStyle: const TextStyle(
//                         //       //   color:
//                         //       //       AppColors
//                         //       //           .colorDarkGray, // Label color changed to gray
//                         //       // ),
//                         //       // hintStyle: const TextStyle(
//                         //       //   color:
//                         //       //       AppColors
//                         //       //           .colorBlack, // Hint color changed to black
//                         //       // ),
//                         //       isDateField: true,
//                         //       isEnable: false,
//                         //     ),
//                         //   ),
//                         // ),
//                         Expanded(
//                           // child: CommonDatePickerInput(
//                           //   controller: controller.fromDateController.value,
//                           //   hintText: "From Date",
//                           //   isEnabled:
//                           //       // controller.selectedDropdownFirmCode.isNotEmpty,
//                           //   (reportFilter?.selectedFirmCode.value
//                           //       ?? controller.selectedDropdownFirmCode.value)
//                           //       .isNotEmpty,
//                           //   onTap: () async {
//                           //     Utils.closeKeyboard(context);
//                           //     DateTime? selectedDate =
//                           //         await AppDatePicker.allDateEnable(
//                           //           context,
//                           //           controller.fromDateController.value,
//                           //         );
//                           //
//                           //     if (selectedDate != null &&
//                           //         controller
//                           //             .selectedDropdownFirmCode
//                           //             .isNotEmpty) {
//                           //       String formattedDate = AppDatePicker.formatDate(
//                           //         selectedDate,
//                           //       );
//                           //       //if (controller.toDateController.value.text != formattedDate) {
//                           //       // controller.fromDateController.value.text =
//                           //       //     formattedDate;
//                           //       // controller
//                           //       //     .fetchLedger(); // API call only after date change
//                           //       final reportFilter = Get.find<ReportsFilterController>();
//                           //       reportFilter.setFromDate(formattedDate);
//                           //       //}
//                           //     }
//                           //   },
//                           //   // enabledBorderColor: Colors.teal,
//                           //   // disabledBorderColor: Colors.grey.shade400,
//                           // ),
//                           child: InkWell(
//                             onTap: () async {
//                               Utils.closeKeyboard(context);
//                               DateTime? selectedDate =
//                               await AppDatePicker.allDateEnable(
//                                 context,
//                                 controller.fromDateController.value,
//                               );
//
//                               if (selectedDate != null &&
//                                   controller
//                                       .selectedDropdownFirmCode
//                                       .isNotEmpty) {
//                                 String formattedDate = AppDatePicker.formatDate(
//                                   selectedDate,
//                                 );
//                                 final reportFilter = Get.find<ReportsFilterController>();
//                                 reportFilter.setFromDate(formattedDate);
//                               }
//                             },
//                             child: CommonAppInput(
//                               textEditingController:
//                               controller.fromDateController.value,
//                               hintText: "From Date",
//                               suffixIcon: Icons.calendar_month,
//                               focusNode: controller.fromDtFocus,
//                               isDateField: true,
//                               isEnable: false,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           // child: CommonDatePickerInput(
//                           //   controller: controller.toDateController.value,
//                           //   hintText: "To Date",
//                           //   isEnabled:
//                           //       // controller.selectedDropdownFirmCode.isNotEmpty,
//                           //   (reportFilter?.selectedFirmCode.value
//                           //       ?? controller.selectedDropdownFirmCode.value)
//                           //       .isNotEmpty,
//                           //   onTap: () async {
//                           //     Utils.closeKeyboard(context);
//                           //     DateTime? selectedDate =
//                           //         await AppDatePicker.allDateEnable(
//                           //           context,
//                           //           controller.toDateController.value,
//                           //         );
//                           //
//                           //     if (selectedDate != null &&
//                           //         controller
//                           //             .selectedDropdownFirmCode
//                           //             .isNotEmpty) {
//                           //       String formattedDate = AppDatePicker.formatDate(
//                           //         selectedDate,
//                           //       );
//                           //       //if (controller.toDateController.value.text != formattedDate) {
//                           //       // controller.toDateController.value.text =
//                           //       //     formattedDate;
//                           //       // controller.fetchLedger();
//                           //       final reportFilter = Get.find<ReportsFilterController>();
//                           //       reportFilter.setToDate(formattedDate);
//                           //     }
//                           //   },
//                           //   // enabledBorderColor: Colors.teal,
//                           //   // disabledBorderColor: Colors.grey.shade400,
//                           // ),
//                           child: InkWell(
//                             onTap: () async {
//                               Utils.closeKeyboard(context);
//                               DateTime? selectedDate =
//                               await AppDatePicker.allDateEnable(
//                                 context,
//                                 controller.toDateController.value,
//                               );
//
//                               if (selectedDate != null &&
//                                   controller
//                                       .selectedDropdownFirmCode
//                                       .isNotEmpty) {
//                                 String formattedDate = AppDatePicker.formatDate(
//                                   selectedDate,
//                                 );
//                                 final reportFilter = Get.find<ReportsFilterController>();
//                                 reportFilter.setFromDate(formattedDate);
//                               }
//                             },
//                             child: CommonAppInput(
//                               textEditingController:
//                               controller.toDateController.value,
//                               hintText: "To Date",
//                               suffixIcon: Icons.calendar_month,
//                               focusNode: controller.toDtFocus,
//                               isDateField: true,
//                               isEnable: false,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // const SizedBox(height: 16),
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
//                         // onSelected: (FirmModel selectedItem) {
//                         //   controller.selectedDropdownFirm.value = selectedItem;
//                         //   controller.selectedDropdownFirmCode.value =
//                         //       selectedItem.syncId.toString().trim();
//                         //   controller.firmController.value.text =
//                         //       selectedItem.firmName.trim();
//                         //   Utils.closeKeyboard(Get.context!);
//                         //   controller.firmFocus.unfocus();
//                         //   controller.fetchLedger();
//                         // },
//                     onSelected: (FirmModel selectedItem) {
//
//                       if (reportFilter != null) {
//                         // 🔗 Shared (Reports tabs)
//                         reportFilter.setFirm(selectedItem);
//                       } else {
//                         // 🧍 Standalone
//                         controller.selectedDropdownFirm.value = selectedItem;
//                         controller.selectedDropdownFirmCode.value =
//                             selectedItem.syncId.toString().trim();
//                         controller.firmController.value.text =
//                             selectedItem.firmName.trim();
//                       }
//
//                       Utils.closeKeyboard(Get.context!);
//                       controller.firmFocus.unfocus();
//                       controller.fetchLedger();
//                     },
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
//                                         // Get.find<AccountLedgerController>()
//                                         //     .firmFocus
//                                         //     .unfocus();
//                                         // Get.find<AccountLedgerController>()
//                                         //     .selectedDropdownFirm
//                                         //     .value = null;
//                                         // Get.find<AccountLedgerController>()
//                                         //     .selectedDropdownFirmName
//                                         //     .value = '';
//                                         // Get.find<AccountLedgerController>()
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
//                                         Utils.closeKeyboard(Get.context!);
//                                         Get.find<AccountLedgerController>()
//                                             .mainList
//                                             .value
//                                             .data
//                                             ?.clear();
//                                         Get.find<AccountLedgerController>()
//                                             .searchList
//                                             .clear();
//                                         Get.find<AccountLedgerController>()
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
//                   // if (controller.selectedDropdownFirmCode.isNotEmpty)
//                   // if((reportFilter?.selectedFirmCode.value
//                   //     ?? controller.selectedDropdownFirmCode.value)
//                   //     .isNotEmpty)
//                   //   CommonAppInput(
//                   //     textInputAction: TextInputAction.done,
//                   //     textEditingController:
//                   //         controller.searchGroupController.value,
//                   //     //prifixIcon: Icons.search,
//                   //     suffixIcon:
//                   //         controller.searchQuery.value.isNotEmpty
//                   //             ? Icons.close
//                   //             : null,
//                   //     hintText: "Search here.. (i.e, Bill No, Account Name)",
//                   //     maxLength: 40,
//                   //     focusNode: controller.searchGroupFocus,
//                   //     onChanged: (text) {
//                   //       controller.searchQuery.value =
//                   //           text; // Update the search query
//                   //       //controller.filterData(); // Restore the original data
//                   //       controller.filterData();
//                   //
//                   //       //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
//                   //     },
//                   //     onSuffixClick: () {
//                   //       controller.searchGroupController.value.clear();
//                   //       Utils.closeKeyboard(context);
//                   //       controller.searchQuery.value = '';
//                   //       //controller.filterData(); // Restore the original data
//                   //       controller.filterData();
//                   //
//                   //       //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
//                   //     },
//                   //   ),
//                   // // if (controller.selectedDropdownFirmCode.isNotEmpty)
//                   // if((reportFilter?.selectedFirmCode.value
//                   //     ?? controller.selectedDropdownFirmCode.value)
//                   //     .isNotEmpty)
//                   //   const SizedBox(height: 10),
//
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
//                                     //     formattedDate;
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
//
//                   //Expanded(child: _getView(context)),
//                   Expanded(
//                     child:
//                         // controller.selectedDropdownFirmCode.isNotEmpty
//                     (reportFilter?.selectedFirmCode.value
//                         ?? controller.selectedDropdownFirmCode.value)
//                         .isNotEmpty
//                             ? _getView(context)
//                             : Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.info_outline,),
//                                   CommonText(
//                                     text: ' Please Select Distributor first',
//                                     fontSize: AppDimensions.fontSizeLarge,
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
//           // final totalCLAmount = cartData.fold<double>(
//           //   0,
//           //       (sum, item) =>
//           //   sum + (double.tryParse(item.cLBAL?.toString() ?? '0') ?? 0.0),
//           // );
//
//           final totalCRAmount = cartData.fold<double>(
//             0,
//             (sum, item) =>
//                 sum + (double.tryParse(item.cRAMT?.toString() ?? '0') ?? 0.0),
//           );
//
//           final totalDRAmount = cartData.fold<double>(
//             0,
//             (sum, item) =>
//                 sum + (double.tryParse(item.dRAMT?.toString() ?? '0') ?? 0.0),
//           );
//
//           final totalCLAmount = totalDRAmount - totalCRAmount;
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
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonText(
//                         text:
//                             'Closing Amt: ₹ ${Utils.formatIndianAmount(totalCLAmount)} ${totalCLAmount < 0 ? 'Cr' : 'Dr'}',
//                         fontWeight: AppFontWeight.w600,
//                         fontSize: AppDimensions.fontSizeRegular,
//                         color: totalCLAmount < 0 ? Colors.green : Colors.red,
//                       ),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: CommonText(
//                               text:
//                                   'CR Amt: ₹ ${Utils.formatIndianAmount(totalCRAmount)} Cr',
//                               fontWeight: AppFontWeight.w600,
//                               fontSize: AppDimensions.fontSizeRegular,
//                             ),
//                           ),
//                           CommonText(
//                             text: '|',
//                             fontWeight: AppFontWeight.w600,
//                             fontSize: AppDimensions.fontSizeRegular,
//                             color: Colors.red,
//                           ),
//                           Expanded(
//                             child: CommonText(
//                               text:
//                                   'DR Amt: ₹ ${Utils.formatIndianAmount(totalDRAmount)} Dr',
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
//         String creditAmount =
//             ledgers.cRAMT != null
//                 ? Utils.formatIndianAmount(
//                   double.parse(ledgers.cRAMT?.toString() ?? '0'),
//                 ) // Ensure positive values for formatting
//                 : "0.00";
//
//         String debitAmount =
//             ledgers.dRAMT != null
//                 ? Utils.formatIndianAmount(
//                   double.parse(ledgers.dRAMT?.toString() ?? '0'),
//                 ) // Ensuring positive values for formatting
//                 : "0.00";
//
//         String closeAmount =
//             ledgers.cLBAL != null
//                 ? Utils.formatIndianAmount(
//                   double.parse(ledgers.cLBAL?.toString() ?? '0'),
//                 ) // Ensuring positive values for formatting
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
//               children: [
//                 Row(
//                   children: [
//                     Expanded(child: CommonText(text: 'BK: ${ledgers.bOOKCD}')),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(text: 'Vouch Dt: ${ledgers.vOUCHDT}'),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(text: 'Bill No: ${ledgers.bILLNO}'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: CommonText(text: 'Cr Amt : ₹$creditAmount'),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(child: CommonText(text: 'Dr Amt : ₹$debitAmount')),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: CommonText(text: 'Closing BL : ₹$closeAmount'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 CommonText(text: 'ACC Name : ${ledgers.aCCNAME}'),
//                 const SizedBox(height: 4),
//                 CommonText(text: 'Narration : ${ledgers.nARRATION}'),
//
//                 //if (index != 0)
//                 if (ledgers.bOOKCD != 'OP' && ledgers.bOOKCD != 'CO')
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: CommonTextButton(
//                       title: 'View Details',
//                       onPressed: () {
//                         if (ledgers.bOOKCD! == 'RC' ||
//                             ledgers.bOOKCD! == 'PY' ||
//                             //accounts.bOOKCD! == 'PU' ||
//                             ledgers.bOOKCD! == 'EP' ||
//                             ledgers.bOOKCD! == 'IC' ||
//                             ledgers.bOOKCD! == 'JV') {
//                           controller.fetchExpandPaymentWithVouch(
//                             'full',
//                             ledgers.bOOKCD!,
//                             ledgers.vOUCHDT!.isNotEmpty
//                                 ? AppDatePicker.convertDateTimeFormat(
//                                   ledgers.vOUCHDT!,
//                                   'dd-MM-yyyy',
//                                   'yyyy-MM-dd',
//                                 )
//                                 : AppDatePicker.currentYYYYMMDDDate(),
//                             ledgers.pARTYCD!,
//                             ledgers.vOUCHNO.toString(),
//                           );
//                         } else {
//                           controller.fetchExpandPaymentWithoutVouch(
//                             'full',
//                             ledgers.bOOKCD!,
//                             ledgers.vOUCHDT!.isNotEmpty
//                                 ? AppDatePicker.convertDateTimeFormat(
//                                   ledgers.vOUCHDT!,
//                                   'dd-MM-yyyy',
//                                   'yyyy-MM-dd',
//                                 )
//                                 : AppDatePicker.currentYYYYMMDDDate(),
//                             ledgers.pARTYCD!,
//                             ledgers.vOUCHNO.toString(),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//
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
//                 //         ledgers.vOUCHNO.toString(),
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
//                 //         ledgers.vOUCHNO.toString(),
//                 //       );
//                 //     }
//                 //   },
//                 //   child: Text(
//                 //     'View Details',
//                 //     style: TextStyle(color: Colors.teal, fontSize: 12),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // ignore: unused_element
//   Widget _listUI1(BuildContext context) {
//     final data = controller.mainList.value.data;
//
//     if (data == null || data.length <= 1) {
//       return Center(child: CommonText(text: "No records found after index 0."));
//     }
//
//     return ListView.builder(
//       itemCount: data.length - 1, // Skip first item
//       itemBuilder: (context, index) {
//         // Start from index 1
//         final ledgers = data[index + 1];
//
//         // Your existing rendering logic here...
//
//         String creditAmount =
//             ledgers.cRAMT != null
//                 ? Utils.formatIndianAmount(
//                   double.parse(ledgers.cRAMT?.toString() ?? '0'),
//                 )
//                 : "0.00";
//
//         String debitAmount =
//             ledgers.dRAMT != null
//                 ? Utils.formatIndianAmount(
//                   double.parse(ledgers.dRAMT?.toString() ?? '0'),
//                 )
//                 : "0.00";
//
//         String closeAmount =
//             ledgers.cLBAL != null
//                 ? Utils.formatIndianAmount(
//                   double.parse(ledgers.cLBAL?.toString() ?? '0'),
//                 )
//                 : "0.00";
//
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//           elevation: 1,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // your row & detail rendering...
//                 Row(
//                   children: [
//                     Expanded(child: CommonText(text: 'BK: ${ledgers.bOOKCD}')),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(text: 'Vouch Dt: ${ledgers.vOUCHDT}'),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       flex: 2,
//                       child: CommonText(text: 'Bill No: ${ledgers.bILLNO}'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CommonText(text: 'Cr Amt : ₹$creditAmount'),
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(child: CommonText(text: 'Dr Amt : ₹$debitAmount')),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: CommonText(text: 'Closing BL : ₹$closeAmount'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 CommonText(text: 'ACC Name : ${ledgers.aCCNAME}'),
//                 const SizedBox(height: 4),
//                 CommonText(text: 'Narration : ${ledgers.nARRATION}'),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: CommonTextButton(
//                     title: 'View Details',
//                     onPressed: () {
//                       final formattedDate =
//                           ledgers.vOUCHDT!.isNotEmpty
//                               ? AppDatePicker.convertDateTimeFormat(
//                                 ledgers.vOUCHDT!,
//                                 'dd-MM-yyyy',
//                                 'yyyy-MM-dd',
//                               )
//                               : AppDatePicker.currentYYYYMMDDDate();
//
//                       if ([
//                         'RC',
//                         'PY',
//                         'EP',
//                         'IC',
//                         'JV',
//                       ].contains(ledgers.bOOKCD)) {
//                         controller.fetchExpandPaymentWithVouch(
//                           'full',
//                           ledgers.bOOKCD!,
//                           formattedDate,
//                           ledgers.pARTYCD!,
//                           ledgers.vOUCHNO.toString(),
//                         );
//                       } else {
//                         controller.fetchExpandPaymentWithoutVouch(
//                           'full',
//                           ledgers.bOOKCD!,
//                           formattedDate,
//                           ledgers.pARTYCD!,
//                           ledgers.vOUCHNO.toString(),
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
