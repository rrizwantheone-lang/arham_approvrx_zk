import 'package:arham_b2c/screens/report/report_controller.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/js.dart';

import '../../../app/app_date_format.dart';
import '../../../app/app_font_weight.dart';

class OutstandingDetailsView extends StatelessWidget {
  final bool isWithVouch; // decide which layout to show
  final dynamic orderNo;
  final dynamic invDate;
  final dynamic dueDate;
  final dynamic dueDays;
  final dynamic billAmt;
  final dynamic paidAmt;
  final dynamic pendingAmt;
  final dynamic bookCD;

  OutstandingDetailsView({
    super.key,
    required this.isWithVouch,
    this.orderNo,
    this.invDate,
    this.dueDate,
    this.dueDays,
    this.billAmt,
    this.paidAmt,
    this.pendingAmt,
    this.bookCD,

  });

  final ReportController controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    final headerData = controller.selectedOutstandingRecord.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('#${headerData?.pARTYBL?.toString()  ?? "Outstanding Details"}', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Obx(() {
        if (controller.isExpandWithoutVouchLoading.value ||
            controller.isExpandWithVouchLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (isWithVouch) {
          final list = controller.outstandingExpandWithVocuhList.value.data ?? [];

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
                      headerData?.vOUCHDT?.toString(),
                      headerData?.dUEDATE?.toString(),
                      headerData?.bOOKCD?.toString(),
                      headerData?.dUEDAYS?.toString(),
                      headerData?.vOUCHAMT?.toString(),
                      headerData?.pAIDAMT?.toString(),
                      headerData?.oSAMT?.toString(),
                    ),
                    _buildWithVouchLayout(context),
                  ],
                )
              ),
              _totalContainer(context, totalAmount),
            ],
          );
        } else {
          final list = controller.outstandingExpandWithoutVocuhList.value.data ?? [];

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
                      headerData?.vOUCHDT?.toString(),
                      headerData?.dUEDATE?.toString(),
                      headerData?.bOOKCD?.toString(),
                      headerData?.dUEDAYS?.toString(),
                      headerData?.vOUCHAMT?.toString(),
                      headerData?.pAIDAMT?.toString(),
                      headerData?.oSAMT?.toString(),
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

  Widget _summaryCard(BuildContext context, String? invDate, String?dueDate, String? bookCD, String? dueDays, String? billAmt, String? paidAmt, String? pendingAmt,) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 16, color: theme.colorScheme.primary,),
                  CommonText(text: ' Inv Date: ', fontWeight: FontWeight.w600, color: theme.colorScheme.primary,),
                  CommonText(text: "${invDate ?? ''}",),
                  ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 16, color: Colors.red,),
                  CommonText(text: ' Due Date: ', fontWeight: FontWeight.w600,),
                  CommonText(text: '${AppDatePicker.convertDateTimeFormat(dueDate!, 'yyyy-MM-dd', 'yyyy-MM-dd')}'),
                  // CommonText(text: "${dueDate ?? ''}",),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 16, color: Colors.red,),
                  Text(
                    dueDate != null
                        ? controller.calculateDueDays(
                      AppDatePicker.convertDateTimeFormat(
                        dueDate,
                        'yyyy-MM-dd',
                        'yyyy-MM-dd',
                      ),
                    ) >=
                        0
                        ? ' ${controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(dueDate!, 'yyyy-MM-dd', 'yyyy-MM-dd'))} ${controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(dueDate!, 'dd-MM-yyyy', 'yyyy-MM-dd')) == 1 ? 'Day' : 'Days'}'
                        : ' ${-controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(dueDate!, 'yyyy-MM-dd', 'yyyy-MM-dd'))} ${-controller.calculateDueDays(AppDatePicker.convertDateTimeFormat(dueDate!, 'dd-MM-yyyy', 'yyyy-MM-dd')) == 1 ? 'Day' : 'Days'}'
                        : ' No due date',
                    style: TextStyle(
                      color:
                      dueDate != null
                          ? controller.calculateDueDays(
                        AppDatePicker.convertDateTimeFormat(
                          dueDate!,
                          'yyyy-MM-dd',
                          'yyyy-MM-dd',
                        ),
                      ) >=
                          0
                          ? Colors.green
                          : Colors.red
                          : Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10,),
                  CommonText(text: " Book: ${bookCD ?? ''}",),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: CommonText(
                  text: "Bill: ₹${Utils.formatIndianAmount(double.tryParse(billAmt ?? '0') ?? 0)}",
                  fontSize: 12,
                  fontWeight: AppFontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 3,),
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
                  text: "Paid: ₹${Utils.formatIndianAmount(double.tryParse(paidAmt ?? '0') ?? 0)}",
                  fontSize: 12,
                  fontWeight: AppFontWeight.w700,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 3,),
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
                  text: "Pending: ₹${Utils.formatIndianAmount(double.tryParse(pendingAmt ?? '0') ?? 0)}",
                  fontSize: 12,
                  fontWeight: AppFontWeight.w700,
                  color: Colors.red[700],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // --------------------------------------------------
  // WITHOUT VOUCH (ITEM WISE)
  // --------------------------------------------------

  Widget _buildWithoutVouchLayout(BuildContext context) {
    final list = controller.outstandingExpandWithoutVocuhList.value.data ?? [];

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
                        Utils.formatIndianAmount(
                          double.tryParse(item.vOUCHAMT?.toString() ?? '0'),
                        ),
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
    final list = controller.outstandingExpandWithVocuhList.value.data ?? [];

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
                    Utils.formatIndianAmount(
                      double.tryParse(item.bLAMOUNT?.toString() ?? '0'),
                    ),
                  ),
                  _row(
                    "Paid Amount",
                    Utils.formatIndianAmount(
                      double.tryParse(item.bLPAID?.toString() ?? '0'),
                    ),
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

  Widget _totalContainer(BuildContext context, double total) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(height: 20),
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
                CommonText(text: "Total Amount:", fontWeight: FontWeight.bold,),
                CommonText(text: "₹${Utils.formatIndianAmount(total)}", fontWeight: FontWeight.bold,),
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:arham_b2c/screens/report/report_controller.dart';
// import 'package:arham_b2c/widgets/common_text.dart';
// import 'package:arham_b2c/utility/utils.dart';
//
// class OutstandingDetailsView extends StatelessWidget {
//   final bool isWithVouch;
//
//   OutstandingDetailsView({super.key, required this.isWithVouch});
//
//   final ReportController controller = Get.find<ReportController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Outstanding Details"),
//       ),
//       body: Obx(() {
//         if (controller.isExpandWithoutVouchLoading.value ||
//             controller.isExpandWithVouchLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return Container(
//           margin: const EdgeInsets.all(12),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: Theme.of(context).colorScheme.surface,
//           ),
//           child: isWithVouch
//               ? _buildWithVouch(context)
//               : _buildWithoutVouch(context),
//         );
//       }),
//     );
//   }
//
//   // -----------------------------
//   // WITHOUT VOUCH
//   // -----------------------------
//   Widget _buildWithoutVouch(BuildContext context) {
//     final list =
//         controller.outstandingExpandWithoutVocuhList.value.data ?? [];
//
//     double total = list.fold<double>(
//       0,
//           (sum, item) =>
//       sum + (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0),
//     );
//
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ...List.generate(list.length, (index) {
//             final item = list[index];
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CommonText(
//                   text: item.bLBILLNO ?? '',
//                   fontWeight: FontWeight.bold,
//                 ),
//                 _row("Bill Amount",
//                     Utils.formatIndianAmount(double.tryParse(item.vOUCHAMT ?? '0'))),
//                 _row("Paid",
//                     Utils.formatIndianAmount(double.tryParse(item.pAIDAMT ?? '0'))),
//                 _row("Pending",
//                     Utils.formatIndianAmount(double.tryParse(item.oSAMT ?? '0'))),
//
//                 if (index != list.length - 1)
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 10),
//                     child: Divider(),
//                   ),
//               ],
//             );
//           }),
//
//           _totalSection(context, total),
//         ],
//       ),
//     );
//   }
//
//   // -----------------------------
//   // WITH VOUCH
//   // -----------------------------
//   Widget _buildWithVouch(BuildContext context) {
//     final list =
//         controller.outstandingExpandWithVouchList.value.data ?? [];
//
//     double total = list.fold<double>(
//       0,
//           (sum, item) =>
//       sum + (double.tryParse(item.oSAMT?.toString() ?? '0') ?? 0),
//     );
//
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ...List.generate(list.length, (index) {
//             final item = list[index];
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CommonText(
//                   text: item.bOOKCD ?? '',
//                   fontWeight: FontWeight.bold,
//                 ),
//                 _row("Vouch Date", item.vOUCHDT ?? ''),
//                 _row("Bill No", item.bLBILLNO ?? ''),
//                 _row("Pending",
//                     Utils.formatIndianAmount(double.tryParse(item.oSAMT ?? '0'))),
//
//                 if (index != list.length - 1)
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 10),
//                     child: Divider(),
//                   ),
//               ],
//             );
//           }),
//
//           _totalSection(context, total),
//         ],
//       ),
//     );
//   }
//
//   Widget _row(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CommonText(text: title),
//           CommonText(text: value, fontWeight: FontWeight.w600),
//         ],
//       ),
//     );
//   }
//
//   Widget _totalSection(BuildContext context, double total) {
//     final theme = Theme.of(context);
//
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         Container(
//           padding:
//           const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//           decoration: BoxDecoration(
//             borderRadius:
//             const BorderRadius.vertical(bottom: Radius.circular(15)),
//             color: theme.colorScheme.surfaceVariant,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const CommonText(
//                 text: "Total Pending",
//                 fontWeight: FontWeight.bold,
//               ),
//               CommonText(
//                 text: Utils.formatIndianAmount(total),
//                 fontWeight: FontWeight.bold,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }