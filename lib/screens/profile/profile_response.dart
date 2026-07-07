class ProfileResponse {
  String? message;
  List<ProfileModel>? data;

  ProfileResponse({this.message, this.data});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ProfileModel>[];
      json['data'].forEach((v) {
        data!.add(new ProfileModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileModel {
  String? dOC1;
  String? dOC2;
  String? cLIENTCD;
  num? sYNCID;
  String? cLIENTPWD;
  String? cLIENTBUSINESSTYPE;
  String? cLIENTFIRMNAME;
  String? cLIENTPERSONNM;
  String? cLIENTADDRESS;
  String? cLIENTCITY;
  String? cLIENTSTATE;
  String? cLIENTSTATECODE;
  String? cLIENTZONE;
  String? cLIENTPINCODE;
  String? cLIENTMOBILE1;
  String? cLIENTMOBILE2;
  String? cLIENTEMAILID;
  String? cLIENTUPI;
  String? cLIENTGSTNO;
  String? cLIENTGSTTYPE;
  String? cLIENTPANNO;
  String? cLIENTFSSAINO;
  String? cLIENTREGISTRATIONNO1;
  String? cLIENTREGISTRATIONNO2;
  String? cLIENTDRUGLIC1;
  String? cLIENTDRUGLIC2;
  String? cLIENTDRUGLIC3;
  String? cLIENTDLEXPDT1;
  String? cLIENTDLEXPDT2;
  num? bLACKLIST;
  num? tERMCONDITION;
  num? pROMOTIONALAGREE;
  String? cREATEDBY;
  String? cREATEDAT;
  String? uPDATEDBY;
  String? uPDATEDAT;
  String? cREATEDAPPTYPE;
  List<ClientFirmLinks>? clientFirmLinks;

  ProfileModel({
    this.dOC1,
    this.dOC2,
    this.cLIENTCD,
    this.sYNCID,
    this.cLIENTPWD,
    this.cLIENTBUSINESSTYPE,
    this.cLIENTFIRMNAME,
    this.cLIENTPERSONNM,
    this.cLIENTADDRESS,
    this.cLIENTCITY,
    this.cLIENTSTATE,
    this.cLIENTSTATECODE,
    this.cLIENTZONE,
    this.cLIENTPINCODE,
    this.cLIENTMOBILE1,
    this.cLIENTMOBILE2,
    this.cLIENTEMAILID,
    this.cLIENTUPI,
    this.cLIENTGSTNO,
    this.cLIENTGSTTYPE,
    this.cLIENTPANNO,
    this.cLIENTFSSAINO,
    this.cLIENTREGISTRATIONNO1,
    this.cLIENTREGISTRATIONNO2,
    this.cLIENTDRUGLIC1,
    this.cLIENTDRUGLIC2,
    this.cLIENTDRUGLIC3,
    this.cLIENTDLEXPDT1,
    this.cLIENTDLEXPDT2,
    this.bLACKLIST,
    this.tERMCONDITION,
    this.pROMOTIONALAGREE,
    this.cREATEDBY,
    this.cREATEDAT,
    this.uPDATEDBY,
    this.uPDATEDAT,
    this.cREATEDAPPTYPE,
    this.clientFirmLinks,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    dOC1 = json['DOC1'];
    dOC2 = json['DOC2'];
    cLIENTCD = json['CLIENT_CD'];
    sYNCID = json['SYNC_ID'];
    cLIENTPWD = json['CLIENT_PWD'];
    cLIENTBUSINESSTYPE = json['CLIENT_BUSINESS_TYPE'];
    cLIENTFIRMNAME = json['CLIENT_FIRM_NAME'];
    cLIENTPERSONNM = json['CLIENT_PERSON_NM'];
    cLIENTADDRESS = json['CLIENT_ADDRESS'];
    cLIENTCITY = json['CLIENT_CITY'];
    cLIENTSTATE = json['CLIENT_STATE'];
    cLIENTSTATECODE = json['CLIENT_STATE_CODE'];
    cLIENTZONE = json['CLIENT_ZONE'];
    cLIENTPINCODE = json['CLIENT_PINCODE'];
    cLIENTMOBILE1 = json['CLIENT_MOBILE1'];
    cLIENTMOBILE2 = json['CLIENT_MOBILE2'];
    cLIENTEMAILID = json['CLIENT_EMAIL_ID'];
    cLIENTUPI = json['CLIENT_UPI'];
    cLIENTGSTNO = json['CLIENT_GST_NO'];
    cLIENTGSTTYPE = json['CLIENT_GST_TYPE'];
    cLIENTPANNO = json['CLIENT_PAN_NO'];
    cLIENTFSSAINO = json['CLIENT_FSSAI_NO'];
    cLIENTREGISTRATIONNO1 = json['CLIENT_REGISTRATION_NO1'];
    cLIENTREGISTRATIONNO2 = json['CLIENT_REGISTRATION_NO2'];
    cLIENTDRUGLIC1 = json['CLIENT_DRUG_LIC1'];
    cLIENTDRUGLIC2 = json['CLIENT_DRUG_LIC2'];
    cLIENTDRUGLIC3 = json['CLIENT_DRUG_LIC3'];
    cLIENTDLEXPDT1 = json['CLIENT_DL_EXPDT1'];
    cLIENTDLEXPDT2 = json['CLIENT_DL_EXPDT2'];
    bLACKLIST = json['BLACKLIST'];
    tERMCONDITION = json['TERM_CONDITION'];
    pROMOTIONALAGREE = json['PROMOTIONAL_AGREE'];
    cREATEDBY = json['CREATED_BY'];
    cREATEDAT = json['CREATED_AT'];
    uPDATEDBY = json['UPDATED_BY'];
    uPDATEDAT = json['UPDATED_AT'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    if (json['client_firm_links'] != null) {
      clientFirmLinks = <ClientFirmLinks>[];
      json['client_firm_links'].forEach((v) {
        clientFirmLinks!.add(new ClientFirmLinks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DOC1'] = this.dOC1;
    data['DOC2'] = this.dOC2;
    data['CLIENT_CD'] = this.cLIENTCD;
    data['SYNC_ID'] = this.sYNCID;
    data['CLIENT_PWD'] = this.cLIENTPWD;
    data['CLIENT_BUSINESS_TYPE'] = this.cLIENTBUSINESSTYPE;
    data['CLIENT_FIRM_NAME'] = this.cLIENTFIRMNAME;
    data['CLIENT_PERSON_NM'] = this.cLIENTPERSONNM;
    data['CLIENT_ADDRESS'] = this.cLIENTADDRESS;
    data['CLIENT_CITY'] = this.cLIENTCITY;
    data['CLIENT_STATE'] = this.cLIENTSTATE;
    data['CLIENT_STATE_CODE'] = this.cLIENTSTATECODE;
    data['CLIENT_ZONE'] = this.cLIENTZONE;
    data['CLIENT_PINCODE'] = this.cLIENTPINCODE;
    data['CLIENT_MOBILE1'] = this.cLIENTMOBILE1;
    data['CLIENT_MOBILE2'] = this.cLIENTMOBILE2;
    data['CLIENT_EMAIL_ID'] = this.cLIENTEMAILID;
    data['CLIENT_UPI'] = this.cLIENTUPI;
    data['CLIENT_GST_NO'] = this.cLIENTGSTNO;
    data['CLIENT_GST_TYPE'] = this.cLIENTGSTTYPE;
    data['CLIENT_PAN_NO'] = this.cLIENTPANNO;
    data['CLIENT_FSSAI_NO'] = this.cLIENTFSSAINO;
    data['CLIENT_REGISTRATION_NO1'] = this.cLIENTREGISTRATIONNO1;
    data['CLIENT_REGISTRATION_NO2'] = this.cLIENTREGISTRATIONNO2;
    data['CLIENT_DRUG_LIC1'] = this.cLIENTDRUGLIC1;
    data['CLIENT_DRUG_LIC2'] = this.cLIENTDRUGLIC2;
    data['CLIENT_DRUG_LIC3'] = this.cLIENTDRUGLIC3;
    data['CLIENT_DL_EXPDT1'] = this.cLIENTDLEXPDT1;
    data['CLIENT_DL_EXPDT2'] = this.cLIENTDLEXPDT2;
    data['BLACKLIST'] = this.bLACKLIST;
    data['TERM_CONDITION'] = this.tERMCONDITION;
    data['PROMOTIONAL_AGREE'] = this.pROMOTIONALAGREE;
    data['CREATED_BY'] = this.cREATEDBY;
    data['CREATED_AT'] = this.cREATEDAT;
    data['UPDATED_BY'] = this.uPDATEDBY;
    data['UPDATED_AT'] = this.uPDATEDAT;
    data['CREATED_APP_TYPE'] = this.cREATEDAPPTYPE;
    if (this.clientFirmLinks != null) {
      data['client_firm_links'] =
          this.clientFirmLinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClientFirmLinks {
  num? iD;
  String? cLIENTCD;
  String? aCCCD;
  num? aCCESSRIGHT;
  num? sYNCID;
  String? cREATEDBY;
  String? cREATEDAPPTYPE;
  String? mODULENO;
  String? uPDATEDBY;
  String? cREATEDAT;
  String? uPDATEDAT;
  Firm? firm;

  ClientFirmLinks({
    this.iD,
    this.cLIENTCD,
    this.aCCCD,
    this.aCCESSRIGHT,
    this.sYNCID,
    this.cREATEDBY,
    this.cREATEDAPPTYPE,
    this.mODULENO,
    this.uPDATEDBY,
    this.cREATEDAT,
    this.uPDATEDAT,
    this.firm,
  });

  ClientFirmLinks.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    cLIENTCD = json['CLIENT_CD'];
    aCCCD = json['ACC_CD'];
    aCCESSRIGHT = json['ACCESS_RIGHT'];
    sYNCID = json['SYNC_ID'];
    cREATEDBY = json['CREATED_BY'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    mODULENO = json['MODULE_NO'];
    uPDATEDBY = json['UPDATED_BY'];
    cREATEDAT = json['CREATED_AT'];
    uPDATEDAT = json['UPDATED_AT'];
    firm = json['firm'] != null ? new Firm.fromJson(json['firm']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CLIENT_CD'] = this.cLIENTCD;
    data['ACC_CD'] = this.aCCCD;
    data['ACCESS_RIGHT'] = this.aCCESSRIGHT;
    data['SYNC_ID'] = this.sYNCID;
    data['CREATED_BY'] = this.cREATEDBY;
    data['CREATED_APP_TYPE'] = this.cREATEDAPPTYPE;
    data['MODULE_NO'] = this.mODULENO;
    data['UPDATED_BY'] = this.uPDATEDBY;
    data['CREATED_AT'] = this.cREATEDAT;
    data['UPDATED_AT'] = this.uPDATEDAT;
    if (this.firm != null) {
      data['firm'] = this.firm!.toJson();
    }
    return data;
  }
}

class Firm {
  String? fIRMQRCODE;
  String? fIRMLOGO;
  String? fIRMSIGN;
  String? fIRMID;
  String? cUSTID;
  num? sYNCID;
  String? fIRMNAME;
  String? mODULENOS;
  String? aDD1;
  String? aDD2;
  String? aDD3;
  String? aDD4;
  String? aDD5;
  String? aDD6;
  String? aDD7;
  String? aDD8;
  String? aDD9;
  String? aDD10;
  String? cITY;
  String? sTATE;
  String? sTATECODE;
  String? zONE;
  String? pINCODE;
  String? mOBILE1;
  String? mOBILE2;
  String? pERSONNM;
  String? eMAILID;
  String? eMAILHOST;
  String? eMAILPASSWORD;
  num? eMAILPORT;
  String? uPI;
  String? gSTNO;
  String? gSTTYPE;
  String? pANNO;
  String? fSSAINO;
  String? rEGNO1;
  String? rEGNO2;
  String? tCSAUTO;
  num? tCSABOVE;
  num? tCSWITHPAN;
  num? tCSWITHOUTPAN;
  String? fOOTER1;
  String? fOOTER2;
  String? fOOTER3;
  String? fOOTER4;
  String? fOOTER5;
  String? fOOTER6;
  String? fOOTER7;
  String? fOOTER8;
  String? fOOTER9;
  String? fOOTER10;
  String? wHATSAPPPARAM1;
  String? wHATSAPPPARAM2;
  String? wHATSAPPPARAM3;
  String? wHATSAPPPARAM4;
  String? dRUGLIC1;
  String? dRUGLIC2;
  String? dRUGLIC3;
  String? dRUGLIC4;
  String? dRUGDATE1;
  String? dRUGDATE2;
  String? dRUGDATE3;
  String? dRUGDATE4;
  String? cATEGORY;
  num? iSB2CENABLE;
  num? iSLOCKED;
  num? bLACKLIST;
  num? iSDELETED;
  String? cREATEDBY;
  String? uPDATEDBY;
  String? dELETEDBY;
  String? dELETEDAT;
  String? cREATEDAPPTYPE;
  String? cREATEDAT;
  String? uPDATEDAT;

  Firm({
    this.fIRMQRCODE,
    this.fIRMLOGO,
    this.fIRMSIGN,
    this.fIRMID,
    this.cUSTID,
    this.sYNCID,
    this.fIRMNAME,
    this.mODULENOS,
    this.aDD1,
    this.aDD2,
    this.aDD3,
    this.aDD4,
    this.aDD5,
    this.aDD6,
    this.aDD7,
    this.aDD8,
    this.aDD9,
    this.aDD10,
    this.cITY,
    this.sTATE,
    this.sTATECODE,
    this.zONE,
    this.pINCODE,
    this.mOBILE1,
    this.mOBILE2,
    this.pERSONNM,
    this.eMAILID,
    this.eMAILHOST,
    this.eMAILPASSWORD,
    this.eMAILPORT,
    this.uPI,
    this.gSTNO,
    this.gSTTYPE,
    this.pANNO,
    this.fSSAINO,
    this.rEGNO1,
    this.rEGNO2,
    this.tCSAUTO,
    this.tCSABOVE,
    this.tCSWITHPAN,
    this.tCSWITHOUTPAN,
    this.fOOTER1,
    this.fOOTER2,
    this.fOOTER3,
    this.fOOTER4,
    this.fOOTER5,
    this.fOOTER6,
    this.fOOTER7,
    this.fOOTER8,
    this.fOOTER9,
    this.fOOTER10,
    this.wHATSAPPPARAM1,
    this.wHATSAPPPARAM2,
    this.wHATSAPPPARAM3,
    this.wHATSAPPPARAM4,
    this.dRUGLIC1,
    this.dRUGLIC2,
    this.dRUGLIC3,
    this.dRUGLIC4,
    this.dRUGDATE1,
    this.dRUGDATE2,
    this.dRUGDATE3,
    this.dRUGDATE4,
    this.cATEGORY,
    this.iSB2CENABLE,
    this.iSLOCKED,
    this.bLACKLIST,
    this.iSDELETED,
    this.cREATEDBY,
    this.uPDATEDBY,
    this.dELETEDBY,
    this.dELETEDAT,
    this.cREATEDAPPTYPE,
    this.cREATEDAT,
    this.uPDATEDAT,
  });

  Firm.fromJson(Map<String, dynamic> json) {
    fIRMQRCODE = json['FIRM_QR_CODE'];
    fIRMLOGO = json['FIRM_LOGO'];
    fIRMSIGN = json['FIRM_SIGN'];
    fIRMID = json['FIRM_ID'];
    cUSTID = json['CUST_ID'];
    sYNCID = json['SYNC_ID'];
    fIRMNAME = json['FIRM_NAME'];
    mODULENOS = json['MODULE_NOS'];
    aDD1 = json['ADD1'];
    aDD2 = json['ADD2'];
    aDD3 = json['ADD3'];
    aDD4 = json['ADD4'];
    aDD5 = json['ADD5'];
    aDD6 = json['ADD6'];
    aDD7 = json['ADD7'];
    aDD8 = json['ADD8'];
    aDD9 = json['ADD9'];
    aDD10 = json['ADD10'];
    cITY = json['CITY'];
    sTATE = json['STATE'];
    sTATECODE = json['STATE_CODE'];
    zONE = json['ZONE'];
    pINCODE = json['PINCODE'];
    mOBILE1 = json['MOBILE1'];
    mOBILE2 = json['MOBILE2'];
    pERSONNM = json['PERSON_NM'];
    eMAILID = json['EMAIL_ID'];
    eMAILHOST = json['EMAIL_HOST'];
    eMAILPASSWORD = json['EMAIL_PASSWORD'];
    eMAILPORT = json['EMAIL_PORT'];
    uPI = json['UPI'];
    gSTNO = json['GST_NO'];
    gSTTYPE = json['GST_TYPE'];
    pANNO = json['PAN_NO'];
    fSSAINO = json['FSSAI_NO'];
    rEGNO1 = json['REG_NO_1'];
    rEGNO2 = json['REG_NO_2'];
    tCSAUTO = json['TCS_AUTO'];
    tCSABOVE = json['TCS_ABOVE'];
    tCSWITHPAN = json['TCS_WITH_PAN'];
    tCSWITHOUTPAN = json['TCS_WITHOUT_PAN'];
    fOOTER1 = json['FOOTER1'];
    fOOTER2 = json['FOOTER2'];
    fOOTER3 = json['FOOTER3'];
    fOOTER4 = json['FOOTER4'];
    fOOTER5 = json['FOOTER5'];
    fOOTER6 = json['FOOTER6'];
    fOOTER7 = json['FOOTER7'];
    fOOTER8 = json['FOOTER8'];
    fOOTER9 = json['FOOTER9'];
    fOOTER10 = json['FOOTER10'];
    wHATSAPPPARAM1 = json['WHATSAPP_PARAM_1'];
    wHATSAPPPARAM2 = json['WHATSAPP_PARAM_2'];
    wHATSAPPPARAM3 = json['WHATSAPP_PARAM_3'];
    wHATSAPPPARAM4 = json['WHATSAPP_PARAM_4'];
    dRUGLIC1 = json['DRUG_LIC1'];
    dRUGLIC2 = json['DRUG_LIC2'];
    dRUGLIC3 = json['DRUG_LIC3'];
    dRUGLIC4 = json['DRUG_LIC4'];
    dRUGDATE1 = json['DRUG_DATE1'];
    dRUGDATE2 = json['DRUG_DATE2'];
    dRUGDATE3 = json['DRUG_DATE3'];
    dRUGDATE4 = json['DRUG_DATE4'];
    cATEGORY = json['CATEGORY'];
    iSB2CENABLE = json['IS_B2C_ENABLE'];
    iSLOCKED = json['IS_LOCKED'];
    bLACKLIST = json['BLACKLIST'];
    iSDELETED = json['ISDELETED'];
    cREATEDBY = json['CREATED_BY'];
    uPDATEDBY = json['UPDATED_BY'];
    dELETEDBY = json['DELETED_BY'];
    dELETEDAT = json['DELETED_AT'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    cREATEDAT = json['CREATED_AT'];
    uPDATEDAT = json['UPDATED_AT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FIRM_QR_CODE'] = this.fIRMQRCODE;
    data['FIRM_LOGO'] = this.fIRMLOGO;
    data['FIRM_SIGN'] = this.fIRMSIGN;
    data['FIRM_ID'] = this.fIRMID;
    data['CUST_ID'] = this.cUSTID;
    data['SYNC_ID'] = this.sYNCID;
    data['FIRM_NAME'] = this.fIRMNAME;
    data['MODULE_NOS'] = this.mODULENOS;
    data['ADD1'] = this.aDD1;
    data['ADD2'] = this.aDD2;
    data['ADD3'] = this.aDD3;
    data['ADD4'] = this.aDD4;
    data['ADD5'] = this.aDD5;
    data['ADD6'] = this.aDD6;
    data['ADD7'] = this.aDD7;
    data['ADD8'] = this.aDD8;
    data['ADD9'] = this.aDD9;
    data['ADD10'] = this.aDD10;
    data['CITY'] = this.cITY;
    data['STATE'] = this.sTATE;
    data['STATE_CODE'] = this.sTATECODE;
    data['ZONE'] = this.zONE;
    data['PINCODE'] = this.pINCODE;
    data['MOBILE1'] = this.mOBILE1;
    data['MOBILE2'] = this.mOBILE2;
    data['PERSON_NM'] = this.pERSONNM;
    data['EMAIL_ID'] = this.eMAILID;
    data['EMAIL_HOST'] = this.eMAILHOST;
    data['EMAIL_PASSWORD'] = this.eMAILPASSWORD;
    data['EMAIL_PORT'] = this.eMAILPORT;
    data['UPI'] = this.uPI;
    data['GST_NO'] = this.gSTNO;
    data['GST_TYPE'] = this.gSTTYPE;
    data['PAN_NO'] = this.pANNO;
    data['FSSAI_NO'] = this.fSSAINO;
    data['REG_NO_1'] = this.rEGNO1;
    data['REG_NO_2'] = this.rEGNO2;
    data['TCS_AUTO'] = this.tCSAUTO;
    data['TCS_ABOVE'] = this.tCSABOVE;
    data['TCS_WITH_PAN'] = this.tCSWITHPAN;
    data['TCS_WITHOUT_PAN'] = this.tCSWITHOUTPAN;
    data['FOOTER1'] = this.fOOTER1;
    data['FOOTER2'] = this.fOOTER2;
    data['FOOTER3'] = this.fOOTER3;
    data['FOOTER4'] = this.fOOTER4;
    data['FOOTER5'] = this.fOOTER5;
    data['FOOTER6'] = this.fOOTER6;
    data['FOOTER7'] = this.fOOTER7;
    data['FOOTER8'] = this.fOOTER8;
    data['FOOTER9'] = this.fOOTER9;
    data['FOOTER10'] = this.fOOTER10;
    data['WHATSAPP_PARAM_1'] = this.wHATSAPPPARAM1;
    data['WHATSAPP_PARAM_2'] = this.wHATSAPPPARAM2;
    data['WHATSAPP_PARAM_3'] = this.wHATSAPPPARAM3;
    data['WHATSAPP_PARAM_4'] = this.wHATSAPPPARAM4;
    data['DRUG_LIC1'] = this.dRUGLIC1;
    data['DRUG_LIC2'] = this.dRUGLIC2;
    data['DRUG_LIC3'] = this.dRUGLIC3;
    data['DRUG_LIC4'] = this.dRUGLIC4;
    data['DRUG_DATE1'] = this.dRUGDATE1;
    data['DRUG_DATE2'] = this.dRUGDATE2;
    data['DRUG_DATE3'] = this.dRUGDATE3;
    data['DRUG_DATE4'] = this.dRUGDATE4;
    data['CATEGORY'] = this.cATEGORY;
    data['IS_B2C_ENABLE'] = this.iSB2CENABLE;
    data['IS_LOCKED'] = this.iSLOCKED;
    data['BLACKLIST'] = this.bLACKLIST;
    data['ISDELETED'] = this.iSDELETED;
    data['CREATED_BY'] = this.cREATEDBY;
    data['UPDATED_BY'] = this.uPDATEDBY;
    data['DELETED_BY'] = this.dELETEDBY;
    data['DELETED_AT'] = this.dELETEDAT;
    data['CREATED_APP_TYPE'] = this.cREATEDAPPTYPE;
    data['CREATED_AT'] = this.cREATEDAT;
    data['UPDATED_AT'] = this.uPDATEDAT;
    return data;
  }
}
