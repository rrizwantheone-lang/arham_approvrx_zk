import 'package:arham_b2c/api/dio_client.dart';
import 'package:arham_b2c/app/app_snack_bar.dart';
import 'package:arham_b2c/app/app_url.dart';
import 'package:arham_b2c/models/firm_response.dart';
import 'package:arham_b2c/utility/constants.dart' show Constants;
import 'package:arham_b2c/utility/network.dart';
import 'package:arham_b2c/utility/utils.dart' show Utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirmController extends GetxController {
  Rx<FirmResponse> mainList = FirmResponse().obs;
  RxList<FirmModel> searchList = <FirmModel>[].obs;

  final Rx<FirmModel?> selectedFirm = Rx<FirmModel?>(null);

  Rx<TextEditingController> searchGroupController = TextEditingController().obs;
  FocusNode searchGroupFocus = FocusNode();
  RxString searchQuery = ''.obs;
  RxString errorMsg = ''.obs;

  // var firmList = <FirmModel>[].obs;
  // var selectedFirm = Rxn<FirmModel>();
  var isLoading = false.obs;
  var requestStatus = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    //fetchDistributor();
    fetchFirm();
  }

  Future<void> fetchFirm() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);

        var response = await DioClient().get(AppURL.distributorFirmURL);

        mainList.value = FirmResponse.fromJson(response);
        if (mainList.value.data!.isNotEmpty) {
          if (mainList.value.message == 'Data fetched successfully') {
            searchList.value = mainList.value.data!;

            // Apply initial filtering based on the search query if any
            filterData();
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          errorMsg.value = 'No record found';
          //AppSnackBar.showGetXCustomSnackBar(message: 'No record found');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
        //Utils.handleException(Exception(e.toString()));
      } finally {
        isLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  void filterData() {
    List<FirmModel> filteredList = searchList; // Start with full list

    // Apply Search Query Filtering
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase();
      filteredList =
          filteredList.where((group) {
            return (group.firmName.toLowerCase().contains(query)) ||
                (group.firmId.toString().toLowerCase().contains(query)) ||
                (group.syncId.toString().toLowerCase().contains(query));
          }).toList();

      // If search results are empty, show "No records found"
      if (filteredList.isEmpty) {
        mainList.value.data = [];
        mainList.refresh();
        return;
      }
    }

    // Update the payment list
    mainList.value.data = filteredList;
    mainList.refresh(); // Update UI
  }

  // Future<void> fetchDistributor() async {
  //   if (await Network.isConnected()) {
  //     try {
  //       isLoading(true);
  //
  //       var response = await DioClient().getQueryParam(AppURL.getFirmURL);
  //
  //       var data = response['data'] as List;
  //
  //       if (data.isNotEmpty) {
  //         firmList.assignAll(
  //           data.map((json) => FirmModel.fromJson(json)).toList(),
  //         );
  //
  //         if (firmList.isNotEmpty) {
  //           selectedFirm.value = firmList.first;
  //           PreferenceUtils.setUserCD(selectedFirm.value!.userCD);
  //           PreferenceUtils.setFirmID(selectedFirm.value!.firmId);
  //           PreferenceUtils.setCustID(selectedFirm.value!.custId);
  //           PreferenceUtils.setSyncID(selectedFirm.value!.syncId);
  //           PreferenceUtils.setFirmName(selectedFirm.value!.firmName);
  //         }
  //       } else {
  //         AppSnackBar.showGetXCustomSnackBar(
  //           message: response['message'] ?? 'No record found.',
  //         );
  //       }
  //     } catch (e) {
  //       Utils.handleException(e);
  //Utils.handleException(Exception(e.toString()));
  //     } finally {
  //       isLoading(false);
  //     }
  //   } else {
  //     AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
  //   }
  // }

  //Client request already exists
  Future<void> sendPostRequest(String syncId, String firmName) async {
    try {
      if (requestStatus[syncId] == 'loading') return;

      requestStatus[syncId] = 'loading';
      requestStatus.refresh();

      if (await Network.isConnected()) {
        var response = await DioClient().post(AppURL.sendRequest, {
          'syncId': syncId,
          'moduleNo':'0101'
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['message'] == 'Client request already exists') {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );

            requestStatus[syncId] = 'error'; // Show tick mark ✅
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: 'Request sent success : \n$syncId with $firmName',
              backgroundColor: Colors.green,
            );
            requestStatus[syncId] = 'success'; // Show tick mark ✅
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );

          requestStatus[syncId] = 'error';
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      requestStatus[syncId] = 'error';
      Utils.handleException(e, stackTrace);
    } finally {
      requestStatus.refresh();
    }
  }

  Future<void> sendPostRequest1(String syncId, String firmName) async {
    if (requestStatus[syncId] == 'loading') return;

    requestStatus[syncId] = 'loading';
    requestStatus.refresh();

    try {
      var response = await DioClient().post1(AppURL.sendRequest, {
        'syncId': syncId,
      });

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        AppSnackBar.showGetXCustomSnackBar(
          message: 'Request sent success : \n$syncId with $firmName',
          backgroundColor: Colors.green,
        );
        requestStatus[syncId] = 'success'; // Show tick mark ✅
      } else {
        requestStatus[syncId] = 'error';
      }
    } catch (e, stackTrace) {
      requestStatus[syncId] = 'error';
      Utils.handleException(e, stackTrace);
    } finally {
      requestStatus.refresh();
    }
  }
}
