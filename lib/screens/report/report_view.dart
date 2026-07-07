import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/screens/account_ledger/account_ledger_view.dart';
import 'package:arham_b2c/screens/outstanding/outstanding_view.dart';
import 'package:arham_b2c/screens/report/report_controller.dart';
import 'package:arham_b2c/screens/sales_register/sales_register_view.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_bar.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_date_picker.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../app/app_date_format.dart';
import '../../widgets/app_hints.dart';

class ReportView extends StatelessWidget {
  ReportView({super.key}){
    _startHintTimer();
  }

  final ReportController controller = Get.put(ReportController());

  void _startHintTimer() {
    Future.delayed(const Duration(seconds: 6), () {
      if (!AppHints.reportsFilterHintShown.value) {
        _fadeOutHint();
      }
    });
  }
  void _fadeOutHint() {
    AppHints.reportsHintOpacity.value = 0.0;

    Future.delayed(const Duration(milliseconds: 400), () {
      AppHints.reportsFilterHintShown.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Reports',
        actions: [
          IconButton(
            onPressed: () {
              controller.isFilterVisible.value = !controller.isFilterVisible.value;
            },
            icon: Obx(() => Icon(
              controller.isFilterVisible.value
                  ? CupertinoIcons.slider_horizontal_3
                  : CupertinoIcons.slider_horizontal_3,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            )),
          )
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // --- 1. TABS SECTION (Moved to Top) ---
                TabBar(
                  controller: controller.tabController,
                  physics: NeverScrollableScrollPhysics(),
                  tabs: const [
                    Tab(text: "Sales"),
                    Tab(text: "Outstanding"),
                    Tab(text: "Ledger"),
                  ],
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: colorScheme.primary,
                ),

                // --- 2. SHARED FILTERS SECTION ---
                Obx((){
                  bool isFirmSelected = controller.selectedDropdownFirmCode.value.isNotEmpty;

                  // Only show the section if:
                  // - No firm is selected (user needs to pick one)
                  // - OR the toggle icon is active
                  bool showEntireSection = !isFirmSelected || controller.isFilterVisible.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // Distributor Dropdown
                        controller.isDropdownFirmLoading.isTrue
                            ? Center(child: Utils.commonCircularProgress())
                            : (controller.firmList.value.data == null ||
                            controller.firmList.value.data!.isEmpty)
                            ? Container()
                            : TypeAheadField<FirmModel>(
                          controller: controller.firmController.value,
                          focusNode: controller.firmFocus,
                          suggestionsCallback: (pattern) async {
                            return controller.firmList.value.data
                                ?.where((item) {
                              return item.firmName
                                  .toString()
                                  .trim()
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase());
                            }).toList();
                          },
                          itemBuilder: (context, FirmModel suggestion) {
                            return ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -2.0, vertical: -4.0),
                              title: CommonText(
                                text: suggestion.mobile1 != null &&
                                    suggestion.mobile1!
                                        .trim()
                                        .isNotEmpty
                                    ? "${suggestion.firmName.trim()} | ${suggestion.mobile1!.trim()}"
                                    : suggestion.firmName.trim(),
                                fontWeight: AppFontWeight.w400,
                                fontSize: 14,
                              ),
                            );
                          },
                          onSelected: (FirmModel selectedItem) {
                            controller.selectedDropdownFirm.value =
                                selectedItem;
                            controller.selectedDropdownFirmCode.value =
                                selectedItem.syncId.toString().trim();
                            controller.firmController.value.text =
                                selectedItem.firmName.trim();

                            // HIDE visibility immediately on selection
                            controller.isFilterVisible.value = false;

                            Utils.closeKeyboard(Get.context!);
                            controller.firmFocus.unfocus();
                            controller.triggerActiveTabFetch();
                          },
                          builder: (context, controller, focusNode) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                counter: const Offstage(),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.find<ReportController>()
                                              .firmController
                                              .value
                                              .clear();
                                          Get.find<ReportController>()
                                              .firmFocus
                                              .unfocus();
                                          Get.find<ReportController>()
                                              .selectedDropdownFirm
                                              .value = null;
                                          Get.find<ReportController>()
                                              .selectedDropdownFirmCode
                                              .value = '';
                                          Utils.closeKeyboard(
                                              Get.context!);
                                          Get.find<ReportController>()
                                              .clearAllData();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child:
                                          Icon(Icons.close, size: 20),
                                        ),
                                      ),
                                      const Icon(
                                          size: 20,
                                          Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                ),
                                labelText: 'Select Distributor',
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(4.0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: colorScheme.outline,
                                      width: 1),
                                  borderRadius:
                                  BorderRadius.circular(4.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: colorScheme.primary,
                                      width: 1),
                                  borderRadius:
                                  BorderRadius.circular(4.0),
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                              ),
                            );
                          },
                        ),
                        if (isFirmSelected && controller.isFilterVisible.value) ...[
                          const SizedBox(height: 16),
                          // Date Inputs
                          Row(
                            children: [
                              Obx(() => Visibility(
                                visible: controller.currentTabIndex.value != 1,
                                child: Expanded(
                                  child: CommonDatePickerInput(
                                    controller: controller.fromDateController.value,
                                    hintText: "From Date",
                                    isEnabled:
                                    controller.selectedDropdownFirmCode.isNotEmpty,
                                    onTap: () async {
                                      Utils.closeKeyboard(context);
                                      DateTime? selectedDate =
                                      await AppDatePicker.allDateEnable(
                                        context,
                                        controller.fromDateController.value,
                                      );
                                      if (selectedDate != null &&
                                          controller
                                              .selectedDropdownFirmCode.isNotEmpty) {
                                        String formattedDate =
                                        AppDatePicker.formatDate(selectedDate);
                                        controller.fromDateController.value.text =
                                            formattedDate;
                                        controller.triggerActiveTabFetch();
                                      }
                                    },
                                  ),
                                ),
                              )),
                              Obx(() => SizedBox(width: controller.currentTabIndex.value != 1 ? 16 : 0)),
                              Expanded(
                                child: CommonDatePickerInput(
                                  controller: controller.toDateController.value,
                                  hintText: "To Date",
                                  isEnabled:
                                  controller.selectedDropdownFirmCode.isNotEmpty,
                                  onTap: () async {
                                    Utils.closeKeyboard(context);
                                    DateTime? selectedDate =
                                    await AppDatePicker.allDateEnable(
                                      context,
                                      controller.toDateController.value,
                                    );
                                    if (selectedDate != null &&
                                        controller
                                            .selectedDropdownFirmCode.isNotEmpty) {
                                      String formattedDate =
                                      AppDatePicker.formatDate(selectedDate);
                                      controller.toDateController.value.text =
                                          formattedDate;
                                      controller.triggerActiveTabFetch();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Search Bar
                          if (controller.selectedDropdownFirmCode.isNotEmpty)
                            CommonAppInput(
                              textInputAction: TextInputAction.done,
                              textEditingController:
                              controller.searchGroupController.value,
                              suffixIcon: controller.searchQuery.value.isNotEmpty
                                  ? Icons.close
                                  : null,
                              hintText: "Search here..",
                              maxLength: 40,
                              focusNode: controller.searchGroupFocus,
                              onChanged: (text) {
                                controller.searchQuery.value = text;
                                controller.filterData();
                              },
                              onSuffixClick: () {
                                controller.searchGroupController.value.clear();
                                Utils.closeKeyboard(context);
                                controller.searchQuery.value = '';
                                controller.filterData();
                              },
                            ),
                          const SizedBox(height: 10),
                        ]
                      ],
                    ),
                  );
                }),

                // --- 3. TAB VIEWS ---
                Expanded(
                  child: Obx(
                        () => controller.selectedDropdownFirmCode.value.isNotEmpty
                        ? TabBarView(
                      controller: controller.tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SalesRegisterView(),
                        OutstandingView(),
                        AccountLedgerView(),
                      ],
                    )
                        : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5,),
                          CommonText(
                            text: 'Please Select Distributor first',
                            fontSize: AppDimensions.fontSizeLarge,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Obx(() {
            if (AppHints.reportsFilterHintShown.value) {
              return const SizedBox.shrink();
            }

            return Positioned(
              top: 0,                    // below app bar + safe area
              right: 5,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                opacity: AppHints.reportsHintOpacity.value,
                child: SimpleFilterHintBubble(
                  onClose: () {
                    _fadeOutHint();
                  },
                ),
              ),
            );
          }),
        ],
      )
    );
  }
}



class AppHints {
  static final reportsFilterHintShown = false.obs;
  static final reportsHintOpacity = 1.0.obs;
}

const double bubbleWidth = 320.0;
class FilterHintBubble extends StatelessWidget {
  final VoidCallback onClose;
  final double arrowLeft; // 👈 dynamic horizontal position

  const FilterHintBubble({
    required this.onClose,
    required this.arrowLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Obx((){
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
                    "Showing last 7 days' orders. Use date filter to view older orders.",
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
              painter: TrianglePainter(Color(0xFF004881)),
            ),
          ),
        ],
      );
    });
  }
}


class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

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



class SimpleFilterHintBubble extends StatelessWidget {
  final VoidCallback onClose;

  const SimpleFilterHintBubble({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            CustomPaint(
              size: const Size(24, 12),   // width 24, height 12
              painter: TrianglePainter(const Color(0xFF004881)),
            ),
            SizedBox(width: 10,),
          ],
        ),
        Container(
          width: 380,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF004881),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommonText(
                  text: "Showing last month's orders. Use date filter to view older orders.",
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}