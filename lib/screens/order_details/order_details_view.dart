import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsView extends StatelessWidget {
  final dynamic orderNo;
  final dynamic billNo;
  final dynamic billDate;
  final dynamic orderAmount;
  final dynamic netAmount;
  final List<dynamic> orderItems;
  final dynamic partyName;
  final dynamic mobile1;

  const OrderDetailsView({
    super.key,
    required this.orderNo,
    required this.billNo,
    required this.billDate,
    required this.orderAmount,
    required this.netAmount,
    required this.orderItems,
    this.partyName,
    this.mobile1,
  });

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[300],
      // appBar: CommonAppBar(title: 'Order: ${orderNo}', ),
      appBar: AppBar(
        title: Text("Order: ${orderNo}"),
        backgroundColor: isDark ? Colors.black : Colors.grey[300],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Summary'),
            _summaryCard(context),

            const SizedBox(height: 16),

            _sectionTitle('Items'),
            _itemsCard(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: CommonText(
        text: title,
        fontSize: AppDimensions.fontSizeRegular,
        fontWeight: AppFontWeight.w600,
      ),
    );
  }

  Widget _summaryCard(BuildContext context) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Card(
      color:
          isDark
              ? Colors.grey[900]
              : Theme.of(Get.context!).colorScheme.surface,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(text: "Bill No: ${billNo}"),
                SizedBox(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 15),
                      CommonText(text: " ${billDate}"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: '${partyName.toString().capitalize}',
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                GestureDetector(
                  onTap:
                      (mobile1?.isNotEmpty ?? false)
                          ? () {
                            makePhoneCall(mobile1!);
                          }
                          : null,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey[100],
                    child: Icon(
                      Icons.call_outlined,
                      size: 20,
                      color:
                          (mobile1?.isNotEmpty ?? false)
                              ? const Color(0xFF004881)
                              : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            // SizedBox(height: 8,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     CommonText(text: 'Total Amount: ₹${Utils.formatIndianAmount(double.tryParse(orderAmount.toString()) ?? 0)}'),
            //     SizedBox(width: 30,),
            //     CommonText(text: 'Net Amount: ₹${Utils.formatIndianAmount(double.tryParse(netAmount.toString()) ?? 0)}'),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _itemsCard() {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Card(
      // color: Colors.white,
      color:
          isDark
              ? Colors.grey[900]
              : Theme.of(Get.context!).colorScheme.surface,

      elevation: 1,
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderItems.length,
            separatorBuilder:
                (_, __) => const Divider(height: 1, indent: 10, endIndent: 10),
            itemBuilder: (context, index) {
              final item = orderItems[index];

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ITEM NAME
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonText(
                            text: item.item?.iTEMNAME ?? 'Unknown Item',
                            fontWeight: AppFontWeight.w600,
                            maxLine: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        CommonText(
                          text: 'Amt: ₹ ${item.aMOUNT ?? 0}',
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// ITEM DETAILS ROW
                    Row(
                      children: [
                        CommonText(text: 'Qty: ${item.qUANTITY ?? 0}'),
                        SizedBox(width: 30),
                        CommonText(text: 'Rate: ${item.rATE ?? 0}'),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.grey[300],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(text: 'Net Amount'),
                    CommonText(
                      text:
                          '₹${Utils.formatIndianAmount(double.tryParse(netAmount.toString()) ?? 0)}',
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(text: 'Total Amount'),
                    CommonText(
                      text:
                          '₹${Utils.formatIndianAmount(double.tryParse(orderAmount.toString()) ?? 0)}',
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
