import 'package:get/get.dart';

class ShopResponse {
  String? message;
  List<ShopModel>? data;

  ShopResponse({this.message, this.data});

  ShopResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ShopModel>[];
      json['data'].forEach((v) {
        data!.add(ShopModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShopModel {
  String? iTEMCD2;
  num? aVLSTK;
  String? eXDT;
  String? rACKNO;
  String? iTEMCAT;
  String? sUBCAT;
  String? iTEMBRAND;
  String? iTEMCD;
  String? iTEMNAME;
  String? iTEMSNAME;
  String? iTEMLNAME;
  String? dEPTCD;
  num? sRATE1;
  num? sRATE3;
  num? sYNCID;
  String? iTEMGRADE;
  String? iTEMDESC;
  num? pRATE;
  num? pDISC;
  num? gSTPERC;
  num? cSTK;
  num? oRSTK;
  Deptment? deptment;
  ItemImage? itemImage;
  RxInt quantity = 1.obs;
  RxDouble totalAmount = 0.0.obs;

  ShopModel({
    this.iTEMCD2,
    this.aVLSTK,
    this.eXDT,
    this.rACKNO,
    this.iTEMCAT,
    this.sUBCAT,
    this.iTEMBRAND,
    this.iTEMCD,
    this.iTEMNAME,
    this.iTEMSNAME,
    this.iTEMLNAME,
    this.dEPTCD,
    this.sRATE1,
    this.sRATE3,
    this.sYNCID,
    this.iTEMGRADE,
    this.iTEMDESC,
    this.pRATE,
    this.pDISC,
    this.gSTPERC,
    this.cSTK,
    this.oRSTK,
    this.deptment,
    this.itemImage,
  }) {
    // ✅ Automatically calculate total amount when object is created
    totalAmount.value = (quantity.value * (sRATE1 ?? 0)).toDouble();
  }

  ShopModel.fromJson(Map<String, dynamic> json) {
    iTEMCD2 = json['ITEM_CD2'];
    aVLSTK = json['AVL_STK'];
    eXDT = json['EX_DT'];
    rACKNO = json['RACK_NO'];
    iTEMCAT = json['ITEM_CAT'];
    sUBCAT = json['SUBCAT'];
    iTEMBRAND = json['ITEM_BRAND'];
    iTEMCD = json['ITEM_CD'];
    iTEMNAME = json['ITEM_NAME'];
    iTEMSNAME = json['ITEM_SNAME'];
    iTEMLNAME = json['ITEM_LNAME'];
    dEPTCD = json['DEPT_CD'];
    sRATE1 = json['SRATE1'];
    sRATE3 = json['SRATE3'];
    sYNCID = json['SYNC_ID'];
    iTEMGRADE = json['ITEM_GRADE'];
    iTEMDESC = json['ITEM_DESC'];
    pRATE = json['PRATE'];
    pDISC = json['PDISC'];
    gSTPERC = json['GST_PERC'];
    cSTK = json['C_STK'];
    oRSTK = json['OR_STK'];
    deptment =
        json['deptment'] != null ? Deptment.fromJson(json['deptment']) : null;
    itemImage =
        json['item_image'] != null
            ? ItemImage.fromJson(json['item_image'])
            : null;
    // ✅ Initialize quantity (if coming from API) or default to 1
    quantity.value = json['quantity'] ?? 1;

    // ✅ Ensure totalAmount is correctly calculated
    totalAmount.value = (quantity.value * (sRATE1 ?? 0)).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_CD2'] = iTEMCD2;
    data['AVL_STK'] = aVLSTK;
    data['EX_DT'] = eXDT;
    data['RACK_NO'] = rACKNO;
    data['ITEM_CAT'] = iTEMCAT;
    data['SUBCAT'] = sUBCAT;
    data['ITEM_BRAND'] = iTEMBRAND;
    data['ITEM_CD'] = iTEMCD;
    data['ITEM_NAME'] = iTEMNAME;
    data['ITEM_SNAME'] = iTEMSNAME;
    data['ITEM_LNAME'] = iTEMLNAME;
    data['DEPT_CD'] = dEPTCD;
    data['SRATE1'] = sRATE1;
    data['SRATE3'] = sRATE3;
    data['SYNC_ID'] = sYNCID;
    data['ITEM_GRADE'] = iTEMGRADE;
    data['ITEM_DESC'] = iTEMDESC;
    data['PRATE'] = pRATE;
    data['PDISC'] = pDISC;
    data['GST_PERC'] = gSTPERC;
    data['C_STK'] = cSTK;
    data['OR_STK'] = oRSTK;
    if (deptment != null) {
      data['deptment'] = deptment!.toJson();
    }
    if (itemImage != null) {
      data['item_image'] = itemImage!.toJson();
    }
    // ✅ Include quantity and totalAmount in API payload
    data['quantity'] = quantity.value;
    data['total_amount'] = totalAmount.value;

    return data;
  }
}

class Deptment {
  String? dEPTCD;
  String? dEPTNAME;
  String? gROUPING;
  num? sYNCID;
  String? cREATEDBY;
  String? cREATEDAPPTYPE;
  String? uPDATEDAT;
  String? cREATEDAT;

  Deptment({
    this.dEPTCD,
    this.dEPTNAME,
    this.gROUPING,
    this.sYNCID,
    this.cREATEDBY,
    this.cREATEDAPPTYPE,
    this.uPDATEDAT,
    this.cREATEDAT,
  });

  Deptment.fromJson(Map<String, dynamic> json) {
    dEPTCD = json['DEPT_CD'];
    dEPTNAME = json['DEPT_NAME'];
    gROUPING = json['GROUPING'];
    sYNCID = json['SYNC_ID'];
    cREATEDBY = json['CREATED_BY'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    uPDATEDAT = json['UPDATED_AT'];
    cREATEDAT = json['CREATED_AT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DEPT_CD'] = dEPTCD;
    data['DEPT_NAME'] = dEPTNAME;
    data['GROUPING'] = gROUPING;
    data['SYNC_ID'] = sYNCID;
    data['CREATED_BY'] = cREATEDBY;
    data['CREATED_APP_TYPE'] = cREATEDAPPTYPE;
    data['UPDATED_AT'] = uPDATEDAT;
    data['CREATED_AT'] = cREATEDAT;
    return data;
  }
}

class ItemImage {
  List<String>? iTEMIMG;
  String? iTEMCD;
  String? iTEMIMG1;
  String? iTEMIMG2;
  String? iTEMIMG3;
  String? iTEMIMG4;
  String? iTEMIMG5;
  String? iTEMIMG6;
  num? sYNCID;
  String? cREATEDBY;
  String? cREATEDAPPTYPE;
  String? uPDATEDAT;
  String? cREATEDAT;

  ItemImage({
    this.iTEMIMG,
    this.iTEMCD,
    this.iTEMIMG1,
    this.iTEMIMG2,
    this.iTEMIMG3,
    this.iTEMIMG4,
    this.iTEMIMG5,
    this.iTEMIMG6,
    this.sYNCID,
    this.cREATEDBY,
    this.cREATEDAPPTYPE,
    this.uPDATEDAT,
    this.cREATEDAT,
  });

  ItemImage.fromJson(Map<String, dynamic> json) {
    iTEMIMG = json['ITEM_IMG'].cast<String>();
    iTEMCD = json['ITEM_CD'];
    iTEMIMG1 = json['ITEM_IMG1'];
    iTEMIMG2 = json['ITEM_IMG2'];
    iTEMIMG3 = json['ITEM_IMG3'];
    iTEMIMG4 = json['ITEM_IMG4'];
    iTEMIMG5 = json['ITEM_IMG5'];
    iTEMIMG6 = json['ITEM_IMG6'];
    sYNCID = json['SYNC_ID'];
    cREATEDBY = json['CREATED_BY'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    uPDATEDAT = json['UPDATED_AT'];
    cREATEDAT = json['CREATED_AT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_IMG'] = iTEMIMG;
    data['ITEM_CD'] = iTEMCD;
    data['ITEM_IMG1'] = iTEMIMG1;
    data['ITEM_IMG2'] = iTEMIMG2;
    data['ITEM_IMG3'] = iTEMIMG3;
    data['ITEM_IMG4'] = iTEMIMG4;
    data['ITEM_IMG5'] = iTEMIMG5;
    data['ITEM_IMG6'] = iTEMIMG6;
    data['SYNC_ID'] = sYNCID;
    data['CREATED_BY'] = cREATEDBY;
    data['CREATED_APP_TYPE'] = cREATEDAPPTYPE;
    data['UPDATED_AT'] = uPDATEDAT;
    data['CREATED_AT'] = cREATEDAT;
    return data;
  }
}
