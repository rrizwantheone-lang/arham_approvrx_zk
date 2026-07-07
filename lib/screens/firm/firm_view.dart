import 'package:arham_b2c/app/app_font_weight.dart';
import 'package:arham_b2c/screens/firm/firm_controller.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:arham_b2c/widgets/common_app_input.dart';
import 'package:arham_b2c/widgets/common_button.dart';
import 'package:arham_b2c/widgets/common_no_message.dart';
import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirmView extends StatelessWidget {
  final FirmController controller = Get.put(FirmController());

  //final Rxn<FirmModel> selectedFirmForAction = Rxn<FirmModel>();

  FirmView({super.key}); // State variable to track selected firm for action

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Distributor')),
      body: SafeArea(
        child: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 16),
                CommonAppInput(
                  textInputAction: TextInputAction.done,
                  textEditingController: controller.searchGroupController.value,
                  //prifixIcon: Icons.search,
                  suffixIcon:
                      controller.searchQuery.value.isNotEmpty
                          ? Icons.close
                          : null,
                  hintText:
                      "Search here.. (i.e, Dist. Name, Dist. Id , Sync Id)",
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
                if (controller.mainList.value.data != null &&
                    controller.mainList.value.data!.isNotEmpty)
                  const SizedBox(height: 10),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchFirm();
                    },
                    child: _getView(context),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget _listUI(BuildContext context) {
    return ListView.builder(
      itemCount: controller.mainList.value.data!.length,
      itemBuilder: (context, index) {
        final ledgers = controller.mainList.value.data![index];
        final accId =
            ledgers.clientFirmLinks?.isNotEmpty == true
                ? ledgers.clientFirmLinks![0].aCCCD
                : '';
        final syncId = ledgers.syncId;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 1,
          shadowColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white60
              : Colors.grey[850],
          //shadowColor: Colors.black.withValues(alpha: 0.35),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]!
                  : Colors.grey[50]!,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 0.0,
              ),
              title: CommonText(
                text: ledgers.firmName,
                fontWeight: AppFontWeight.w600,
                //fontSize: 16,
                //style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: 'Distributor ID: ${ledgers.firmId}',
                    fontSize: 12,
                  ),
                  CommonText(text: 'Sync ID: $syncId', fontSize: 12),
                  CommonText(text: 'Assign ID: $accId', fontSize: 12),
                  const SizedBox(height: 4),

                  /// Dynamic Status and Button
                  Obx(() {
                    // final status = controller.requestStatus[syncId];
                    //
                    // final accCd =
                    //     ledgers.clientFirmLinks?.isNotEmpty == true
                    //         ? ledgers.clientFirmLinks![0].aCCCD
                    //         : '';
                    // //final accCd = ledgers.clientFirmLinks?[0].aCCCD;
                    // final accCdNotEmpty = accCd != null && accCd.isNotEmpty;
                    //
                    // /*final accessRight =
                    //     (ledgers.clientFirmLinks?.isNotEmpty == true)
                    //         ? ledgers.clientFirmLinks![0].aCCESSRIGHT
                    //         : false;*/
                    //
                    // final accessRight =
                    //     (ledgers.clientFirmLinks?.isNotEmpty == true)
                    //         ? (ledgers.clientFirmLinks![0].aCCESSRIGHT == 1)
                    //         : false;
                    //
                    // final syncVal =
                    //     (ledgers.clientFirmLinks?.isNotEmpty == true)
                    //         ? ledgers.clientFirmLinks![0].sYNCID?.toString()
                    //         : null;
                    //
                    // final syncIdNotEmpty = syncVal != null && syncVal.isNotEmpty;
                    //
                    // //TODO : Accept
                    // bool isMapped =
                    //     syncIdNotEmpty &&
                    //     (accessRight == 1 || accessRight == true) &&
                    //     accCdNotEmpty;
                    // //bool isNotMapped = syncIdNotEmpty && (accessRight == 0 || !accCdNotEmpty);
                    //
                    // //TODO : Reject
                    // bool isNotMapped =
                    //     syncIdNotEmpty &&
                    //     (accessRight == 0 || accessRight == false) &&
                    //     (accCdNotEmpty || !accCdNotEmpty);
                    //
                    // //TODO : Pending
                    // bool isPending =
                    //     (syncIdNotEmpty &&
                    //         !accCdNotEmpty &&
                    //         (accessRight == 2 || accessRight == false)) ||
                    //     status == 'success';
                    //
                    // String statusText = '';
                    // Color statusColor = Colors.blue;
                    //
                    // if (isMapped) {
                    //   statusText = 'Mapped';
                    //   statusColor = Colors.green;
                    // } else if (isNotMapped) {
                    //   statusText = 'Not Mapped';
                    //   statusColor = Colors.red;
                    // } else if (isPending) {
                    //   statusText = 'Your request is under process/review';
                    //   statusColor = Colors.blue;
                    // }

                    final status = controller.requestStatus[syncId];

                    final link =
                        (ledgers.clientFirmLinks?.isNotEmpty == true)
                            ? ledgers.clientFirmLinks!.first
                            : null;

                    final String accCd = link?.aCCCD ?? '';
                    final bool accCdNotEmpty = accCd.isNotEmpty;

                    final String syncVal = link?.sYNCID?.toString() ?? '';
                    final bool syncIdNotEmpty = syncVal.isNotEmpty;

                    final int? accessRight = link?.aCCESSRIGHT?.toInt();

                    final bool isMapped =
                        accCdNotEmpty && syncIdNotEmpty && accessRight == 1;

                    final bool isNotMapped =
                        accCdNotEmpty && syncIdNotEmpty && accessRight == 0;

                    final bool isRejected =
                        !accCdNotEmpty && syncIdNotEmpty && accessRight == 0;

                    final bool isPending =
                        !accCdNotEmpty && syncIdNotEmpty && accessRight == 2;

                    String statusText = '';
                    Color statusColor = Colors.blue;

                    if (isMapped) {
                      statusText = 'Mapped';
                      statusColor = Colors.green;
                    } else if (isNotMapped) {
                      statusText = 'Not Mapped';
                      statusColor = Colors.orange; // different from rejected
                    } else if (isRejected) {
                      statusText = 'Rejected';
                      statusColor = Colors.red;
                    } else if (isPending || status == 'success') {
                      statusText = 'Your request is under process / review';
                      statusColor = Colors.blue;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isMapped ||
                            isNotMapped ||
                            isRejected ||
                            isPending ||
                            status == 'success')
                          CommonText(
                            text: statusText,
                            color: statusColor,
                            fontWeight: AppFontWeight.w700,
                          ),
                        if (isMapped || isNotMapped || isRejected || isPending)
                          const SizedBox(height: 0),

                        // if (status != 'success' &&
                        //     accessRight == null &&
                        //     !accCdNotEmpty &&
                        //     !syncIdNotEmpty)

                        // if (status != 'success' &&
                        //     (ledgers.clientFirmLinks?.isEmpty ?? false))
                        if (status != 'success' && link == null)
                          CommonButton(
                            buttonText: 'Send Request',
                            onPressed: () async {
                              await controller.sendPostRequest(
                                syncId,
                                ledgers.firmName,
                              );
                            },
                            isLoading: status == 'loading',
                            isDisable: status == 'loading',
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
