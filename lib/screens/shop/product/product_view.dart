import 'dart:async';

import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
//import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/shop/product/product_controller.dart';
import 'package:arham_b2c/screens/shop/shop_controller.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_no_message.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  ProductView({super.key});

  final ProductController controller = Get.put(ProductController());

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
              Visibility(visible: false, child: const SizedBox(height: 16)),
              Visibility(
                visible: false,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Utils.closeKeyboard(context);
                          DateTime? selectedDate =
                              await AppDatePicker.allDateEnable(
                                context,
                                controller.fromDateController.value,
                              );

                          if (selectedDate != null &&
                              controller.selectedDropdownFirmCode.isNotEmpty) {
                            String formattedDate = AppDatePicker.formatDate(
                              selectedDate,
                            );
                            //if (controller.toDateController.value.text != formattedDate) {
                            controller.fromDateController.value.text =
                                formattedDate;
                            controller
                                .fetchProduct(); // API call only after date change
                            //}
                          }
                        },
                        child: CommonAppInput(
                          textEditingController:
                              controller.fromDateController.value,
                          hintText: "From Date",
                          suffixIcon: Icons.calendar_month,
                          suffixColor: AppColors.colorDarkBlue,
                          focusNode: controller.fromDtFocus,
                          isDateField: true,
                          isEnable: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Utils.closeKeyboard(context);
                          DateTime? selectedDate =
                              await AppDatePicker.allDateEnable(
                                context,
                                controller.toDateController.value,
                              );

                          if (selectedDate != null &&
                              controller.selectedDropdownFirmCode.isNotEmpty) {
                            String formattedDate = AppDatePicker.formatDate(
                              selectedDate,
                            );
                            //if (controller.toDateController.value.text != formattedDate) {
                            controller.toDateController.value.text =
                                formattedDate;
                            controller.fetchProduct();
                          }
                        },
                        child: CommonAppInput(
                          textEditingController:
                              controller.toDateController.value,
                          hintText: "To Date",
                          suffixIcon: Icons.calendar_month,
                          suffixColor: AppColors.colorDarkBlue,
                          focusNode: controller.toDtFocus,
                          // labelStyle: const TextStyle(
                          //   color:
                          //       AppColors
                          //           .colorDarkGray, // Label color changed to gray
                          // ),
                          // hintStyle: const TextStyle(
                          //   color:
                          //       AppColors
                          //           .colorBlack, // Hint color changed to black
                          // ),
                          isDateField: true,
                          isEnable: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(visible: true, child: const SizedBox(height: 16)),
              Visibility(
                visible: false,
                child:
                    controller.isDropdownFirmLoading.isTrue
                        ? Center(child: Utils.commonCircularProgress())
                        : (controller.firmList.value.data == null ||
                            controller.firmList.value.data!.isEmpty)
                        ? Container()
                        : TypeAheadField<FirmModel>(
                          controller: controller.firmController.value,
                          focusNode: controller.firmFocus,
                          suggestionsCallback: (pattern) async {
                            return controller.firmList.value.data?.where((
                              item,
                            ) {
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
                                            suggestion.mobile1!
                                                .trim()
                                                .isNotEmpty
                                        ? "${suggestion.firmName.trim()} | ${suggestion.mobile1!.trim()}"
                                        : suggestion.firmName.trim(),
                                fontWeight: AppFontWeight.w400,
                                fontSize: 14,
                              ),
                            );
                          },
                          onSelected: (FirmModel selectedItem) {
                            controller.selectedDropdownFirm.value =
                                selectedItem;
                            controller.selectedDropdownFirmCode.value =
                                selectedItem.syncId.toString().trim();
                            controller.firmController.value.text =
                                selectedItem.firmName.trim();
                            Utils.closeKeyboard(Get.context!);
                            controller.firmFocus.unfocus();
                            controller.fetchProduct();
                          },
                          builder: (context, controller, focusNode) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                counter: const Offstage(),
                                suffixIconConstraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 39,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          controller.clear();
                                          Get.find<ProductController>()
                                              .firmFocus
                                              .unfocus();
                                          Get.find<ProductController>()
                                              .selectedDropdownFirm
                                              .value = null;
                                          Get.find<ProductController>()
                                              .selectedDropdownFirmName
                                              .value = '';
                                          Get.find<ProductController>()
                                              .selectedDropdownFirmCode
                                              .value = '';
                                          Utils.closeKeyboard(Get.context!);
                                          Get.find<ProductController>()
                                              .mainList
                                              .value
                                              .data
                                              ?.clear();
                                          Get.find<ProductController>()
                                              .searchList
                                              .clear();
                                          Get.find<ProductController>().mainList
                                              .refresh();
                                          // Get.find<ProductController>()
                                          //     .fetchProduct();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(Icons.close, size: 20),
                                        ),
                                      ),
                                      const Icon(
                                        size: 30,
                                        Icons.keyboard_arrow_down,
                                      ),
                                    ],
                                  ),
                                ),
                                labelText: 'Select Distributor',
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                // disabledBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     color: AppColors.indigoSwatch,
                                //     style: BorderStyle.solid,
                                //     width: 1,
                                //   ),
                                //   borderRadius: BorderRadius.circular(10.0),
                                // ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colorScheme.primary,
                                    // Highlight color when focused
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 12.0,
                                ),
                              ),
                            );
                          },
                        ),
              ),

              Visibility(visible: false, child: const SizedBox(height: 16)),

              //if (controller.selectedDropdownFirmCode.isNotEmpty)

              // if (controller.mainList.value.data != null &&
              //     controller.mainList.value.data!.isNotEmpty)
              CommonAppInput(
                textInputAction: TextInputAction.done,
                textEditingController: controller.searchGroupController.value,
                //prifixIcon: Icons.search,
                suffixIcon:
                    controller.searchQuery.value.isNotEmpty
                        ? Icons.close
                        : null,
                hintText: "Search here (Min 3 Char)... (i.e,Name ,Contataint)",
                //content
                maxLength: 40,
                focusNode: controller.searchGroupFocus,
                onChanged: (text) async {
                  // controller.searchQuery.value =
                  //     text; // Update the search query
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
                        await controller.fetchProduct();
                      } else {
                        if (controller.searchQuery.value.length >= 3) {
                          await controller.fetchProductBySearch();
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
                    await controller.fetchProduct();
                  }
                },
              ),
              //if (controller.selectedDropdownFirmCode.isNotEmpty)

              // if (controller.mainList.value.data != null &&
              //     controller.mainList.value.data!.isNotEmpty)
              const SizedBox(height: 10),

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
      itemBuilder: (context, index) {
        //final ledgers = controller.mainList.value.data![index];
        if (index < dataList.length) {
          final ledgers = dataList[index];
          var controller1 = Get.find<ShopController>();
          var isAdd =
              controller1.cartList.value.data != null &&
              controller1.cartList.value.data!.any(
                (element) => element.iTEMCD == ledgers.iTEMCD,
              );

          Color cstkColor = Colors.green;

          if (ledgers.hasCstk) {
            final cstk = Utils.convertToDouble(ledgers.cSTK);

            cstkColor = cstk <= 0 ? Colors.red : Colors.green;
          }

          Color stockLevelColor = Colors.green;

          if (ledgers.hasStockLevel) {
            final level = (ledgers.stockLevel ?? '').trim().toLowerCase();

            if (level.contains('out')) {
              stockLevelColor = Colors.red;
            } else if (level.contains('low')) {
              stockLevelColor = Colors.orange;
            } else {
              stockLevelColor = Colors.green;
            }
          }

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
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 2.2,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(color: cstkColor),
                      ),
                      SizedBox(width: 8),
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
                            CommonText(
                              text: ledgers.iTEMLNAME?.toString() ?? '',
                              //style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: CommonText(
                                    text:
                                        'MRP: ₹${Utils.formatIndianAmount(double.parse(ledgers.sRATE3?.toString() ?? '0'))}',
                                  ),
                                ),
                                if (ledgers.iTEMDESC != null &&
                                    ledgers.iTEMDESC!.isNotEmpty)
                                  Flexible(
                                    child: CommonText(
                                      text:
                                          'Scheme: ${ledgers.iTEMDESC?.toString()}',
                                    ),
                                  ),
                              ],
                            ),

                            // CommonText(
                            //   text:
                            //       'Stock: ${Utils.formatIndianAmount(double.parse(ledgers.cSTK?.toString() ?? '0'))}',
                            //   //style: TextStyle(fontSize: 14, color: Colors.black),
                            //   color: stock <= 0 ? Colors.red : Colors.green,
                            // ),
                            Row(
                              children: [
                                // if (cstk != null)
                                //   CommonText(
                                //     text:
                                //         'Stock: ${Utils.formatIndianAmount(Utils.convertToDouble(cstk))}',
                                //     color:
                                //         cstk <= 0
                                //             ? Colors.red
                                //             : ((minStk != null && cstk < minStk)
                                //                 ? Colors.orange
                                //                 : Colors.green),
                                //   ),
                                if (ledgers.hasCstk)
                                  CommonText(
                                    text:
                                        'Stock: ${Utils.formatIndianAmount(Utils.convertToDouble(ledgers.cSTK))}',
                                    color: cstkColor,
                                  ),

                                if (ledgers.hasCstk) const SizedBox(width: 5),

                                // if (stockLevel != null && stockLevel.isNotEmpty)
                                //   CommonText(
                                //     text: stockLevel,
                                //     style: TextStyle(
                                //       color:
                                //           stockLevel.toLowerCase() ==
                                //                   "out of stock"
                                //               ? Colors.red
                                //               : stockLevel.toLowerCase() ==
                                //                   "low stock"
                                //               ? Colors.orange
                                //               : Colors.green,
                                //     ),
                                //   ),
                                if (ledgers.hasStockLevel)
                                  CommonText(
                                    text: ledgers.stockLevel.toString(),
                                    color: stockLevelColor,
                                  ),
                              ],
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     CommonText(
                            //       text:
                            //           stock <= 0
                            //               ? 'Out of Stock'
                            //               : stock < 100
                            //               ? 'Low Stock: ${stocks}'
                            //               : 'Stock: ${stocks}',
                            //       color:
                            //           stock <= 0
                            //               ? Colors.red
                            //               : stock < 100
                            //               ? Colors.orange
                            //               : Colors.green,
                            //       fontWeight: AppFontWeight.w600,
                            //     ),
                            //
                            //     CommonText(
                            //       text: ' ${ledgers.stockLevel ?? ""}',
                            //       style: TextStyle(
                            //         color:
                            //             stockLevel.toLowerCase() == "out of stock"
                            //                 ? Colors.red
                            //                 : stockLevel.toLowerCase() ==
                            //                     "low stock"
                            //                 ? Colors.orange
                            //                 : Colors.green,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            CommonText(
                              text:
                                  'Distributor : ${ledgers.firm?.fIRMNAME ?? ""}',
                              color: Theme.of(context).colorScheme.primary,
                            ),

                            // ✅ Updated Price Display
                            // Obx(() => Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       'Price: ₹${ledgers.sRATE1!.toStringAsFixed(2)}',
                            //       style: TextStyle(fontSize: 14, color: Colors.black),
                            //     ),
                            //     SizedBox(height: 4),
                            //     Text(
                            //       'Total: ₹${ledgers.totalAmount.value.toStringAsFixed(2)}',
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.red,
                            //       ),
                            //     ),
                            //   ],
                            // )),
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
                                                ledgers.sRATE1 ?? 0,
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
                                              ledgers.sRATE1 ?? 0,
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
                                              ledgers.sRATE1 ?? 0,
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
                                                  ledgers.sRATE1 ?? 0,
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
                                          text:
                                              ledgers.quantity.value.toString(),
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
                                                  ledgers.sRATE1 ?? 0,
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
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        textInputAction: TextInputAction.done,
                                        cursorColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        onChanged: (value) {
                                          int? val = int.tryParse(value);
                                          if (val != null && val > 0) {
                                            ledgers.quantity.value = val;
                                            ledgers.totalAmount.value =
                                                val *
                                                //(ledgers.sRATE1 ?? 0).toDouble();
                                                Utils.convertToDouble(
                                                  ledgers.sRATE1 ?? 0,
                                                );
                                          }
                                        },
                                        onEditingComplete: () {
                                          String text =
                                              ledgers.quantityController.text
                                                  .trim();
                                          if (text.isEmpty) {
                                            ledgers.quantityController.text =
                                                '';
                                            ledgers.quantity.value = 0;
                                            ledgers.totalAmount.value = 0.0;
                                          } else {
                                            int? val = int.tryParse(text);
                                            if (val != null && val >= 0) {
                                              ledgers.quantity.value = val;
                                              ledgers.totalAmount.value =
                                                  val *
                                                  Utils.convertToDouble(
                                                    ledgers.sRATE1 ?? 0,
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
                                            ledgers.sRATE1 ?? 0,
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
                                        Icons.add_shopping_cart,
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
            ),
          );
        } else {
          return Obx(() {
            return controller.isLoading.isTrue
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
