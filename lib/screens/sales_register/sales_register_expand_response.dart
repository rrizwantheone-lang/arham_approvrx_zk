class SalesRegisterExpandResponse {
  String? message;
  List<SalesRegisterExpandModel>? data;

  SalesRegisterExpandResponse({this.message, this.data});

  SalesRegisterExpandResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <SalesRegisterExpandModel>[];
      json['data'].forEach((v) {
        data!.add(SalesRegisterExpandModel.fromJson(v));
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

class SalesRegisterExpandModel {
  dynamic iTEMCD;
  dynamic sIZECD;
  dynamic qUANTITY;
  dynamic oTHERDESC;
  dynamic rATE;
  dynamic vOUCHAMT;
  dynamic vOUCHTYPE;
  Item? item;

  SalesRegisterExpandModel({
    this.iTEMCD,
    this.sIZECD,
    this.qUANTITY,
    this.oTHERDESC,
    this.rATE,
    this.vOUCHAMT,
    this.vOUCHTYPE,
    this.item,
  });

  SalesRegisterExpandModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
