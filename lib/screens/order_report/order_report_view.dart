import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/order_report/order_report_controller.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_bar.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_date_picker.dart';
import 'package:arham_b2c/widgets/common_no_message.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:arham_b2c/widgets/common_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/app_hints.dart';
import '../order_details/order_details_view.dart';

class OrderReportView extends StatelessWidget {
  OrderReportView({super.key}){
    _startHintTimer();
  }

  final OrderReportController controller = Get.put(OrderReportController());

  void _startHintTimer() {
    Future.delayed(const Duration(seconds: 6), () {
      if (!AppHints.reportsFilterHintShown.value) {
        _fadeOutHint();
      }
    });
  }
  void _fadeOutHint() {
    AppHints.reportsHintOpacity.value = 0.0;

    Future.delayed(const Duration(milliseconds: 400), () {
      AppHints.reportsFilterHintShown.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;



    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        return;
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: 'Order Report',
          actions: [
            IconButton(
              onPressed: (){
                controller.isFilterVisible.toggle();
              },
              icon: Icon(CupertinoIcons.slider_horizontal_3),
              tooltip: 'Filter',
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Obx(
                    () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Obx(() => AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        child: controller.isFilterVisible.value
                            ? Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                // Expanded(
                                //   child: InkWell(
                                //     onTap: () async {
                                //       Utils.closeKeyboard(context);
                                //       DateTime? selectedDate =
                                //           await AppDatePicker.allDateEnable(
                                //             context,
                                //             controller.fromDateController.value,
                                //           );
                                //
                                //       if (selectedDate != null &&
                                //           controller
                                //               .selectedDropdownFirmCode
                                //               .isNotEmpty) {
                                //         String formattedDate = AppDatePicker.formatDate(
                                //           selectedDate,
                                //         );
                                //         //if (controller.toDateController.value.text != formattedDate) {
                                //         controller.fromDateController.value.text =
                                //             formattedDate;
                                //         controller
                                //             .fetchOrder(); // API call only after date change
                                //         //}
                                //       }
                                //     },
                                //     child: CommonAppInput(
                                //       textEditingController:
                                //           controller.fromDateController.value,
                                //       hintText: "From Date",
                                //       suffixIcon: Icons.calendar_month,
                                //       focusNode: controller.fromDtFocus,
                                //       // labelStyle: const TextStyle(
                                //       //   color:
                                //       //       AppColors
                                //       //           .colorDarkGray, // Label color changed to gray
                                //       // ),
                                //       // hintStyle: const TextStyle(
                                //       //   color:
                                //       //       AppColors
                                //       //           .colorBlack, // Hint color changed to black
                                //       // ),
                                //       isDateField: true,
                                //       isEnable: false,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(width: 16),
                                // Expanded(
                                //   child: InkWell(
                                //     onTap: () async {
                                //       Utils.closeKeyboard(context);
                                //       DateTime? selectedDate =
                                //           await AppDatePicker.allDateEnable(
                                //             context,
                                //             controller.toDateController.value,
                                //           );
                                //
                                //       if (selectedDate != null &&
                                //           controller
                                //               .selectedDropdownFirmCode
                                //               .isNotEmpty) {
                                //         String formattedDate = AppDatePicker.formatDate(
                                //           selectedDate,
                                //         );
                                //         //if (controller.toDateController.value.text != formattedDate) {
                                //         controller.toDateController.value.text =
                                //             formattedDate;
                                //         controller.fetchOrder();
                                //       }
                                //     },
                                //     child: CommonAppInput(
                                //       textEditingController:
                                //           controller.toDateController.value,
                                //       hintText: "To Date",
                                //       suffixIcon: Icons.calendar_month,
                                //       focusNode: controller.toDtFocus,
                                //       // labelStyle: const TextStyle(
                                //       //   color:
                                //       //       AppColors
                                //       //           .colorDarkGray, // Label color changed to gray
                                //       // ),
                                //       // hintStyle: const TextStyle(
                                //       //   color:
                                //       //       AppColors
                                //       //           .colorBlack, // Hint color changed to black
                                //       // ),
                                //       isDateField: true,
                                //       isEnable: false,
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: CommonDatePickerInput(
                                    controller: controller.fromDateController.value,
                                    hintText: "From Date",
                                    isEnabled:
                                    // controller.selectedDropdownFirmCode.isNotEmpty,
                                    true,
                                    onTap: () async {
                                      final selectedDate =
                                      await AppDatePicker.allDateEnable(
                                        context,
                                        controller.fromDateController.value,
                                      );
                                      if (selectedDate != null) {
                                        controller.fromDateController.value.text =
                                            AppDatePicker.formatDate(selectedDate);
                                        controller.fetchOrder();
                                      }
                                    },
                                    // enabledBorderColor: Colors.teal,
                                    // disabledBorderColor: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CommonDatePickerInput(
                                    controller: controller.toDateController.value,
                                    hintText: "To Date",
                                    isEnabled:
                                    // controller.selectedDropdownFirmCode.isNotEmpty,
                                    true,
                                    onTap: () async {
                                      Utils.closeKeyboard(context);
                                      DateTime? selectedDate =
                                      await AppDatePicker.allDateEnable(
                                        context,
                                        controller.toDateController.value,
                                      );

                                      if (selectedDate != null) {
                                        String formattedDate = AppDatePicker.formatDate(
                                          selectedDate,
                                        );
                                        //if (controller.toDateController.value.text != formattedDate) {
                                        controller.toDateController.value.text =
                                            formattedDate;
                                        controller.fetchOrder();
                                      }
                                    },
                                    // enabledBorderColor: Colors.teal,
                                    // disabledBorderColor: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            controller.isDropdownFirmLoading.isTrue
                                ? Center(child: Utils.commonCircularProgress())
                                : (controller.firmList.value.data == null ||
                                controller.firmList.value.data!.isEmpty)
                                ? Container()
                                : TypeAheadField<FirmModel>(
                              controller: controller.firmController.value,
                              focusNode: controller.firmFocus,
                              suggestionsCallback: (pattern) async {
                                return controller.firmList.value.data?.where((item) {
                                  return item.firmName
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase());
                                }).toList();
                              },
                              itemBuilder: (context, FirmModel suggestion) {
                                return ListTile(
                                  visualDensity: const VisualDensity(
                                    horizontal: -2.0,
                                    vertical: -4.0,
                                  ),
                                  title: CommonText(
                                    text:
                                    suggestion.mobile1 != null &&
                                        suggestion.mobile1!.trim().isNotEmpty
                                        ? "${suggestion.firmName.trim()} | ${suggestion.mobile1!.trim()}"
                                        : suggestion.firmName.trim(),
                                    fontWeight: AppFontWeight.w400,
                                    fontSize: 14,
                                  ),
                                );
                              },
                              onSelected: (FirmModel selectedItem) {
                                controller.selectedDropdownFirm.value = selectedItem;
                                controller.selectedDropdownFirmCode.value =
                                    selectedItem.syncId.toString().trim();
                                controller.firmController.value.text =
                                    selectedItem.firmName.trim();
                                Utils.closeKeyboard(Get.context!);
                                controller.firmFocus.unfocus();

                                controller.fetchOrder();

                                // controller.isFilterVisible.toggle();
                              },
                              builder: (context, controller, focusNode) {
                                final orderReportController = Get.put(OrderReportController());
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    counter: const Offstage(),
                                    // suffixIconConstraints: const BoxConstraints(
                                    //   minWidth: 16,
                                    //   minHeight: 39,
                                    // ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              controller.clear();
                                              Get.find<OrderReportController>()
                                                  .firmFocus
                                                  .unfocus();
                                              Get.find<OrderReportController>()
                                                  .selectedDropdownFirm
                                                  .value = null;
                                              Get.find<OrderReportController>()
                                                  .selectedDropdownFirmName
                                                  .value = '';
                                              Get.find<OrderReportController>()
                                                  .selectedDropdownFirmCode
                                                  .value = '';
                                              Utils.closeKeyboard(Get.context!);
                                              Get.find<OrderReportController>()
                                                  .mainList
                                                  .value
                                                  .data
                                                  ?.clear();
                                              Get.find<OrderReportController>()
                                                  .searchList
                                                  .clear();
                                              Get.find<OrderReportController>()
                                                  .mainList
                                                  .refresh();
                                              // Get.find<OrderReportController>()
                                              //     .fetchPayment();

                                              Get.find<OrderReportController>()
                                                  .status
                                                  .value = 'A';
                                              Get.find<OrderReportController>()
                                                  .radioCheck
                                                  .value = 1;

                                              Get.find<OrderReportController>().fetchOrder();
                                              // orderReportController.isFilterVisible.toggle();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.close, size: 20),
                                            ),
                                          ),
                                          const Icon(
                                            size: 20,
                                            Icons.keyboard_arrow_down,
                                          ),
                                        ],
                                      ),
                                    ),
                                    labelText: 'Select Distributor',
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: colorScheme.outline,
                                        // Default themed outline color
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: colorScheme.primary,
                                        // Highlight color when focused
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                );
                              },
                            ),

                            //TODO : Status Check
                            // if (controller.selectedDropdownFirmCode.isNotEmpty)
                            //   Visibility(
                            //     visible: false,
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         Radio<String>(
                            //           value: 'A',
                            //           groupValue: controller.status.value,
                            //           onChanged: (String? value) {
                            //             if (value != null) {
                            //               controller.status.value = value;
                            //               controller.radioCheck.value = 1;
                            //               controller.fetchOrder();
                            //             }
                            //           },
                            //         ),
                            //         CommonText(
                            //           text: "All",
                            //           fontSize: AppDimensions.fontSizeSmall,
                            //           fontWeight: AppFontWeight.w400,
                            //         ),
                            //         Radio<String>(
                            //           value: 'P',
                            //           groupValue: controller.status.value,
                            //           onChanged: (String? value) {
                            //             if (value != null) {
                            //               controller.status.value = value;
                            //               controller.radioCheck.value = 2;
                            //               controller.fetchOrder();
                            //             }
                            //           },
                            //         ),
                            //         CommonText(
                            //           text: "Pending",
                            //           fontSize: AppDimensions.fontSizeSmall,
                            //           fontWeight: AppFontWeight.w400,
                            //         ),
                            //         Radio<String>(
                            //           value: 'R',
                            //           groupValue: controller.status.value,
                            //           onChanged: (String? value) {
                            //             if (value != null) {
                            //               controller.status.value = value;
                            //               controller.radioCheck.value = 3;
                            //               controller.fetchOrder();
                            //             }
                            //           },
                            //         ),
                            //         CommonText(
                            //           text: "Received",
                            //           fontSize: AppDimensions.fontSizeSmall,
                            //           fontWeight: AppFontWeight.w400,
                            //         ),
                            //         Radio<String>(
                            //           value: 'C',
                            //           groupValue: controller.status.value,
                            //           onChanged: (String? value) {
                            //             if (value != null) {
                            //               controller.status.value = value;
                            //               controller.radioCheck.value = 4;
                            //               controller.fetchOrder();
                            //             }
                            //           },
                            //         ),
                            //         CommonText(
                            //           text: "Completed",
                            //           fontSize: AppDimensions.fontSizeSmall,
                            //           fontWeight: AppFontWeight.w400,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //if (controller.selectedDropdownFirmCode.isNotEmpty)

                          ],
                        )
                            : SizedBox.shrink(),
                      )),

                      // Expanded(
                      //   child:
                      //       controller.selectedDropdownFirmCode.isNotEmpty
                      //           ? _getView(context)
                      //           : Center(
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Icon(Icons.info_outline, color: Colors.red,),
                      //                 CommonText(
                      //                   text: ' Please Select Distributor first',
                      //                   fontSize: AppDimensions.fontSizeLarge,
                      //                   color: Colors.red,
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      // ),

                      Visibility(
                        visible: true,
                        child: Obx(
                              () => RadioGroup<String>(
                            groupValue: controller.status.value,
                            onChanged: (value) {
                              if (value != null) {
                                controller.status.value = value;

                                // Map the radio value to radioCheck
                                switch (value) {
                                  case 'A':
                                    controller.radioCheck.value = 1;
                                    break;
                                  case 'P':
                                    controller.radioCheck.value = 2;
                                    break;
                                  case 'R':
                                    controller.radioCheck.value = 3;
                                    break;
                                  case 'C':
                                    controller.radioCheck.value = 4;
                                    break;
                                }

                                controller.fetchOrder();
                              }
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio<String>(value: 'A'),
                                  CommonText(
                                    text: "All",
                                    fontSize: AppDimensions.fontSizeSmall,
                                    fontWeight: AppFontWeight.w400,
                                  ),
                                  Radio<String>(value: 'P'),
                                  CommonText(
                                    text: "Pending",
                                    fontSize: AppDimensions.fontSizeSmall,
                                    fontWeight: AppFontWeight.w400,
                                  ),
                                  Radio<String>(value: 'R'),
                                  CommonText(
                                    text: "Received",
                                    fontSize: AppDimensions.fontSizeSmall,
                                    fontWeight: AppFontWeight.w400,
                                  ),
                                  Radio<String>(value: 'C'),
                                  CommonText(
                                    text: "Completed",
                                    fontSize: AppDimensions.fontSizeSmall,
                                    fontWeight: AppFontWeight.w400,
                                  ),
                                ],
                              ),
                            ),

                            // child: Wrap(
                            //   // spacing: 8,
                            //   // runSpacing: 8,
                            //   crossAxisAlignment: WrapCrossAlignment.start,
                            //   alignment: WrapAlignment.start,
                            //   children: [
                            //     Row(mainAxisSize: MainAxisSize.min, children: [
                            //       Radio<String>(value: 'A'),
                            //       CommonText(text: "All"),
                            //     ]),
                            //     Row(mainAxisSize: MainAxisSize.min, children: [
                            //       Radio<String>(value: 'P'),
                            //       CommonText(text: "Pending"),
                            //     ]),
                            //     Row(mainAxisSize: MainAxisSize.min, children: [
                            //       Radio<String>(value: 'R'),
                            //       CommonText(text: "Received"),
                            //     ]),
                            //     Row(mainAxisSize: MainAxisSize.min, children: [
                            //       Radio<String>(value: 'C'),
                            //       CommonText(text: "Completed"),
                            //     ]),
                            //   ],
                            // ),

                            // child: Row(
                            //   children: [
                            //     Expanded(child: _radioItem('A', "All")),
                            //     Expanded(child: _radioItem('P', "Pending")),
                            //     Expanded(child: _radioItem('R', "Received")),
                            //     Expanded(child: _radioItem('C', "Completed")),
                            //   ],
                            // ),
                          ),
                        ),
                      ),

                      //const SizedBox(height: 16),
                      //if (controller.selectedDropdownFirmCode.isNotEmpty)
                      CommonAppInput(
                        textInputAction: TextInputAction.done,
                        textEditingController:
                        controller.searchGroupController.value,
                        //prifixIcon: Icons.search,
                        suffixIcon:
                        controller.searchQuery.value.isNotEmpty
                            ? Icons.close
                            : null,
                        hintText: "Search here.. (i.e, Bill No, Account Name)",
                        maxLength: 40,
                        focusNode: controller.searchGroupFocus,
                        onChanged: (text) {
                          controller.searchQuery.value =
                              text; // Update the search query
                          //controller.filterData(); // Restore the original data
                          controller.filterData();

                          //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
                        },
                        onSuffixClick: () {
                          controller.searchGroupController.value.clear();
                          Utils.closeKeyboard(context);
                          controller.searchQuery.value = '';
                          //controller.filterData(); // Restore the original data
                          controller.filterData();
                          //controller.onTabSelected(controller.selectedSort.value); // Trigger filtering
                        },
                      ),
                      //if (controller.selectedDropdownFirmCode.isNotEmpty)
                      const SizedBox(height: 10),
                      Expanded(child: _getView(context)),
                    ],
                  ),
                ),
              ),
            ),

            Obx(() {
              if (AppHints.reportsFilterHintShown.value) {
                return const SizedBox.shrink();
              }

              return Positioned(
                top: 0,                    // below app bar + safe area
                right: 5,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  opacity: AppHints.reportsHintOpacity.value,
                  child: SimpleFilterHintBubble(
                    onClose: () {
                      _fadeOutHint();
                    },
                  ),
                ),
              );
            }),
          ],
        ),
        bottomNavigationBar: Obx(() {
          final cartData = controller.mainList.value.data ?? [];

          if (cartData.isEmpty) return const SizedBox.shrink();

          final totalOrderAmount = cartData.fold<double>(
            0,
            (sum, item) =>
                sum + (double.tryParse(item.oRAMT?.toString() ?? '0') ?? 0.0),
          );

          // final totalNetAmount = cartData.fold<double>(
          //   0,
          //   (sum, item) =>
          //       sum + (double.tryParse(item.nETAMT?.toString() ?? '0') ?? 0.0),
          // );

          final Set<String> seenBillNumbers = {};

          final totalNetAmount = cartData.fold<double>(0, (sum, item) {
            final billNo = item.bILLNO?.toString() ?? '';
            final netAmt =
                double.tryParse(item.nETAMT?.toString() ?? '0') ?? 0.0;

            if (!seenBillNumbers.contains(billNo)) {
              seenBillNumbers.add(billNo);
              return sum + netAmt;
            } else {
              return sum; // Already counted this billNo
            }
          });

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CommonText(
                              text:
                                  'Total Order Amt: ₹ ${Utils.formatIndianAmount(controller.mainList.value.grandTotal)}',
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
                              textAlign: TextAlign.end,
                              text:
                                  'Total Bill Amt: ₹ ${Utils.formatIndianAmount(totalNetAmount)}',
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
      ),
    );
  }

  // ignore: unused_element
  Widget _radioItem
      (String value, String label) {
    return Row(
      children: [
        Radio<String>(value: value),
        CommonText(text: label),
      ],
    );
  }

  Widget _getView(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Utils.buildShimmerList();   // full screen shimmer for first load
      }

      if (controller.mainList.value.data == null ||
          controller.mainList.value.data!.isEmpty) {
        return CommonNoMessage(
          searchQuery: controller.searchQuery.value,
          errorMessage: controller.errorMsg.value,
        );
      }

      return _listUI(context);
    });
  }
  // Widget _getView(BuildContext context) {
  //   return controller.isLoading.isTrue
  //       ? Utils.buildShimmerList()
  //       : (controller.mainList.value.data == null ||
  //           controller.mainList.value.data!.isEmpty)
  //       ? CommonNoMessage(
  //         searchQuery: controller.searchQuery.value,
  //         errorMessage: controller.errorMsg.value,
  //       )
  //       : _listUI(context);
  // }

  Widget _listUI(BuildContext context) {
    int itemCount = controller.mainList.value.data!.length;

    return ListView.builder(
      controller: controller.scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      // itemCount: controller.mainList.value.data!.length,
      //itemCount: controller.isLoadMore.isTrue ? itemCount + 1 : itemCount,
      itemCount: itemCount + (controller.isPageLoading.value ? 1 : 0),
      itemBuilder: (context, index) {

        // Show loading indicator at the very bottom
        // if (index == itemCount) {
        //   return Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Center(child: Utils.commonCircularProgress()), // Or a standard CircularProgressIndicator()
        //   );
        // }

        if (index == itemCount) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: controller.isPageLoading.value
                  ? Utils.commonCircularProgress()
                  : CommonText(
                text: "You've reached the end",
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          );
        }

        final ledgers = controller.mainList.value.data![index];

        String orderAmt =
            ledgers.oRAMT != null
                ? Utils.formatIndianAmount(
                  double.parse(ledgers.oRAMT?.toString() ?? '0'),
                )
                : "0.00";

        String billAmt =
            ledgers.nETAMT != null
                ? Utils.formatIndianAmount(
                  double.parse(ledgers.nETAMT?.toString() ?? '0'),
                )
                : "0.00";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 1,
          shadowColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white60
              : Colors.grey[850],
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]!
                  : Colors.grey[50]!,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align content to the left
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: 'Order #${ledgers.oId}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xff00075a),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Expanded(
                      //   flex: 1,
                      //   // child: CommonText(text: 'Date: ${ledgers.vOUCHDT}'),
                      //   child: Text.rich(
                      //     TextSpan(
                      //         children: [
                      //           TextSpan(text: 'Date:', style: TextStyle(fontWeight: FontWeight.bold),),
                      //           TextSpan(text: ' ${ledgers.vOUCHDT}',),
                      //         ]
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(width: 4),
                      Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text: 'Amt:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: Color(0xff00075a),
                                ),
                              ),
                              TextSpan(text: ' ₹$orderAmt',),
                            ]
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CommonText(text: '${ledgers.pARTYNAME.toString().capitalize}', fontWeight: FontWeight.bold,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   child: Text.rich(
                      //     TextSpan(
                      //       children: [
                      //         TextSpan(text: 'Bill No:', style: TextStyle(fontWeight: FontWeight.bold),),
                      //         TextSpan(text: ' ${ledgers.bILLNO}',),
                      //       ]
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(width: 4),
                      // Expanded(
                      //   flex: 1,
                      //   // child: CommonText(text: 'Bill Dt : ${ledgers.vOUCHDT}'),
                      //   child: Text.rich(
                      //     TextSpan(
                      //         children: [
                      //           TextSpan(text: 'Bill Dt:', style: TextStyle(fontWeight: FontWeight.bold),),
                      //           TextSpan(text: ' ${ledgers.vOUCHDT}',),
                      //         ]
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(width: 4),
                      // Expanded(
                      //   flex: 1,
                      //   child: CommonText(text: 'Bill Amt : ₹$billAmt'),
                      // ),
                      Expanded(
                        flex: 1,
                        // child: CommonText(text: 'Date: ${ledgers.vOUCHDT}'),
                        child: Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Date:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // color: Color(0xff00075a),
                                  ),
                                ),
                                TextSpan(text: ' ${ledgers.vOUCHDT}',),
                              ]
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //controller.showBottomSheetDialogExpandPaymentWithoutVocuhNo(Get.context!);

                          // controller
                          //     .showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(
                          //       Get.context!,
                          //       ledgers.ordritms!,
                          //     );
                          Get.to(
                                () => OrderDetailsView(
                              orderNo: ledgers.oId,
                              billNo: ledgers.bILLNO,
                              billDate: ledgers.vOUCHDT,
                              orderAmount: ledgers.oRAMT,
                              netAmount: ledgers.nETAMT,
                              orderItems: ledgers.ordritms ?? [],
                                  partyName: ledgers.pARTYNAME,
                                  mobile1: ledgers.mOBILE1,
                            ),
                            transition: Transition.rightToLeftWithFade
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonText(text: "View Details", color: Theme.of(context).colorScheme.primary, fontSize: 13, fontWeight: AppFontWeight.w700,),
                            SizedBox(width: 4,),
                            Icon(Icons.arrow_forward_ios, size: 12, color: Theme.of(context).colorScheme.primary,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (ledgers.nARRATION!.isNotEmpty)
                    CommonText(text: 'Remarks : ${ledgers.nARRATION}'),
                  const SizedBox(height: 4),

                  // CommonText(text: 'Party Name : ${''}'),
                  // const SizedBox(height: 4),
                  // CommonText(text: 'User : ${''}'),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   // child: CommonTextButton(
                  //   //   title: 'View Details',
                  //   //   onPressed: () {
                  //   //     //controller.showBottomSheetDialogExpandPaymentWithoutVocuhNo(Get.context!);
                  //   //     controller
                  //   //         .showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(
                  //   //           Get.context!,
                  //   //           ledgers.ordritms!,
                  //   //         );
                  //   //   },
                  //   // ),
                  //   child: GestureDetector(
                  //       onTap: () {
                  //         //controller.showBottomSheetDialogExpandPaymentWithoutVocuhNo(Get.context!);
                  //
                  //         // controller
                  //         //     .showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(
                  //         //       Get.context!,
                  //         //       ledgers.ordritms!,
                  //         //     );
                  //         Get.to(
                  //               () => OrderDetailsView(
                  //                 orderNo: ledgers.oId,
                  //                 billNo: ledgers.bILLNO,
                  //                 billDate: ledgers.vOUCHDT,
                  //                 orderAmount: ledgers.oRAMT,
                  //                 netAmount: ledgers.nETAMT,
                  //                 orderItems: ledgers.ordritms ?? [],
                  //           ),
                  //         );
                  //       },
                  //     child: Container(
                  //       width: 120,
                  //       padding: EdgeInsets.symmetric(vertical: 5),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(5),
                  //         color: Colors.blue[100]
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Icon(Icons.info_outline, size: 17,),
                  //           CommonText(text: " View Details"),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //     padding: EdgeInsets.zero, // Remove default padding
                  //   ),
                  //   onPressed: () {
                  //     //controller.showBottomSheetDialogExpandPaymentWithoutVocuhNo(Get.context!);
                  //     controller
                  //         .showBottomSheetDialogExpandPaymentWithoutVocuhNoTable(
                  //           Get.context!,
                  //           ledgers.ordritms!,
                  //         );
                  //   },
                  //   child: Text(
                  //     'View Details',
                  //     style: TextStyle(color: AppColors.teal, fontSize: 12),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}




class AppHints {
  static final reportsFilterHintShown = false.obs;
  static final reportsHintOpacity = 1.0.obs;
}

const double bubbleWidth = 320.0;
class FilterHintBubble extends StatelessWidget {
  final VoidCallback onClose;
  final double arrowLeft; // 👈 dynamic horizontal position

  const FilterHintBubble({
    required this.onClose,
    required this.arrowLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Stack(
        clipBehavior: Clip.none,
        children: [
          // Bubble
          Container(
            width: bubbleWidth,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF004881),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonText(
                    text:
                    "Showing last 7 days' orders. Use date filter to view older orders.",
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Triangle (positioned manually)
          Positioned(
            top: 0,
            left: arrowLeft,
            child: CustomPaint(
              size: const Size(20, 10),
              painter: TrianglePainter(Color(0xFF004881)),
            ),
          ),
        ],
      );
    });
  }
}


class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



class SimpleFilterHintBubble extends StatelessWidget {
  final VoidCallback onClose;

  const SimpleFilterHintBubble({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            CustomPaint(
              size: const Size(24, 12),   // width 24, height 12
              painter: TrianglePainter(const Color(0xFF004881)),
            ),
            SizedBox(width: 10,),
          ],
        ),
        Container(
          width: 380,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF004881),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommonText(
                  text: "Showing last week's orders. Use date filter to view older orders.",
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}