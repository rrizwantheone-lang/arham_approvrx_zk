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

class OutstandingView extends StatelessWidget {
  OutstandingView({super.key});

  final ReportController controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        children: [
          Expanded(child: _getView(context)),
          Obx(() {
            final cartData = controller.outstandingMainList.value.data ?? []; // Updated

            if (cartData.isEmpty) return const SizedBox.shrink();

            final totalVouchAmount = cartData.fold<double>(
              0,
                  (sum, item) =>
              sum +
                  (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0.0),
            );
            final totalPaidAmount = cartData.fold<double>(
              0,
                  (sum, item) =>
              sum + (double.tryParse(item.pAIDAMT?.toString() ?? '0') ?? 0.0),
            );

            final totalOSAmount = cartData.fold<double>(
              0,
                  (sum, item) =>
              sum + (double.tryParse(item.oSAMT?.toString() ?? '0') ?? 0.0),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text:
                          'Bill Amt: ₹ ${Utils.formatIndianAmount(totalVouchAmount)}',
                          fontWeight: AppFontWeight.w600,
                          fontSize: AppDimensions.fontSizeRegular,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CommonText(
                                text:
                                'Paid Amt: ₹ ${Utils.formatIndianAmount(totalPaidAmount)}',
                                fontWeight: AppFontWeight.w600,
                                fontSize: AppDimensions.fontSizeRegular,
                              ),
                            ),

                            CommonText(
                              text: '|',
                              fontWeight: AppFontWeight.w600,
                              fontSize: AppDimensions.fontSizeRegular,
                              color: Colors.red,
                            ),
                            Expanded(
                              child: CommonText(
                                text:
                                'Pending Amt: ₹ ${Utils.formatIndianAmount(totalOSAmount)}',
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
        : (controller.outstandingMainList.value.data == null ||
        controller.outstandingMainList.value.data!.isEmpty)
        ? CommonNoMessage(
      searchQuery: controller.searchQuery.value,
      errorMessage: controller.errorMsg.value,
    )
        : Padding(
          padding: const EdgeInsets.all(10),
          child: _listUI(context),
        );
  }

  Widget _listUI(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Obx(
          () => ListView.builder(
        itemCount: controller.outstandingMainList.value.data!.length,
        itemBuilder: (context, index) {
          final accounts = controller.outstandingMainList.value.data![index];

          final isReceipt = accounts.bOOKCD == 'RC';

          DateTime? vouchDate =
          accounts.vOUCHDT != null && accounts.vOUCHDT!.isNotEmpty
              ? Utils.parseDate(accounts.vOUCHDT!, 'yyyy-MM-dd')
              : null;

          final fy = Utils.getFinancialYearRange();
          DateTime financialYearStart = fy['start']!;
          DateTime financialYearEnd = fy['end']!;

          bool isInCurrentFinancialYear =
              vouchDate != null &&
                  vouchDate.isAfter(
                    financialYearStart.subtract(const Duration(days: 1)),
                  ) &&
                  vouchDate.isBefore(financialYearEnd.add(const Duration(days: 1)));

          String oSAMT =
          accounts.oSAMT != null
              ? (double.parse(accounts.oSAMT.toString()) < 0
              ? Utils.formatIndianAmount(
            double.parse(accounts.oSAMT.toString()) * -1,
          )
              : Utils.formatIndianAmount(double.parse(accounts.oSAMT.toString())))
              : "0.00";

          String pAIDAMT =
          accounts.pAIDAMT != null
              ? (double.parse(accounts.pAIDAMT.toString()) < 0
              ? Utils.formatIndianAmount(
            double.parse(accounts.pAIDAMT.toString()) * -1,
          )
              : Utils.formatIndianAmount(double.parse(accounts.pAIDAMT.toString())))
              : "0.00";

          String vouchAmount =
          accounts.vOUCHAMT != null
              ? (double.parse(accounts.vOUCHAMT.toString()) < 0
              ? Utils.formatIndianAmount(
            double.parse(accounts.vOUCHAMT.toString()) * -1,
          )
              : Utils.formatIndianAmount(
            double.parse(accounts.vOUCHAMT.toString()),
          ))
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 3,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          // color:
                          // accounts.vOUCHAMT != accounts.oSAMT
                          //     ? Colors.green
                          //     : Colors.red,
                          color: isReceipt ? Colors.green : Colors.red,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: '# ${accounts.pARTYBL}',
                              fontSize: AppDimensions.fontSizeMedium,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                SizedBox(width: 2,),
                                CommonText(
                                  text: 'Inv Date: ',
                                  fontSize: AppDimensions.fontSizeSmall,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                                CommonText(
                                  text: '${AppDatePicker.convertDateTimeFormat(accounts.vOUCHDT, 'yyyy-MM-dd', 'yyyy-MM-dd')}',
                                  fontSize: AppDimensions.fontSizeSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 2,),
                                CommonText(
                                  text: 'Due Date: ',
                                  fontSize: AppDimensions.fontSizeSmall,
                                  fontWeight: FontWeight.w600,
                                ),
                                CommonText(
                                  text: '${AppDatePicker.convertDateTimeFormat(accounts.dUEDATE, 'yyyy-MM-dd', 'yyyy-MM-dd')}',
                                  //text: '${accounts.dUEDATE}',
                                  fontSize: AppDimensions.fontSizeSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // CommonText(
                                //   text: '₹$vouchAmount',
                                //   fontSize: AppDimensions.fontSizeSmall,
                                //   fontWeight: FontWeight.w600,
                                // ),
                                Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 2,),
                                Text(
                                  accounts.dUEDATE != null
                                      ? controller.calculateDueDays(
                                    AppDatePicker.convertDateTimeFormat(
                                      accounts.dUEDATE!,
                                      'yyyy-MM-dd',
                                      'yyyy-MM-dd',
                                    ),
                                  ) >=
                                      0
                                      ? '${controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'yyyy-MM-dd', 'yyyy-MM-dd'))} ${controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'dd-MM-yyyy', 'yyyy-MM-dd')) == 1 ? 'Day' : 'Days'}'
                                      : '${-controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'yyyy-MM-dd', 'yyyy-MM-dd'))} ${-controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'dd-MM-yyyy', 'yyyy-MM-dd')) == 1 ? 'Day' : 'Days'}'
                                      : 'No due date',
                                  style: TextStyle(
                                    color:
                                    accounts.dUEDATE != null
                                        ? controller.calculateDueDays(
                                      AppDatePicker.convertDateTimeFormat(
                                        accounts.dUEDATE!,
                                        'yyyy-MM-dd',
                                        'yyyy-MM-dd',
                                      ),
                                    ) >=
                                        0
                                        ? Colors.green
                                        : Colors.red
                                        : Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                // const SizedBox(width: 10),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //     vertical: 4,
                                //     horizontal: 8,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color:
                                //     accounts.vOUCHAMT != accounts.oSAMT
                                //         ? Colors.green[100]
                                //         : Colors.red[100],
                                //     borderRadius: BorderRadius.circular(
                                //       12,
                                //     ),
                                //   ),
                                //   child: Text(
                                //     accounts.vOUCHAMT != accounts.oSAMT
                                //         ? 'Partially Pending'
                                //         : 'Pending',
                                //     textAlign: TextAlign.center,
                                //     style: TextStyle(
                                //       fontSize: 12,
                                //       color:
                                //       accounts.vOUCHAMT != accounts.oSAMT
                                //           ? Colors.green
                                //           : Colors.red,
                                //       fontWeight:
                                //       FontWeight
                                //           .bold,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(width: 10,),
                                CommonText(
                                  text: 'Book: ${accounts.bOOKCD}',
                                  fontSize: 12,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: CommonText(
                              text: 'Bill: ₹$vouchAmount',
                              fontSize: AppDimensions.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 3,),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
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
                              text: 'Paid: ₹$pAIDAMT',
                              fontSize: AppDimensions.fontSizeSmall,
                              fontWeight: AppFontWeight.w700,
                              color: Colors.green[700],
                            ),
                          ),
                          SizedBox(height: 3,),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
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
                              text: 'Pending: ₹$oSAMT',
                              fontSize: AppDimensions.fontSizeSmall,
                              fontWeight: AppFontWeight.w700,
                              color: Colors.red[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Row(
                          //   mainAxisAlignment:
                          //   MainAxisAlignment.end,
                          //   children: [
                          //     Text(
                          //       accounts.dUEDATE != null
                          //           ? controller.calculateDueDays(
                          //         AppDatePicker.convertDateTimeFormat(
                          //           accounts.dUEDATE!,
                          //           'yyyy-MM-dd',
                          //           'yyyy-MM-dd',
                          //         ),
                          //       ) >=
                          //           0
                          //           ? 'Due ${controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'yyyy-MM-dd', 'yyyy-MM-dd'))} ${controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'dd-MM-yyyy', 'yyyy-MM-dd')) == 1 ? 'Day' : 'Days'}'
                          //           : 'Overdue ${-controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'yyyy-MM-dd', 'yyyy-MM-dd'))} ${-controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'dd-MM-yyyy', 'yyyy-MM-dd')) == 1 ? 'Day' : 'Days'}'
                          //           : 'No due date',
                          //       style: TextStyle(
                          //         color:
                          //         accounts.dUEDATE != null
                          //             ? controller.calculateDueDays(
                          //           AppDatePicker.convertDateTimeFormat(
                          //             accounts.dUEDATE!,
                          //             'yyyy-MM-dd',
                          //             'yyyy-MM-dd',
                          //           ),
                          //         ) >=
                          //             0
                          //             ? Colors.green
                          //             : Colors.red
                          //             : Colors.grey,
                          //         fontSize: 12,
                          //       ),
                          //     ),
                          //     const SizedBox(width: 4),
                          //     Icon(
                          //       Icons.calendar_month_outlined,
                          //       color:
                          //       controller.calculateDueDays(
                          //         AppDatePicker.convertDateTimeFormat(
                          //           accounts.dUEDATE!,
                          //           'yyyy-MM-dd',
                          //           'yyyy-MM-dd',
                          //         ),
                          //       ) >=
                          //           0
                          //           ? Colors.green
                          //           : Colors.red,
                          //       size: 16,
                          //     ),
                          //   ],
                          // ),

                          // isInCurrentFinancialYear
                          //     ? Align(
                          //   alignment: Alignment.centerRight,
                          //   child: CommonTextButton(
                          //     title: 'View Details',
                          //     onPressed: () {
                          //       // Call expand methods on controller
                          //     },
                          //   ),
                          // ).paddingOnly(top: 25)
                          //     : const SizedBox.shrink(),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: Row(
                                children: [
                                  CommonText(
                                    text: 'View Details',
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ),
                              onTap: (){
                                controller.selectedOutstandingRecord.value = accounts;
                                // Call controller methods
                                if (accounts.bOOKCD! == 'RC' ||
                                    accounts.bOOKCD! == 'PY' ||
                                    //accounts.bOOKCD! == 'PU' ||
                                    accounts.bOOKCD! == 'EP' ||
                                    accounts.bOOKCD! == 'IC' ||
                                    accounts.bOOKCD! == 'JV') {
                                  controller.fetchExpandPaymentWithVouchOutstanding(
                                    'full',
                                    accounts.bOOKCD!,
                                    accounts.vOUCHDT!.isNotEmpty
                                        ? AppDatePicker.convertDateTimeFormat(
                                      accounts.vOUCHDT!,
                                      'yyyy-MM-dd',
                                      'yyyy-MM-dd',
                                    )
                                        : AppDatePicker.currentYYYYMMDDDate(),
                                    accounts.pARTYCD!,
                                    accounts.vOUCHNO.toString(),
                                  );
                                } else {
                                  controller.fetchExpandPaymentWithoutVouchOutstanding(
                                    'full',
                                    accounts.bOOKCD!,
                                    accounts.vOUCHDT!.isNotEmpty
                                        ? AppDatePicker.convertDateTimeFormat(
                                      accounts.vOUCHDT!,
                                      'yyyy-MM-dd',
                                      'yyyy-MM-dd',
                                    )
                                        : AppDatePicker.currentYYYYMMDDDate(),
                                    accounts.pARTYCD!,
                                    accounts.vOUCHNO.toString(),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}











// import 'package:arham_b2c/app/app_date_format.dart';
// import 'package:arham_b2c/app/app_dimensions.dart';
// import 'package:arham_b2c/app/app_font_weight.dart';
// import 'package:arham_b2c/widgets/common_text_button.dart';
// import 'package:arham_b2c/models/firm_response.dart';
// import 'package:arham_b2c/screens/outstanding/outstanding_controller.dart';
// import 'package:arham_b2c/utility/utils.dart';
// import 'package:arham_b2c/widgets/common_app_input.dart';
// import 'package:arham_b2c/widgets/common_date_picker.dart';
// import 'package:arham_b2c/widgets/common_no_message.dart';
// import 'package:arham_b2c/widgets/common_text.dart';
// import 'package:arham_b2c/widgets/common_app_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
//
// import '../reports/reports_filter_controller.dart';
//
// class OutstandingView extends StatelessWidget {
//   final bool showCommonAppBar;
//   OutstandingView({super.key, this.showCommonAppBar = true});
//
//   final OutstandingController controller = Get.put(OutstandingController());
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
//           title: 'Outstanding',
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
//         // appBar: CommonAppBar(title: 'Outstanding',),
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
//                                 // controller
//                                 //     .fetchOutstanding(); // API call only after date change
//                                 final reportFilter = Get.find<ReportsFilterController>();
//                                 reportFilter.setFromDate(formattedDate);
//                                 //}
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
//                                 // controller.fetchOutstanding();
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
//                       Visibility(
//                         visible: false,
//                         child: Expanded(
//                           child: CommonDatePickerInput(
//                             controller: controller.fromDateController.value,
//                             hintText: "From Date",
//                             isEnabled:
//                                 // controller.selectedDropdownFirmCode.isNotEmpty,
//                             (reportFilter?.selectedFirmCode.value
//                                 ?? controller.selectedDropdownFirmCode.value)
//                                 .isNotEmpty,
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
//                                 // controller
//                                 //     .fetchOutstanding(); // API call only after date change
//                                 final reportFilter = Get.find<ReportsFilterController>();
//                                 reportFilter.setFromDate(formattedDate);
//                                 //}
//                               }
//                             },
//                             // enabledBorderColor: Colors.teal,
//                             // disabledBorderColor: Colors.grey.shade400,
//                           ),
//                         ),
//                       ),
//                       Visibility(
//                         visible: false,
//                         child: Expanded(
//                           child: CommonDatePickerInput(
//                             controller: controller.toDateController.value,
//                             hintText: "To Date",
//                             isEnabled:
//                             // controller.selectedDropdownFirmCode.isNotEmpty,
//                             (reportFilter?.selectedFirmCode.value
//                                 ?? controller.selectedDropdownFirmCode.value)
//                                 .isNotEmpty,
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
//                                 //if (controller.toDateController.value.text != formattedDate) {
//                                 // controller.toDateController.value.text =
//                                 //     formattedDate;
//                                 // controller.fetchOutstanding();
//                                 final reportFilter = Get.find<ReportsFilterController>();
//                                 reportFilter.setToDate(formattedDate);
//                               }
//                             },
//                             // enabledBorderColor: Colors.teal,
//                             // disabledBorderColor: Colors.grey.shade400,
//                           ),
//                         ),
//                       ),
//                     ],
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
//                         //
//                         onSelected: (FirmModel selectedItem) {
//
//                           if (reportFilter != null) {
//                             // 🔗 Shared (Reports tabs)
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
//                           controller.fetchOutstanding();
//                         },
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
//                                         // Get.find<OutstandingController>()
//                                         //     .firmFocus
//                                         //     .unfocus();
//                                         // Get.find<OutstandingController>()
//                                         //     .selectedDropdownFirm
//                                         //     .value = null;
//                                         // Get.find<OutstandingController>()
//                                         //     .selectedDropdownFirmName
//                                         //     .value = '';
//                                         // Get.find<OutstandingController>()
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
//                                         Get.find<OutstandingController>()
//                                             .mainList
//                                             .value
//                                             .data
//                                             ?.clear();
//                                         Get.find<OutstandingController>()
//                                             .searchList
//                                             .clear();
//                                         Get.find<OutstandingController>()
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
//
//                   Obx(() => AnimatedSize(
//                     duration: const Duration(milliseconds: 280),
//                     curve: Curves.easeInOut,
//                     child: reportFilter?.showFilterSection.value == true
//                         ? Column(
//                       children: [
//                         Row(
//                           children: [
//                             // Expanded(
//                             //   child: CommonDatePickerInput(
//                             //     controller: controller.fromDateController.value,
//                             //     hintText: "From Date",
//                             //     isEnabled:
//                             //     (reportFilter?.selectedFirmCode.value
//                             //         ?? controller.selectedDropdownFirmCode.value)
//                             //         .isNotEmpty,
//                             //     // controller.selectedDropdownFirmCode.isNotEmpty,
//                             //     onTap: () async {
//                             //       Utils.closeKeyboard(context);
//                             //       DateTime? selectedDate =
//                             //       await AppDatePicker.allDateEnable(
//                             //         context,
//                             //         controller.fromDateController.value,
//                             //       );
//                             //
//                             //       if (selectedDate != null &&
//                             //           controller
//                             //               .selectedDropdownFirmCode
//                             //               .isNotEmpty) {
//                             //         String formattedDate = AppDatePicker.formatDate(
//                             //           selectedDate,
//                             //         );
//                             //         //if (controller.toDateController.value.text != formattedDate) {
//                             //         // controller.fromDateController.value.text =
//                             //         //     formattedDate;
//                             //         // controller.fetchSalesRegister();
//                             //         final reportFilter = Get.find<ReportsFilterController>();
//                             //         reportFilter.setFromDate(formattedDate);
//                             //       }
//                             //     },
//                             //     // enabledBorderColor: Colors.teal,
//                             //     // disabledBorderColor: Colors.grey.shade400,
//                             //   ),
//                             // ),
//                             // const SizedBox(width: 16),
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
//           final totalVouchAmount = cartData.fold<double>(
//             0,
//             (sum, item) =>
//                 sum +
//                 (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0.0),
//           );
//
//           final totalPaidAmount = cartData.fold<double>(
//             0,
//             (sum, item) =>
//                 sum + (double.tryParse(item.pAIDAMT?.toString() ?? '0') ?? 0.0),
//           );
//
//           //final totalCLAmount = totalPaidAmount - totalVouchAmount;
//
//           final totalOSAmount = cartData.fold<double>(
//             0,
//             (sum, item) =>
//                 sum + (double.tryParse(item.oSAMT?.toString() ?? '0') ?? 0.0),
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
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonText(
//                         text:
//                             'Bill Amt: ₹ ${Utils.formatIndianAmount(totalVouchAmount)}',
//                         fontWeight: AppFontWeight.w600,
//                         fontSize: AppDimensions.fontSizeRegular,
//                       ),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: CommonText(
//                               text:
//                                   'Paid Amt: ₹ ${Utils.formatIndianAmount(totalPaidAmount)}',
//                               fontWeight: AppFontWeight.w600,
//                               fontSize: AppDimensions.fontSizeRegular,
//                             ),
//                           ),
//
//                           CommonText(
//                             text: '|',
//                             fontWeight: AppFontWeight.w600,
//                             fontSize: AppDimensions.fontSizeRegular,
//                             color: Colors.red,
//                           ),
//                           Expanded(
//                             child: CommonText(
//                               text:
//                                   'Pending Amt: ₹ ${Utils.formatIndianAmount(totalOSAmount)}',
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
//     return Obx(
//       () => ListView.builder(
//         itemCount: controller.mainList.value.data!.length,
//         itemBuilder: (context, index) {
//           final accounts = controller.mainList.value.data![index];
//
//           // Inside your widget or method
//           DateTime? vouchDate =
//               accounts.vOUCHDT != null && accounts.vOUCHDT!.isNotEmpty
//                   ? Utils.parseDate(accounts.vOUCHDT!, 'dd-MM-yyyy')
//                   : null;
//
//           // Get dynamic financial year start and end
//           final fy = Utils.getFinancialYearRange();
//           DateTime financialYearStart = fy['start']!;
//           DateTime financialYearEnd = fy['end']!;
//
//           // Check if voucher date is within financial year
//           bool isInCurrentFinancialYear =
//               vouchDate != null &&
//               vouchDate.isAfter(
//                 financialYearStart.subtract(const Duration(days: 1)),
//               ) &&
//               vouchDate.isBefore(financialYearEnd.add(const Duration(days: 1)));
//
//           // String paidAmount =
//           //     accounts.oSAMT != null
//           //         ? (double.parse(accounts.oSAMT!) < 0
//           //             ? (double.parse(accounts.oSAMT!) * -1).toStringAsFixed(2) // Handling negative values
//           //             : double.parse(
//           //               accounts.oSAMT!,
//           //             ).toStringAsFixed(2))
//           //         : "0.00";
//
//           String paidAmount =
//               accounts.oSAMT != null
//                   ? (double.parse(accounts.oSAMT.toString()) < 0
//                       ? Utils.formatIndianAmount(
//                         double.parse(accounts.oSAMT.toString()) * -1,
//                       )
//                       : Utils.formatIndianAmount(double.parse(accounts.oSAMT.toString())))
//                   : "0.00";
//
//           // String vouchAmount =
//           //     accounts.vOUCHAMT != null
//           //         ? (double.parse(accounts.vOUCHAMT!) < 0
//           //             ? (double.parse(accounts.vOUCHAMT!) * -1).toStringAsFixed(
//           //               2,
//           //             ) // Handling negative values
//           //             : double.parse(
//           //               accounts.vOUCHAMT!,
//           //             ).toStringAsFixed(2)) // Handling positive values
//           //         : "0.00";
//
//           String vouchAmount =
//               accounts.vOUCHAMT != null
//                   ? (double.parse(accounts.vOUCHAMT.toString()) < 0
//                       ? Utils.formatIndianAmount(
//                         double.parse(accounts.vOUCHAMT.toString()) * -1,
//                       ) // Handling negative values
//                       : Utils.formatIndianAmount(
//                         double.parse(accounts.vOUCHAMT.toString()),
//                       ))
//                   : "0.00";
//
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6),
//             ),
//             elevation: 1,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       // Align content to the left
//                       children: [
//                         CommonText(text: 'Bill No: ${accounts.pARTYBL}'),
//                         const SizedBox(height: 4),
//                         // Space between outst2 and invoice date
//                         CommonText(
//                           text: 'Invoice Date: ${accounts.vOUCHDT}',
//                           fontSize: AppDimensions.fontSizeSmall,
//                         ),
//                         const SizedBox(height: 4),
//                         // Space between invoice date and due date
//                         CommonText(
//                           text: 'Due Date: ${accounts.dUEDATE}',
//                           fontSize: AppDimensions.fontSizeSmall,
//                         ),
//                         const SizedBox(height: 8),
//                         // Space before amount section
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             CommonText(
//                               text: '₹$vouchAmount',
//                               fontSize: AppDimensions.fontSizeSmall,
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 4,
//                                   horizontal: 6,
//                                 ),
//                                 // Add some padding for the pill effect
//                                 decoration: BoxDecoration(
//                                   color:
//                                       accounts.vOUCHAMT != accounts.oSAMT
//                                           ? Colors.orange[100]
//                                           : Colors.red[100],
//                                   // Light background colors
//                                   borderRadius: BorderRadius.circular(
//                                     12,
//                                   ), // Rounded corners for pill shape
//                                 ),
//                                 child: Text(
//                                   accounts.vOUCHAMT != accounts.oSAMT
//                                       ? 'Partially Pending'
//                                       : 'Pending',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color:
//                                         accounts.vOUCHAMT != accounts.oSAMT
//                                             ? Colors.orange
//                                             : Colors.red,
//                                     // Text color matching the status
//                                     fontWeight:
//                                         FontWeight
//                                             .bold, // Bold to make it stand out
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         // Align(
//                         //   alignment: Alignment.centerRight,
//                         //   child: CommonTextButton(title: 'View Details', onPressed: () {
//                         //     if (accounts.bOOKCD! == 'RC' ||
//                         //         accounts.bOOKCD! == 'PY' ||
//                         //         //accounts.bOOKCD! == 'PU' ||
//                         //         accounts.bOOKCD! == 'EP' ||
//                         //         accounts.bOOKCD! == 'IC' ||
//                         //         accounts.bOOKCD! == 'JV') {
//                         //       controller.fetchExpandPaymentWithVouch(
//                         //         'full',
//                         //         accounts.bOOKCD!,
//                         //         accounts.vOUCHDT!.isNotEmpty
//                         //             ? AppDatePicker.convertDateTimeFormat(
//                         //           accounts.vOUCHDT!,
//                         //           'dd-MM-yyyy',
//                         //           'yyyy-MM-dd',
//                         //         )
//                         //             : AppDatePicker.currentYYYYMMDDDate(),
//                         //         accounts.pARTYCD!,
//                         //         accounts.vOUCHNO.toString(),
//                         //       );
//                         //     } else {
//                         //       controller.fetchExpandPaymentWithoutVouch(
//                         //         'full',
//                         //         accounts.bOOKCD!,
//                         //         accounts.vOUCHDT!.isNotEmpty
//                         //             ? AppDatePicker.convertDateTimeFormat(
//                         //           accounts.vOUCHDT!,
//                         //           'dd-MM-yyyy',
//                         //           'yyyy-MM-dd',
//                         //         )
//                         //             : AppDatePicker.currentYYYYMMDDDate(),
//                         //         accounts.pARTYCD!,
//                         //         accounts.vOUCHNO.toString(),
//                         //       );
//                         //     }
//                         //   },),
//                         // ),
//
//                         // TextButton(
//                         //   style: TextButton.styleFrom(
//                         //     padding: EdgeInsets.zero, // Remove default padding
//                         //   ),
//                         //   onPressed: () {
//                         //     if (accounts.bOOKCD! == 'RC' ||
//                         //         accounts.bOOKCD! == 'PY' ||
//                         //         //accounts.bOOKCD! == 'PU' ||
//                         //         accounts.bOOKCD! == 'EP' ||
//                         //         accounts.bOOKCD! == 'IC' ||
//                         //         accounts.bOOKCD! == 'JV') {
//                         //       controller.fetchExpandPaymentWithVouch(
//                         //         'full',
//                         //         accounts.bOOKCD!,
//                         //         accounts.vOUCHDT!.isNotEmpty
//                         //             ? AppDatePicker.convertDateTimeFormat(
//                         //               accounts.vOUCHDT!,
//                         //               'dd-MM-yyyy',
//                         //               'yyyy-MM-dd',
//                         //             )
//                         //             : AppDatePicker.currentYYYYMMDDDate(),
//                         //         accounts.pARTYCD!,
//                         //         accounts.vOUCHNO.toString(),
//                         //       );
//                         //     } else {
//                         //       controller.fetchExpandPaymentWithoutVouch(
//                         //         'full',
//                         //         accounts.bOOKCD!,
//                         //         accounts.vOUCHDT!.isNotEmpty
//                         //             ? AppDatePicker.convertDateTimeFormat(
//                         //               accounts.vOUCHDT!,
//                         //               'dd-MM-yyyy',
//                         //               'yyyy-MM-dd',
//                         //             )
//                         //             : AppDatePicker.currentYYYYMMDDDate(),
//                         //         accounts.pARTYCD!,
//                         //         accounts.vOUCHNO.toString(),
//                         //       );
//                         //     }
//                         //   },
//                         //   child: Text(
//                         //     'View Details',
//                         //     style: TextStyle(
//                         //       color: AppColors.teal,
//                         //       fontSize: 12,
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//
//                   Expanded(
//                     flex: 1, // Allows it to take half the space
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       // Align content to the right
//                       children: [
//                         CommonText(
//                           text: 'Pending: ₹$paidAmount',
//                           fontSize: AppDimensions.fontSizeSmall,
//                           fontWeight: AppFontWeight.w700,
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.end, // Align to the right
//                           children: [
//                             Text(
//                               accounts.dUEDATE != null
//                                   ? controller.calculateDueDays(
//                                             AppDatePicker.convertDateTimeFormat(
//                                               accounts.dUEDATE!,
//                                               'dd-MM-yyyy',
//                                               'yyyy-MM-dd',
//                                             ),
//                                           ) >=
//                                           0
//                                       ? 'Due ${controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'dd-MM-yyyy', 'yyyy-MM-dd'))} ${controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'dd-MM-yyyy', 'yyyy-MM-dd')) == 1 ? 'Day' : 'Days'}'
//                                       : 'Overdue ${-controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'dd-MM-yyyy', 'yyyy-MM-dd'))} ${-controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(accounts.dUEDATE!, 'dd-MM-yyyy', 'yyyy-MM-dd')) == 1 ? 'Day' : 'Days'}'
//                                   : 'No due date',
//                               style: TextStyle(
//                                 color:
//                                     accounts.dUEDATE != null
//                                         ? controller.calculateDueDays(
//                                                   AppDatePicker.convertDateTimeFormat(
//                                                     accounts.dUEDATE!,
//                                                     'dd-MM-yyyy',
//                                                     'yyyy-MM-dd',
//                                                   ),
//                                                 ) >=
//                                                 0
//                                             ? Colors.green
//                                             : Colors.red
//                                         : Colors.grey,
//                                 // default color if dueDate is null
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(width: 4),
//                             Icon(
//                               Icons.calendar_month_outlined,
//                               color:
//                                   controller.calculateDueDays(
//                                             AppDatePicker.convertDateTimeFormat(
//                                               accounts.dUEDATE!,
//                                               'dd-MM-yyyy',
//                                               'yyyy-MM-dd',
//                                             ),
//                                           ) >=
//                                           0
//                                       ? Colors.green
//                                       : Colors.red, // Matching icon color
//                               size: 16,
//                             ),
//                           ],
//                         ),
//                         isInCurrentFinancialYear
//                             ? Align(
//                               alignment: Alignment.centerRight,
//                               child: CommonTextButton(
//                                 title: 'View Details',
//                                 onPressed: () {
//                                   if (accounts.bOOKCD! == 'RC' ||
//                                       accounts.bOOKCD! == 'PY' ||
//                                       //accounts.bOOKCD! == 'PU' ||
//                                       accounts.bOOKCD! == 'EP' ||
//                                       accounts.bOOKCD! == 'IC' ||
//                                       accounts.bOOKCD! == 'JV') {
//                                     controller.fetchExpandPaymentWithVouch(
//                                       'full',
//                                       accounts.bOOKCD!,
//                                       accounts.vOUCHDT!.isNotEmpty
//                                           ? AppDatePicker.convertDateTimeFormat(
//                                             accounts.vOUCHDT!,
//                                             'dd-MM-yyyy',
//                                             'yyyy-MM-dd',
//                                           )
//                                           : AppDatePicker.currentYYYYMMDDDate(),
//                                       accounts.pARTYCD!,
//                                       accounts.vOUCHNO.toString(),
//                                     );
//                                   } else {
//                                     controller.fetchExpandPaymentWithoutVouch(
//                                       'full',
//                                       accounts.bOOKCD!,
//                                       accounts.vOUCHDT!.isNotEmpty
//                                           ? AppDatePicker.convertDateTimeFormat(
//                                             accounts.vOUCHDT!,
//                                             'dd-MM-yyyy',
//                                             'yyyy-MM-dd',
//                                           )
//                                           : AppDatePicker.currentYYYYMMDDDate(),
//                                       accounts.pARTYCD!,
//                                       accounts.vOUCHNO.toString(),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ).paddingOnly(top: 25)
//                             : const SizedBox.shrink(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
