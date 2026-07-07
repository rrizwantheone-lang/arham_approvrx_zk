import 'package:arham_b2c/models/state_response.dart';
import 'package:arham_b2c/screens/profile/profile_response.dart';
import 'package:arham_b2c/screens/profile/profile_response_new.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../api/dio_client.dart';
import '../../app/app_snack_bar.dart';
import '../../app/app_url.dart';
import '../../utility/constants.dart';
import '../../utility/network.dart';
import '../../utility/utils.dart';

class ProfileController extends GetxController {
  var hasProfile = false.obs;

  var isLoading = false.obs;
  var isUpdateLoading = false.obs;
  var isDisable = false.obs;
  var isTextField = false.obs;

  Rx<TextEditingController> userCdController = TextEditingController().obs;
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<TextEditingController> userTypeController = TextEditingController().obs;
  Rx<TextEditingController> mobileNoController = TextEditingController().obs;

  FocusNode userCDFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode userTypeFocus = FocusNode();
  FocusNode mobileNoFocus = FocusNode();
  FocusNode firmFocus = FocusNode();

  Rx<TextEditingController> licenceExpireDaysController =
      TextEditingController().obs;
  Rx<TextEditingController> licenceStartDtController =
      TextEditingController().obs;
  Rx<TextEditingController> licenceEndDtController =
      TextEditingController().obs;
  Rx<TextEditingController> licenceRenewalDtController =
      TextEditingController().obs;
  Rx<TextEditingController> maxFirmsController = TextEditingController().obs;
  Rx<TextEditingController> maxUserController = TextEditingController().obs;

  FocusNode licenceExpireDaysFocus = FocusNode();
  FocusNode licenceStartDtFocus = FocusNode();
  FocusNode licenceEndDtFocus = FocusNode();
  FocusNode licenceRenewalDtFocus = FocusNode();
  FocusNode maxFirmsFocus = FocusNode();
  FocusNode maxUsersFocus = FocusNode();

  Rx<ProfileResponse> mainList = ProfileResponse().obs;
  RxList<ProfileModel> searchList =
      <ProfileModel>[].obs; // List to store all groups

  var isObscured = true.obs;

  void toggleObscured() {
    isObscured.value = !isObscured.value;
  }

  // Text controllers
  Rx<TextEditingController> businessTypeController =
      TextEditingController().obs;
  Rx<TextEditingController> firmNameController = TextEditingController().obs;
  Rx<TextEditingController> personNmController = TextEditingController().obs;
  Rx<TextEditingController> clientCdController = TextEditingController().obs;
  Rx<TextEditingController> clientPwdController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  FocusNode stateFocus = FocusNode();
  Rx<TextEditingController> stateCdController = TextEditingController().obs;
  FocusNode stateCDFocus = FocusNode();
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeController = TextEditingController().obs;
  Rx<TextEditingController> mobile1Controller = TextEditingController().obs;
  Rx<TextEditingController> mobile2Controller = TextEditingController().obs;
  Rx<TextEditingController> emailIdController = TextEditingController().obs;
  Rx<TextEditingController> registrationNo1Controller =
      TextEditingController().obs;
  Rx<TextEditingController> registrationNo2Controller =
      TextEditingController().obs;
  Rx<TextEditingController> drugLic1Controller = TextEditingController().obs;
  Rx<TextEditingController> expireDate1Controller = TextEditingController().obs;
  Rx<TextEditingController> drugLic2Controller = TextEditingController().obs;
  Rx<TextEditingController> expireDate2Controller = TextEditingController().obs;
  Rx<TextEditingController> drugLic3Controller = TextEditingController().obs;

  Rx<TextEditingController> zoneController = TextEditingController().obs;
  Rx<TextEditingController> upiController = TextEditingController().obs;
  Rx<TextEditingController> gstNoController = TextEditingController().obs;
  Rx<TextEditingController> gsttpyeController = TextEditingController().obs;
  Rx<TextEditingController> panNoController = TextEditingController().obs;
  Rx<TextEditingController> fssaiNoController = TextEditingController().obs;

  // Dropdown selections
  RxString selectedCity = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedBusinessType = ''.obs;
  RxString selectedGstType = ''.obs;

  // Terms and agreements
  RxBool termsAccepted = false.obs;
  RxBool promotionalAgreed = false.obs;

  // File paths
  RxString doc1Path = ''.obs;
  RxString doc2Path = ''.obs;

  var reg2Visible = false.obs;
  var drugLicense2Visible = false.obs;

  var isDropdownLoading = false.obs;
  Rx<StateResponse> stateList = StateResponse().obs;
  final Rx<StateModel?> selectedDropdownState = Rx<StateModel?>(null);
  RxString selectedDropdownStateName = ''.obs;
  RxString selectedDropdownStateCD = ''.obs;

  final List<String> bannerListData = [];

  void pickFile(int docNumber) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // type: FileType.custom,
      // allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'], // Allow both images & files
    );

    if (result != null) {
      String filePath = result.files.single.path ?? '';
      if (docNumber == 1) {
        doc1Path.value = filePath;
      } else if (docNumber == 2) {
        doc2Path.value = filePath;
      }
    }
  }

  void clearFile(int docNumber) {
    if (docNumber == 1) {
      doc1Path.value = '';
    } else if (docNumber == 2) {
      doc2Path.value = '';
    }
  }

  void signupValidation() {
    // if (selectedBusinessType.value.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please select business type.',
    //   );
    // } else if (firmNameController.value.text.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please enter the distributor name.',
    //   );
    // } else
      if (personNmController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter the person name.',
      );
    }
    // else if (clientCdController.value.text.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please enter your client code.',
    //   );
    // } else if (clientPwdController.value.text.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please enter your client password.',
    //   );
    // } else if (addressController.value.text.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(message: 'Please enter your address.');
    // } else if (pinCodeController.value.text.isNotEmpty &&
    //     pinCodeController.value.text.length < 6) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please enter a valid pin code.',
    //   );
    // } else if (mobile1Controller.value.text.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(message: 'Please enter mobile 1.');
    // } else if (mobile1Controller.value.text.isNotEmpty &&
    //     mobile1Controller.value.text.length != 10) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please enter a valid mobile 1.',
    //   );
    // }
    /*else if (mobile2Controller.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter mobile 2.');
    } */
    else if (mobile2Controller.value.text.isNotEmpty &&
        mobile2Controller.value.text.length != 10) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter a valid mobile 2.',
      );
    }
    // else if (emailIdController.value.text.isNotEmpty &&
    //     !Utils.isValidEmail(emailIdController.value.text)) {
    //   AppSnackBar.showGetXCustomSnackBar(message: 'Please enter valid email.');
    // } else if ((selectedGstType.value == 'Regular' ||
    //         selectedGstType.value == 'Composition') &&
    //     gstNoController.value.text.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(message: 'Please enter gst no.');
    // } else if (gstNoController.value.text.isNotEmpty &&
    //     gstNoController.value.text.length != 15) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please enter 15 digit gst no.',
    //   );
    // } else if ((selectedBusinessType.value == 'Chemist') &&
    //     drugLic1Controller.value.text.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(message: 'Please enter durg license.');
    // } else if ((selectedBusinessType.value == 'Chemist') &&
    //     doc1Path.value.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please attach durg license.',
    //   );
    // } else if (selectedBusinessType.value == 'Doctor' ||
    //     selectedBusinessType.value == 'Hospital' ||
    //     selectedBusinessType.value == 'General Store' &&
    //         registrationNo1Controller.value.text.isEmpty) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please enter Registration 1.',
    //   );
    // } else if (!termsAccepted.value /*|| !promotionalAgreed.value*/ ) {
    //   AppSnackBar.showGetXCustomSnackBar(
    //     message: 'Please accept terms and agreements.',
    //   );
    // }
    else {
      profileUpdate();
    }
  }

  Future<void> profileUpdate() async {
    isUpdateLoading(true);
    isDisable(true);

    try {
      if (await Network.isConnected()) {
        // Create MultipartFormData
        FormData formData = FormData();

        // Add text fields (Only non-null fields)
        Map<String, dynamic> fields = {
          'scUserCd': clientCdController.value.text,
          //'clientCd': clientCdController.value.text,
          //'clientPwd': clientPwdController.value.text,
          'businessType': selectedBusinessType.value,
          'firmName': firmNameController.value.text,
          'personNm': personNmController.value.text,
          'address': addressController.value.text,
          'city': selectedCity.value,
          'state': selectedState.value,
          'stateCd': stateCdController.value.text,
          'zone': zoneController.value.text,
          'pinCode': pinCodeController.value.text,
          'mobile1': mobile1Controller.value.text,
          'mobile2': mobile2Controller.value.text,
          'emailId': emailIdController.value.text,
          'upi': upiController.value.text,
          'gstNo': gstNoController.value.text,
          'gstType': selectedGstType.value,
          'panNo': panNoController.value.text,
          'fssaiNo': fssaiNoController.value.text,
          'registrationNo1': registrationNo1Controller.value.text,
          'registrationNo2': registrationNo2Controller.value.text,
          'drugLic1': drugLic1Controller.value.text,
          'drugLic2': drugLic2Controller.value.text,
          'drugLic3': drugLic3Controller.value.text,
          'termCondition': termsAccepted.value ? 1 : 0,
          'promotionalAgree': promotionalAgreed.value ? 1 : 0,
          'scFirmId': PreferenceUtils.getFirmID(),
          // 'termCondition': termsAccepted.value ? "true" : "false",
          // 'promotionalAgree': promotionalAgreed.value ? "true" : "false",
          // 'termCondition': termsAccepted.value ? "Y" : "N",
          // 'promotionalAgree': promotionalAgreed.value ? "Y" : "N",
        };

        fields.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });

        // if (doc1Path.value.isNotEmpty) {
        //   formData.files.add(
        //     MapEntry(
        //       'doc1',
        //       await MultipartFile.fromFile(
        //         doc1Path.value,
        //         filename: doc1Path.value.split('/').last,
        //       ),
        //     ),
        //   );
        // }

        // if (doc2Path.value.isNotEmpty) {
        //   formData.files.add(
        //     MapEntry(
        //       'doc2',
        //       await MultipartFile.fromFile(
        //         doc2Path.value,
        //         filename: doc2Path.value.split('/').last,
        //       ),
        //     ),
        //   );
        // }

        // API Call
        var response = await DioClient().postFormDataPut(
          AppURL.profileURL,
          formData,
        );

        // Handle response
        if (response != null) {
          clearForm();
          await fetchProfile();
          await Utils.successWithBack(response['message']);
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Unknown response from the server',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print(e);
      Utils.handleException(e, stackTrace);
      //Utils.handleException(Exception(e.toString()));
    } finally {
      isUpdateLoading(false);
      isDisable(false);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // userCdController.value.text = PreferenceUtils.getLoginUserCode();
    // userNameController.value.text = PreferenceUtils.getLoginUserName();
    // mobileNoController.value.text = PreferenceUtils.getLoginMobileNO();
    // firmNameController.value.text = PreferenceUtils.getFirmName();
    // if (PreferenceUtils.getLoginUserRole() == 'M') {
    //   userTypeController.value.text = 'Master';
    // } else {
    //   userTypeController.value.text = 'Master';
    // }

    // licenceStartDtController.value.text =
    //     Get.arguments?['LStartDt'] != null
    //         ? AppDatePicker.convertDateTimeFormat(
    //           Get.arguments?['LStartDt'] ?? '',
    //           'yyyy-MM-dd',
    //           'dd-MM-yyyy',
    //         )
    //         : '';
    // licenceEndDtController.value.text =
    //     Get.arguments?['LEndDt'] != null
    //         ? AppDatePicker.convertDateTimeFormat(
    //           Get.arguments?['LEndDt'] ?? '',
    //           'yyyy-MM-dd',
    //           'dd-MM-yyyy',
    //         )
    //         : '';
    // licenceRenewalDtController.value.text =
    //     Get.arguments?['LRenewalDt'] != null
    //         ? AppDatePicker.convertDateTimeFormat(
    //           Get.arguments?['LRenewalDt'] ?? '',
    //           'yyyy-MM-dd',
    //           'dd-MM-yyyy',
    //         )
    //         : '';
    // maxFirmsController.value.text = Get.arguments?['MaxFirms'] ?? '';
    // maxUserController.value.text = Get.arguments?['MaxUsers'] ?? '';
    //
    // if (Get.arguments?['LStartDt'] != null &&
    //     Get.arguments?['LEndDt'] != null) {
    //   String startDateStr = Get.arguments?['LStartDt'] ?? '';
    //   String endDateStr = Get.arguments?['LEndDt'] ?? '';
    //
    //   // Convert string to DateTime
    //   DateTime startDate = DateTime.parse(startDateStr);
    //   DateTime endDate = DateTime.parse(endDateStr);
    //
    //   // Calculate the difference in days
    //   int daysLeft = endDate.difference(startDate).inDays;
    //   licenceExpireDaysController.value.text = '$daysLeft Days';
    // }

    fetchState();
    fetchProfile();
  }

  @override
  void onClose() {
    // Dispose of all TextEditingControllers
    cityController.value.dispose();
    clientPwdController.value.dispose();
    businessTypeController.value.dispose();
    firmNameController.value.dispose();
    personNmController.value.dispose();
    addressController.value.dispose();
    stateController.value.dispose();
    pinCodeController.value.dispose();
    mobile1Controller.value.dispose();
    emailIdController.value.dispose();
    clientCdController.value.dispose();
    stateCdController.value.dispose();
    zoneController.value.dispose();
    mobile2Controller.value.dispose();
    upiController.value.dispose();
    gstNoController.value.dispose();
    gsttpyeController.value.dispose();
    panNoController.value.dispose();
    fssaiNoController.value.dispose();
    registrationNo1Controller.value.dispose();
    registrationNo2Controller.value.dispose();
    drugLic1Controller.value.dispose();
    drugLic2Controller.value.dispose();
    drugLic3Controller.value.dispose();

    selectedCity.value = '';
    selectedState.value = '';
    selectedBusinessType.value = '';
    selectedGstType.value = '';

    termsAccepted.value = false;
    promotionalAgreed.value = false;

    doc1Path.value = '';
    doc2Path.value = '';

    super.onClose();
  }

  void clearForm() {
    cityController.value.clear();
    clientPwdController.value.clear();
    businessTypeController.value.clear();
    firmNameController.value.clear();
    personNmController.value.clear();
    addressController.value.clear();
    stateController.value.clear();
    pinCodeController.value.clear();
    mobile1Controller.value.clear();
    emailIdController.value.clear();
    clientCdController.value.clear();
    stateCdController.value.clear();
    zoneController.value.clear();
    mobile2Controller.value.clear();
    upiController.value.clear();
    gstNoController.value.clear();
    gsttpyeController.value.clear();
    panNoController.value.clear();
    fssaiNoController.value.clear();
    registrationNo1Controller.value.clear();
    registrationNo2Controller.value.clear();
    drugLic1Controller.value.clear();
    drugLic2Controller.value.clear();
    drugLic3Controller.value.clear();

    selectedCity.value = '';
    selectedState.value = '';
    selectedBusinessType.value = '';
    selectedGstType.value = '';

    termsAccepted.value = false;
    promotionalAgreed.value = false;

    doc1Path.value = '';
    doc2Path.value = '';

    isTextField.value = false;
  }

  Future<void> fetchState() async {
    try {
      isDropdownLoading(true);

      // Static state data (Replacing API response)
      var staticResponse = {
        "message": "Data fetch successfully",
        "data": [
          {"state_cd": "01", "state_name": "Jammu & Kashmir"},
          {"state_cd": "02", "state_name": "Himachal Pradesh"},
          {"state_cd": "03", "state_name": "Punjab"},
          {"state_cd": "04", "state_name": "Chandigarh"},
          {"state_cd": "05", "state_name": "Uttarakhand"},
          {"state_cd": "06", "state_name": "Haryana"},
          {"state_cd": "07", "state_name": "Delhi"},
          {"state_cd": "08", "state_name": "Rajasthan"},
          {"state_cd": "09", "state_name": "Uttar Pradesh"},
          {"state_cd": "10", "state_name": "Bihar"},
          {"state_cd": "11", "state_name": "Sikkim"},
          {"state_cd": "12", "state_name": "Arunachal Pradesh"},
          {"state_cd": "13", "state_name": "Nagaland"},
          {"state_cd": "14", "state_name": "Manipur"},
          {"state_cd": "15", "state_name": "Mizoram"},
          {"state_cd": "16", "state_name": "Tripura"},
          {"state_cd": "17", "state_name": "Meghalaya"},
          {"state_cd": "18", "state_name": "Assam"},
          {"state_cd": "19", "state_name": "West Bengal"},
          {"state_cd": "20", "state_name": "Jharkhand"},
          {"state_cd": "21", "state_name": "Odisha"},
          {"state_cd": "22", "state_name": "Chhattisgarh"},
          {"state_cd": "23", "state_name": "Madhya Pradesh"},
          {"state_cd": "24", "state_name": "Gujarat"},
          {"state_cd": "25", "state_name": "Daman & Diu"},
          {"state_cd": "26", "state_name": "Dadra & Nagar Haveli"},
          {"state_cd": "27", "state_name": "Maharashtra"},
          {"state_cd": "29", "state_name": "Karnataka"},
          {"state_cd": "30", "state_name": "Goa"},
          {"state_cd": "31", "state_name": "Lakshadweep"},
          {"state_cd": "32", "state_name": "Kerala"},
          {"state_cd": "33", "state_name": "Tamil Nadu"},
          {"state_cd": "34", "state_name": "Pondicherry"},
          {"state_cd": "36", "state_name": "Telangana"},
          {"state_cd": "37", "state_name": "Andhra Pradesh"},
          {"state_cd": "38", "state_name": "Ladakh"},
          {"state_cd": "97", "state_name": "Other Territory"},
        ],
      };

      // Parsing static response
      stateList.value = StateResponse.fromJson(staticResponse);

      if (stateList.value.data!.isNotEmpty) {
        if (stateList.value.message == 'Data fetch successfully') {
        } else {
          // Show failure message
          AppSnackBar.showGetXCustomSnackBar(
            message: stateList.value.message ?? 'Error fetching data',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: 'Error: No record found');
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
      //Utils.handleException(Exception(e.toString()));
    } finally {
      isDropdownLoading(false);
    }
  }

  Future<void> fetchProfile1() async {
    if (await Network.isConnected()) {
      try {
        isLoading(true);

        var response = await DioClient().getQueryParam(AppURL.profileURL);

        var newData = ProfileResponse.fromJson(response);

        if (newData.data != null && newData.data!.isNotEmpty) {
          if (newData.message == 'Data fetch successfully') {
            mainList.value = newData;
            searchList.value = mainList.value.data!;

            // selectedBusinessType.value =
            //     mainList.value.data![0].cLIENTBUSINESSTYPE!;
            // if ((selectedBusinessType.value == 'Medical' ||
            //     selectedBusinessType.value == 'Chemist')) {
            //   selectedBusinessType.value = 'Chemist';
            // } else if (selectedBusinessType.value == 'Hospital') {
            //   selectedBusinessType.value = 'Hospital';
            // } else if (selectedBusinessType.value == 'Doctor') {
            //   selectedBusinessType.value = 'Doctor';
            // }
            // firmNameController.value.text =
            //     mainList.value.data![0].cLIENTFIRMNAME!;
            // personNmController.value.text =
            //     mainList.value.data![0].cLIENTPERSONNM!;
            // clientCdController.value.text = mainList.value.data![0].cLIENTCD!;
            // clientPwdController.value.text = mainList.value.data![0].cLIENTPWD!;
            // addressController.value.text =
            //     mainList.value.data![0].cLIENTADDRESS!;
            // stateController.value.text =
            //     selectedState.value = mainList.value.data![0].cLIENTSTATE!;
            // stateCdController.value.text =
            //     mainList.value.data![0].cLIENTSTATECODE!;
            // cityController.value.text = mainList.value.data![0].cLIENTCITY!;
            // pinCodeController.value.text =
            //     mainList.value.data![0].cLIENTPINCODE!;
            // mobile1Controller.value.text =
            //     mainList.value.data![0].cLIENTMOBILE1!;
            // mobile2Controller.value.text =
            //     mainList.value.data![0].cLIENTMOBILE2!;
            // emailIdController.value.text =
            //     mainList.value.data![0].cLIENTEMAILID!;
            //
            // zoneController.value.text = mainList.value.data![0].cLIENTZONE!;
            // upiController.value.text = mainList.value.data![0].cLIENTUPI!;
            // selectedGstType.value = mainList.value.data![0].cLIENTGSTTYPE!;
            // if (selectedGstType.value == 'R' ||
            //     selectedGstType.value == 'Regular') {
            //   selectedGstType.value = 'Regular';
            // } else if (selectedGstType.value == 'C' ||
            //     selectedGstType.value == 'Composition') {
            //   selectedGstType.value = 'Composition';
            // } else if (selectedGstType.value == 'E' ||
            //     selectedGstType.value == 'Exempted') {
            //   selectedGstType.value = 'Exempted';
            // } else {
            //   selectedGstType.value = 'None';
            // }
            //
            // gstNoController.value.text = mainList.value.data![0].cLIENTGSTNO!;
            // panNoController.value.text = mainList.value.data![0].cLIENTPANNO!;
            // fssaiNoController.value.text =
            //     mainList.value.data![0].cLIENTFSSAINO!;
            //
            // registrationNo1Controller.value.text =
            //     mainList.value.data![0].cLIENTREGISTRATIONNO1!;
            // registrationNo2Controller.value.text =
            //     mainList.value.data![0].cLIENTREGISTRATIONNO2!;
            // if (registrationNo2Controller.value.text.isNotEmpty) {
            //   reg2Visible.value = true;
            // }
            //
            // drugLic1Controller.value.text =
            //     mainList.value.data![0].cLIENTDRUGLIC1!;
            // drugLic2Controller.value.text =
            //     mainList.value.data![0].cLIENTDRUGLIC2!;
            // drugLic3Controller.value.text =
            //     mainList.value.data![0].cLIENTDRUGLIC3!;
            //
            // // doc1Path.value = mainList.value.data![0].dOC1!.split('/').last;
            // // doc2Path.value = mainList.value.data![0].dOC2!.split('/').last;
            // doc1Path.value = mainList.value.data![0].dOC1!;
            // doc2Path.value = mainList.value.data![0].dOC2!;
            //
            // if (doc1Path.value.isNotEmpty) {
            //   bannerListData.add(doc1Path.value);
            // }
            //
            // if (doc2Path.value.isNotEmpty) {
            //   bannerListData.add(doc2Path.value);
            // }
            //
            // if (doc2Path.value.isNotEmpty) {
            //   drugLicense2Visible.value = true;
            // }
            //
            // termsAccepted.value =
            //     mainList.value.data?[0].tERMCONDITION ?? false;
            // promotionalAgreed.value =
            //     mainList.value.data?[0].pROMOTIONALAGREE ?? false;

            final client = mainList.value.data![0];

            selectedBusinessType.value = client.cLIENTBUSINESSTYPE ?? '';
            if (selectedBusinessType.value == 'Medical' ||
                selectedBusinessType.value == 'Chemist') {
              selectedBusinessType.value = 'Chemist';
            } else if (selectedBusinessType.value == 'Hospital') {
              selectedBusinessType.value = 'Hospital';
            } else if (selectedBusinessType.value == 'Doctor') {
              selectedBusinessType.value = 'Doctor';
            }

            firmNameController.value.text = client.cLIENTFIRMNAME ?? '';
            personNmController.value.text = client.cLIENTPERSONNM ?? '';
            clientCdController.value.text = client.cLIENTCD ?? '';
            clientPwdController.value.text = client.cLIENTPWD ?? '';
            addressController.value.text = client.cLIENTADDRESS ?? '';
            stateController.value.text =
                selectedState.value = client.cLIENTSTATE ?? '';
            stateCdController.value.text = client.cLIENTSTATECODE ?? '';
            cityController.value.text = client.cLIENTCITY ?? '';
            pinCodeController.value.text = client.cLIENTPINCODE ?? '';
            mobile1Controller.value.text = client.cLIENTMOBILE1 ?? '';
            mobile2Controller.value.text = client.cLIENTMOBILE2 ?? '';
            emailIdController.value.text = client.cLIENTEMAILID ?? '';
            zoneController.value.text = client.cLIENTZONE ?? '';
            upiController.value.text = client.cLIENTUPI ?? '';

            selectedGstType.value = client.cLIENTGSTTYPE ?? '';
            if (selectedGstType.value == 'R' ||
                selectedGstType.value == 'Regular') {
              selectedGstType.value = 'Regular';
            } else if (selectedGstType.value == 'C' ||
                selectedGstType.value == 'Composition') {
              selectedGstType.value = 'Composition';
            } else if (selectedGstType.value == 'E' ||
                selectedGstType.value == 'Exempted') {
              selectedGstType.value = 'Exempted';
            } else {
              selectedGstType.value = 'None';
            }

            gstNoController.value.text = client.cLIENTGSTNO ?? '';
            panNoController.value.text = client.cLIENTPANNO ?? '';
            fssaiNoController.value.text = client.cLIENTFSSAINO ?? '';
            registrationNo1Controller.value.text =
                client.cLIENTREGISTRATIONNO1 ?? '';
            registrationNo2Controller.value.text =
                client.cLIENTREGISTRATIONNO2 ?? '';

            if (registrationNo2Controller.value.text.isNotEmpty) {
              reg2Visible.value = true;
            }

            drugLic1Controller.value.text = client.cLIENTDRUGLIC1 ?? '';
            drugLic2Controller.value.text = client.cLIENTDRUGLIC2 ?? '';
            drugLic3Controller.value.text = client.cLIENTDRUGLIC3 ?? '';

            doc1Path.value = client.dOC1 ?? '';
            doc2Path.value = client.dOC2 ?? '';

            if (doc1Path.value.isNotEmpty) {
              bannerListData.add(doc1Path.value);
            }

            if (doc2Path.value.isNotEmpty) {
              bannerListData.add(doc2Path.value);
              drugLicense2Visible.value = true;
            }

            print(bannerListData);

            // termsAccepted.value = client.tERMCONDITION ?? false;
            // promotionalAgreed.value = client.pROMOTIONALAGREE ?? false;

            termsAccepted.value = (client.tERMCONDITION ?? 0) == 1;
            promotionalAgreed.value = (client.pROMOTIONALAGREE ?? 0) == 1;
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: response.data['message'],
            );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        }
      } catch (e, stackTrace) {
        Utils.handleException(e, stackTrace);
      } finally {
        isLoading(false);
      }
    } else {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
    }
  }

  Future<void> fetchProfile() async {
    if (!await Network.isConnected()) {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      return;
    }

    try {
      isLoading(true);

      final response = await DioClient().getQueryParam(AppURL.profileURL);
      final profile = ProfileResponseNew.fromJson(response);

      if (profile.status != true ||
          profile.data == null ||
          profile.data!.firms == null ||
          profile.data!.firms!.isEmpty) {
        hasProfile.value = false;
        AppSnackBar.showGetXCustomSnackBar(message: 'No record found.');
        return;
      }

      hasProfile.value = true;

      final user = profile.data!.user;
      final firm = profile.data!.firms!.first;

      /// ---------------- BUSINESS TYPE ----------------
      selectedBusinessType.value = firm.sCBUSINESSTYPE ?? '';
      if (selectedBusinessType.value == 'Medical' ||
          selectedBusinessType.value == 'Chemist') {
        selectedBusinessType.value = 'Chemist';
      }

      /// ---------------- FIRM DETAILS ----------------
      firmNameController.value.text = firm.sCFIRMNAME ?? '';
      personNmController.value.text = firm.sCPERSONNM ?? '';
      addressController.value.text = firm.sCADDRESS ?? '';
      cityController.value.text = firm.sCCITY ?? '';
      stateController.value.text = selectedState.value = firm.sCSTATE ?? '';
      stateCdController.value.text = firm.sCSTATECODE ?? '';
      pinCodeController.value.text = firm.sCPINCODE ?? '';
      zoneController.value.text = firm.sCZONE ?? '';
      upiController.value.text = firm.sCUPI ?? '';

      /// ---------------- CONTACT ----------------
      mobile1Controller.value.text = firm.sCMOBILE1 ?? '';
      mobile2Controller.value.text = firm.sCMOBILE2 ?? '';
      emailIdController.value.text = firm.sCEMAILID ?? '';

      /// ---------------- GST ----------------
      selectedGstType.value = firm.sCGSTTYPE ?? 'None';
      gstNoController.value.text = firm.sCGSTNO ?? '';
      panNoController.value.text = firm.sCPANNO ?? '';
      fssaiNoController.value.text = firm.sCFSSAINO ?? '';

      /// ---------------- REGISTRATION ----------------
      registrationNo1Controller.value.text = firm.sCREGISTRATIONNO1 ?? '';
      registrationNo2Controller.value.text = firm.sCREGISTRATIONNO2 ?? '';
      reg2Visible.value =
          registrationNo2Controller.value.text.isNotEmpty;

      /// ---------------- DRUG LICENSE ----------------
      drugLic1Controller.value.text = firm.sCDRUGLIC1 ?? '';
      drugLic2Controller.value.text = firm.sCDRUGLIC2 ?? '';
      drugLic3Controller.value.text = firm.sCDRUGLIC3 ?? '';

      /// ---------------- DOCUMENTS ----------------
      bannerListData.clear();
      doc1Path.value = firm.dOC1 ?? '';
      doc2Path.value = firm.dOC2 ?? '';

      if (doc1Path.value.isNotEmpty) bannerListData.add(doc1Path.value);
      if (doc2Path.value.isNotEmpty) {
        bannerListData.add(doc2Path.value);
        drugLicense2Visible.value = true;
      }

      /// ---------------- TERMS ----------------
      termsAccepted.value = firm.tERMCONDITION == 1;
      promotionalAgreed.value = firm.pROMOTIONALAGREE == 1;

      /// ---------------- USER DATA ----------------
      clientCdController.value.text = user?.sCUSERCD ?? '';
      clientPwdController.value.text = user?.sCUSERPWD ?? '';

    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isLoading(false);
    }
  }
}


