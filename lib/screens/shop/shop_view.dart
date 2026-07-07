import 'package:arham_b2c/screens/shop/distributor/distributor_view.dart';
import 'package:arham_b2c/screens/shop/product/product_view.dart';
import 'package:arham_b2c/screens/shop/shop_controller.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_view.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopView extends StatelessWidget {
  ShopView({super.key});

  final ShopController controller = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {
              controller.scanHeaderBarcode(context);
            },
          ),
          Obx(() {
            final data = controller.cartList.value.data;

            final hasItems = data != null && data.isNotEmpty;
            final itemCount = data?.length ?? 0;

            return TextButton.icon(
              onPressed: () {
                Get.to(
                  () => CartView(),
                  arguments: {
                    'cartItems': controller.cartItems1,
                    'isSales': 'Shop',
                  },
                  transition: Transition.rightToLeftWithFade,
                );
              },
              icon: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -9, end: -6),
                showBadge: hasItems,
                badgeContent: Text(
                  itemCount > 9 ? '9+' : '$itemCount',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(5),
                ),
                child: const Icon(Icons.shopping_cart, size: 30),
              ),
              label: const Text("Cart", style: TextStyle(fontSize: 16)),
            );
          }),
        ],

        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.shopping_cart_rounded),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => ShoppingCartView()),
        //       );
        //     },
        //   ),
        // ],
        bottom: TabBar(
          controller: controller.tabController,
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: colorScheme.primary,
          // Uses theme primary color
          labelColor: colorScheme.primary,
          // Selected tab label
          unselectedLabelColor: colorScheme.onSurface,
          tabs: [Tab(text: 'Distributor'), Tab(text: 'Product')],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [DistributorView(), ProductView()],
      ),
    );
  }
}
