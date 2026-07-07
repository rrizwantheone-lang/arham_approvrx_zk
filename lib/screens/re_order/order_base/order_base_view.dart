import 'dart:async';

import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/re_order/order_base/order_base_controller.dart';
import 'package:arham_b2c/screens/re_order/re_order_controller.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_date_picker.dart';
import 'package:arham_b2c/widgets/common_no_message.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class OrderBaseView extends StatelessWidget {
  OrderBaseView({super.key});

  final OrderBaseController controller = Get.put(OrderBaseController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CommonDatePickerInput(
                      controller: controller.fromDateController.value,
                      hintText: "From Date",
                      // isEnabled:
                      // controller.selectedDropdownFirmCode.isNotEmpty,
                      isEnabled: true,
                      onTap: () async {
                        Utils.closeKeyboard(context);
                        DateTime? selectedDate =
                            await AppDatePicker.allDateEnable(
                              context,
                              controller.fromDateController.value,
                            );

                        if (selectedDate != null &&
                            controller.selectedDropdownFirmCode.isNotEmpty) {
                          controller.currentPage.value = 1;
                          String formattedDate = AppDatePicker.formatDate(
                            selectedDate,
                          );
                          //if (controller.toDateController.value.text != formattedDate) {
                          controller.fromDateController.value.text =
                              formattedDate;
                          controller
                              .fetchData(); // API call only after date change
                          //}
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
                      // isEnabled:
                      // controller.selectedDropdownFirmCode.isNotEmpty,
                      isEnabled: true,
                      onTap: () async {
                        Utils.closeKeyboard(context);
                        DateTime? selectedDate =
                            await AppDatePicker.allDateEnable(
                              context,
                              controller.toDateController.value,
                            );

                        if (selectedDate != null &&
                            controller.selectedDropdownFirmCode.isNotEmpty) {
                          controller.currentPage.value = 1;
                          String formattedDate = AppDatePicker.formatDate(
                            selectedDate,
                          );
                          //if (controller.toDateController.value.text != formattedDate) {
                          controller.toDateController.value.text =
                              formattedDate;
                          controller.fetchData();
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
                      // Clear previously selected department and reload departments for the new firm
                      controller.selectedDropdownDept.value = null;
                      controller.selectedDropdownDeptName.value = '';
                      controller.selectedDropdownDeptCode.value = '';
                      controller.deptController.value.clear();
                      controller.fetchDept();
                      controller.currentPage.value = 1;
                      controller.fetchData();
                    },
                    builder: (context, controller, focusNode) {
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
                                    Get.find<OrderBaseController>().firmFocus
                                        .unfocus();
                                    Get.find<OrderBaseController>()
                                        .selectedDropdownFirm
                                        .value = null;
                                    Get.find<OrderBaseController>()
                                        .selectedDropdownFirmName
                                        .value = '';
                                    Get.find<OrderBaseController>()
                                        .selectedDropdownFirmCode
                                        .value = '';
                                    Utils.closeKeyboard(Get.context!);
                                    Get.find<OrderBaseController>()
                                        .currentPage
                                        .value = 1;
                                    Get.find<OrderBaseController>().fetchData();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.close, size: 20),
                                  ),
                                ),
                                const Icon(size: 20, Icons.keyboard_arrow_down),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: CommonAppInput(
                      textInputAction: TextInputAction.done,
                      textEditingController:
                          controller.searchGroupController.value,
                      //prifixIcon: Icons.search,
                      suffixIcon:
                          controller.searchQuery.value.isNotEmpty
                              ? Icons.close
                              : null,
                      hintText:
                          "Search here (Min 3 Char)... (i.e,Name ,Content)",
                      maxLength: 40,
                      focusNode: controller.searchGroupFocus,
                      onChanged: (text) async {
                        // controller.searchQuery.value = text;
                        // controller.filterData();

                        controller.searchQuery.value = text.trim();
                        if (controller.debounce?.isActive ?? false)
                          controller.debounce?.cancel();

                        controller.debounce = Timer(
                          const Duration(milliseconds: 750),
                          () async {
                            if (controller.searchQuery.value.isEmpty) {
                              controller.searchGroupController.value.clear();
                              Utils.closeKeyboard(context);
                              controller.searchQuery.value = '';
                              controller.mainList.value.data?.clear();
                              controller.searchList.clear();
                              controller.currentPage.value = 1;
                              await controller.fetchData();
                            } else {
                              if (controller.searchQuery.value.length >= 3) {
                                await controller.fetchData();
                              }
                            }
                          },
                        );
                      },
                      onSuffixClick: () async {
                        // controller.searchGroupController.value.clear();
                        // Utils.closeKeyboard(context);
                        // controller.searchQuery.value = '';
                        // controller.filterData();

                        if (controller.searchQuery.value.isNotEmpty) {
                          controller.searchGroupController.value.clear();
                          Utils.closeKeyboard(context);
                          controller.searchQuery.value = '';
                          controller.mainList.value.data?.clear();
                          controller.searchList.clear();
                          controller.currentPage.value = 1;
                          await controller.fetchData();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: Obx(
                      () =>
                          controller.isDropdownDeptLoading.isTrue
                              ? Center(child: Utils.commonCircularProgress())
                              : Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap:
                                          () => controller.showBottomSheetMenu(
                                            Get.context!,
                                          ),
                                      // Open Bottom Sheet
                                      child: AbsorbPointer(
                                        child: CommonAppInput(
                                          textInputAction: TextInputAction.next,
                                          textEditingController:
                                              controller.deptController.value,
                                          //prifixIcon: Icons.search,
                                          suffixIcon: Icons.keyboard_arrow_down,
                                          hintText: "Select Dept (Name,Cd)",
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (controller
                                      .selectedDropdownDeptName
                                      .value
                                      .isNotEmpty)
                                    const SizedBox(width: 10),
                                  Obx(() {
                                    if (controller
                                        .selectedDropdownDeptName
                                        .value
                                        .isNotEmpty) {
                                      return InkWell(
                                        onTap: () async {
                                          // Clear selected party
                                          controller
                                              .selectedDropdownDept
                                              .value = null;
                                          controller
                                              .selectedDropdownDeptName
                                              .value = '';
                                          controller
                                              .selectedDropdownDeptCode
                                              .value = '';
                                          controller.deptController.value
                                              .clear();
                                          Get.find<OrderBaseController>()
                                              .currentPage
                                              .value = 1;
                                          Get.find<OrderBaseController>()
                                              .fetchData();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 20,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink(); // Hide cancel button if no party is selected
                                    }
                                  }),
                                  if (controller
                                      .selectedDropdownDeptName
                                      .value
                                      .isNotEmpty)
                                    const SizedBox(width: 10),
                                ],
                              ),
                    ),
                  ),
                ],
              ),
              Expanded(child: _getView(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getView(BuildContext context) {
    final isLoading = controller.isLoading.value;
    final dataList = controller.mainList.value.data;
    final hasData = dataList != null && dataList.isNotEmpty;

    if (isLoading && !hasData) {
      return Utils.buildShimmerList();
    }

    if (!hasData) {
      return CommonNoMessage(
        searchQuery: controller.searchQuery.value,
        errorMessage: controller.errorMsg.value,
      );
    }

    return _listUI(context);
  }

  Widget _listUI(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dataList = controller.mainList.value.data!;

    return ListView.builder(
      controller: controller.scrollController,
      itemCount: dataList.length + 1,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) {
        if (index < dataList.length) {
          final ledgers = dataList[index];
          var reOrderController = Get.find<ReOrderController>();
          var isAdd =
              reOrderController.cartList.value.data != null &&
              reOrderController.cartList.value.data!.any(
                (element) => element.iTEMCD == ledgers.iTEMCD,
              );
          final double stock = Utils.convertToDouble(
            ledgers.cSTK?.toString() ?? '0',
          );

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 1,
            shadowColor:
                theme.brightness == Brightness.dark
                    ? Colors.white60
                    : Colors.grey[850],
            child: Container(
              decoration: BoxDecoration(
                color:
                    theme.brightness == Brightness.dark
                        ? Colors.grey[900]!
                        : Colors.grey[50]!,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CommonText(
                                  text: ledgers.iTEMNAME!,
                                  fontSize: AppDimensions.fontSizeMedium,
                                  fontWeight: AppFontWeight.w700,
                                  // style: TextStyle(
                                  //   fontSize: 16,
                                  //   fontWeight: FontWeight.bold,
                                  //   color: AppTheme.primaryColor,
                                  // ),
                                ),
                              ),
                              //SizedBox(width: 8),
                              // if (ledgers.pDISC != null && ledgers.pDISC! > 0)
                              //   Container(
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: 8,
                              //       vertical: 4,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       color: Colors.lightGreen[100],
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     child: Text(
                              //       '${ledgers.pDISC}% Off',
                              //       style: TextStyle(
                              //         color: Colors.green,
                              //         fontSize: 12,
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Flexible(
                                child: CommonText(
                                  text:
                                      // "${ledgers.iTEMCD ?? ''} • ${ledgers.dEPTNAME ?? ''}",
                                      "${(ledgers.dEPTNAME ?? '').split(' ').first}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(Icons.north_east, size: 12),
                              // Icon(Icons.north_east, size: 12,),
                              CommonText(text: " • "),
                              Expanded(
                                child: CommonText(
                                  text:
                                      '${ledgers.fIRMNAME ?? ""}', //Distributor Name
                                  color: Theme.of(context).colorScheme.primary,
                                  maxLine: 1,
                                ),
                              ),
                            ],
                          ),
                          // CommonText(
                          //   text: '${ledgers.fIRMNAME ?? ""}',   //Distributor Name
                          //   color: Theme.of(context).colorScheme.primary,
                          // ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Flexible(
                              //   child: CommonText(
                              //     text:
                              //         'Qty\n${ledgers.qUANTITY?.toString() ?? '0'}',
                              //   ),
                              // ),
                              // Flexible(
                              //   child: CommonText(
                              //     text:
                              //         'Free\n${ledgers.oTHERDESC?.toString() ?? '0'}',
                              //   ),
                              // ),
                              Flexible(
                                child: CommonText(
                                  text:
                                      'Rate: ${ledgers.rATE?.toString() ?? '0'}',
                                ),
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                child: CommonText(
                                  // text: 'Stock: ${Utils.formatIndianAmount(stock)}',
                                  // color: stock <= 0 ? Colors.red : Colors.green,
                                  text:
                                      stock <= 0
                                          ? 'Out of Stock'
                                          : stock < 100
                                          ? 'Low Stock: ${Utils.formatIndianAmount(stock)}'
                                          : 'Stock: ${Utils.formatIndianAmount(stock)}',
                                  color:
                                      stock <= 0
                                          ? Colors.red
                                          : stock < 100
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
                              // Flexible(
                              //   child: CommonText(
                              //     text:
                              //         'Amt\n₹${Utils.formatIndianAmount(double.parse(ledgers.vOUCHAMT?.toString() ?? '0'))}',
                              //   ),
                              // ),

                              // if (ledgers.iTEMDESC != null &&
                              //     ledgers.iTEMDESC!.isNotEmpty)
                              //   Flexible(
                              //     child: CommonText(
                              //       text:
                              //           'Scheme: ${ledgers.iTEMDESC?.toString()}',
                              //     ),
                              //   ),
                            ],
                          ),

                          // CommonText(
                          //   text: 'Stock: ${Utils.formatIndianAmount(stock)}',
                          //   color: stock <= 0 ? Colors.red : Colors.green,
                          // ),

                          // CommonText(
                          //   text:
                          //       'Stock: ${Utils.formatIndianAmount(double.parse(ledgers.cSTK?.toString() ?? '0'))}',
                          // ),

                          // CommonText(
                          //   text: '${ledgers.fIRMNAME ?? ""}',   //Distributor Name
                          //   color: Theme.of(context).colorScheme.primary,
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),

                    // ✅ Quantity & Button Section
                    Obx(() {
                      final status =
                          controller.requestStatus[ledgers.iTEMCD] ?? '';

                      //if (status == 'success' || (ledgers.cart?.isNotEmpty ?? false)) {
                      if (status == 'success' ||
                          (ledgers.cartStatus ?? false) ||
                          isAdd) {
                        return Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 30,
                        ); // ✅ Show only checkmark after success
                      }

                      return Column(
                        children: [
                          // ✅ Quantity controls (Hidden when status is success)
                          if (status == 'success' ||
                              (ledgers.cartStatus ?? false))
                            Visibility(
                              visible: false,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, size: 20),
                                    onPressed: () {
                                      if (ledgers.quantity.value > 1) {
                                        ledgers.quantity.value--;
                                        ledgers.totalAmount.value =
                                            ledgers.quantity.value *
                                            Utils.convertToDouble(
                                              ledgers.rATE ?? 0,
                                            );
                                        //(ledgers.sRATE1 ?? 0).toDouble();
                                      }
                                    },
                                  ),
                                  Text(ledgers.quantity.value.toString()),
                                  IconButton(
                                    icon: Icon(Icons.add, size: 20),
                                    onPressed: () {
                                      ledgers.quantity.value++;
                                      ledgers.totalAmount.value =
                                          ledgers.quantity.value *
                                          Utils.convertToDouble(
                                            ledgers.rATE ?? 0,
                                          );
                                      //(ledgers.sRATE1 ?? 0).toDouble();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          Obx(
                            () => Row(
                              children: [
                                IconButton(
                                  highlightColor: Colors.transparent,
                                  icon: Icon(Icons.remove, size: 20),
                                  onPressed: () {
                                    //if (ledgers.quantity.value > 1) {
                                    if (ledgers.quantity.value >= 1) {
                                      ledgers.quantity.value--;
                                      ledgers.quantityController.text =
                                          ledgers.quantity.value.toString();

                                      ledgers.totalAmount.value =
                                          ledgers.quantity.value *
                                          Utils.convertToDouble(
                                            ledgers.rATE ?? 0,
                                          );
                                      //(ledgers.sRATE1 ?? 0).toDouble();
                                    }
                                  },
                                ),
                                Visibility(
                                  visible: false,
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: CommonAppInput(
                                      textInputAction: TextInputAction.done,
                                      //hintText: "Qty",
                                      labelStyle: const TextStyle(
                                        color: AppColors.colorDarkBlue,
                                      ),
                                      hintStyle: const TextStyle(
                                        color: AppColors.colorDarkBlue,
                                      ),
                                      textEditingController:
                                          TextEditingController(
                                            text:
                                                ledgers.quantity.value
                                                    .toString(),
                                          ),
                                      textAlign: TextAlign.center,
                                      textInputType: TextInputType.number,
                                      onChanged: (value) {
                                        int? val = int.tryParse(value);
                                        if (val != null && val > 0) {
                                          ledgers.quantity.value = val;
                                          ledgers.totalAmount.value =
                                              val *
                                              //(ledgers.sRATE1 ?? 0).toDouble();
                                              Utils.convertToDouble(
                                                ledgers.rATE ?? 0,
                                              );
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: false,
                                  child: SizedBox(
                                    width: 60,
                                    child: TextFormField(
                                      controller: TextEditingController(
                                        text: ledgers.quantity.value.toString(),
                                      ),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        int? val = int.tryParse(value);
                                        if (val != null && val > 0) {
                                          ledgers.quantity.value = val;
                                          ledgers.totalAmount.value =
                                              val *
                                              //(ledgers.sRATE1 ?? 0).toDouble();
                                              Utils.convertToDouble(
                                                ledgers.rATE ?? 0,
                                              );
                                        }
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: colorScheme.outline,
                                            // Default themed outline color
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: colorScheme.primary,
                                            // Highlight color when focused
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: true,
                                  child: SizedBox(
                                    width: 60,
                                    child: TextFormField(
                                      controller: ledgers.quantityController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      textInputAction: TextInputAction.done,
                                      cursorColor:
                                          Theme.of(context).colorScheme.primary,
                                      onChanged: (value) {
                                        int? val = int.tryParse(value);
                                        if (val != null && val > 0) {
                                          ledgers.quantity.value = val;
                                          ledgers.totalAmount.value =
                                              val *
                                              //(ledgers.sRATE1 ?? 0).toDouble();
                                              Utils.convertToDouble(
                                                ledgers.rATE ?? 0,
                                              );
                                        }
                                      },
                                      onEditingComplete: () {
                                        String text =
                                            ledgers.quantityController.text
                                                .trim();
                                        if (text.isEmpty) {
                                          ledgers.quantityController.text = '';
                                          ledgers.quantity.value = 0;
                                          ledgers.totalAmount.value = 0.0;
                                        } else {
                                          int? val = int.tryParse(text);
                                          if (val != null && val >= 0) {
                                            ledgers.quantity.value = val;
                                            ledgers.totalAmount.value =
                                                val *
                                                Utils.convertToDouble(
                                                  ledgers.rATE ?? 0,
                                                );
                                          } else {
                                            // Fallback in case of invalid input
                                            ledgers.quantityController.text =
                                                '0';
                                            ledgers.quantity.value = 0;
                                            ledgers.totalAmount.value = 0.0;
                                          }
                                        }
                                        // Hide keyboard
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.outline,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                IconButton(
                                  highlightColor: Colors.transparent,
                                  icon: Icon(Icons.add, size: 20),
                                  onPressed: () {
                                    ledgers.quantity.value++;
                                    ledgers.quantityController.text =
                                        ledgers.quantity.value.toString();
                                    ledgers.totalAmount.value =
                                        ledgers.quantity.value *
                                        //(ledgers.sRATE1 ?? 0).toDouble();
                                        Utils.convertToDouble(
                                          ledgers.rATE ?? 0,
                                        );

                                    // if (ledgers.quantity.value >=
                                    //     ledgers.aVLSTK!) {
                                    //   AppSnackBar.showGetXCustomSnackBar(
                                    //     message:
                                    //         '${ledgers.iTEMNAME!} has only ${ledgers.aVLSTK!} in stock. You can’t add more.',
                                    //   );
                                    // } else {
                                    //   ledgers.quantity.value++;
                                    //   ledgers.totalAmount.value =
                                    //       ledgers.quantity.value *
                                    //       (ledgers.sRATE1 ?? 0).toDouble();
                                    // }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),

                          // ✅ Add to Cart Button (Hidden after success)
                          // if (status != 'success')
                          //   ElevatedButton.icon(
                          //     onPressed:
                          //         status == 'loading'
                          //             ? null // Disable button when loading
                          //             : () async {
                          //               // if (ledgers.quantity.value >=
                          //               //     ledgers.aVLSTK!) {
                          //               //   AppSnackBar.showGetXCustomSnackBar(
                          //               //     message:
                          //               //         '${ledgers.iTEMNAME!} has only ${ledgers.aVLSTK!} in stock. You can’t add more.',
                          //               //   );
                          //               // } else {
                          //               //   await controller.sendCart(
                          //               //     ledgers.iTEMCD!,
                          //               //     ledgers.quantity.value,
                          //               //     ledgers.sYNCID.toString(),
                          //               //   );
                          //               // }
                          //
                          //               await controller.sendCart(
                          //                 ledgers.iTEMCD!,
                          //                 ledgers.quantity.value,
                          //                 ledgers.sYNCID.toString(),
                          //               );
                          //             },
                          //     label:
                          //         status == 'loading'
                          //             ? SizedBox(
                          //               width: 16,
                          //               height: 16,
                          //               child: CircularProgressIndicator(
                          //                 color: Colors.white,
                          //                 strokeWidth: 2,
                          //               ),
                          //             )
                          //             : Text(
                          //               'Add',
                          //               style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize: 12,
                          //               ),
                          //             ),
                          //     icon:
                          //         status == 'loading'
                          //             ? SizedBox.shrink() // Hide icon when loading
                          //             : Icon(
                          //               Icons.shopping_bag_outlined,
                          //               color: Colors.white,
                          //             ),
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: AppTheme.primaryColor,
                          //       padding: EdgeInsets.symmetric(
                          //         horizontal: 8,
                          //         vertical: 4,
                          //       ),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //     ),
                          //   ),
                          ElevatedButton.icon(
                            onPressed:
                                status == 'loading'
                                    ? null
                                    : () async {
                                      int quantity =
                                          int.tryParse(
                                            ledgers
                                                .quantityController
                                                .value
                                                .text,
                                          ) ??
                                          0;

                                      if (quantity == 0) {
                                        AppSnackBar.showGetXCustomSnackBar(
                                          message:
                                              //"This item ${ledgers.iTEMNAME} quantity is 0, please add quantity",
                                              "This item ${ledgers.iTEMNAME} quantity is empty, please add quantity",
                                        );
                                      } else {
                                        await controller.sendCart(
                                          ledgers.iTEMCD!,
                                          //ledgers.quantity.value,
                                          quantity,
                                          // controller
                                          //     .selectedDropdownFirmCode
                                          //     .value,
                                          ledgers.sYNCID.toString(),
                                        );
                                      }

                                      // await controller.sendCart(
                                      //   ledgers.iTEMCD!,
                                      //   ledgers.quantity.value,
                                      //   ledgers.sYNCID.toString(),
                                      // );
                                    },
                            label:
                                status == 'loading'
                                    ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color:
                                            Theme.of(context)
                                                .colorScheme
                                                .onPrimary, // Loader color based on theme
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      'Add',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context)
                                                .colorScheme
                                                .onPrimary, // Text color based on theme
                                        fontSize: 12,
                                      ),
                                    ),
                            icon:
                                status == 'loading'
                                    ? SizedBox.shrink()
                                    : Icon(
                                      Icons
                                          .add_shopping_cart, // shopping_bag_outlined
                                      color:
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary, // Icon color based on theme
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary, // Button color from theme
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Obx(() {
            return controller.isPageLoading.isTrue
                ? Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: Utils.commonCircularProgress()),
                )
                : const SizedBox(); // Hide loader if not loading
          });
        }
      },
    );
  }
}
