import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/screens/home/home_controller.dart';
import 'package:arham_b2c/screens/order_confirm/order_confirmation_view.dart';
import 'package:arham_b2c/screens/re_order/order_base/order_base_controller.dart';
import 'package:arham_b2c/screens/re_order/re_order_controller.dart';
import 'package:arham_b2c/screens/re_order/sales_base/sales_base_controller.dart';
import 'package:arham_b2c/screens/shop/distributor/distributor_controller.dart';
import 'package:arham_b2c/screens/shop/product/product_controller.dart';
import 'package:arham_b2c/screens/shop/shop_controller.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_controller.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_response.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_bar.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:arham_b2c/widgets/common_material_dialog.dart';
import 'package:arham_b2c/widgets/common_no_message.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  final CartController controller = Get.put(CartController());

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (controller.isSales.value == 'Sales') {
          final orderBaseController = Get.find<OrderBaseController>();
          final salesBaseController = Get.find<SalesBaseController>();
          final reOrderController = Get.find<ReOrderController>();

          // Refresh cart
          await reOrderController.fetchCart();

          // Fetch order base product only if distributor selected
          orderBaseController.currentPage.value = 1;
          await orderBaseController.fetchData();

          // Fetch sales base product only if distributor selected
          salesBaseController.currentPage.value = 1;
          await salesBaseController.fetchData();

          // Refresh cart
          // await reOrderController.fetchCart();
        } else if (controller.isSales.value == 'Shop') {
          final distributorController = Get.find<DistributorController>();
          final productController = Get.find<ProductController>();
          final shopController = Get.find<ShopController>();

          // Refresh cart
          await shopController.fetchCart();

          // Fetch distributor product only if distributor selected
          if (distributorController.selectedDropdownFirmCode.isNotEmpty) {
            //await distributorController.fetchProduct();
            await distributorController.fetchProductBySearch();
          }

          // Reset pagination and fetch product list
          if (productController.searchQuery.value.isNotEmpty) {
            await productController.fetchProductBySearch();
          } else {
            productController.currentPage.value = 1;
            // productController.searchQuery.value = '';
            // productController.searchGroupController.value.text = '';
            // productController.searchGroupFocus.unfocus();
            await productController.fetchProduct();
          }

          // Refresh cart
          // await shopController.fetchCart();
        } else if (controller.isSales.value == 'Home') {
          //Back
        }

        return;
      },
      child: Scaffold(
        appBar: const CommonAppBar(title: 'Shopping Cart'),
        body: SafeArea(
          child: Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  // if(controller.cartList.value.data != null &&
                  //     controller.cartList.value.data!.isNotEmpty)
                  CommonAppInput(
                    textInputAction: TextInputAction.done,
                    textEditingController:
                        controller.searchGroupController.value,
                    //prifixIcon: Icons.search,
                    suffixIcon:
                        controller.searchQuery.value.isNotEmpty
                            ? Icons.close
                            : null,
                    hintText: "Search here.. (i.e, Product Name , Product CD)",
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
                  // if(controller.cartList.value.data != null &&
                  //     controller.cartList.value.data!.isNotEmpty)
                  const SizedBox(height: 10),
                  Expanded(child: _getView(context)),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(() {
          final cartData = controller.mainList.value.data ?? [];

          if (cartData.isEmpty) return const SizedBox.shrink();

          // Total quantity & amount logic
          // final totalQuantity = cartData.fold<int>(
          //   0,
          //   (sum, item) => sum + int.tryParse(item.qUANTITY.toString())!,
          // );

          final totalAmount = cartData.fold<double>(
            0,
            (sum, item) =>
                sum +
                ((int.tryParse(item.qUANTITY.toString()) ?? 0) *
                    (double.tryParse(item.rATE.toString()) ?? 0.0)),
          );

          return Visibility(
            visible: cartData.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(
                      context,
                    ).viewInsets.bottom, // ✅ Adjusts for keyboard
              ),
              child: Card(
                margin: const EdgeInsets.only(top: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                // padding: const EdgeInsets.symmetric(
                //   horizontal: 16,
                //   vertical: 12,
                // ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // ✅ Aligns "Total" to right
                          children: [
                            CommonText(
                              text:
                                  'Total: ₹ ${Utils.formatIndianAmount(totalAmount)}',
                              fontWeight: AppFontWeight.w900,
                              fontSize: AppDimensions.fontSizeLarge,
                              // style: const TextStyle(
                              //   fontSize: 16,
                              //   fontWeight: FontWeight.bold,
                              // ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CommonAppInput(
                                textInputAction: TextInputAction.done,
                                textEditingController:
                                    controller.narrationController.value,
                                hintText: "Remarks",
                                maxLength: 40,
                                focusNode: controller.narrationFocus,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CommonButton(
                                buttonText: 'Order Now',
                                onPressed: () {
                                  // controller
                                  //     .sendOrder(
                                  //       controller.narrationController.value.text,
                                  //     )
                                  //     .then((val) {
                                  //       //Get.offAll(() => HomeView());
                                  //       Get.to(() => OrderConfirmationView());
                                  //     });

                                  controller
                                      .sendOrder(
                                        controller
                                            .narrationController
                                            .value
                                            .text,
                                      )
                                      .then((isSuccess) {
                                        if (isSuccess) {
                                          Get.to(() => OrderConfirmationView());
                                        } else {
                                          AppSnackBar.showGetXCustomSnackBar(
                                            message:
                                                'Order failed. Please try again.',
                                          );
                                        }
                                      });
                                },
                                isLoading: controller.isLoadingOrderNow.value,
                                isDisable: controller.isDisableOrderNow.value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _getView(BuildContext context) {
    return controller.isLoading.isTrue
        ? Utils.buildShimmerList()
        : (controller.mainList.value.data == null ||
            controller.mainList.value.data!.isEmpty)
        ? CommonNoMessage(
          searchQuery: controller.searchQuery.value,
          errorMessage: controller.errorMsg.value,
        )
        : _listUI(context);
  }

  // ignore: unused_element
  Widget _listUI1(BuildContext context) {
    return ListView.builder(
      itemCount: controller.mainList.value.data!.length,
      itemBuilder: (context, index) {
        final product = controller.mainList.value.data![index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // 👈 Customize the radius
          ),
          elevation: 1,
          shadowColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white60
                  : Colors.grey[850],
          child: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]!
                      : Colors.grey[50]!,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Item details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: product.item!.iTEMNAME!,
                              fontSize: AppDimensions.fontSizeMedium,
                              fontWeight: AppFontWeight.w700,
                              // style: TextStyle(
                              //   fontSize: 16,
                              //   fontWeight: FontWeight.bold,
                              //   color: AppTheme.primaryColor,
                              // ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text:
                                          'MRP: ₹ ${Utils.formatIndianAmount(double.tryParse(product.item!.sRATE1?.toString() ?? '0'))}',
                                      fontSize: AppDimensions.fontSizeSmall,
                                    ),
                                    SizedBox(height: 5),
                                    CommonText(
                                      text:
                                          'Disc: ${Utils.formatIndianAmount(double.tryParse(product.item!.sDISC?.toString() ?? '0'))}',
                                      fontSize: AppDimensions.fontSizeSmall,
                                    ),
                                    SizedBox(height: 5),
                                    CommonText(
                                      text:
                                          'Stock: ${Utils.numberFormat(double.tryParse(product.item!.aVLSTK?.toString() ?? '0'))}',
                                      textAlign: TextAlign.start,
                                      fontSize: AppDimensions.fontSizeSmall,
                                    ),
                                    CommonText(
                                      text:
                                          'Distributor : ${product.firm?.fIRMNAME?.toString() ?? ""}',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Right: Delete button and price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Close icon
                          InkWell(
                            onTap: () {
                              Get.dialog(
                                CommonMaterialDialog(
                                  title: 'Delete Confirmation',
                                  message:
                                      'Are you sure you want to delete this cart : ${product.item!.iTEMNAME}?',
                                  yesButtonText: 'Yes',
                                  noButtonText: 'No',
                                  onConfirm: () {
                                    final itemCd = product.item!.iTEMCD;

                                    controller.deleteProduct(
                                      product.cId.toString(),
                                    );

                                    final distributorController =
                                        Get.find<DistributorController>();
                                    if (distributorController
                                        .selectedDropdownFirmCode
                                        .value
                                        .isNotEmpty) {
                                      distributorController.requestStatus
                                          .remove(itemCd);
                                      distributorController.requestStatus
                                          .refresh();
                                    }

                                    //Refresh home screen after cart deletion
                                    if (Get.isRegistered<HomeController>()) {
                                      Get.find<HomeController>().allCallAPI();
                                    }

                                    // Remove request status entry so UI refreshes
                                    final productController =
                                        Get.find<ProductController>();
                                    productController.requestStatus.remove(
                                      itemCd,
                                    );
                                    productController.requestStatus.refresh();
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                  isLoading: controller.isDeleteLoading,
                                ),
                              );
                            },
                            child: const Icon(
                              // Icons.delete,
                              CupertinoIcons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // reduced spacing
                          Obx(
                            () => Visibility(
                              visible:
                                  product.aMOUNT.value.toString().isNotEmpty,
                              child: CommonText(
                                //'You pay : ₹${product.aMOUNT.value.toString()}',
                                text:
                                    'You pay : ₹${Utils.convertToDouble(product.aMOUNT.value)}',
                                fontSize: AppDimensions.fontSizeSmall,
                                color: AppColors.colorRed,
                              ),
                            ),
                          ),

                          SizedBox(height: 5),
                          Obx(
                            () => Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    int qty =
                                        Utils.convertToDouble(
                                          product.qUANTITY.value,
                                        ).round();
                                    qty++;

                                    controller.updateQty(product, qty);

                                    await controller.updateCart(
                                      product.iTEMCD!,
                                      qty,
                                      product.sYNCID.toString(),
                                      product.cId.toString(),
                                    );
                                  },
                                  child: Icon(Icons.remove, size: 20),
                                ),
                                SizedBox(width: 4),

                                Visibility(
                                  visible: true,
                                  child: SizedBox(
                                    width: 60,
                                    child: TextFormField(
                                      controller: product.quantityController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      textInputAction: TextInputAction.done,
                                      cursorColor:
                                          Theme.of(context).colorScheme.primary,
                                      onChanged: (value) async {
                                        int? val = int.tryParse(value);
                                        if (val != null &&
                                            val >
                                                0 /*&&
                                            val < product.item!.aVLSTK!*/ ) {
                                          product.qUANTITY.value = val;
                                          product.aMOUNT.value =
                                              val *
                                              (double.tryParse(
                                                    product.rATE.toString(),
                                                  ) ??
                                                  0.0);

                                          // product.aMOUNT.value =
                                          //     (Utils.convertToDouble(
                                          //               val.toString(),
                                          //             ) *
                                          //             Utils.convertToDouble(
                                          //               product.rATE ?? '0',
                                          //             ))
                                          //         .toString();

                                          await controller
                                              .updateCart(
                                                product.iTEMCD!,
                                                //int.parse(product.qUANTITY.value),
                                                product.qUANTITY.value,
                                                product.sYNCID.toString(),
                                                product.cId!.toString(),
                                              )
                                              .then((val) {
                                                product.aMOUNT.value =
                                                    product.qUANTITY.value *
                                                    (double.tryParse(
                                                          product.rATE
                                                              .toString(),
                                                        ) ??
                                                        0.0);

                                                // product.aMOUNT.value =
                                                //     (Utils.convertToDouble(
                                                //               product
                                                //                   .qUANTITY
                                                //                   .value,
                                                //             ) *
                                                //             Utils.convertToDouble(
                                                //               product.rATE ?? '0',
                                                //             ))
                                                //         .toString();
                                              });
                                        }
                                        // else {
                                        //   AppSnackBar.showGetXCustomSnackBar(
                                        //     message:
                                        //         '${product.item!.iTEMNAME!} has only ${product.item!.aVLSTK} in stock.',
                                        //   );
                                        // }
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

                                SizedBox(width: 4),

                                InkWell(
                                  onTap: () async {
                                    int qty =
                                        Utils.convertToDouble(
                                          product.qUANTITY.value,
                                        ).round();
                                    if (qty > 1) qty--;

                                    controller.updateQty(product, qty);

                                    await controller.updateCart(
                                      product.iTEMCD!,
                                      qty,
                                      product.sYNCID.toString(),
                                      product.cId.toString(),
                                    );
                                  },

                                  child: Icon(Icons.add, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _listUI(BuildContext context) {
    return Obx(() {
      final list = controller.mainList.value.data ?? [];

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _cartItemUI(list[index], context);
        },
      );
    });
  }

  Widget _cartItemUI(CartModel product, BuildContext context) {
    final minStk = Utils.convertToDouble(
      product.item?.mINSTK?.toString() ?? '0',
    );

    Color cstkColor = Colors.green;

    if (product.item!.hasCstk) {
      final cstk = Utils.convertToDouble(product.item?.cSTK);

      cstkColor = cstk <= 0 ? Colors.red : Colors.green;
    }

    Color stockLevelColor = Colors.green;

    if (product.item!.hasStockLevel) {
      final level = (product.item?.stockLevel ?? '').trim().toLowerCase();

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
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white60
              : Colors.grey[850],
      child: Container(
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]!
                  : Colors.grey[50]!,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT SIDE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.item!.iTEMNAME ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Rate : ₹ ${Utils.formatIndianAmount(double.tryParse(product.item!.sRATE1?.toString() ?? '0'))}",
                        ),
                        if (product.item!.sDISC != null)
                          Text("Disc : ${product.item!.sDISC}"),
                        // Text("Stock : ${product.item!.aVLSTK}"),
                        // Text(
                        //   avlStk <= 0
                        //       ? 'Out of Stock'
                        //       : avlStk < 100
                        //       ? 'Low Stock: ${product.item!.aVLSTK}'
                        //       : 'Stock: ${product.item!.aVLSTK}',
                        //   style: TextStyle(
                        //     color:
                        //         avlStk <= 0
                        //             ? Colors.red
                        //             : avlStk < 100
                        //             ? Colors.orange
                        //             : Colors.green,
                        //   ),
                        // ),
                        // Row(
                        //   children: [
                        //     if (hasavlStock)
                        //       CommonText(
                        //         text:
                        //             'Stock: ${Utils.formatIndianAmount(avlStk)}',
                        //         color: avlStkColor,
                        //       ),
                        //
                        //     if (hasStockLevel)
                        //       CommonText(
                        //         text: ' (${rawStockLevel.toString()})',
                        //         style: TextStyle(color: avlStkColor),
                        //       ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            if (product.item!.hasCstk)
                              CommonText(
                                text: 'Stock: ${product.item!.cSTK}',
                                color: cstkColor,
                              ),

                            if (product.item!.hasCstk &&
                                product.item!.hasStockLevel)
                              const SizedBox(width: 5),

                            if (product.item!.hasStockLevel)
                              Expanded(
                                child: CommonText(
                                  text: product.item!.stockLevel ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLine: 1,
                                  color: stockLevelColor,
                                ),
                              ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     if (hasStock && avlStk != 0)
                        //       CommonText(
                        //         text:
                        //             'Stock: ${Utils.formatIndianAmount(avlStk)} ',
                        //         color: avlStkColor,
                        //       ),
                        //
                        //     // if (stockLevel.isNotEmpty) const SizedBox(width: 5),
                        //     if (stockLevel.isNotEmpty)
                        //       CommonText(
                        //         text: stockLevel,
                        //         style: TextStyle(color: avlStkColor),
                        //       ),
                        //   ],
                        // ),
                        // Text(stockLevel, style: TextStyle(color: avlStkColor)),
                        CommonText(
                          text:
                              'Distributor : ${product.firm?.fIRMNAME?.toString() ?? ""}',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),

                  // RIGHT SIDE
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.dialog(
                            CommonMaterialDialog(
                              title: 'Delete Confirmation',
                              message:
                                  'Are you sure you want to delete this cart : ${product.item!.iTEMNAME}?',
                              yesButtonText: 'Yes',
                              noButtonText: 'No',
                              onConfirm: () {
                                final itemCd = product.item!.iTEMCD;

                                controller.deleteProduct(
                                  product.cId.toString(),
                                );

                                final distributorController =
                                    Get.find<DistributorController>();
                                if (distributorController
                                    .selectedDropdownFirmCode
                                    .value
                                    .isNotEmpty) {
                                  distributorController.requestStatus.remove(
                                    itemCd,
                                  );
                                  distributorController.requestStatus.refresh();
                                }
                                // if (Get.isRegistered<DistributorController>()) {
                                //   final distributorController =
                                //   Get.find<DistributorController>();
                                //   if (distributorController
                                //       .selectedDropdownFirmCode
                                //       .value
                                //       .isNotEmpty) {
                                //     distributorController.requestStatus.remove(
                                //       itemCd,
                                //     );
                                //     distributorController.requestStatus.refresh();
                                //   }
                                // }

                                //Refresh home screen after cart deletion
                                if (Get.isRegistered<HomeController>()) {
                                  Get.find<HomeController>().allCallAPI();
                                }

                                // Remove request status entry so UI refreshes
                                final productController =
                                    Get.find<ProductController>();
                                productController.requestStatus.remove(itemCd);
                                productController.requestStatus.refresh();
                              },
                              onCancel: () {
                                Get.back();
                              },
                              isLoading: controller.isDeleteLoading,
                            ),
                          );
                        },
                        child: const Icon(
                          // Icons.delete,
                          CupertinoIcons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // ⚠ Only amount is Obx
                      Obx(
                        () => Text(
                          "You pay: ₹${Utils.formatIndianAmount(Utils.convertToDouble(product.aMOUNT.value))}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      _qtyButtons(product), // separate function
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyButtons(CartModel product) {
    return Obx(() {
      int qty = Utils.convertToDouble(product.qUANTITY.value).round();

      return Row(
        children: [
          // ➖ Decrease
          InkWell(
            onTap: () async {
              if (qty > 1) qty--;
              controller.updateQty(product, qty);
              await controller.updateCart(
                product.iTEMCD!,
                qty,
                product.sYNCID.toString(),
                product.cId.toString(),
              );
            },
            child: const Icon(Icons.remove, size: 20),
          ),

          const SizedBox(width: 4),

          SizedBox(
            width: 60,
            child: TextFormField(
              controller: product.quantityController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],

              // onChanged: (value) async {
              //   int? val = int.tryParse(value);
              //   if (val != null &&
              //       val >
              //           0 /*&&
              //                             val < product.item!.aVLSTK!*/ ) {
              //     product.qUANTITY.value = val.toString();
              //     // product.aMOUNT.value =
              //     //     val *
              //     //     (double.tryParse(
              //     //           product.rATE ?? '0',
              //     //         ) ??
              //     //         0.0).toString();
              //
              //     product.aMOUNT.value =
              //         (Utils.convertToDouble(
              //           val.toString(),
              //         ) *
              //             Utils.convertToDouble(
              //               product.rATE ?? '0',
              //             ))
              //             .toString();
              //
              //     await controller
              //         .updateCart(
              //       product.iTEMCD!,
              //       int.parse(product.qUANTITY.value),
              //       product.sYNCID.toString(),
              //       product.cId!.toString(),
              //     )
              //         .then((val) {
              //       // product.aMOUNT.value =
              //       //     product.qUANTITY.value *
              //       //     (double.tryParse(
              //       //           product.rATE ?? '0',
              //       //         ) ??
              //       //         0.0);
              //
              //       product.aMOUNT.value =
              //           (Utils.convertToDouble(
              //             product
              //                 .qUANTITY
              //                 .value,
              //           ) *
              //               Utils.convertToDouble(
              //                 product.rATE ?? '0',
              //               ))
              //               .toString();
              //     });
              //   }
              //   // else {
              //   //   AppSnackBar.showGetXCustomSnackBar(
              //   //     message:
              //   //         '${product.item!.iTEMNAME!} has only ${product.item!.aVLSTK} in stock.',
              //   //   );
              //   // }
              // },

              // onChanged: (value) async {
              //   int newQty = int.tryParse(value) ?? 1;
              //   controller.updateQty(product, newQty);
              //   await controller.updateCart(
              //     product.iTEMCD!,
              //     newQty,
              //     product.sYNCID.toString(),
              //     product.cId.toString(),
              //   );
              // },
              onChanged: (value) async {
                // When field is empty → allow empty but do nothing
                if (value.isEmpty) {
                  // keep model qty same or clear controller only
                  return;
                }

                // When user types something but it's not a valid number
                int? newQty = int.tryParse(value);

                if (newQty == null) {
                  return;
                }

                // Qty must be minimum 1
                if (newQty < 1) {
                  newQty = 1;
                  product.quantityController.text = "1";
                  product.quantityController.selection =
                      TextSelection.fromPosition(TextPosition(offset: 1));
                }

                // Update UI values
                controller.updateQty(product, newQty);

                // Update API
                await controller.updateCart(
                  product.iTEMCD!,
                  newQty,
                  product.sYNCID.toString(),
                  product.cId.toString(),
                );
              },

              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // ➕ Increase
          InkWell(
            onTap: () async {
              qty++;
              controller.updateQty(product, qty);
              await controller.updateCart(
                product.iTEMCD!,
                qty,
                product.sYNCID.toString(),
                product.cId.toString(),
              );
            },
            child: const Icon(Icons.add, size: 20),
          ),
        ],
      );
    });
  }
}
