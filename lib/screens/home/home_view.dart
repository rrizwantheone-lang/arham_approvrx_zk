import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_images.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/models/login_firm_response.dart';
import 'package:arham_b2c/screens/order_report/order_report_view.dart';
import 'package:arham_b2c/screens/re_order/re_order_view.dart';
import 'package:arham_b2c/screens/report/report_view.dart';
import 'package:arham_b2c/screens/shop/shop_view.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_banner.dart';
import 'package:arham_b2c/widgets/common_no_message.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  //final HomeController controller = Get.put(HomeController(), permanent: false);
  // final HomeController controller = Get.find<HomeController>();

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          // final isLoading = controller.isDropdownLoading.value;
          // final firmList = controller.firmDropdownList.value.data;
          // final theme = Theme.of(Get.context!);
          // final colorScheme = theme.colorScheme;

          // if (isLoading || firmList == null) {
          //   return Center(child: Utils.commonCircularProgress());
          // }

          // if (isLoading || firmList == null) {
          //   return Shimmer.fromColors(
          //     baseColor: colorScheme.primary.withValues(alpha: 0.2),
          //     highlightColor: colorScheme.onPrimary.withValues(alpha: 0.2),
          //     child: Container(
          //       height: 45,
          //       decoration: BoxDecoration(
          //         color: colorScheme.primary.withValues(alpha: 0.3),
          //         borderRadius: BorderRadius.circular(4),
          //       ),
          //     ),
          //   );
          // }

          if (controller.isDropdownLoading.value) {
            return Center(child: Utils.commonCircularProgress());
          }

          final firms = controller.firmDropdownList.value.data;

          if (firms == null || firms.isEmpty) {
            return CommonText(text: 'No firms available', color: Colors.grey);
          }

          return DropdownButton<LoginFirmModel?>(
            value: controller.selectedDropdownFirm.value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            underline: const SizedBox(),
            hint: CommonText(
              text: 'Select Firm',
              fontWeight: AppFontWeight.w400,
              fontSize: AppDimensions.fontSizeMedium,
            ),
            items:
                firms.map((LoginFirmModel firm) {
                  return DropdownMenuItem<LoginFirmModel>(
                    value: firm,
                    child: CommonText(
                      text: firm.sCFIRMNAME ?? '',
                      fontWeight: AppFontWeight.w400,
                      fontSize: AppDimensions.fontSizeMedium,
                    ),
                  );
                }).toList(),
            onChanged: (LoginFirmModel? newValue) {
              if (newValue != null &&
                  controller.selectedDropdownFirmID.value !=
                      newValue.sCSYNCID.toString()) {
                controller.selectedDropdownFirm.value = newValue;
                controller.selectedDropdownFirmID.value =
                    newValue.sCSYNCID.toString();

                // Save firm details
                PreferenceUtils.setFirmID(newValue.sCFIRMID.toString());
                PreferenceUtils.setCustID(newValue.sCCUSTID.toString());
                PreferenceUtils.setSyncID(
                  controller.selectedDropdownFirmID.value,
                );
                PreferenceUtils.setFirmName(newValue.sCFIRMNAME.toString());
                PreferenceUtils.setFirmGSTType(newValue.sCGSTTYPE.toString());
                PreferenceUtils.setFirmStateCD(newValue.sCSTATECODE.toString());
                PreferenceUtils.setFirmStateName(newValue.sCSTATE.toString());

                AppSnackBar.showGetXCustomSnackBar(
                  message: 'Please wait, loading firm data...',
                  backgroundColor: AppColors.colorGreen,
                );

                controller.changeFirmLogin(newValue.sCSYNCID.toString());
              }
            },
          );
        }),
      ),
      // drawer: CommonDrawer(),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              await controller.refreshAllData();
            },
            child: SingleChildScrollView(
              // physics: const BouncingScrollPhysics(),
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ------------------ Quick Actions ------------------
                  _buildQuickActionGrid(context),

                  const SizedBox(height: 10),

                  /// ------------------ Business Overview ------------------
                  _buildSectionTitle('Business Overview'),

                  if (controller.isDashboardLoading.value)
                    SizedBox(
                      height: 200,
                      child: Center(child: Utils.commonCircularProgress()),
                    )
                  else if (controller.bannerListData.isEmpty)
                    SizedBox(
                      height: 200,
                      child: Center(child: CommonText(text: 'No Banner Found')),
                    )
                  else
                    CommonCarouselBanner(
                      images: controller.bannerListData,
                      height: 200,
                      fit: BoxFit.cover,
                    ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Your Top Products'),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => ReOrderView(),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          child: CommonText(
                            text: 'View more',
                            fontSize: AppDimensions.fontSizeMedium,
                            fontWeight: AppFontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// ------------------ API LIST ------------------
                  _getView(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final isExtraSmallScreen = screenWidth < 330;
    final isSmallScreen = screenWidth < 400;

    // Responsive aspect ratio and spacing
    final childAspectRatio =
        isExtraSmallScreen
            ? 0.85
            : isSmallScreen
            ? 0.95
            : 0.95; // Originally 1.1

    final spacing =
        isExtraSmallScreen
            ? 4.0
            : isSmallScreen
            ? 6.0
            : 8.0;
    final mainAxisSpacing =
        isExtraSmallScreen
            ? 4.0
            : isSmallScreen
            ? 6.0
            : 8.0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: spacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
      children: [
        _buildQuickActionButtonWithImage(
          context,
          'New Orders',
          AppImages.icOrder,
          const Color(0xFF2196F3), // Blue
          () async {
            await Get.to(
              () => ShopView(),
              transition: Transition.rightToLeftWithFade,
            );
            controller.allCallAPI();
          },
        ),

        _buildQuickActionButtonWithImage(
          context,
          'Re-Orders',
          AppImages.icReOrder,
          const Color(0xFFFF9800), // Orange
          () async {
            await Get.to(
              () => ReOrderView(),
              transition: Transition.rightToLeftWithFade,
            );
            controller.allCallAPI();
          },
        ),
        _buildQuickActionButtonWithImage(
          context,
          'Orders Reports',
          AppImages.icOrderReports,
          const Color(0xFF4CAF50), // Green
          () {
            Get.to(
              () => OrderReportView(),
              transition: Transition.rightToLeftWithFade,
            );
          },
        ),
        _buildQuickActionButtonWithImage(
          context,
          'Reports',
          AppImages.icSalesReports,
          const Color(0xFF9C27B0), // Purple
          () {
            Get.to(
              () => ReportView(),
              transition: Transition.rightToLeftWithFade,
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionButtonWithImage(
    BuildContext context,
    String label,
    String imagePath,
    Color color,
    VoidCallback onTap,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isExtraSmallScreen = screenWidth < 330;
    final isSmallScreen = screenWidth < 400;

    // 🔑 Responsive image size
    final imageSize =
        isExtraSmallScreen
            ? 32.0
            : isSmallScreen
            ? 40.0
            : 52.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // 🖼 IMAGE (responsive size)
            Flexible(
              child: Image.asset(
                imagePath,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image, size: imageSize, color: color);
                },
              ),
            ),
            SizedBox(height: 10),
            // 🏷 LABEL
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CommonText(
                  text: label,
                  fontSize:
                      isExtraSmallScreen
                          ? 10 //Originally 9
                          : isSmallScreen
                          ? 12 //Originally 11
                          : 13, //Originally 13
                  fontWeight: AppFontWeight.w600,
                  textAlign: TextAlign.center,
                  maxLine: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CommonText(
        text: title,
        fontSize: AppDimensions.fontSizeLarge,
        fontWeight: AppFontWeight.w900,
      ),
    );
  }

  Widget _getView(BuildContext context) {
    final isLoading = controller.isLoading.value;
    final dataList = controller.mainList.value.data;

    if (isLoading && (dataList == null || dataList.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Utils.commonCircularProgress()),
      );
    }

    if (dataList == null || dataList.isEmpty) {
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final ledgers = dataList[index];
        var homeController = Get.find<HomeController>();
        var isAdd =
            homeController.cartList.value.data != null &&
            homeController.cartList.value.data!.any(
              (element) => element.iTEMCD == ledgers.iTEMCD,
            );

        Color cstkColor = Colors.green;

        if (ledgers.hasCstk) {
          final cstk = Utils.convertToDouble(ledgers.cSTK);

          cstkColor = cstk <= 0 ? Colors.red : Colors.green;
        }

        if (ledgers.hasRate) {
          final rate = Utils.convertToDouble(ledgers.rATE);
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            CommonText(
                              text:
                                  // "${ledgers.iTEMCD ?? ''} • ${ledgers.dEPTNAME ?? ''}",     //Item code and Company name
                                  "${(ledgers.dEPTNAME ?? '').trim().split(' ').first}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            Icon(Icons.north_east, size: 12),
                            CommonText(text: " • "),
                            Flexible(
                              child: CommonText(
                                text: '${ledgers.fIRMNAME ?? ""}',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Flexible(
                        //       child: CommonText(
                        //         text:
                        //             'Quantity: ${ledgers.qUANTITY?.toString() ?? '0'}',
                        //       ),
                        //     ),
                        //     Flexible(
                        //       child: CommonText(
                        //         text: 'Rate: ${ledgers.rATE?.toString() ?? '0'}',
                        //       ),
                        //     ),
                        //
                        //     // if (ledgers.iTEMDESC != null &&
                        //     //     ledgers.iTEMDESC!.isNotEmpty)
                        //     //   Flexible(
                        //     //     child: CommonText(
                        //     //       text:
                        //     //           'Scheme: ${ledgers.iTEMDESC?.toString()}',
                        //     //     ),
                        //     //   ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (ledgers.hasRate)
                              SizedBox(
                                width: 95,
                                child: CommonText(
                                  text:
                                      // 'Rate: ${ledgers.rATE?.toString() ?? '0'}',
                                      'Rate: ${ledgers.rATE}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLine: 1,
                                ),
                              ),
                            // CommonText(
                            //   text:
                            //   'Free: ${ledgers.oTHERDESC?.toString() ?? '0'}',
                            // ),
                            // Spacer(),
                            // CommonText(
                            //   text: 'Amt: ₹${Utils.formatIndianAmount(double.parse(ledgers.vOUCHAMT?.toString() ?? '0'))}',
                            //   maxLine: 1,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            // SizedBox(width: 10,),
                            Expanded(
                              child: Row(
                                children: [
                                  if (ledgers.hasCstk)
                                    CommonText(
                                      text: 'Stock: ${ledgers.cSTK}',
                                      color: cstkColor,
                                    ),

                                  if (ledgers.hasCstk && ledgers.hasStockLevel)
                                    const SizedBox(width: 5),

                                  if (ledgers.hasStockLevel)
                                    Expanded(
                                      child: CommonText(
                                        text: ledgers.stockLevel ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLine: 1,
                                        color: stockLevelColor,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Expanded(
                            //   // child: CommonText(
                            //   //   // text:
                            //   //   //     'Stock: ${Utils.formatIndianAmount(stock)}',
                            //   //   text:
                            //   //       stock <= 0
                            //   //           ? 'Out of Stock'
                            //   //           : stock < 100
                            //   //           ? 'Low Stock: ${Utils.formatIndianAmount(stock)}'
                            //   //           : 'Stock: ${Utils.formatIndianAmount(stock)}',
                            //   //   overflow: TextOverflow.ellipsis,
                            //   //   maxLine: 1,
                            //   //   textAlign: TextAlign.start,
                            //   //   // color: stock <= 0 ? Colors.red : Colors.green,
                            //   //   color:
                            //   //       stock <= 0
                            //   //           ? Colors.red
                            //   //           : stock < 100
                            //   //           ? Colors.orange
                            //   //           : Colors.green,
                            //   // ),
                            //   child: CommonText(
                            //     text: '${stockLevel}',
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLine: 1,
                            //     textAlign: TextAlign.start,
                            //     // color: stock <= 0 ? Colors.red : Colors.green,
                            //     color:
                            //         stock <= 0
                            //             ? Colors.red
                            //             : stockLevel.toString() == "Low Stock"
                            //             ? Colors.orange
                            //             : Colors.green,
                            //   ),
                            // ),
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
                        //   text: '${ledgers.fIRMNAME ?? ""}',
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
                    if (
                    //status == 'success' ||
                    //(ledgers.cartStatus ?? false) ||
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
                                              ledgers.quantity.value.toString(),
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
                                    // onChanged: (value) {
                                    //   int? val = int.tryParse(value);
                                    //   if (val != null && val > 0) {
                                    //     ledgers.quantity.value = val;
                                    //     ledgers.totalAmount.value =
                                    //         val *
                                    //         //(ledgers.sRATE1 ?? 0).toDouble();
                                    //         Utils.convertToDouble(
                                    //           ledgers.rATE ?? 0,
                                    //         );
                                    //   }
                                    // },
                                    onChanged: (value) {
                                      //Prevent backspacing from zero to empty
                                      // if (value.isEmpty) {
                                      //   // Immediately show 0 when cleared
                                      //   ledgers.quantityController.text = '0';
                                      //   ledgers.quantity.value = 0;
                                      //   ledgers.totalAmount.value = 0.0;
                                      //   // Optional: move cursor to end
                                      //   ledgers.quantityController.selection = TextSelection.fromPosition(
                                      //     TextPosition(offset: ledgers.quantityController.text.length),
                                      //   );
                                      //   return;
                                      // }

                                      int? val = int.tryParse(value);
                                      if (val != null) {
                                        ledgers.quantity.value = val;
                                        ledgers.totalAmount.value =
                                            val *
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
                                          ledgers.quantityController.text = '0';
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
                                      Utils.convertToDouble(ledgers.rATE ?? 0);

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
                                          ledgers.quantityController.value.text,
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
                                        .add_shopping_cart, // previously shopping_bag_outlined
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
      },
    );
  }
}
