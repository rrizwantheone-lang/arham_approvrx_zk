import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class OrderBaseResponse {
//   String? message;
//   int? page;
//   int? limit;
//   int? totalRecords;
//   int? totalPages;
//   List<OrderBaseModel>? data;
//
//   OrderBaseResponse({
//     this.message,
//     this.page,
//     this.limit,
//     this.totalRecords,
//     this.totalPages,
//     this.data,
//   });
//
//   OrderBaseResponse.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     page = json['page'];
//     limit = json['limit'];
//     totalRecords = json['totalRecords'];
//     totalPages = json['totalPages'];
//     if (json['data'] != null) {
//       data = <OrderBaseModel>[];
//       json['data'].forEach((v) {
//         data!.add(new OrderBaseModel.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     data['page'] = this.page;
//     data['limit'] = this.limit;
//     data['totalRecords'] = this.totalRecords;
//     data['totalPages'] = this.totalPages;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class OrderBaseModel {
//   num? sALECOUNT;
//   String? pARTYCD;
//   String? bILLNO;
//   String? bILLDT;
//   num? nETAMT;
//   num? oRAMT;
//   String? oRDERNO;
//   String? vOUCHDT;
//   num? oId;
//   String? uSERCD;
//   String? nARRATION;
//   String? cLIENTCD;
//   num? sYNCID;
//   String? iTEMCD;
//   num? qUANTITY;
//   num? rATE;
//   num? aMOUNT;
//   String? oTHERDESC;
//   String? iTEMNAME;
//   String? iTEMSNAME;
//   String? dEPTCD;
//   String? dEPTNAME;
//   num? sRATE1;
//   num? sDISC;
//   num? cSTK;
//   String? fIRMNAME;
//
//   bool? cartStatus;
//
//   //RxInt quantity = 1.obs;
//   RxInt quantity = 0.obs;
//   RxDouble totalAmount = 0.0.obs;
//   TextEditingController quantityController = TextEditingController();
//
//   OrderBaseModel({
//     this.sALECOUNT,
//
//     this.pARTYCD,
//     this.bILLNO,
//     this.bILLDT,
//     this.nETAMT,
//     this.oRAMT,
//     this.oRDERNO,
//     this.vOUCHDT,
//     this.oId,
//     this.uSERCD,
//     this.nARRATION,
//     this.cLIENTCD,
//     this.sYNCID,
//     this.iTEMCD,
//     this.qUANTITY,
//     this.rATE,
//     this.aMOUNT,
//     this.oTHERDESC,
//     this.iTEMNAME,
//     this.iTEMSNAME,
//     this.dEPTCD,
//     this.dEPTNAME,
//     this.sRATE1,
//     this.sDISC,
//     this.cSTK,
//     this.fIRMNAME,
//     this.cartStatus,
//   }) {
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
//   OrderBaseModel.fromJson(Map<String, dynamic> json) {
//     sALECOUNT = json['SALE_COUNT'];
//     pARTYCD = json['PARTY_CD'];
//     bILLNO = json['BILL_NO'];
//     bILLDT = json['BILL_DT'];
//     nETAMT = json['NET_AMT'];
//     oRAMT = json['OR_AMT'];
//     oRDERNO = json['ORDER_NO'];
//     vOUCHDT = json['VOUCH_DT'];
//     oId = json['oId'];
//     uSERCD = json['USER_CD'];
//     nARRATION = json['NARRATION'];
//     cLIENTCD = json['CLIENT_CD'];
//     sYNCID = json['SYNC_ID'];
//     iTEMCD = json['ITEM_CD'];
//     qUANTITY = json['QUANTITY'];
//     rATE = json['RATE'];
//     aMOUNT = json['AMOUNT'];
//     oTHERDESC = json['OTHER_DESC'];
//     iTEMNAME = json['ITEM_NAME'];
//     iTEMSNAME = json['ITEM_SNAME'];
//     dEPTCD = json['DEPT_CD'];
//     dEPTNAME = json['DEPT_NAME'];
//     sRATE1 = json['SRATE1'];
//     sDISC = json['SDISC'];
//     cSTK = json['C_STK'];
//     fIRMNAME = json['FIRM_NAME'];
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
//     data['SALE_COUNT'] = this.sALECOUNT;
//     data['PARTY_CD'] = this.pARTYCD;
//     data['BILL_NO'] = this.bILLNO;
//     data['BILL_DT'] = this.bILLDT;
//     data['NET_AMT'] = this.nETAMT;
//     data['OR_AMT'] = this.oRAMT;
//     data['ORDER_NO'] = this.oRDERNO;
//     data['VOUCH_DT'] = this.vOUCHDT;
//     data['oId'] = this.oId;
//     data['USER_CD'] = this.uSERCD;
//     data['NARRATION'] = this.nARRATION;
//     data['CLIENT_CD'] = this.cLIENTCD;
//     data['SYNC_ID'] = this.sYNCID;
//     data['ITEM_CD'] = this.iTEMCD;
//     data['QUANTITY'] = this.qUANTITY;
//     data['RATE'] = this.rATE;
//     data['AMOUNT'] = this.aMOUNT;
//     data['OTHER_DESC'] = this.oTHERDESC;
//     data['ITEM_NAME'] = this.iTEMNAME;
//     data['ITEM_SNAME'] = this.iTEMSNAME;
//     data['DEPT_CD'] = this.dEPTCD;
//     data['DEPT_NAME'] = this.dEPTNAME;
//     data['SRATE1'] = this.sRATE1;
//     data['SDISC'] = this.sDISC;
//     data['C_STK'] = this.cSTK;
//     data['FIRM_NAME'] = this.fIRMNAME;
//
//     data['cartStatus'] = this.cartStatus;
//
//     // ✅ Include quantity and totalAmount in API payload
//     data['quantity'] = quantity.value;
//     data['total_amount'] = totalAmount.value;
//     return data;
//   }
// }

class OrderBaseResponse {
  String? message;
  int? page;
  int? limit;
  int? totalRecords;
  int? totalPages;
  List<OrderBaseModel>? data;

  OrderBaseResponse({
    this.message,
    this.page,
    this.limit,
    this.totalRecords,
    this.totalPages,
    this.data,
  });

  OrderBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    page = json['page'];
    limit = json['limit'];
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      data = <OrderBaseModel>[];
      json['data'].forEach((v) {
        data!.add(new OrderBaseModel.fromJson(v));
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

class OrderBaseModel {
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
  dynamic stockLevel;
  String? fIRMNAME;
  num? vOUCHAMT;
  num? qUANTITY;
  num? oTHERDESC;
  bool? cartStatus;

  //RxInt quantity = 1.obs;
  RxInt quantity = 0.obs;
  RxDouble totalAmount = 0.0.obs;
  TextEditingController quantityController = TextEditingController();

  bool hasCstk = false;
  bool hasStockLevel = false;
  bool hasRate = false;

  OrderBaseModel({
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
    this.stockLevel,
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

  OrderBaseModel.fromJson(Map<String, dynamic> json) {
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
    stockLevel = json['STOCK_LEVEL'];
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

    hasCstk = json.containsKey('C_STK');
    hasStockLevel = json.containsKey('STOCK_LEVEL');
    hasRate = json.containsKey('RATE');
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
    if (this.stockLevel != null) {
      data['STOCK_LEVEL'] = this.stockLevel;
    }
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
