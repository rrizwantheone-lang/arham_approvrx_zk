// import 'package:arham_b2c/app/app_date_format.dart';
// import 'package:arham_b2c/app/app_dimensions.dart';
// import 'package:arham_b2c/app/app_font_weight.dart';
// import 'package:arham_b2c/models/firm_response.dart';
// import 'package:arham_b2c/screens/reports/reports_controller.dart';
// import 'package:arham_b2c/screens/sales_register/sales_register_controller.dart';
// import 'package:arham_b2c/screens/outstanding/outstanding_controller.dart';
// // import 'package:arham_b2c/screens/outstanding/outstanding_view.dart';  // ← add when ready
// import 'package:arham_b2c/utility/utils.dart';
// import 'package:arham_b2c/widgets/common_app_bar.dart';
// import 'package:arham_b2c/widgets/common_date_picker.dart';
// import 'package:arham_b2c/widgets/common_text.dart';
// import 'package:arham_b2c/widgets/common_text_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
//
// import '../sales_register/sales_register_view.dart';
//
// class ReportsView extends StatelessWidget {
//   const ReportsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final reportsCtrl = Get.put(ReportsController());
//     final salesCtrl = Get.put(SalesRegisterController());
//     final outstandingCtrl = Get.put(OutstandingController());
//
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: CommonAppBar(
//           title: 'Reports',
//           actions: [
//             Obx(() => IconButton(
//               icon: Icon(
//                 reportsCtrl.showFilters.value
//                     ? Icons.filter_list_off
//                     : Icons.filter_list,
//               ),
//               onPressed: reportsCtrl.toggleFilters,
//             )),
//           ],
//         ),
//         body: SafeArea(
//           child: Column(
//             children: [
//               // ─── Tab Bar (always visible) ────────────────────────────────
//               Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.surface,
//                   border: Border(
//                     bottom: BorderSide(
//                       color: Theme.of(context).dividerColor,
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 child: const TabBar(
//                   tabs: [
//                     Tab(text: 'Sales Register'),
//                     Tab(text: 'Outstanding'),
//                   ],
//                   labelStyle: TextStyle(fontWeight: FontWeight.w600),
//                   indicatorWeight: 4,
//                 ),
//               ),
//
//               // ─── Collapsible Filters ──────────────────────────────────────
//               Obx(() => Visibility(
//                 visible: reportsCtrl.showFilters.value,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CommonDatePickerInput(
//                               controller: reportsCtrl.fromDateController.value,
//                               hintText: "From Date",
//                               isEnabled: true,
//                               onTap: () async {
//                                 Utils.closeKeyboard(context);
//                                 DateTime? selected = await AppDatePicker.allDateEnable(
//                                   context,
//                                   reportsCtrl.fromDateController.value,
//                                 );
//                                 if (selected != null) {
//                                   String formatted = AppDatePicker.formatDate(selected);
//                                   reportsCtrl.fromDateController.value.text = formatted;
//                                   reportsCtrl.refreshAllReports();
//                                 }
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: CommonDatePickerInput(
//                               controller: reportsCtrl.toDateController.value,
//                               hintText: "To Date",
//                               isEnabled: true,
//                               onTap: () async {
//                                 Utils.closeKeyboard(context);
//                                 DateTime? selected = await AppDatePicker.allDateEnable(
//                                   context,
//                                   reportsCtrl.toDateController.value,
//                                 );
//                                 if (selected != null) {
//                                   String formatted = AppDatePicker.formatDate(selected);
//                                   reportsCtrl.toDateController.value.text = formatted;
//                                   reportsCtrl.refreshAllReports();
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Distributor dropdown
//                       Obx(() => reportsCtrl.isDropdownFirmLoading.value
//                           ? const Center(child: CircularProgressIndicator())
//                           : TypeAheadField<FirmModel>(
//                         controller: reportsCtrl.firmController.value,
//                         focusNode: reportsCtrl.firmFocus,
//                         suggestionsCallback: (pattern) async {
//                           return reportsCtrl.firmList.value.data?.where((item) {
//                             return item.firmName
//                                 .toString()
//                                 .trim()
//                                 .toLowerCase()
//                                 .contains(pattern.toLowerCase());
//                           }).toList() ??
//                               [];
//                         },
//                         itemBuilder: (context, FirmModel suggestion) {
//                           return ListTile(
//                             visualDensity: const VisualDensity(
//                               horizontal: -2.0,
//                               vertical: -4.0,
//                             ),
//                             title: CommonText(
//                               text: suggestion.mobile1 != null &&
//                                   suggestion.mobile1!.trim().isNotEmpty
//                                   ? "${suggestion.firmName.trim()} | ${suggestion.mobile1!.trim()}"
//                                   : suggestion.firmName.trim(),
//                               fontWeight: AppFontWeight.w400,
//                               fontSize: 14,
//                             ),
//                           );
//                         },
//                         onSelected: (FirmModel selectedItem) {
//                           reportsCtrl.selectedDropdownFirm.value = selectedItem;
//                           reportsCtrl.selectedDropdownFirmCode.value =
//                               selectedItem.syncId.toString().trim();
//                           reportsCtrl.firmController.value.text =
//                               selectedItem.firmName.trim();
//                           Utils.closeKeyboard(context);
//                           reportsCtrl.firmFocus.unfocus();
//                           reportsCtrl.refreshAllReports();
//                         },
//                         builder: (context, controller, focusNode) {
//                           return TextField(
//                             controller: controller,
//                             focusNode: focusNode,
//                             decoration: InputDecoration(
//                               labelText: 'Select Distributor',
//                               suffixIcon: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   if (controller.text.isNotEmpty)
//                                     IconButton(
//                                       icon: const Icon(Icons.close, size: 20),
//                                       onPressed: () {
//                                         controller.clear();
//                                         reportsCtrl.selectedDropdownFirm.value = null;
//                                         reportsCtrl.selectedDropdownFirmCode.value = '';
//                                         reportsCtrl.firmController.value.clear();
//                                         reportsCtrl.refreshAllReports();
//                                       },
//                                     ),
//                                   const Icon(Icons.keyboard_arrow_down, size: 20),
//                                 ],
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 10,
//                                 horizontal: 12,
//                               ),
//                             ),
//                           );
//                         },
//                       )),
//                     ],
//                   ),
//                 ),
//               )),
//
//               // ─── Tab Content ──────────────────────────────────────────────
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     SalesRegisterView(),
//                     // Replace with your real Outstanding view when ready
//                     Center(child: CommonText(text: 'Outstanding Report (coming soon)')),
//                     // OutstandingView(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'package:arham_b2c/screens/account_ledger/account_ledger_view.dart';
import 'package:arham_b2c/screens/outstanding/outstanding_view.dart';
import 'package:arham_b2c/screens/reports/reports_filter_controller.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_view.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

const double bubbleWidth = 320.0;

class _ReportsViewState extends State<ReportsView> with SingleTickerProviderStateMixin {

  final GlobalKey _filterIconKey = GlobalKey();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // if (!Get.isRegistered<ReportsFilterController>()) {
    //   Get.put(ReportsFilterController(), permanent: true);
    // }

    // Initialize TabController
    _tabController = TabController(length: 3, vsync: this);

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Update the shared controller with the new index
        Get.find<ReportsFilterController>().setTabIndex(_tabController.index);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFilterHintIfNeeded();
    });
  }

  @override
  void dispose() {
    // if (Get.isRegistered<ReportsFilterController>()) {
    //   Get.delete<ReportsFilterController>();
    // }
    _tabController.dispose();
    super.dispose();
  }

  void _showFilterHintIfNeeded() {
    if (AppHints.reportsFilterHintShown) return;

    final iconContext = _filterIconKey.currentContext;
    if (iconContext == null) return;

    AppHints.reportsFilterHintShown = true;

    final overlay = Overlay.of(iconContext);
    final renderBox = iconContext.findRenderObject() as RenderBox;
    final iconPosition = renderBox.localToGlobal(Offset.zero);
    final iconSize = renderBox.size;

    // const bubbleWidth = 220.0;
    const triangleWidth = 20.0;
    const screenPadding = 5.0;

    final screenWidth = MediaQuery.of(iconContext).size.width;

    // 1️⃣ Bubble position (DECLARE FIRST)
    double left =
        iconPosition.dx + iconSize.width / 2 - bubbleWidth / 2;

    // Clamp bubble inside screen
    left = left.clamp(
      screenPadding,
      screenWidth - bubbleWidth - screenPadding,
    );

    // 2️⃣ Triangle position relative to bubble
    double arrowLeft =
        (iconPosition.dx + iconSize.width / 2) - left - (triangleWidth / 2);

    // Keep triangle inside bubble bounds
    arrowLeft = arrowLeft.clamp(
      12.0,
      bubbleWidth - triangleWidth - 12.0,
    );

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: iconPosition.dy + iconSize.height - 10,
        left: left,
        child: Material(
          color: Colors.transparent,
          child: _FilterHintBubble(
            arrowLeft: arrowLeft,
            onClose: () {
              if (overlayEntry.mounted) {
                overlayEntry.remove();
              }
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    final filterCtrl = Get.find<ReportsFilterController>();

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          filterCtrl.clearFirm();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CommonText(text: 'Reports', fontSize: 22,),
          actions: [
            Obx(() => IconButton(
              key: _filterIconKey,
              onPressed: (){
                filterCtrl.toggleFilterSection();
                },
              icon: Icon(filterCtrl.showFilterSection.value ? CupertinoIcons.slider_horizontal_3 : CupertinoIcons.slider_horizontal_3),
              tooltip: 'Filter',
            )),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Sales',),
              Tab(text: 'Outstanding',),
              Tab(text: 'Ledger',),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SalesRegisterView(),
            OutstandingView(),
            AccountLedgerView(),
          ],
        ),
      ),
    );
  }
}


class AppHints {
  static bool reportsFilterHintShown = false;
}

class _FilterHintBubble extends StatelessWidget {
  final VoidCallback onClose;
  final double arrowLeft; // 👈 dynamic horizontal position

  const _FilterHintBubble({
    required this.onClose,
    required this.arrowLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bubble
        Container(
          width: bubbleWidth,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF004881),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommonText(
                  text:
                  "Showing last week's orders. Use date filter to view older orders.",
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // Triangle (positioned manually)
        Positioned(
          top: 0,
          left: arrowLeft,
          child: CustomPaint(
            size: const Size(20, 10),
            painter: _TrianglePainter(Color(0xFF004881)),
          ),
        ),
      ],
    );
  }
}


class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

