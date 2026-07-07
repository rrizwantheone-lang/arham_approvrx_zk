import 'package:arham_b2c/screens/re_order/order_base/order_base_view.dart';
import 'package:arham_b2c/screens/re_order/sales_base/sales_base_view.dart';
import 'package:arham_b2c/screens/re_order/re_order_controller.dart';
import 'package:arham_b2c/screens/shopping_cart/cart_view.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReOrderView extends StatelessWidget {
  ReOrderView({super.key});

  final ReOrderController controller = Get.put(ReOrderController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Re-Order'),
        actions: [
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
                    'isSales': 'Sales',
                  },
                  transition: Transition.rightToLeftWithFade
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
          tabs: [Tab(text: 'Order Base'), Tab(text: 'Sale Base')],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [OrderBaseView(), SalesBaseView()],
      ),
    );
  }
}
