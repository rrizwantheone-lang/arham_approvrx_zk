import 'package:arham_b2c/screens/home/home_controller.dart';
import 'package:arham_b2c/screens/home/home_screen.dart';
import 'package:arham_b2c/screens/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shopping_cart/cart_response.dart';

class OrderConfirmationView extends StatefulWidget {
  const OrderConfirmationView({super.key});

  @override
  State<OrderConfirmationView> createState() => _OrderConfirmationViewState();
}

class _OrderConfirmationViewState extends State<OrderConfirmationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;



  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();

    // ⏳ Delay redirection after animation (or fixed delay)
    Future.delayed(Duration(seconds: 3)).then((_) async{
      //Get.offAll(() => HomeView());

      //Newly added
      if (Get.isRegistered<HomeController>()) {
        final controller = Get.find<HomeController>();
        controller.cartList.value = CartResponse(data: []);
        controller.cartSearchList.clear();
      }

      Get.find<BottomNavController>().changeIndex(0);
      Get.offAll(() => HomeScreen());

      await Future.delayed(const Duration(milliseconds: 200));

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().allCallAPI();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(color: Colors.green),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(Icons.check_circle, color: Colors.white, size: 100),
            ),
            SizedBox(height: 15),
            Text(
              "ThankYou!",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 15),
            Text(
              "Your order has been placed.",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
