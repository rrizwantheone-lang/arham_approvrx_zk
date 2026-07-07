class OrderReportExpandResponse {
  String? message;
  List<OrderReportExpandModel>? data;

  OrderReportExpandResponse({this.message, this.data});

  OrderReportExpandResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderReportExpandModel>[];
      json['data'].forEach((v) {
        data!.add(OrderReportExpandModel.fromJson(v));
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

class OrderReportExpandModel {
  dynamic iTEMCD;
  dynamic sIZECD;
  dynamic qUANTITY;
  dynamic oTHERDESC;
  dynamic rATE;
  dynamic vOUCHAMT;
  dynamic vOUCHTYPE;
  Item? item;

  OrderReportExpandModel({
    this.iTEMCD,
    this.sIZECD,
    this.qUANTITY,
    this.oTHERDESC,
    this.rATE,
    this.vOUCHAMT,
    this.vOUCHTYPE,
    this.item,
  });

  OrderReportExpandModel.fromJson(Map<String, dynamic> json) {
    iTEMCD = json['ITEM_CD'];
    sIZECD = json['SIZE_CD'];
    qUANTITY = json['QUANTITY'];
    oTHERDESC = json['OTHER_DESC'];
    rATE = json['RATE'];
    vOUCHAMT = json['VOUCH_AMT'];
    vOUCHTYPE = json['VOUCH_TYPE'];
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_CD'] = iTEMCD;
    data['SIZE_CD'] = sIZECD;
    data['QUANTITY'] = qUANTITY;
    data['OTHER_DESC'] = oTHERDESC;
    data['RATE'] = rATE;
    data['VOUCH_AMT'] = vOUCHAMT;
    data['VOUCH_TYPE'] = vOUCHTYPE;
    if (item != null) {
      data['item'] = item!.toJson();
    }
    return data;
  }
}

class Item {
  dynamic iTEMCD2;
  dynamic nRATE;
  dynamic aVLSTK;
  dynamic eXDT;
  dynamic rACKNO;
  dynamic iTEMCAT;
  dynamic sUBCAT;
  dynamic iTEMBRAND;
  dynamic iTEMCD;
  dynamic iTEMNAME;
  dynamic iTEMSNAME;
  dynamic iTEMLNAME;
  dynamic dEPTCD;
  dynamic gSTPERC;
  dynamic cESS;
  dynamic tAXINCLUDEDYN;
  dynamic iSSERVICES;
  dynamic hSNNO;
  dynamic uNIT;
  dynamic lASTEDIT;
  dynamic pRATE;
  dynamic sRATE1;
  dynamic sRATE2;
  dynamic sRATE3;
  dynamic sRATE4;
  dynamic sRATE5;
  dynamic mRP;
  dynamic tLAND;
  dynamic fRMLSRT1;
  dynamic pDISC;
  dynamic sDISC;
  dynamic sDISC1;
  dynamic cSTK;
  dynamic oRSTK;
  dynamic mINSTK;
  dynamic rEORDERQTY;
  dynamic sTOCKEFFECT;
  dynamic gSTSTAXCD;
  dynamic lASTSIZE;
  dynamic bLACKLIST;
  dynamic sYNCID;
  dynamic iTEMGRADE;
  dynamic iTEMDESC;
  dynamic sEARCHTEXT;
  dynamic bARCODENO1;
  dynamic bARCODENO2;
  dynamic bARCODENO3;
  dynamic bARCODENO4;
  dynamic bARCODENO5;
  dynamic bARCODENO6;
  dynamic bARCODENO7;
  dynamic bARCODENO8;
  dynamic bARCODENO9;
  dynamic bARCODENO10;
  dynamic cREATEDBY;
  dynamic cREATEDAPPTYPE;
  dynamic uPDATEDAT;
  dynamic cREATEDAT;

  Item({
    this.iTEMCD2,
    this.nRATE,
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
    this.gSTPERC,
    this.cESS,
    this.tAXINCLUDEDYN,
    this.iSSERVICES,
    this.hSNNO,
    this.uNIT,
    this.lASTEDIT,
    this.pRATE,
    this.sRATE1,
    this.sRATE2,
    this.sRATE3,
    this.sRATE4,
    this.sRATE5,
    this.mRP,
    this.tLAND,
    this.fRMLSRT1,
    this.pDISC,
    this.sDISC,
    this.sDISC1,
    this.cSTK,
    this.oRSTK,
    this.mINSTK,
    this.rEORDERQTY,
    this.sTOCKEFFECT,
    this.gSTSTAXCD,
    this.lASTSIZE,
    this.bLACKLIST,
    this.sYNCID,
    this.iTEMGRADE,
    this.iTEMDESC,
    this.sEARCHTEXT,
    this.bARCODENO1,
    this.bARCODENO2,
    this.bARCODENO3,
    this.bARCODENO4,
    this.bARCODENO5,
    this.bARCODENO6,
    this.bARCODENO7,
    this.bARCODENO8,
    this.bARCODENO9,
    this.bARCODENO10,
    this.cREATEDBY,
    this.cREATEDAPPTYPE,
    this.uPDATEDAT,
    this.cREATEDAT,
  });

  Item.fromJson(Map<String, dynamic> json) {
    iTEMCD2 = json['ITEM_CD2'];
    nRATE = json['NRATE'];
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
    gSTPERC = json['GST_PERC'];
    cESS = json['CESS'];
    tAXINCLUDEDYN = json['TAX_INCLUDED_YN'];
    iSSERVICES = json['IS_SERVICES'];
    hSNNO = json['HSN_NO'];
    uNIT = json['UNIT'];
    lASTEDIT = json['LAST_EDIT'];
    pRATE = json['PRATE'];
    sRATE1 = json['SRATE1'];
    sRATE2 = json['SRATE2'];
    sRATE3 = json['SRATE3'];
    sRATE4 = json['SRATE4'];
    sRATE5 = json['SRATE5'];
    mRP = json['MRP'];
    tLAND = json['T_LAND'];
    fRMLSRT1 = json['FRML_SRT1'];
    pDISC = json['PDISC'];
    sDISC = json['SDISC'];
    sDISC1 = json['SDISC1'];
    cSTK = json['C_STK'];
    oRSTK = json['OR_STK'];
    mINSTK = json['MIN_STK'];
    rEORDERQTY = json['RE_ORDER_QTY'];
    sTOCKEFFECT = json['STOCK_EFFECT'];
    gSTSTAXCD = json['GST_STAXCD'];
    lASTSIZE = json['LAST_SIZE'];
    bLACKLIST = json['BLACKLIST'];
    sYNCID = json['SYNC_ID'];
    iTEMGRADE = json['ITEM_GRADE'];
    iTEMDESC = json['ITEM_DESC'];
    sEARCHTEXT = json['SEARCH_TEXT'];
    bARCODENO1 = json['BARCODE_NO1'];
    bARCODENO2 = json['BARCODE_NO2'];
    bARCODENO3 = json['BARCODE_NO3'];
    bARCODENO4 = json['BARCODE_NO4'];
    bARCODENO5 = json['BARCODE_NO5'];
    bARCODENO6 = json['BARCODE_NO6'];
    bARCODENO7 = json['BARCODE_NO7'];
    bARCODENO8 = json['BARCODE_NO8'];
    bARCODENO9 = json['BARCODE_NO9'];
    bARCODENO10 = json['BARCODE_NO10'];
    cREATEDBY = json['CREATED_BY'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    uPDATEDAT = json['UPDATED_AT'];
    cREATEDAT = json['CREATED_AT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_CD2'] = iTEMCD2;
    data['NRATE'] = nRATE;
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
    data['GST_PERC'] = gSTPERC;
    data['CESS'] = cESS;
    data['TAX_INCLUDED_YN'] = tAXINCLUDEDYN;
    data['IS_SERVICES'] = iSSERVICES;
    data['HSN_NO'] = hSNNO;
    data['UNIT'] = uNIT;
    data['LAST_EDIT'] = lASTEDIT;
    data['PRATE'] = pRATE;
    data['SRATE1'] = sRATE1;
    data['SRATE2'] = sRATE2;
    data['SRATE3'] = sRATE3;
    data['SRATE4'] = sRATE4;
    data['SRATE5'] = sRATE5;
    data['MRP'] = mRP;
    data['T_LAND'] = tLAND;
    data['FRML_SRT1'] = fRMLSRT1;
    data['PDISC'] = pDISC;
    data['SDISC'] = sDISC;
    data['SDISC1'] = sDISC1;
    data['C_STK'] = cSTK;
    data['OR_STK'] = oRSTK;
    data['MIN_STK'] = mINSTK;
    data['RE_ORDER_QTY'] = rEORDERQTY;
    data['STOCK_EFFECT'] = sTOCKEFFECT;
    data['GST_STAXCD'] = gSTSTAXCD;
    data['LAST_SIZE'] = lASTSIZE;
    data['BLACKLIST'] = bLACKLIST;
    data['SYNC_ID'] = sYNCID;
    data['ITEM_GRADE'] = iTEMGRADE;
    data['ITEM_DESC'] = iTEMDESC;
    data['SEARCH_TEXT'] = sEARCHTEXT;
    data['BARCODE_NO1'] = bARCODENO1;
    data['BARCODE_NO2'] = bARCODENO2;
    data['BARCODE_NO3'] = bARCODENO3;
    data['BARCODE_NO4'] = bARCODENO4;
    data['BARCODE_NO5'] = bARCODENO5;
    data['BARCODE_NO6'] = bARCODENO6;
    data['BARCODE_NO7'] = bARCODENO7;
    data['BARCODE_NO8'] = bARCODENO8;
    data['BARCODE_NO9'] = bARCODENO9;
    data['BARCODE_NO10'] = bARCODENO10;
    data['CREATED_BY'] = cREATEDBY;
    data['CREATED_APP_TYPE'] = cREATEDAPPTYPE;
    data['UPDATED_AT'] = uPDATEDAT;
    data['CREATED_AT'] = cREATEDAT;
    return data;
  }
}
