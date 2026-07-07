import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistributorResponse {
  List<DistributorModel>? data;
  Payload? payload;

  DistributorResponse({this.data, this.payload});

  DistributorResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DistributorModel>[];
      json['data'].forEach((v) {
        data!.add(DistributorModel.fromJson(v));
      });
    }
    payload =
        json['payload'] != null ? Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    return data;
  }
}

class DistributorModel {
  dynamic nRATE;
  dynamic eXDT;
  dynamic iTEMCD;
  dynamic iTEMNAME;
  dynamic iTEMSNAME;
  dynamic iTEMLNAME;
  dynamic dEPTCD;
  dynamic gSTPERC;
  dynamic hSNNO;
  dynamic rACKNO;
  dynamic iTEMCAT;
  dynamic sUBCAT;
  dynamic iTEMBRAND;
  dynamic iTEMGRADE;
  dynamic iTEMDESC;
  dynamic sEARCHTEXT;
  dynamic sRATE1;
  dynamic sRATE3;
  dynamic mRP;
  dynamic fRMLSRT1;
  dynamic pDISC;
  dynamic sDISC;
  dynamic sDISC1;
  dynamic cSTK;
  dynamic minStk;
  dynamic lASTSIZE;
  dynamic bLACKLIST;
  dynamic sYNCID;
  Deptment? deptment;
  ItemImage? itemImage;
  String? stockLevel;
  Firm? firm;
  bool? cartStatus;
  //RxInt quantity = 1.obs;
  RxInt quantity = 0.obs;
  RxDouble totalAmount = 0.0.obs;
  TextEditingController quantityController = TextEditingController();

  bool hasCstk = false;
  bool hasStockLevel = false;

  DistributorModel({
    this.nRATE,
    this.eXDT,
    this.iTEMCD,
    this.iTEMNAME,
    this.iTEMSNAME,
    this.iTEMLNAME,
    this.dEPTCD,
    this.gSTPERC,
    this.hSNNO,
    this.rACKNO,
    this.iTEMCAT,
    this.sUBCAT,
    this.iTEMBRAND,
    this.iTEMGRADE,
    this.iTEMDESC,
    this.sEARCHTEXT,
    this.sRATE1,
    this.sRATE3,
    this.mRP,
    this.fRMLSRT1,
    this.pDISC,
    this.sDISC,
    this.sDISC1,
    this.cSTK,
    this.minStk,
    this.lASTSIZE,
    this.bLACKLIST,
    this.sYNCID,
    this.deptment,
    this.itemImage,
    this.stockLevel,
    this.firm,
    this.cartStatus,
  }) {
    // ✅ Automatically calculate total amount when object is created
    //totalAmount.value = (quantity.value * (sRATE1 ?? 0)).toDouble();

    totalAmount.value =
        (quantity.value * Utils.convertToDouble(sRATE1)).toDouble();
    //quantityController.text = quantity.value.toString();//TODO : 0 Quantity Set Remove

    // Optionally keep them in sync:
    // quantity.listen((val) {
    //   quantityController.text = val.toString();
    // });
  }

  DistributorModel.fromJson(Map<String, dynamic> json) {
    nRATE = json['NRATE'];
    eXDT = json['EX_DT'];
    iTEMCD = json['ITEM_CD'];
    iTEMNAME = json['ITEM_NAME'];
    iTEMSNAME = json['ITEM_SNAME'];
    iTEMLNAME = json['ITEM_LNAME'];
    dEPTCD = json['DEPT_CD'];
    gSTPERC = json['GST_PERC'];
    hSNNO = json['HSN_NO'];
    rACKNO = json['RACK_NO'];
    iTEMCAT = json['ITEM_CAT'];
    sUBCAT = json['SUBCAT'];
    iTEMBRAND = json['ITEM_BRAND'];
    iTEMGRADE = json['ITEM_GRADE'];
    iTEMDESC = json['ITEM_DESC'];
    sEARCHTEXT = json['SEARCH_TEXT'];
    sRATE1 = json['SRATE1'];
    sRATE3 = json['SRATE3'];
    mRP = json['MRP'];
    fRMLSRT1 = json['FRML_SRT1'];
    pDISC = json['PDISC'];
    sDISC = json['SDISC'];
    sDISC1 = json['SDISC1'];
    cSTK = json['C_STK'];
    minStk = json['MIN_STK'];
    lASTSIZE = json['LAST_SIZE'];
    bLACKLIST = json['BLACKLIST'];
    sYNCID = json['SYNC_ID'];
    deptment =
        json['deptment'] != null ? Deptment.fromJson(json['deptment']) : null;
    itemImage =
        json['item_image'] != null
            ? ItemImage.fromJson(json['item_image'])
            : null;
    stockLevel = json['stockLevel'];
    firm = json['firm'] != null ? new Firm.fromJson(json['firm']) : null;
    cartStatus = json['cartStatus'];
    // ✅ Initialize quantity (if coming from API) or default to 1
    //quantity.value = json['quantity'] ?? 1;
    quantity.value = json['quantity'] ?? 0;
    //quantityController.text = quantity.value.toString(); //TODO : 0 Quantity Set Remove

    // ✅ Ensure totalAmount is correctly calculated
    //totalAmount.value = (quantity.value * (sRATE1 ?? 0)).toDouble();
    totalAmount.value =
        (quantity.value * Utils.convertToDouble(sRATE1)).toDouble();

    hasCstk = json.containsKey('C_STK');
    hasStockLevel = json.containsKey('stockLevel');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NRATE'] = this.nRATE;
    data['EX_DT'] = this.eXDT;
    data['ITEM_CD'] = this.iTEMCD;
    data['ITEM_NAME'] = this.iTEMNAME;
    data['ITEM_SNAME'] = this.iTEMSNAME;
    data['ITEM_LNAME'] = this.iTEMLNAME;
    data['DEPT_CD'] = this.dEPTCD;
    data['GST_PERC'] = this.gSTPERC;
    data['HSN_NO'] = this.hSNNO;
    data['RACK_NO'] = this.rACKNO;
    data['ITEM_CAT'] = this.iTEMCAT;
    data['SUBCAT'] = this.sUBCAT;
    data['ITEM_BRAND'] = this.iTEMBRAND;
    data['ITEM_GRADE'] = this.iTEMGRADE;
    data['ITEM_DESC'] = this.iTEMDESC;
    data['SEARCH_TEXT'] = this.sEARCHTEXT;
    data['SRATE1'] = this.sRATE1;
    data['SRATE3'] = this.sRATE3;
    data['MRP'] = this.mRP;
    data['FRML_SRT1'] = this.fRMLSRT1;
    data['PDISC'] = this.pDISC;
    data['SDISC'] = this.sDISC;
    data['SDISC1'] = this.sDISC1;
    data['C_STK'] = this.cSTK;
    data['MIN_STK'] = this.minStk;
    data['LAST_SIZE'] = this.lASTSIZE;
    data['BLACKLIST'] = this.bLACKLIST;
    data['SYNC_ID'] = this.sYNCID;
    if (deptment != null) {
      data['deptment'] = deptment!.toJson();
    }
    if (itemImage != null) {
      data['item_image'] = itemImage!.toJson();
    }
    if (stockLevel != null) {
      data['stockLevel'] = itemImage!.toJson();
    }
    if (this.firm != null) {
      data['firm'] = this.firm!.toJson();
    }
    data['cartStatus'] = this.cartStatus;
    // ✅ Include quantity and totalAmount in API payload
    data['quantity'] = quantity.value;
    data['total_amount'] = totalAmount.value;
    return data;
  }
}

class Deptment {
  dynamic dEPTCD;
  dynamic dEPTNAME;
  dynamic gROUPING;
  num? sYNCID;
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

class ItemImage {
  List<String>? iTEMIMG;
  dynamic iTEMCD;
  dynamic iTEMIMG1;
  dynamic iTEMIMG2;
  dynamic iTEMIMG3;
  dynamic iTEMIMG4;
  dynamic iTEMIMG5;
  dynamic iTEMIMG6;
  num? sYNCID;
  dynamic cREATEDBY;
  dynamic cREATEDAPPTYPE;
  dynamic uPDATEDAT;
  dynamic cREATEDAT;

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

class Firm {
  dynamic fIRMNAME;

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

class Payload {
  Pagination? pagination;

  Payload({this.pagination});

  Payload.fromJson(Map<String, dynamic> json) {
    final paginationJson = json['pagination'];
    if (paginationJson is Map && paginationJson.isNotEmpty) {
      pagination = Pagination.fromJson(json['pagination']);
    } else {
      pagination = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  String? itemsPerPage;
  int? page;
  int? total;
  List<Links>? links;
  int? lastPage;
  int? from;
  int? to;

  Pagination({
    this.itemsPerPage,
    this.page,
    this.total,
    this.links,
    this.lastPage,
    this.from,
    this.to,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    itemsPerPage = json['items_per_page'];
    page = json['page'];
    total = json['total'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    lastPage = json['last_page'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items_per_page'] = itemsPerPage;
    data['page'] = page;
    data['total'] = total;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['last_page'] = lastPage;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class Links {
  bool? active;
  String? label;
  num? page;

  Links({this.active, this.label, this.page});

  Links.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    label = json['label'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['label'] = label;
    data['page'] = page;
    return data;
  }
}
