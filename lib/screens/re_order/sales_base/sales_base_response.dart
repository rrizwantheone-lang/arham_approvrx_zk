import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesBaseResponse {
  String? message;
  int? page;
  int? limit;
  int? totalRecords;
  int? totalPages;
  List<SalesBaseModel>? data;

  SalesBaseResponse({
    this.message,
    this.page,
    this.limit,
    this.totalRecords,
    this.totalPages,
    this.data,
  });

  SalesBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    page = json['page'];
    limit = json['limit'];
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      data = <SalesBaseModel>[];
      json['data'].forEach((v) {
        data!.add(new SalesBaseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalRecords'] = this.totalRecords;
    data['totalPages'] = this.totalPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesBaseModel {
  String? iTEMCD;
  String? iTEMNAME;
  String? dEPTCD;
  String? dEPTNAME;
  num? rATE;
  String? pARTYCD;
  String? vOUCHDT;
  num? sYNCID;
  num? sALECOUNT;
  num? cSTK;
  String? fIRMNAME;
  num? vOUCHAMT;
  num? qUANTITY;
  num? oTHERDESC;

  bool? cartStatus;

  //RxInt quantity = 1.obs;
  RxInt quantity = 0.obs;
  RxDouble totalAmount = 0.0.obs;
  TextEditingController quantityController = TextEditingController();

  SalesBaseModel({
    this.iTEMCD,
    this.iTEMNAME,
    this.dEPTCD,
    this.dEPTNAME,
    this.rATE,
    this.pARTYCD,
    this.vOUCHDT,
    this.sYNCID,
    this.sALECOUNT,
    this.cSTK,
    this.fIRMNAME,
    this.vOUCHAMT,
    this.qUANTITY,
    this.oTHERDESC,
    this.cartStatus,
  }) {
    // ✅ Automatically calculate total amount when object is created
    //totalAmount.value = (quantity.value * (sRATE1 ?? 0)).toDouble();

    totalAmount.value =
        (quantity.value * Utils.convertToDouble(rATE)).toDouble();
    //quantityController.text = quantity.value.toString();//TODO : 0 Quantity Set Remove

    // Optionally keep them in sync:
    // quantity.listen((val) {
    //   quantityController.text = val.toString();
    // });
  }

  SalesBaseModel.fromJson(Map<String, dynamic> json) {
    iTEMCD = json['ITEM_CD'];
    iTEMNAME = json['ITEM_NAME'];
    dEPTCD = json['DEPT_CD'];
    dEPTNAME = json['DEPT_NAME'];
    rATE = json['RATE'];
    pARTYCD = json['PARTY_CD'];
    vOUCHDT = json['VOUCH_DT'];
    sYNCID = json['SYNC_ID'];
    sALECOUNT = json['SALE_COUNT'];
    cSTK = json['C_STK'];
    fIRMNAME = json['FIRM_NAME'];
    vOUCHAMT = json['VOUCH_AMT'];
    qUANTITY = json['QUANTITY'];
    oTHERDESC = json['OTHER_DESC'];
    cartStatus = json['cartStatus'];

    // ✅ Initialize quantity (if coming from API) or default to 1
    //quantity.value = json['quantity'] ?? 1;
    //quantity.value = json['QUANTITY'] ?? 0;
    quantity.value = json['quantity'] ?? 0;
    //quantityController.text = quantity.value.toString(); //TODO : 0 Quantity Set Remove

    // ✅ Ensure totalAmount is correctly calculated
    //totalAmount.value = (quantity.value * (sRATE1 ?? 0)).toDouble();
    totalAmount.value =
        (quantity.value * Utils.convertToDouble(rATE)).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ITEM_CD'] = this.iTEMCD;
    data['ITEM_NAME'] = this.iTEMNAME;
    data['DEPT_CD'] = this.dEPTCD;
    data['DEPT_NAME'] = this.dEPTNAME;
    data['RATE'] = this.rATE;
    data['PARTY_CD'] = this.pARTYCD;
    data['VOUCH_DT'] = this.vOUCHDT;
    data['SYNC_ID'] = this.sYNCID;
    data['SALE_COUNT'] = this.sALECOUNT;
    data['C_STK'] = this.cSTK;
    data['FIRM_NAME'] = this.fIRMNAME;
    data['VOUCH_AMT'] = this.vOUCHAMT;
    data['QUANTITY'] = this.qUANTITY;
    data['OTHER_DESC'] = this.oTHERDESC;
    data['cartStatus'] = this.cartStatus;

    // ✅ Include quantity and totalAmount in API payload
    data['quantity'] = quantity.value;
    data['total_amount'] = totalAmount.value;
    return data;
  }
}

// class SalesBaseResponse {
//   String? message;
//   List<SalesBaseModel>? data;
//
//   SalesBaseResponse({this.message, this.data});
//
//   SalesBaseResponse.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <SalesBaseModel>[];
//       json['data'].forEach((v) {
//         data!.add(new SalesBaseModel.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class SalesBaseModel {
//   String? iTEMCDS;
//   num? sYNCID;
//   String? iTEMCD;
//   String? dEPTCD;
//   String? dEPTNAME;
//   String? iTEMNAME;
//   String? iTEMSNAME;
//   num? vOUCHAMTA;
//   num? rATE;
//   num? cSTK;
//   num? qUANTITYA;
//   String? oTHERDESCA;
//   String? vOUCHDT;
//   String? pARTYCD;
//   num? vOUCHAMT;
//   num? qUANTITY;
//   num? oTHERDESC;
//
//   bool? cartStatus;
//   //RxInt quantity = 1.obs;
//   RxInt quantity = 0.obs;
//   RxDouble totalAmount = 0.0.obs;
//   TextEditingController quantityController = TextEditingController();
//
//   SalesBaseModel({
//     this.iTEMCDS,
//     this.sYNCID,
//     this.iTEMCD,
//     this.dEPTCD,
//     this.dEPTNAME,
//     this.iTEMNAME,
//     this.iTEMSNAME,
//     this.vOUCHAMTA,
//     this.rATE,
//     this.cSTK,
//     this.qUANTITYA,
//     this.oTHERDESCA,
//     this.vOUCHDT,
//     this.pARTYCD,
//     this.vOUCHAMT,
//     this.qUANTITY,
//     this.oTHERDESC,
//     this.cartStatus,
//   }){
//     // ✅ Automatically calculate total amount when object is created
//     //totalAmount.value = (quantity.value * (sRATE1 ?? 0)).toDouble();
//
//     totalAmount.value =
//         (quantity.value * Utils.convertToDouble(rATE)).toDouble();
//     //quantityController.text = quantity.value.toString();//TODO : 0 Quantity Set Remove
//
//     // Optionally keep them in sync:
//     // quantity.listen((val) {
//     //   quantityController.text = val.toString();
//     // });
//   }
//
//   SalesBaseModel.fromJson(Map<String, dynamic> json) {
//     iTEMCDS = json['ITEM_CD_S'];
//     sYNCID = json['SYNC_ID'];
//     iTEMCD = json['ITEM_CD'];
//     dEPTCD = json['DEPT_CD'];
//     dEPTNAME = json['DEPT_NAME'];
//     iTEMNAME = json['ITEM_NAME'];
//     iTEMSNAME = json['ITEM_SNAME'];
//     vOUCHAMTA = json['VOUCH_AMT_A'];
//     rATE = json['RATE'];
//     cSTK = json['C_STK'];
//     qUANTITYA = json['QUANTITY_A'];
//     oTHERDESCA = json['OTHER_DESC_A'];
//     vOUCHDT = json['VOUCH_DT'];
//     pARTYCD = json['PARTY_CD'];
//     vOUCHAMT = json['VOUCH_AMT'];
//     qUANTITY = json['QUANTITY'];
//     oTHERDESC = json['OTHER_DESC'];
//     cartStatus = json['cartStatus'];
//
//     // ✅ Initialize quantity (if coming from API) or default to 1
//     //quantity.value = json['quantity'] ?? 1;
//     //quantity.value = json['QUANTITY'] ?? 0;
//     quantity.value = json['quantity'] ?? 0;
//     //quantityController.text = quantity.value.toString(); //TODO : 0 Quantity Set Remove
//
//     // ✅ Ensure totalAmount is correctly calculated
//     //totalAmount.value = (quantity.value * (sRATE1 ?? 0)).toDouble();
//     totalAmount.value =
//         (quantity.value * Utils.convertToDouble(rATE)).toDouble();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ITEM_CD_S'] = this.iTEMCDS;
//     data['SYNC_ID'] = this.sYNCID;
//     data['ITEM_CD'] = this.iTEMCD;
//     data['DEPT_CD'] = this.dEPTCD;
//     data['DEPT_NAME'] = this.dEPTNAME;
//     data['ITEM_NAME'] = this.iTEMNAME;
//     data['ITEM_SNAME'] = this.iTEMSNAME;
//     data['VOUCH_AMT_A'] = this.vOUCHAMTA;
//     data['RATE'] = this.rATE;
//     data['C_STK'] = this.cSTK;
//     data['QUANTITY_A'] = this.qUANTITYA;
//     data['OTHER_DESC_A'] = this.oTHERDESCA;
//     data['VOUCH_DT'] = this.vOUCHDT;
//     data['PARTY_CD'] = this.pARTYCD;
//     data['VOUCH_AMT'] = this.vOUCHAMT;
//     data['QUANTITY'] = this.qUANTITY;
//     data['OTHER_DESC'] = this.oTHERDESC;
//     data['cartStatus'] = this.cartStatus;
//
//     // ✅ Include quantity and totalAmount in API payload
//     data['quantity'] = quantity.value;
//     data['total_amount'] = totalAmount.value;
//     return data;
//   }
// }
