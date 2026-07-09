import 'package:arham_b2c/screens/report/report_controller.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesDetailsView extends StatelessWidget {
  final bool isWithVouch; // decide which layout to show
  final dynamic orderNo;
  final dynamic date;
  final dynamic bookCD;
  final dynamic partyCD;

  SalesDetailsView({
    super.key,
    required this.isWithVouch,
    this.orderNo,
    this.date,
    this.bookCD,
    this.partyCD,
  });

  final ReportController controller = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    final list = controller.salesExpandWithoutVocuhList.value.data ?? [];

    double totalAmount = list.fold<double>(0, (sum, item) {
      return sum + (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0);
    });

    final headerData = controller.selectedSalesRecord.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '#${headerData?.pARTYBL?.toString() ?? 'Sales Register Details'}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isExpandWithoutVouchLoading.value ||
            controller.isExpandWithVouchLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // final headerData = controller.selectedSalesRecord.value;

        if (isWithVouch) {
          final list = controller.salesExpandWithoutVocuhList.value.data ?? [];

          double totalAmount = list.fold<double>(0, (sum, item) {
            return sum +
                (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0);
          });
          return Column(
            children: [
              // _summaryCard(context, orderNo, date, bookCD, partyCD),
              Expanded(
                child: ListView(
                  children: [
                    _summaryCard(
                      context,
                      headerData?.account?.aCCNAME
                          ?.toString()
                          .capitalize, // Party Bill / Order No
                      headerData?.vOUCHDT?.toString(), // Date
                      headerData?.bOOKCD?.toString(), // Book Code
                      headerData?.pARTYCD?.toString(), // Account Name
                    ),
                    _buildWithVouchLayout(context),
                  ],
                ),
              ),
              _totalContainer(context, totalAmount),
            ],
          );
        } else {
          final list = controller.salesExpandWithoutVocuhList.value.data ?? [];

          double totalAmount = list.fold<double>(0, (sum, item) {
            return sum +
                (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0);
          });
          return Column(
            children: [
              // _summaryCard(context, orderNo, date, bookCD, partyCD),
              Expanded(
                child: ListView(
                  children: [
                    _summaryCard(
                      context,
                      headerData?.account?.aCCNAME
                          ?.toString()
                          .capitalize, // Party Bill / Order No
                      headerData?.vOUCHDT?.toString(), // Date
                      headerData?.bOOKCD?.toString(), // Book Code
                      headerData?.pARTYCD?.toString(), // Account Name
                    ),
                    _buildWithoutVouchLayout(context),
                  ],
                ),
              ),
              _totalContainer(context, totalAmount),
            ],
          );
        }
      }),
    );
  }

  // --------------------------------------------------
  // WITHOUT VOUCH (ITEM WISE)
  // --------------------------------------------------

  Widget _buildWithoutVouchLayout(BuildContext context) {
    final list = controller.salesExpandWithoutVocuhList.value.data ?? [];

    double totalAmount = list.fold<double>(0, (sum, item) {
      return sum + (double.tryParse(item.vOUCHAMT?.toString() ?? '0') ?? 0);
    });

    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Container(
        // margin: const EdgeInsets.all(10),
        // padding: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // color:
          //     Theme.of(context).brightness == Brightness.dark
          //         ? Colors.grey[850]
          //         : Colors.grey[200],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.brightness == Brightness.dark
                  ? Colors.grey[850]!
                  : Colors.white,
              theme.brightness == Brightness.dark
                  ? Colors.grey[900]!
                  : Colors.grey[50]!,
            ],
          ),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
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
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _row(
                        "Rate: ",
                        Utils.formatRate(item.rATE?.toString() ?? ''),
                      ),
                      Row(
                        children: [
                          CommonText(
                            text: 'Amount: ',
                            fontWeight: FontWeight.bold,
                          ),
                          CommonText(
                            text:
                                '₹${Utils.formatIndianAmount(double.tryParse(item.vOUCHAMT?.toString() ?? '0'))}',
                          ),
                        ],
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
    final list = controller.salesExpandWithVocuhList.value.data ?? [];

    double totalAmount = list.fold<double>(0, (sum, item) {
      return sum + (double.tryParse(item.bLAMOUNT?.toString() ?? '0') ?? 0);
    });

    double totalPaid = list.fold<double>(0, (sum, item) {
      return sum + (double.tryParse(item.bLPAID?.toString() ?? '0') ?? 0);
    });

    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        shadowColor: Colors.black12,
        child: Container(
          // margin: const EdgeInsets.all(10),
          // padding: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            // color:
            //     Theme.of(context).brightness == Brightness.dark
            //         ? Colors.grey[850]
            //         : Colors.grey[200],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.brightness == Brightness.dark
                    ? Colors.grey[850]!
                    : Colors.white,
                theme.brightness == Brightness.dark
                    ? Colors.grey[900]!
                    : Colors.grey[50]!,
              ],
            ),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              width: 1,
            ),
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
                              CommonText(
                                text: '${item.bLVDT ?? ''}',
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: Theme.of(context).colorScheme.primary,
                              ),
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
                    if (index != list.length - 1) Divider(thickness: 1),
                  ],
                );
              }),
            ],
          ),
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
          CommonText(text: value, textAlign: TextAlign.right),
        ],
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context,
    String? accName,
    String? date,
    String? bookCD,
    String? partyCd,
  ) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Container(
        // padding: EdgeInsets.all(12),
        padding: EdgeInsets.all(8.0),
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color:
          //     theme.brightness == Brightness.dark
          //         ? Colors.grey[850]
          //         : Colors.grey[200],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.brightness == Brightness.dark
                  ? Colors.grey[850]!
                  : Colors.white,
              theme.brightness == Brightness.dark
                  ? Colors.grey[900]!
                  : Colors.grey[50]!,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: "${accName ?? ''}",
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 4),
                CommonText(
                  text: date ?? '',
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color:
                          theme.brightness == Brightness.dark
                              ? Colors.grey[200]!
                              : Colors.grey[600]!,
                    ),
                  ),
                  child: CommonText(
                    text: "Book: ${bookCD ?? ''}",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalContainer(BuildContext context, double total) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 50,
            left: 12,
            right: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            color:
                theme.brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.grey[200],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(text: "Total Amount:", fontWeight: FontWeight.bold),
              CommonText(
                text: "₹${Utils.formatIndianAmount(total)}",
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          // _row(
          //   "Total Amount",
          //   Utils.formatIndianAmount(total),
          // ),
        ),
      ],
    );
  }
}
