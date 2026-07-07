import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arham_b2c/app/app_date_format.dart';
import 'package:arham_b2c/models/state_response.dart';
import 'package:arham_b2c/models/user_exits_response.dart';
import 'package:arham_b2c/screens/signup/pincode_response.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../../api/dio_client.dart';
import '../../app/app_snack_bar.dart';
import '../../app/app_url.dart';
import '../../utility/constants.dart';
import '../../utility/network.dart';
import '../../utility/utils.dart';

class SignupController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentStep = 0.obs;

  var errorMsg = ''.obs;
  Timer? _debounce;

  var isUserExitsLoading = false.obs;
  var isSignupLoading = false.obs;
  var isSignupDisable = false.obs;
  var isObscured = true.obs;

  void toggleObscured() {
    isObscured.value = !isObscured.value;
  }

  // Text controllers
  Rx<TextEditingController> businessTypeController =
      TextEditingController().obs;
  RxString selectedBusinessType = ''.obs;
  Rx<TextEditingController> firmNameController = TextEditingController().obs;
  Rx<TextEditingController> personNmController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeController = TextEditingController().obs;
  Rx<TextEditingController> zoneController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  FocusNode stateFocus = FocusNode();
  Rx<TextEditingController> stateCdController = TextEditingController().obs;
  FocusNode stateCDFocus = FocusNode();
  RxString selectedCity = ''.obs;
  RxString selectedState = ''.obs;

  Rx<TextEditingController> clientCdController = TextEditingController().obs;
  Rx<TextEditingController> clientPwdController = TextEditingController().obs;
  Rx<TextEditingController> mobile1Controller = TextEditingController().obs;
  Rx<TextEditingController> mobile2Controller = TextEditingController().obs;
  Rx<TextEditingController> emailIdController = TextEditingController().obs;
  Rx<TextEditingController> upiController = TextEditingController().obs;
  Rx<TextEditingController> referralCodeController =
      TextEditingController().obs;

  var drugLicense2Visible = false.obs;

  // File paths
  Rx<File?> doc1File = Rx<File?>(null); // Mobile
  Rx<File?> doc2File = Rx<File?>(null);

  Rxn<Uint8List?> doc1Web = Rxn<Uint8List>(); // Web
  Rxn<Uint8List?> doc2Web = Rxn<Uint8List>();

  RxnString doc1WebName = RxnString(); // Store filename
  RxnString doc2WebName = RxnString();

  Rx<TextEditingController> drugLic1Controller = TextEditingController().obs;
  Rx<TextEditingController> expireDate1Controller = TextEditingController().obs;
  Rx<TextEditingController> drugLic2Controller = TextEditingController().obs;
  Rx<TextEditingController> expireDate2Controller = TextEditingController().obs;
  Rx<TextEditingController> drugLic3Controller = TextEditingController().obs;
  Rx<TextEditingController> expireDate3Controller = TextEditingController().obs;
  Rx<TextEditingController> registrationNo1Controller =
      TextEditingController().obs;
  Rx<TextEditingController> registrationNo2Controller =
      TextEditingController().obs;
  var reg2Visible = false.obs;

  Rx<TextEditingController> gstTypeController = TextEditingController().obs;
  Rx<TextEditingController> gstNoController = TextEditingController().obs;
  Rx<TextEditingController> panNoController = TextEditingController().obs;
  Rx<TextEditingController> fssaiNoController = TextEditingController().obs;
  RxString selectedGstType = 'None'.obs;

  // Terms and agreements
  RxBool termsAccepted = false.obs;
  RxBool promotionalAgreed = false.obs;

  var isAreaDropdownLoading = false.obs;
  Rx<PinCodeResponse> areaList = PinCodeResponse().obs;
  final Rx<PinCodeModel?> selectedDropdownArea = Rx<PinCodeModel?>(null);
  RxString selectedDropdownAreaName = ''.obs;
  RxString selectedDropdownAreaCD = ''.obs;

  var isCityDropdownLoading = false.obs;
  Rx<PinCodeResponse> cityList = PinCodeResponse().obs;
  RxList<PinCodeModel> uniqueBlockList = <PinCodeModel>[].obs;
  final Rx<PinCodeModel?> selectedDropdownCity = Rx<PinCodeModel?>(null);
  RxString selectedDropdownCityName = ''.obs;
  RxString selectedDropdownCityCD = ''.obs;

  var isStateDropdownLoading = false.obs;
  Rx<StateResponse> stateList = StateResponse().obs;
  final Rx<StateModel?> selectedDropdownState = Rx<StateModel?>(null);
  RxString selectedDropdownStateName = ''.obs;
  RxString selectedDropdownStateCD = ''.obs;

  var isVerifyCheckLoading = false.obs;
  var isVerifyCheckDisable = false.obs;
  var isVerifyOTPLoading = false.obs;
  var isVerifyOTPDisable = false.obs;
  var isResendOTPLoading = false.obs;
  var isResendOTPDisable = false.obs;
  RxString mobileNo = ''.obs;
  RxBool isVerified = true.obs;
  Rx<TextEditingController> verifyOTPController = TextEditingController().obs;

  var resendSeconds = 60.obs;
  var isResendEnabled = false.obs;
  Timer? _resendTimer;

  void startResendTimer() {
    resendSeconds.value = 60;
    isResendEnabled.value = false;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendSeconds.value == 0) {
        timer.cancel();
        isResendEnabled.value = true;
      } else {
        resendSeconds.value--;
      }
    });
  }

  void pickFile(int docNumber) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      if (docNumber == 1) {
        doc1File.value = file;
      } else if (docNumber == 2) {
        doc2File.value = file;
      }
    }
  }

  void clearFile(int docNumber) {
    if (docNumber == 1) {
      doc1File.value = null;
    } else if (docNumber == 2) {
      doc2File.value = null;
    }
  }

  void signupValidation() {
    if (selectedBusinessType.value.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please select business type.',
      );
    } else if (firmNameController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message:
            'Please enter the ' +
            selectedBusinessType.value.toLowerCase() +
            ' name.',
      );
    } else if (personNmController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter the person name.',
      );
    } else if (clientCdController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter your User id.');
    } else if (clientPwdController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter your password.',
      );
    } else if (addressController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter your address.');
    } else if (pinCodeController.value.text.isNotEmpty &&
        pinCodeController.value.text.length < 6) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter a valid pin code.',
      );
    } else if (mobile1Controller.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter mobile 1.');
    } else if (mobile1Controller.value.text.isNotEmpty &&
        mobile1Controller.value.text.length != 10) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter a valid mobile 1.',
      );
    }
    /*else if (mobile2Controller.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter mobile 2.');
    } */
    else if (mobile2Controller.value.text.isNotEmpty &&
        mobile2Controller.value.text.length != 10) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter a valid mobile 2.',
      );
    } else if (emailIdController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter email.');
    } else if (emailIdController.value.text.isNotEmpty &&
        !Utils.isValidEmail(emailIdController.value.text)) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter valid email.');
    } else if ((selectedGstType.value == 'Regular' ||
            selectedGstType.value == 'Composition') &&
        gstNoController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter gst no.');
    } else if (gstNoController.value.text.isNotEmpty &&
        gstNoController.value.text.length != 15) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter 15 digit gst no.',
      );
    } else if ((selectedBusinessType.value == 'Chemist') &&
        drugLic1Controller.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter durg license.');
    } else if (selectedBusinessType.value == 'Chemist' &&
        doc1File.value == null) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please attach durg license.',
      );
    } else if ((selectedBusinessType.value == 'Doctor' ||
            selectedBusinessType.value == 'Hospital' ||
            selectedBusinessType.value == 'General Store') &&
        registrationNo1Controller.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please enter Registration 1.',
      );
    } else if (!termsAccepted.value /*|| !promotionalAgreed.value*/ ) {
      AppSnackBar.showGetXCustomSnackBar(
        message: 'Please accept terms and agreements.',
      );
    } else {
      signUpHttp();
      //signUpDio();
    }
  }

  bool validateCurrentStep(BuildContext context) {
    switch (currentStep.value) {
      case 0:
        if (selectedBusinessType.value.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please select business type.',
          );
          return false;
        }

        if (firmNameController.value.text.isEmpty) {
          // AppSnackBar.showGetXCustomSnackBar(
          //   message:
          //       'Please enter the ' +
          //       selectedBusinessType.value.toLowerCase() +
          //       ' name.',
          // );

          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter the firm name.',
          );
          return false;
        }

        if (personNmController.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter the person name.',
          );

          return false;
        }

        if (addressController.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter your address.',
          );
          return false;
        }

        if (pinCodeController.value.text.isNotEmpty &&
            pinCodeController.value.text.length < 6) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter a valid pin code.',
          );
          return false;
        }
        return true;

      case 1:
        if ((selectedBusinessType.value == 'Chemist') &&
            drugLic1Controller.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter durg license 1.',
          );
          return false;
        }

        if (selectedBusinessType.value == 'Chemist' && doc1File.value == null) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please attach durg license 1.',
          );
          return false;
        }

        if (selectedBusinessType.value == 'Chemist' &&
            expireDate1Controller.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please select dl expiry dt 1.',
          );
          return false;
        }

        if ((selectedBusinessType.value == 'Doctor' ||
                selectedBusinessType.value == 'Hospital' ||
                selectedBusinessType.value == 'General Store') &&
            registrationNo1Controller.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter Registration 1.',
          );
          return false;
        }

        if ((selectedGstType.value == 'Regular' ||
                selectedGstType.value == 'Composition') &&
            gstNoController.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(message: 'Please enter gst no.');
          return false;
        }

        if (gstNoController.value.text.isNotEmpty &&
            gstNoController.value.text.length != 15) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter 15 digit gst no.',
          );
          return false;
        }

        return true;

      case 2:
        if (clientCdController.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter your User id.',
          );
          return false;
        }

        if (clientPwdController.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter your password.',
          );
          return false;
        }

        if (mobile1Controller.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(message: 'Please enter mobile 1.');
          return false;
        }

        if (mobile1Controller.value.text.isNotEmpty) {
          final mobile = mobile1Controller.value.text;

          if (mobile.length != 10 ||
              !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
            AppSnackBar.showGetXCustomSnackBar(
              message:
                  'Please enter a valid Mobile 1 number (starting with 6-9).',
            );
            return false;
          }
        }

        if (mobile1Controller.value.text.isNotEmpty &&
            mobile1Controller.value.text.length != 10) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter a valid mobile 1.',
          );
          return false;
        }

        // if (mobile2Controller.value.text.isEmpty) {
        //   AppSnackBar.showGetXCustomSnackBar(message: 'Please enter mobile 2.');
        //   return false;
        // }

        if (mobile2Controller.value.text.isNotEmpty) {
          final mobile = mobile2Controller.value.text;

          if (mobile.length != 10 ||
              !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
            AppSnackBar.showGetXCustomSnackBar(
              message:
                  'Please enter a valid Mobile 2 number (starting with 6-9).',
            );
            return false;
          }
        }

        if (mobile2Controller.value.text.isNotEmpty &&
            mobile2Controller.value.text.length != 10) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter a valid mobile 2.',
          );
          return false;
        }

        if (emailIdController.value.text.isEmpty) {
          AppSnackBar.showGetXCustomSnackBar(message: 'Please enter email.');
          return false;
        }

        if (emailIdController.value.text.isNotEmpty &&
            !Utils.isValidEmail(emailIdController.value.text)) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please enter valid email.',
          );
          return false;
        }

        if (!termsAccepted.value /*|| !promotionalAgreed.value*/ ) {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Please accept terms and agreements.',
          );
          return false;
        }

        return true;

      default:
        return true;
    }
  }

  void nextStep(BuildContext context) {
    if (validateCurrentStep(context)) {
      if (currentStep.value < 2) {
        currentStep.value++;
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void submit(BuildContext context) {
    if (validateCurrentStep(context)) {
      //AppSnackBar.showGetXCustomSnackBar(message: "Signup completed!");
      signUpHttp();
      //signUpDio();
    }
  }

  // Future<void> signUp1() async {
  //   isLoading(true);
  //   isDisable(true);
  //
  //   try {
  //     if (await Network.isConnected()) {
  //       // Create MultipartFormData
  //       //FormData formData = FormData();
  //
  //       dio.FormData formData = dio.FormData();
  //
  //       // Add text fields (Only non-null fields)
  //       Map<String, dynamic> fields = {
  //         'clientCd': clientCdController.value.text,
  //         'clientPwd': clientPwdController.value.text,
  //         'businessType': selectedBusinessType.value,
  //         'firmName': firmNameController.value.text,
  //         'personNm': personNmController.value.text,
  //         'address': addressController.value.text,
  //         'city': selectedCity.value,
  //         'state': selectedState.value,
  //         'stateCd': stateCdController.value.text,
  //         'zone': zoneController.value.text,
  //         'pinCode': pinCodeController.value.text,
  //         'mobile1': mobile1Controller.value.text,
  //         'mobile2': mobile2Controller.value.text,
  //         'emailId': emailIdController.value.text,
  //         'upi': upiController.value.text,
  //         'gstNo': gstNoController.value.text,
  //         //'gstType': selectedGstType.value,
  //         "gstType":
  //             selectedGstType.value.isNotEmpty
  //                 ? selectedGstType.value[0].toUpperCase()
  //                 : '',
  //         'panNo': panNoController.value.text,
  //         'fssaiNo': fssaiNoController.value.text,
  //         'registrationNo1': registrationNo1Controller.value.text,
  //         'registrationNo2': registrationNo2Controller.value.text,
  //         'drugLic1': drugLic1Controller.value.text,
  //         'drugLic2': drugLic2Controller.value.text,
  //         'drugLic3': drugLic3Controller.value.text,
  //         'termCondition': termsAccepted.value ? "true" : "false",
  //         'promotionalAgree': promotionalAgreed.value ? "true" : "false",
  //         // 'termCondition': termsAccepted.value ? "Y" : "N",
  //         // 'promotionalAgree': promotionalAgreed.value ? "Y" : "N",
  //       };
  //
  //       fields.forEach((key, value) {
  //         if (value != null && value.toString().isNotEmpty) {
  //           formData.fields.add(MapEntry(key, value.toString()));
  //         }
  //       });
  //
  //       // Add files (Only if selected)
  //       if (doc1Path.value.isNotEmpty) {
  //         formData.files.add(
  //           MapEntry(
  //             'doc1',
  //             //await MultipartFile.fromFile(
  //             await dio.MultipartFile.fromFile(
  //               doc1Path.value,
  //               filename: doc1Path.value.split('/').last,
  //             ),
  //           ),
  //         );
  //       }
  //
  //       if (doc2Path.value.isNotEmpty) {
  //         formData.files.add(
  //           MapEntry(
  //             'doc2',
  //             //await MultipartFile.fromFile(
  //             await dio.MultipartFile.fromFile(
  //               doc2Path.value,
  //               filename: doc2Path.value.split('/').last,
  //             ),
  //           ),
  //         );
  //       }
  //
  //       // API Call
  //       var response = await DioClient().postFormDataPost(
  //         AppURL.signUPURL,
  //         formData,
  //       );
  //
  //       // Handle response
  //       if (response != null && response['message'] != null) {
  //         if (response['message'] == 'User Created') {
  //           clearForm();
  //
  //           await Utils.successWithBack(response['message']);
  //         } else if (response['message'] == 'User already Exists') {
  //           //clearForm();
  //
  //           await Utils.errorWithoutBack(response['message']);
  //         } else {
  //           AppSnackBar.showGetXCustomSnackBar(message: response['message']);
  //         }
  //       } else {
  //         AppSnackBar.showGetXCustomSnackBar(
  //           message: 'Unknown response from the server',
  //         );
  //       }
  //     } else {
  //       AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
  //     }
  //   } catch (e) {
  //     Utils.handleException(e);
  //     //Utils.handleException(Exception(e.toString()));
  //   } finally {
  //     isLoading(false);
  //     isDisable(false);
  //   }
  // }

  // Future<void> signUpDio() async {
  //   isLoading(true);
  //   isDisable(true);
  //
  //   try {
  //     if (await Network.isConnected()) {
  //       // Prepare FormData
  //       FormData formData = FormData();
  //
  //       Map<String, dynamic> fields = {
  //         'clientCd': clientCdController.value.text,
  //         'clientPwd': clientPwdController.value.text,
  //         'businessType': selectedBusinessType.value,
  //         'firmName': firmNameController.value.text,
  //         'personNm': personNmController.value.text,
  //         'address': addressController.value.text,
  //         'city': selectedCity.value,
  //         'state': selectedState.value,
  //         'stateCd': stateCdController.value.text,
  //         'zone': zoneController.value.text,
  //         'pinCode': pinCodeController.value.text,
  //         'mobile1': mobile1Controller.value.text,
  //         'mobile2': mobile2Controller.value.text,
  //         'emailId': emailIdController.value.text,
  //         'upi': upiController.value.text,
  //         'gstNo': gstNoController.value.text,
  //         'gstType':
  //             selectedGstType.value.isNotEmpty
  //                 ? selectedGstType.value[0].toUpperCase()
  //                 : '',
  //         'panNo': panNoController.value.text,
  //         'fssaiNo': fssaiNoController.value.text,
  //         'registrationNo1': registrationNo1Controller.value.text,
  //         'registrationNo2': registrationNo2Controller.value.text,
  //         'drugLic1': drugLic1Controller.value.text,
  //         'drugLic2': drugLic2Controller.value.text,
  //         'drugLic3': drugLic3Controller.value.text,
  //         'dlexpdt1':
  //             expireDate1Controller.value.text.isNotEmpty
  //                 ? AppDatePicker.convertDateTimeFormat(
  //                   expireDate1Controller.value.text,
  //                   'dd-MM-yyyy',
  //                   'yyyy-MM-dd',
  //                 )
  //                 : null,
  //         'dlexpdt2':
  //             expireDate2Controller.value.text.isNotEmpty
  //                 ? AppDatePicker.convertDateTimeFormat(
  //                   expireDate2Controller.value.text,
  //                   'dd-MM-yyyy',
  //                   'yyyy-MM-dd',
  //                 )
  //                 : null,
  //         // 'termCondition': termsAccepted.value ? "true" : "false",
  //         // 'promotionalAgree': promotionalAgreed.value ? "true" : "false",
  //         'termCondition': termsAccepted.value ? 1 : 0,
  //         'promotionalAgree': promotionalAgreed.value ? 1 : 0,
  //       };
  //
  //       // Add all non-null fields to FormData
  //       fields.forEach((key, value) {
  //         if (value != null && value.toString().isNotEmpty) {
  //           formData.fields.add(MapEntry(key, value.toString()));
  //         }
  //       });
  //
  //       if (doc1File.value != null) {
  //         formData.files.add(
  //           MapEntry(
  //             'doc1',
  //             await MultipartFile.fromFile(
  //               doc1File.value!.path,
  //               filename: doc1File.value!.path.split('/').last,
  //             ),
  //           ),
  //         );
  //       }
  //
  //       if (doc2File.value != null) {
  //         formData.files.add(
  //           MapEntry(
  //             'doc2',
  //             await MultipartFile.fromFile(
  //               doc2File.value!.path,
  //               filename: doc2File.value!.path.split('/').last,
  //             ),
  //           ),
  //         );
  //       }
  //
  //       // Send to API
  //       var response = await DioClient().postFormDataPost1(
  //         AppURL.signUPURL,
  //         formData,
  //       );
  //
  //       if (response != null && response['message'] != null) {
  //         if (response['message'] == 'User Created') {
  //           clearForm();
  //
  //           await Utils.successWithBack(response['message']);
  //
  //           print(response['data']);
  //         } else if (response['message'] == 'User already Exists') {
  //           await Utils.errorWithoutBack(response['message']);
  //         } else {
  //           AppSnackBar.showGetXCustomSnackBar(message: response['message']);
  //         }
  //       } else {
  //         AppSnackBar.showGetXCustomSnackBar(
  //           message: 'Unknown server response',
  //         );
  //       }
  //     } else {
  //       AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
  //     }
  //   } catch (e) {
  //     Utils.handleException(e);
  //   } finally {
  //     isLoading(false);
  //     isDisable(false);
  //   }
  // }

  Future<void> signUpHttp() async {
    isSignupLoading(true);
    isSignupDisable(true);

    try {
      if (await Network.isConnected()) {
        // Create the multipart request
        var uri = Uri.parse(AppURL.signUPURL);
        var request = http.MultipartRequest('POST', uri);

        // 📌 Set headers
        final headers = {
          'x-app-type': 'b2c',
          'Content-Type': 'multipart/form-data',
        };
        request.headers.addAll(headers);
        print("Headers: $headers");

        // Add all form fields
        // Map<String, String> fields = {
        //   'clientCd': clientCdController.value.text,
        //   'clientPwd': clientPwdController.value.text,
        //   'businessType': selectedBusinessType.value,
        //   'firmName': firmNameController.value.text,
        //   'personNm': personNmController.value.text,
        //   'address': addressController.value.text,
        //   'city': selectedCity.value,
        //   'state': selectedState.value,
        //   'stateCd': stateCdController.value.text,
        //   'zone': zoneController.value.text,
        //   'pinCode': pinCodeController.value.text,
        //   'mobile1': mobile1Controller.value.text,
        //   'mobile2': mobile2Controller.value.text,
        //   'emailId': emailIdController.value.text,
        //   'upi': upiController.value.text,
        //   'gstNo': gstNoController.value.text,
        //   'gstType':
        //       selectedGstType.value.isNotEmpty
        //           ? selectedGstType.value[0].toUpperCase()
        //           : '',
        //   'panNo': panNoController.value.text,
        //   'fssaiNo': fssaiNoController.value.text,
        //   'registrationNo1': registrationNo1Controller.value.text,
        //   'registrationNo2': registrationNo2Controller.value.text,
        //   'drugLic1': drugLic1Controller.value.text,
        //   'drugLic2': drugLic2Controller.value.text,
        //   'drugLic3': drugLic3Controller.value.text,
        //   'termCondition': termsAccepted.value ? "true" : "false",
        //   'promotionalAgree': promotionalAgreed.value ? "true" : "false",
        // };
        //
        // fields.forEach((key, value) {
        //   if (value.isNotEmpty) {
        //     request.fields[key] = value;
        //   }
        // });

        // 📌 Add fields
        final fields = <String, String>{
          //'clientCd': clientCdController.value.text,
          'scUserCd': clientCdController.value.text,
          'clientPwd': clientPwdController.value.text,
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
          'gstType':
              selectedGstType.value.isNotEmpty
                  ? selectedGstType.value[0].toUpperCase()
                  : '',
          'panNo': panNoController.value.text,
          'fssaiNo': fssaiNoController.value.text,
          'registrationNo1': registrationNo1Controller.value.text,
          'registrationNo2': registrationNo2Controller.value.text,
          'drugLic1': drugLic1Controller.value.text,
          'drugLic2': drugLic2Controller.value.text,
          'drugLic3': drugLic3Controller.value.text,
          // 'dlexpdt1':
          // expireDate1Controller.value.text.isNotEmpty
          //     ? AppDatePicker.convertDateTimeFormat(
          //   expireDate1Controller.value.text,
          //   'dd-MM-yyyy',
          //   'yyyy-MM-dd',
          // )
          //     : null,
          // 'dlexpdt2':
          // expireDate2Controller.value.text.isNotEmpty
          //     ? AppDatePicker.convertDateTimeFormat(
          //   expireDate2Controller.value.text,
          //   'dd-MM-yyyy',
          //   'yyyy-MM-dd',
          // )
          //     : null,
          // 'termCondition': termsAccepted.value ? "true" : "false",
          // 'promotionalAgree': promotionalAgreed.value ? "true" : "false",
          'termCondition': termsAccepted.value ? '1' : '0',
          'promotionalAgree': promotionalAgreed.value ? '1' : '0',
        };

        if (referralCodeController.value.text.isNotEmpty) {
          fields['referral_code'] = referralCodeController.value.text;
        }

        if (expireDate1Controller.value.text.isNotEmpty) {
          fields['dlexpdt1'] = AppDatePicker.convertDateTimeFormat(
            expireDate1Controller.value.text,
            'dd-MM-yyyy',
            'yyyy-MM-dd',
          );
        }

        if (expireDate2Controller.value.text.isNotEmpty) {
          fields['dlexpdt2'] = AppDatePicker.convertDateTimeFormat(
            expireDate2Controller.value.text,
            'dd-MM-yyyy',
            'yyyy-MM-dd',
          );
        }

        fields.forEach((key, value) {
          if (value.isNotEmpty) {
            request.fields[key] = value;
          }
        });

        print("Fields: ${request.fields}");

        // Add files if they exist
        // if (doc1File.value != null && File(doc1File.value!.path).existsSync()) {
        //   request.files.add(
        //     await http.MultipartFile.fromPath('doc1', doc1File.value!.path),
        //   );
        // }
        //
        // if (doc2File.value != null && File(doc2File.value!.path).existsSync()) {
        //   request.files.add(
        //     await http.MultipartFile.fromPath('doc2', doc2File.value!.path),
        //   );
        // }

        // 📌 Helper to add file
        Future<void> addFile(File file, String fieldName) async {
          final fileName = p.basename(file.path);
          final mimeType =
              lookupMimeType(file.path) ?? 'application/octet-stream';
          final typeSplit = mimeType.split('/');

          request.files.add(
            http.MultipartFile.fromBytes(
              fieldName,
              await file.readAsBytes(),
              filename: fileName,
              contentType: MediaType(typeSplit[0], typeSplit[1]),
            ),
          );

          print("📎 Attached $fieldName: $fileName ($mimeType)");
        }

        Future<void> addFileBytes(
          Uint8List bytes,
          String fieldName,
          String fileName,
        ) async {
          final mimeType =
              lookupMimeType(fileName) ?? 'application/octet-stream';
          final typeSplit = mimeType.split('/');
          request.files.add(
            http.MultipartFile.fromBytes(
              fieldName,
              bytes,
              filename: fileName,
              contentType: MediaType(typeSplit[0], typeSplit[1]),
            ),
          );
          print("📎 Attached $fieldName (web): $fileName ($mimeType)");
        }

        if (kIsWeb) {
          if (doc1Web.value != null && doc1WebName.value != null) {
            await addFileBytes(doc1Web.value!, 'doc1', 'doc1.png');
          }
          if (doc2Web.value != null && doc2WebName.value != null) {
            await addFileBytes(doc2Web.value!, 'doc2', 'doc2.png');
          }
        } else {
          if (doc1File.value != null &&
              File(doc1File.value!.path).existsSync()) {
            await addFile(doc1File.value!, 'doc1');
          }
          if (doc2File.value != null &&
              File(doc2File.value!.path).existsSync()) {
            await addFile(doc2File.value!, 'doc2');
          }
        }

        // Send the request
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);

          if (responseData['status'] == true &&
              (responseData['message'] == 'User Created' ||
                  responseData['message'] ==
                      'B2C Signup successful. OTP sent.')) {
            clearForm();
            //await Utils.successWithBack(responseData['message']);
            mobileNo.value = responseData['data']['user']['SC_MOBILENO'];
            isVerified.value = responseData['data']['user']['IS_VERIFIED'];

            print(responseData['data']);

            startResendTimer();
          } else if (responseData['status'] == false &&
              (responseData['message'] == 'User already Exists' ||
                  responseData['message'] == "User exists")) {
            await Utils.errorWithoutBack(responseData['message']);
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: responseData['message'],
            );
          }
        } else {
          if (response.statusCode == 409) {
            final responseData = jsonDecode(response.body);
            AppSnackBar.showGetXCustomSnackBar(
              message: responseData['message'] ?? 'Bad Request',
            );
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: 'Error: ${response.statusCode}',
            );
          }
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print('Error : ${e}');
      Utils.handleException(e, stackTrace);
    } finally {
      isSignupLoading(false);
      isSignupDisable(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize any state or perform setup tasks here
    //Utils.hideStatusBar();

    //fetchState();

    gstNoController.value.addListener(() {
      final text = gstNoController.value.text.toUpperCase();

      // Ensure GST No is uppercase without modifying controller.text directly
      if (gstNoController.value.text != text) {
        final selection = gstNoController.value.selection;
        gstNoController.value.value = TextEditingValue(
          text: text,
          selection: selection,
        );
      }

      // Update PAN No based on GST No (3rd to 12th char)
      if (text.length >= 3) {
        final endIndex = text.length >= 12 ? 12 : text.length;
        final panNo = text.substring(2, endIndex);
        panNoController.value.text = panNo;

        // Keep cursor at end
        panNoController.value.selection = TextSelection.collapsed(
          offset: panNo.length,
        );
      } else {
        panNoController.value.clear();
      }
    });

    panNoController.value.addListener(() {
      final text = panNoController.value.text;
      final upperText = text.toUpperCase();

      if (text != upperText) {
        final selection = panNoController.value.selection;
        panNoController.value.value = TextEditingValue(
          text: upperText,
          selection: selection,
        );
      }
    });

    PreferenceUtils.setAuthToken(''); // Save auth token
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
    gstTypeController.value.dispose();
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

    doc1File.value = null;
    doc2File.value = null;

    currentStep.value == 0;

    _resendTimer?.cancel();

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
    gstTypeController.value.clear();
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

    doc1File.value = null;
    doc2File.value = null;

    currentStep.value == 0;

    // verifyOTPController.value.clear();
    // mobileNo.value = '';
    // isVerified.value = true;
  }

  Future<void> fetchArea(String pincode) async {
    try {
      isAreaDropdownLoading(true);

      // Clear previous data
      areaList.value = PinCodeResponse();
      selectedCity.value = '';
      selectedState.value = '';

      final String url = 'https://api.postalpincode.in/pincode/$pincode';

      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List && data.isNotEmpty) {
          final item = data[0];

          // ✅ Parse main response to your model
          final parsed = PinCodeResponse.fromJson(item);

          if (parsed.status == 'Success' &&
              parsed.postOffice != null &&
              parsed.postOffice!.isNotEmpty) {
            // ✅ Set the list again with fresh data
            areaList.value = parsed;

            // ✅ Extract city/state from parsed.postOffice
            final cityName = parsed.postOffice!.first.district;
            final stateName = parsed.postOffice!.first.state;

            selectedCity.value = cityName ?? '';
            selectedState.value = stateName ?? '';

            await generateUniqueBlockList();
          } else {
            AppSnackBar.showGetXCustomSnackBar(
              message: parsed.message ?? 'No data found',
            );
          }
        } else {
          AppSnackBar.showGetXCustomSnackBar(message: 'No data returned');
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(
          message: 'Failed to fetch city: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isAreaDropdownLoading(false);
    }
  }

  Future<void> fetchState() async {
    try {
      isStateDropdownLoading(true);

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
          if (areaList.value.postOffice!.isNotEmpty) {
            var stateCdFromArgs = areaList.value.postOffice![0].state!;
            print(stateCdFromArgs);
            if (stateCdFromArgs.toString().isNotEmpty) {
              // Filter the list to find the subgroup that matches the GroupCD
              var selectedState = stateList.value.data!.firstWhere(
                (state) => state.stateName == stateCdFromArgs,
                orElse: () => StateModel(), // Default to the first if not found
              );

              // Set the selected values
              selectedDropdownState.value = selectedState;
              selectedDropdownStateName.value =
                  selectedState.stateName.toString().trim();
              selectedDropdownStateCD.value =
                  selectedState.stateCd.toString().trim();

              stateController.value.text =
                  selectedState.stateName.toString().trim();
              stateCdController.value.text =
                  selectedState.stateCd.toString().trim();
            }
          }
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
      isStateDropdownLoading(false);
    }
  }

  void generateUniqueBlockList1() {
    try {
      isCityDropdownLoading(true);

      final blockSet = <String>{};
      final tempList = <PinCodeModel>[];

      if (areaList.value.postOffice != null) {
        for (var po in areaList.value.postOffice!) {
          final blockName = po.block?.trim();
          if (blockName != null &&
              blockName.isNotEmpty &&
              blockName.toUpperCase() != "NA" &&
              !blockSet.contains(blockName)) {
            blockSet.add(blockName);
            tempList.add(po); // Add model for first instance of each block
          }
        }
      }

      uniqueBlockList.value = tempList;

      print("Unique Block Count: ${uniqueBlockList.length}");
      print("Blocks:");
      for (var item in uniqueBlockList) {
        print(item.block);
      }
    } catch (e, stackTrace) {
      print(e);
      Utils.handleException(e, stackTrace);
    } finally {
      isCityDropdownLoading(false);
    }
  }

  Future<void> generateUniqueBlockList() async {
    try {
      isCityDropdownLoading(true); // Show loader

      final blockSet = <String>{};
      final tempList =
          <PinCodeModel>[]; // Assuming PinCodeModel is your PostOffice model

      if (areaList.value.postOffice != null) {
        for (var po in areaList.value.postOffice!) {
          final blockName = po.block?.trim();
          if (blockName != null &&
              blockName.isNotEmpty &&
              blockName.toUpperCase() != "NA" &&
              !blockSet.contains(blockName)) {
            blockSet.add(blockName);
            tempList.add(po); // Add model for first instance of each block
          }
        }
      }

      uniqueBlockList.value = tempList;

      print("Unique Block Count: ${uniqueBlockList.length}");
      print("Blocks:");
      for (var item in uniqueBlockList) {
        print(item.block);
      }
    } catch (e, stackTrace) {
      print('Error generating block list: $e');
      Utils.handleException(e, stackTrace);
    } finally {
      isCityDropdownLoading(false); // Hide loader
    }
  }

  Future<void> fetchUserExits(String clientCd) async {
    if (!await Network.isConnected()) {
      AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      return;
    }

    try {
      isUserExitsLoading(true);

      final response = await DioClient().getQueryParam(
        AppURL.checkUserURL,
        //queryParams: {"clientCd": clientCd},
        queryParams: {"scUserCd": clientCd},
      );

      final firmResponse = UserExitsResponse.fromJson(response);

      if (firmResponse.status == true &&
          (firmResponse.message == "User already exists" ||
              firmResponse.message == "User exists")) {
        errorMsg.value = 'User already exists';
      } else if (firmResponse.status == false &&
          firmResponse.message == "User does not exist") {
        //errorMsg.value = 'User does not exist';
        errorMsg.value = '';
      }
    } on DioException catch (e, stackTrace) {
      errorMsg.value = '';
      Utils.handleException(e, stackTrace);
    } catch (e, stackTrace) {
      errorMsg.value = '';
      Utils.handleException(e, stackTrace);
    } finally {
      isUserExitsLoading(false);
    }
  }

  void onClientCdChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (val.isNotEmpty) {
        fetchUserExits(val);
      }
    });
  }

  void verifyOTPValidation() {
    if (verifyOTPController.value.text.isEmpty) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter OTP.');
    } else if (verifyOTPController.value.text.isNotEmpty &&
        verifyOTPController.value.text.length < 6) {
      AppSnackBar.showGetXCustomSnackBar(message: 'Please enter a valid OTP.');
    } else {
      _verifyOTP(mobileNo.value, verifyOTPController.value.text);
    }
  }

  Future<void> _verifyOTP(String mobileNumber, String otp) async {
    try {
      isVerifyOTPLoading(true);
      isVerifyOTPDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': mobileNumber, 'otp': otp};

        var response = await DioClient().post(AppURL.verifyOTPURL, param);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // if (response['status'] == true &&
          //     response['message'] == 'OTP verified successfully') {
          //   // mobileNo.value = response['data']['user']['SC_MOBILENO'];
          //   // isVerified.value = response['data']['verified'];
          //
          //   clearForm();
          //
          //   verifyOTPController.value.clear();
          //   mobileNo.value = '';
          //   isVerified.value = true;
          //
          //   //isVerified.value = true;
          //
          //   Utils.closeKeyboard(Get.context!);
          //
          //   await Utils.successWithBack(response['message']);
          // } else {
          //   AppSnackBar.showGetXCustomSnackBar(
          //     message: response.data['message'],
          //   );
          // }

          clearForm();

          // verifyOTPController.value.clear();
          // mobileNo.value = '';
          // isVerified.value = true;

          //isVerified.value = true;

          Utils.closeKeyboard(Get.context!);

          //await Utils.successWithBack(response['message']);
          //Get.back();

          Navigator.pop(Get.context!);

          AppSnackBar.showGetXCustomSnackBar(
            message: 'Verify OTP successfully',
            backgroundColor: Colors.green,
          );
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print('Error $e');
      Utils.handleException(e, stackTrace);
    } finally {
      isVerifyOTPLoading(false);
      isVerifyOTPDisable(false);
    }
  }

  Future<void> resendOTP(String mobileNumber) async {
    try {
      isResendOTPLoading(true);
      isResendOTPDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': mobileNumber};

        var response = await DioClient().post(AppURL.resendOTPURL, param);

        if (response.statusCode == 200 || response.statusCode == 201) {
          verifyOTPController.value.clear();

          Utils.closeKeyboard(Get.context!);

          AppSnackBar.showGetXCustomSnackBar(
            message: 'OTP resent successfully',
            backgroundColor: Colors.green,
          );

          startResendTimer();

          //await Utils.successWithoutBack(response['message']);

          // if (response['status'] == true &&
          //     response['message'] == 'OTP resent successfully') {
          //   // mobileNo.value = response['data']['user']['SC_MOBILENO'];
          //   // isVerified.value = response['data']['verified'];
          //
          //   //isVerified.value = true;
          //
          //   verifyOTPController.value.clear();
          //
          //   Utils.closeKeyboard(Get.context!);
          //
          //   await Utils.successWithoutBack(response['message']);
          // } else {
          //   AppSnackBar.showGetXCustomSnackBar(
          //     message: response.data['message'],
          //   );
          // }
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      Utils.handleException(e, stackTrace);
    } finally {
      isResendOTPLoading(false);
      isResendOTPDisable(false);
    }
  }

  Future<void> verifiedOTP(String mobileNumber) async {
    try {
      isVerifyCheckLoading(true);
      isVerifyCheckDisable(true);

      if (await Network.isConnected()) {
        Map<String, dynamic> param = {'mobileNo': mobileNumber};
        //Map<String, dynamic> param = {'scUserCd': mobileNumber};

        var response = await DioClient().getQueryParam(
          AppURL.isVerifiedOTPURL,
          queryParams: param,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // if (response['status'] == true) {
          //   isVerified.value = response['data']['IS_VERIFIED'];
          //   Utils.closeKeyboard(Get.context!);
          //   //Get.back();
          // } else {
          //   AppSnackBar.showGetXCustomSnackBar(
          //     message: response.data['message'],
          //   );
          // }

          isVerified.value = response.data['data']['IS_VERIFIED'];
          Utils.closeKeyboard(Get.context!);
        } else {
          AppSnackBar.showGetXCustomSnackBar(
            message: 'Error: ${response.statusCode}',
          );
        }
      } else {
        AppSnackBar.showGetXCustomSnackBar(message: Constants.networkMsg);
      }
    } catch (e, stackTrace) {
      print('IS Verified $e');
      Utils.handleException(e, stackTrace);
    } finally {
      isVerifyCheckLoading(false);
      isVerifyCheckDisable(false);
    }
  }

  Future<void> getWithBodyDio(String mobileNumber) async {
    final dio = Dio();

    try {
      final response = await dio.request(
        AppURL.verifyOTPURL,
        options: Options(
          method: 'GET',
          headers: {'Content-Type': 'application/json'},
        ),
        data: {'mobileNo': mobileNumber},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        isVerified.value = response.data['IS_VERIFIED'];
        print('Is Verified ${isVerified.value}');
      } else {
        //AppSnackBar.showGetXCustomSnackBar(message: response.data['message']);
        print('Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Exception: $e');
      Utils.handleException(e, stackTrace);
    }
  }
}
