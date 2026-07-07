import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartResponse {
  String? message;
  List<CartModel>? data;

  CartResponse({this.message, this.data});

  CartResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CartModel>[];
      json['data'].forEach((v) {
        data!.add(CartModel.fromJson(v));
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

class CartModel {
  num? cId;
  String? pARTYCD;
  String? uSERCD;
  String? cLIENTCD;
  String? iTEMCD;
  RxInt qUANTITY;

  //RxString qUANTITY;
  String? oTHERDESC;
  String? fLD5;
  num? rATE;
  num? nRATE;
  num? lRATE;
  RxDouble aMOUNT;

  //RxString aMOUNT;
  num? sYNCID;
  String? cREATEDBY;
  String? cREATEDAPPTYPE;
  String? uPDATEDAT;
  String? cREATEDAT;
  Item? item;
  Firm? firm;
  TextEditingController quantityController = TextEditingController();

  CartModel({
    this.cId,
    this.pARTYCD,
    this.uSERCD,
    this.cLIENTCD,
    this.iTEMCD,
    required int quantity,
    //required String quantity,
    this.oTHERDESC,
    this.fLD5,
    this.rATE,
    this.nRATE,
    this.lRATE,
    required double amount,
    //required String amount,
    this.sYNCID,
    this.cREATEDBY,
    this.cREATEDAPPTYPE,
    this.uPDATEDAT,
    this.cREATEDAT,
    this.item,
    this.firm,
  }) : qUANTITY = quantity.obs,
       aMOUNT = amount.obs {
    quantityController.text = quantity.toString();

    // Keep the controller and observable in sync
    // qUANTITY.listen((val) {
    //   quantityController.text = val.toString();
    // });
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final String rawQty = json['QUANTITY']?.toString() ?? '1';
    final int quantity = Utils.convertToDouble(rawQty).round();

    final String rate = json['RATE']?.toString() ?? '0';
    final double amount = quantity * Utils.convertToDouble(rate);

    return CartModel(
      cId: json['cId'],
      pARTYCD: json['PARTY_CD'],
      uSERCD: json['USER_CD'],
      cLIENTCD: json['CLIENT_CD'],
      iTEMCD: json['ITEM_CD'],
      quantity: quantity,
      oTHERDESC: json['OTHER_DESC'],
      fLD5: json['FLD5'],
      rATE: json['RATE'],
      nRATE: json['NRATE'],
      lRATE: json['LRATE'],
      amount: amount,
      sYNCID: json['SYNC_ID'],
      cREATEDBY: json['CREATED_BY'],
      cREATEDAPPTYPE: json['CREATED_APP_TYPE'],
      uPDATEDAT: json['UPDATED_AT'],
      cREATEDAT: json['CREATED_AT'],
      item: json['item'] != null ? Item.fromJson(json['item']) : null,
      firm: json['firm'] != null ? Firm.fromJson(json['firm']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['cId'] = cId;
    json['PARTY_CD'] = pARTYCD;
    json['USER_CD'] = uSERCD;
    json['CLIENT_CD'] = cLIENTCD;
    json['ITEM_CD'] = iTEMCD;
    json['QUANTITY'] = qUANTITY.value;
    json['OTHER_DESC'] = oTHERDESC;
    json['FLD5'] = fLD5;
    json['RATE'] = rATE;
    json['NRATE'] = nRATE;
    json['LRATE'] = lRATE;
    json['AMOUNT'] = aMOUNT.value;
    json['SYNC_ID'] = sYNCID;
    json['CREATED_BY'] = cREATEDBY;
    json['CREATED_APP_TYPE'] = cREATEDAPPTYPE;
    json['UPDATED_AT'] = uPDATEDAT;
    json['CREATED_AT'] = cREATEDAT;
    if (item != null) {
      json['item'] = item!.toJson();
    }
    if (this.firm != null) {
      json['firm'] = this.firm!.toJson();
    }
    return json;
  }
}

class Item {
  dynamic nRATE;
  dynamic aVLSTK;
  dynamic eXDT;
  dynamic iTEMCD;
  dynamic aDOPTEDITEMCD;
  dynamic iTEMCD2;
  dynamic iTEMNAME;
  dynamic iTEMSNAME;
  dynamic iTEMLNAME;
  dynamic sCHEDULETYPE;
  dynamic tOORDERSTATUS;
  dynamic iSDRAFT;
  dynamic dRUGCD;
  dynamic dEPTCD;
  dynamic dNAME;
  dynamic gSTPERC;
  dynamic cESS;
  dynamic tAXINCLUDEDYN;
  dynamic iSSERVICES;
  dynamic iSFROMSERVER;
  dynamic hSNNO;
  dynamic uNIT;
  dynamic iTEMTYPE;
  dynamic pRATE;
  dynamic sRATE1;
  dynamic sRATE2;
  dynamic sRATE3;
  dynamic sRATE4;
  dynamic sRATE5;
  dynamic oRATE;
  dynamic mRP;
  dynamic nEWMRP;
  dynamic tLAND;
  dynamic fRMLSRT1;
  dynamic pDISC;
  dynamic sDISC;
  dynamic sDISC1;
  dynamic cSTK;
  dynamic oRSTK;
  dynamic oSTK;
  dynamic stockLevel;
  dynamic dRSTOCK;
  dynamic cRSTOCK;
  dynamic mINSTK;
  dynamic rEORDERQTY;
  dynamic sTOCKEFFECT;
  dynamic gSTSTAXCD;
  dynamic lASTSIZE;
  dynamic bLACKLIST;
  dynamic sYNCID;
  dynamic iTEMGRADE;
  dynamic rACKNO;
  dynamic iTEMCAT;
  dynamic sUBCAT;
  dynamic iTEMBRAND;
  dynamic iTEMDESC;
  dynamic sEARCHTEXT;
  dynamic cREATEDBY;
  dynamic uPDATEDBY;
  dynamic cREATEDAPPTYPE;
  dynamic uPDATEDAT;
  dynamic mODULENO;
  dynamic cREATEDAT;
  Deptment? deptment;
  ItemImage? itemImage;

  bool hasCstk = false;
  bool hasStockLevel = false;

  Item({
    this.nRATE,
    this.aVLSTK,
    this.eXDT,
    this.iTEMCD,
    this.aDOPTEDITEMCD,
    this.iTEMCD2,
    this.iTEMNAME,
    this.iTEMSNAME,
    this.iTEMLNAME,
    this.sCHEDULETYPE,
    this.tOORDERSTATUS,
    this.iSDRAFT,
    this.dRUGCD,
    this.dEPTCD,
    this.dNAME,
    this.gSTPERC,
    this.cESS,
    this.tAXINCLUDEDYN,
    this.iSSERVICES,
    this.iSFROMSERVER,
    this.hSNNO,
    this.uNIT,
    this.iTEMTYPE,
    this.pRATE,
    this.sRATE1,
    this.sRATE2,
    this.sRATE3,
    this.sRATE4,
    this.sRATE5,
    this.oRATE,
    this.mRP,
    this.nEWMRP,
    this.tLAND,
    this.fRMLSRT1,
    this.pDISC,
    this.sDISC,
    this.sDISC1,
    this.cSTK,
    this.oRSTK,
    this.oSTK,
    this.stockLevel,
    this.dRSTOCK,
    this.cRSTOCK,
    this.mINSTK,
    this.rEORDERQTY,
    this.sTOCKEFFECT,
    this.gSTSTAXCD,
    this.lASTSIZE,
    this.bLACKLIST,
    this.sYNCID,
    this.iTEMGRADE,
    this.rACKNO,
    this.iTEMCAT,
    this.sUBCAT,
    this.iTEMBRAND,
    this.iTEMDESC,
    this.sEARCHTEXT,
    this.cREATEDBY,
    this.uPDATEDBY,
    this.cREATEDAPPTYPE,
    this.uPDATEDAT,
    this.mODULENO,
    this.cREATEDAT,
    this.deptment,
    this.itemImage,
  });

  Item.fromJson(Map<String, dynamic> json) {
    nRATE = json['NRATE'];
    aVLSTK = json['AVL_STK'];
    eXDT = json['EX_DT'];
    iTEMCD = json['ITEM_CD'];
    aDOPTEDITEMCD = json['ADOPTED_ITEM_CD'];
    iTEMCD2 = json['ITEM_CD2'];
    iTEMNAME = json['ITEM_NAME'];
    iTEMSNAME = json['ITEM_SNAME'];
    iTEMLNAME = json['ITEM_LNAME'];
    sCHEDULETYPE = json['SCHEDULE_TYPE'];
    tOORDERSTATUS = json['TO_ORDER_STATUS'];
    iSDRAFT = json['ISDRAFT'];
    dRUGCD = json['DRUG_CD'];
    dEPTCD = json['DEPT_CD'];
    dNAME = json['DNAME'];
    gSTPERC = json['GST_PERC'];
    cESS = json['CESS'];
    tAXINCLUDEDYN = json['TAX_INCLUDED_YN'];
    iSSERVICES = json['IS_SERVICES'];
    iSFROMSERVER = json['IS_FROM_SERVER'];
    hSNNO = json['HSN_NO'];
    uNIT = json['UNIT'];
    iTEMTYPE = json['ITEM_TYPE'];
    pRATE = json['PRATE'];
    sRATE1 = json['SRATE1'];
    sRATE2 = json['SRATE2'];
    sRATE3 = json['SRATE3'];
    sRATE4 = json['SRATE4'];
    sRATE5 = json['SRATE5'];
    oRATE = json['O_RATE'];
    mRP = json['MRP'];
    nEWMRP = json['NEW_MRP'];
    tLAND = json['T_LAND'];
    fRMLSRT1 = json['FRML_SRT1'];
    pDISC = json['PDISC'];
    sDISC = json['SDISC'];
    sDISC1 = json['SDISC1'];
    cSTK = json['C_STK'];
    oRSTK = json['OR_STK'];
    oSTK = json['O_STK'];
    stockLevel = json['STOCK_LEVEL'];
    dRSTOCK = json['DR_STOCK'];
    cRSTOCK = json['CR_STOCK'];
    mINSTK = json['MIN_STK'];
    rEORDERQTY = json['RE_ORDER_QTY'];
    sTOCKEFFECT = json['STOCK_EFFECT'];
    gSTSTAXCD = json['GST_STAXCD'];
    lASTSIZE = json['LAST_SIZE'];
    bLACKLIST = json['BLACKLIST'];
    sYNCID = json['SYNC_ID'];
    iTEMGRADE = json['ITEM_GRADE'];
    rACKNO = json['RACK_NO'];
    iTEMCAT = json['ITEM_CAT'];
    sUBCAT = json['SUBCAT'];
    iTEMBRAND = json['ITEM_BRAND'];
    iTEMDESC = json['ITEM_DESC'];
    sEARCHTEXT = json['SEARCH_TEXT'];
    cREATEDBY = json['CREATED_BY'];
    uPDATEDBY = json['UPDATED_BY'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    uPDATEDAT = json['UPDATED_AT'];
    mODULENO = json['MODULE_NO'];
    cREATEDAT = json['CREATED_AT'];
    deptment =
        json['deptment'] != null
            ? new Deptment.fromJson(json['deptment'])
            : null;
    itemImage =
        json['item_image'] != null
            ? ItemImage.fromJson(json['item_image'])
            : null;

    hasCstk = json.containsKey('C_STK');
    hasStockLevel = json.containsKey('STOCK_LEVEL');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NRATE'] = this.nRATE;
    data['AVL_STK'] = this.aVLSTK;
    data['EX_DT'] = this.eXDT;
    data['ITEM_CD'] = this.iTEMCD;
    data['ADOPTED_ITEM_CD'] = this.aDOPTEDITEMCD;
    data['ITEM_CD2'] = this.iTEMCD2;
    data['ITEM_NAME'] = this.iTEMNAME;
    data['ITEM_SNAME'] = this.iTEMSNAME;
    data['ITEM_LNAME'] = this.iTEMLNAME;
    data['SCHEDULE_TYPE'] = this.sCHEDULETYPE;
    data['TO_ORDER_STATUS'] = this.tOORDERSTATUS;
    data['ISDRAFT'] = this.iSDRAFT;
    data['DRUG_CD'] = this.dRUGCD;
    data['DEPT_CD'] = this.dEPTCD;
    data['DNAME'] = this.dNAME;
    data['GST_PERC'] = this.gSTPERC;
    data['CESS'] = this.cESS;
    data['TAX_INCLUDED_YN'] = this.tAXINCLUDEDYN;
    data['IS_SERVICES'] = this.iSSERVICES;
    data['IS_FROM_SERVER'] = this.iSFROMSERVER;
    data['HSN_NO'] = this.hSNNO;
    data['UNIT'] = this.uNIT;
    data['ITEM_TYPE'] = this.iTEMTYPE;
    data['PRATE'] = this.pRATE;
    data['SRATE1'] = this.sRATE1;
    data['SRATE2'] = this.sRATE2;
    data['SRATE3'] = this.sRATE3;
    data['SRATE4'] = this.sRATE4;
    data['SRATE5'] = this.sRATE5;
    data['O_RATE'] = this.oRATE;
    data['MRP'] = this.mRP;
    data['NEW_MRP'] = this.nEWMRP;
    data['T_LAND'] = this.tLAND;
    data['FRML_SRT1'] = this.fRMLSRT1;
    data['PDISC'] = this.pDISC;
    data['SDISC'] = this.sDISC;
    data['SDISC1'] = this.sDISC1;
    data['C_STK'] = this.cSTK;
    data['OR_STK'] = this.oRSTK;
    data['O_STK'] = this.oSTK;
    data['STOCK_LEVEL'] = this.stockLevel;
    data['DR_STOCK'] = this.dRSTOCK;
    data['CR_STOCK'] = this.cRSTOCK;
    data['MIN_STK'] = this.mINSTK;
    data['RE_ORDER_QTY'] = this.rEORDERQTY;
    data['STOCK_EFFECT'] = this.sTOCKEFFECT;
    data['GST_STAXCD'] = this.gSTSTAXCD;
    data['LAST_SIZE'] = this.lASTSIZE;
    data['BLACKLIST'] = this.bLACKLIST;
    data['SYNC_ID'] = this.sYNCID;
    data['ITEM_GRADE'] = this.iTEMGRADE;
    data['RACK_NO'] = this.rACKNO;
    data['ITEM_CAT'] = this.iTEMCAT;
    data['SUBCAT'] = this.sUBCAT;
    data['ITEM_BRAND'] = this.iTEMBRAND;
    data['ITEM_DESC'] = this.iTEMDESC;
    data['SEARCH_TEXT'] = this.sEARCHTEXT;
    data['CREATED_BY'] = this.cREATEDBY;
    data['UPDATED_BY'] = this.uPDATEDBY;
    data['CREATED_APP_TYPE'] = this.cREATEDAPPTYPE;
    data['UPDATED_AT'] = this.uPDATEDAT;
    data['MODULE_NO'] = this.mODULENO;
    data['CREATED_AT'] = this.cREATEDAT;
    if (this.deptment != null) {
      data['deptment'] = this.deptment!.toJson();
    }
    if (itemImage != null) {
      data['item_image'] = itemImage!.toJson();
    }
    return data;
  }
}

class Deptment {
  dynamic dEPTCD;
  dynamic dEPTNAME;
  dynamic gROUPING;
  dynamic sYNCID;
  dynamic cREATEDBY;
  dynamic cREATEDAPPTYPE;
  dynamic uPDATEDAT;
  dynamic cREATEDAT;

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

// class ItemImage {
//   List<String>? iTEMIMG;
//   dynamic iTEMCD;
//   dynamic iTEMIMG1;
//   dynamic iTEMIMG2;
//   dynamic iTEMIMG3;
//   dynamic iTEMIMG4;
//   dynamic iTEMIMG5;
//   dynamic iTEMIMG6;
//   dynamic sYNCID;
//   dynamic cREATEDBY;
//   dynamic cREATEDAPPTYPE;
//   dynamic uPDATEDAT;
//   dynamic cREATEDAT;
//
//   ItemImage({
//     this.iTEMIMG,
//     this.iTEMCD,
//     this.iTEMIMG1,
//     this.iTEMIMG2,
//     this.iTEMIMG3,
//     this.iTEMIMG4,
//     this.iTEMIMG5,
//     this.iTEMIMG6,
//     this.sYNCID,
//     this.cREATEDBY,
//     this.cREATEDAPPTYPE,
//     this.uPDATEDAT,
//     this.cREATEDAT,
//   });
//
//   ItemImage.fromJson(Map<String, dynamic> json) {
//     iTEMIMG = json['ITEM_IMG'].cast<String>();
//     iTEMCD = json['ITEM_CD'];
//     iTEMIMG1 = json['ITEM_IMG1'];
//     iTEMIMG2 = json['ITEM_IMG2'];
//     iTEMIMG3 = json['ITEM_IMG3'];
//     iTEMIMG4 = json['ITEM_IMG4'];
//     iTEMIMG5 = json['ITEM_IMG5'];
//     iTEMIMG6 = json['ITEM_IMG6'];
//     sYNCID = json['SYNC_ID'];
//     cREATEDBY = json['CREATED_BY'];
//     cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
//     uPDATEDAT = json['UPDATED_AT'];
//     cREATEDAT = json['CREATED_AT'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['ITEM_IMG'] = iTEMIMG;
//     data['ITEM_CD'] = iTEMCD;
//     data['ITEM_IMG1'] = iTEMIMG1;
//     data['ITEM_IMG2'] = iTEMIMG2;
//     data['ITEM_IMG3'] = iTEMIMG3;
//     data['ITEM_IMG4'] = iTEMIMG4;
//     data['ITEM_IMG5'] = iTEMIMG5;
//     data['ITEM_IMG6'] = iTEMIMG6;
//     data['SYNC_ID'] = sYNCID;
//     data['CREATED_BY'] = cREATEDBY;
//     data['CREATED_APP_TYPE'] = cREATEDAPPTYPE;
//     data['UPDATED_AT'] = uPDATEDAT;
//     data['CREATED_AT'] = cREATEDAT;
//     return data;
//   }
// }

class ItemImage {
  /// Always non-null, safe to use
  List<String> iTEMIMG;

  dynamic iTEMCD;
  dynamic iTEMIMG1;
  dynamic iTEMIMG2;
  dynamic iTEMIMG3;
  dynamic iTEMIMG4;
  dynamic iTEMIMG5;
  dynamic iTEMIMG6;
  dynamic sYNCID;
  dynamic cREATEDBY;
  dynamic cREATEDAPPTYPE;
  dynamic uPDATEDAT;
  dynamic cREATEDAT;

  ItemImage({
    this.iTEMIMG = const [],
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

  ItemImage.fromJson(Map<String, dynamic> json)
    : iTEMIMG = _parseItemImages(json),
      iTEMCD = json['ITEM_CD'],
      iTEMIMG1 = json['ITEM_IMG1'],
      iTEMIMG2 = json['ITEM_IMG2'],
      iTEMIMG3 = json['ITEM_IMG3'],
      iTEMIMG4 = json['ITEM_IMG4'],
      iTEMIMG5 = json['ITEM_IMG5'],
      iTEMIMG6 = json['ITEM_IMG6'],
      sYNCID = json['SYNC_ID'],
      cREATEDBY = json['CREATED_BY'],
      cREATEDAPPTYPE = json['CREATED_APP_TYPE'],
      uPDATEDAT = json['UPDATED_AT'],
      cREATEDAT = json['CREATED_AT'];

  /// 🔐 Centralized safe parser
  static List<String> _parseItemImages(Map<String, dynamic> json) {
    final itemImg = json['ITEM_IMG'];

    // Case 1: ITEM_IMG is a list
    if (itemImg is List) {
      return itemImg
          .where((e) => e != null && e.toString().isNotEmpty)
          .map((e) => e.toString())
          .toList();
    }

    // Case 2: ITEM_IMG is a single string
    if (itemImg is String && itemImg.isNotEmpty) {
      return [itemImg];
    }

    // Case 3: Build list from ITEM_IMG1 ... ITEM_IMG6
    final fallbackImages = [
      json['ITEM_IMG1'],
      json['ITEM_IMG2'],
      json['ITEM_IMG3'],
      json['ITEM_IMG4'],
      json['ITEM_IMG5'],
      json['ITEM_IMG6'],
    ];

    return fallbackImages
        .where((e) => e != null && e.toString().isNotEmpty)
        .map((e) => e.toString())
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'ITEM_IMG': iTEMIMG,
      'ITEM_CD': iTEMCD,
      'ITEM_IMG1': iTEMIMG1,
      'ITEM_IMG2': iTEMIMG2,
      'ITEM_IMG3': iTEMIMG3,
      'ITEM_IMG4': iTEMIMG4,
      'ITEM_IMG5': iTEMIMG5,
      'ITEM_IMG6': iTEMIMG6,
      'SYNC_ID': sYNCID,
      'CREATED_BY': cREATEDBY,
      'CREATED_APP_TYPE': cREATEDAPPTYPE,
      'UPDATED_AT': uPDATEDAT,
      'CREATED_AT': cREATEDAT,
    };
  }
}

class Firm {
  String? fIRMNAME;

  Firm({this.fIRMNAME});

  Firm.fromJson(Map<String, dynamic> json) {
    fIRMNAME = json['FIRM_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FIRM_NAME'] = this.fIRMNAME;
    return data;
  }
}
