import 'package:arham_b2c/screens/report/report_controller.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/js.dart';

import '../../../app/app_font_weight.dart';

class LedgerDetailsView extends StatelessWidget {
  final bool isWithVouch; // decide which layout to show

  LedgerDetailsView({super.key, required this.isWithVouch});

  final ReportController controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    final list = controller.ledgerExpandWithVocuhList.value.data ?? [];

    double totalAmount = list.fold<double>(0, (sum, item) {
      return sum +
          (double.tryParse(item.bLAMOUNT?.toString() ?? '0') ?? 0);
    });
    double totalPaid = list.fold<double>(0, (sum, item) {
      return sum +
          (double.tryParse(item.bLPAID?.toString() ?? '0') ?? 0);
    });

    final headerData = controller.selectedLedgerRecord.value;
    return Scaffold(
      appBar: AppBar(
        title: Text("#${headerData?.bILLNO.toString() ?? 'Ledger Details'}", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Obx(() {
        if (controller.isExpandWithoutVouchLoading.value ||
            controller.isExpandWithVouchLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (isWithVouch) {
          final list = controller.ledgerExpandWithVocuhList.value.data ?? [];

          double totalAmount = list.fold<double>(0, (sum, item) {
            return sum +
                (double.tryParse(item.bLAMOUNT?.toString() ?? '0') ?? 0);
          });

          double totalPaid = list.fold<double>(0, (sum, item) {
            return sum +
                (double.tryParse(item.bLPAID?.toString() ?? '0') ?? 0);
          });

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _summaryCard(
                      context,
                      headerData?.aCCNAME.toString(),
                      headerData?.vOUCHDT.toString(),
                      headerData?.bOOKCD.toString(),
                      headerData?.dRAMT.toString(),
                      headerData?.cRAMT.toString(),
                      headerData?.cLBAL.toString(),
                    ),
                    _buildWithVouchLayout(context),
                  ],
                )
              ),
              _totalContainerWithVouch(context, totalAmount, totalPaid),
            ],
          );
        } else {
          final list = controller.ledgerExpandWithoutVocuhList.value.data ?? [];

          double totalAmount = list.fold<double>(0, (sum, item) {
            return sum +
                (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0);
          });

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _summaryCard(
                      context,
                      headerData?.aCCNAME.toString(),
                      headerData?.vOUCHDT.toString(),
                      headerData?.bOOKCD.toString(),
                      headerData?.dRAMT.toString(),
                      headerData?.cRAMT.toString(),
                      headerData?.cLBAL.toString(),
                    ),
                    _buildWithoutVouchLayout(context),
                  ],
                )
              ),
              _totalContainer(context, totalAmount),
            ],
          );
        }
      }),
    );
  }

  Widget _summaryCard(BuildContext context, String? accName, String? vouchDate, String? bookCD, String? drAmt, String? crAmt, String? balanceAmt,) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, size: 16, color: theme.colorScheme.primary.withValues(alpha: 0.6),),
                  SizedBox(width: 4,),
                  CommonText(
                    text: "${accName ?? ''}",
                    maxLine: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: theme.colorScheme.primary,),
                      SizedBox(width: 4,),
                      CommonText(text: "${vouchDate ?? ''}", color: theme.colorScheme.primary, fontWeight: FontWeight.bold,),
                    ],
                  ),
                  SizedBox(height: 5,),
                  CommonText(text: "Book: ${bookCD ?? ''}", fontWeight: FontWeight.bold,),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
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
                          text: "Dr ₹${Utils.formatIndianAmount(double.tryParse(drAmt ?? '0') ?? 0)}",
                          fontSize: 12,
                          fontWeight: AppFontWeight.w700,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(width: 3,),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
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
                          text: "Cr ₹${Utils.formatIndianAmount(double.tryParse(crAmt ?? '0') ?? 0)}",
                          fontSize: 12,
                          fontWeight: AppFontWeight.w700,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CommonText(
                      text: "Balance ₹${Utils.formatIndianAmount(double.tryParse(balanceAmt ?? '0') ?? 0)}",
                      fontSize: 12,
                      fontWeight: AppFontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // WITHOUT VOUCH (ITEM WISE)
  // --------------------------------------------------

  Widget _buildWithoutVouchLayout(BuildContext context) {
    final list = controller.ledgerExpandWithoutVocuhList.value.data ?? [];

    double totalAmount = list.fold<double>(0, (sum, item) {
      return sum +
          (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0);
    });

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ITEMS
            ...List.generate(list.length, (index) {
              final item = list[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonText(
                        text: item.item?.iTEMNAME ?? '',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _row("Batch No: ", item.sIZECD ?? ''),
                      _row("Qty: ", item.qUANTITY?.toString() ?? ''),
                      _row(
                        "Free Qty: ",
                        (item.oTHERDESC?.toString().trim().isEmpty ?? true)
                            ? "0"
                            : item.oTHERDESC.toString(),
                      ),
                      // if ((item.oTHERDESC ?? '').isNotEmpty)
                      //   _row("Free Qty: ", item.oTHERDESC ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _row("Rate: ",
                          Utils.formatRate(item.rATE?.toString() ?? '')),
                      _row(
                        "Amount: ",
                        "₹${Utils.formatIndianAmount(double.tryParse(item.vOUCHAMT?.toString() ?? '0'),)}"
                      ),
                    ],
                  ),

                  if (index != list.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(thickness: 1),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // WITH VOUCH (BILL WISE)
  // --------------------------------------------------

  Widget _buildWithVouchLayout(BuildContext context) {
    final list = controller.ledgerExpandWithVocuhList.value.data ?? [];

    double totalAmount = list.fold<double>(0, (sum, item) {
      return sum +
          (double.tryParse(item.bLAMOUNT?.toString() ?? '0') ?? 0);
    });

    double totalPaid = list.fold<double>(0, (sum, item) {
      return sum +
          (double.tryParse(item.bLPAID?.toString() ?? '0') ?? 0);
    });

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(list.length, (index) {
              final item = list[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: '# ${item.bLBILLNO ?? ''}',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),

                      CommonText(text: 'Book: ${item.bLBOOKCD ?? ''}'),

                      SizedBox(
                        child: Row(
                          children: [
                            CommonText(text: '${item.bLVDT ?? ''}', color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600,),
                            SizedBox(width: 4,),
                            Icon(Icons.calendar_today_outlined, size: 12, color: Theme.of(context).colorScheme.primary,),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // _row("Book Code", item.bLBOOKCD ?? ''),
                  // _row("Vouch Date", item.bLVDT ?? ''),
                  // _row("Bill No", item.bLBILLNO ?? ''),
                  _row(
                    "Bill Amount",
                    "₹${Utils.formatIndianAmount(double.tryParse(item.bLAMOUNT?.toString() ?? '0'),)}",
                  ),
                  _row(
                    "Paid Amount",
                    "₹${Utils.formatIndianAmount(double.tryParse(item.bLPAID?.toString() ?? '0'),)}",
                  ),
                  if (index != list.length - 1)
                    Divider(thickness: 1),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }


  // --------------------------------------------------
  // COMMON ROW WIDGET
  // --------------------------------------------------

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(text: title, fontWeight: FontWeight.bold),
          CommonText(
            text: value,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _totalContainer(BuildContext context, double totalBill) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(height: 20,),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(text: "Total Bill Amount:", fontWeight: FontWeight.bold, textAlign: TextAlign.start,),
                CommonText(text: "₹${Utils.formatIndianAmount(totalBill)}", fontWeight: FontWeight.bold, textAlign: TextAlign.start,),
                // Expanded(child: CommonText(text: "Total Bill Amount: ₹${Utils.formatIndianAmount(totalBill)}", fontWeight: FontWeight.bold, textAlign: TextAlign.start,)),
                // CommonText(text: "|"),
                // Expanded(child: CommonText(text: "Total Paid Amount: ₹${Utils.formatIndianAmount(totalPaid)}", fontWeight: FontWeight.bold, textAlign: TextAlign.end,)),
              ],
            )
          // _row(
          //   "Total Amount",
          //   Utils.formatIndianAmount(total),
          // ),
        ),
      ],
    );
  }

  Widget _totalContainerWithVouch(BuildContext context, double totalBill, double totalPaid) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(height: 20,),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CommonText(text: "Total Bill Amount:", fontWeight: FontWeight.bold, textAlign: TextAlign.start,),
                // CommonText(text: "₹${Utils.formatIndianAmount(totalBill)}", fontWeight: FontWeight.bold, textAlign: TextAlign.start,),
                Expanded(child: CommonText(text: "Total Bill Amount: ₹${Utils.formatIndianAmount(totalBill)}", fontWeight: FontWeight.bold, textAlign: TextAlign.start,)),
                CommonText(text: "|"),
                Expanded(child: CommonText(text: "Total Paid Amount: ₹${Utils.formatIndianAmount(totalPaid)}", fontWeight: FontWeight.bold, textAlign: TextAlign.end,)),
              ],
            )
          // _row(
          //   "Total Amount",
          //   Utils.formatIndianAmount(total),
          // ),
        ),
      ],
    );
  }
}
