class ProfileResponseNew {
  bool? status;
  String? message;
  ProfileModelNew? data;

  ProfileResponseNew({this.status, this.message, this.data});

  ProfileResponseNew.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ProfileModelNew.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfileModelNew {
  User? user;
  List<Firms>? firms;

  ProfileModelNew({this.user, this.firms});

  ProfileModelNew.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['firms'] != null) {
      firms = <Firms>[];
      json['firms'].forEach((v) {
        firms!.add(new Firms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.firms != null) {
      data['firms'] = this.firms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? iD;
  String? sCUSERCD;
  int? sCCUSTID;
  String? sCUSERPWD;
  String? sCUSERNAME;
  String? sCMOBILENO;
  String? sCUSERTYPE;
  dynamic rESETOTP;
  dynamic rESETOTPEXPIRES;
  int? iSVERIFIED;
  String? cREATEDBY;
  String? cREATEDAT;
  String? cREATEDAPPTYPE;

  User(
      {this.iD,
        this.sCUSERCD,
        this.sCCUSTID,
        this.sCUSERPWD,
        this.sCUSERNAME,
        this.sCMOBILENO,
        this.sCUSERTYPE,
        this.rESETOTP,
        this.rESETOTPEXPIRES,
        this.iSVERIFIED,
        this.cREATEDBY,
        this.cREATEDAT,
        this.cREATEDAPPTYPE});

  User.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    sCUSERCD = json['SC_USER_CD'];
    sCCUSTID = json['SC_CUST_ID'];
    sCUSERPWD = json['SC_USER_PWD'];
    sCUSERNAME = json['SC_USER_NAME'];
    sCMOBILENO = json['SC_MOBILENO'];
    sCUSERTYPE = json['SC_USER_TYPE'];
    rESETOTP = json['RESET_OTP'];
    rESETOTPEXPIRES = json['RESET_OTP_EXPIRES'];
    iSVERIFIED = json['IS_VERIFIED'];
    cREATEDBY = json['CREATED_BY'];
    cREATEDAT = json['CREATED_AT'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['SC_USER_CD'] = this.sCUSERCD;
    data['SC_CUST_ID'] = this.sCCUSTID;
    data['SC_USER_PWD'] = this.sCUSERPWD;
    data['SC_USER_NAME'] = this.sCUSERNAME;
    data['SC_MOBILENO'] = this.sCMOBILENO;
    data['SC_USER_TYPE'] = this.sCUSERTYPE;
    data['RESET_OTP'] = this.rESETOTP;
    data['RESET_OTP_EXPIRES'] = this.rESETOTPEXPIRES;
    data['IS_VERIFIED'] = this.iSVERIFIED;
    data['CREATED_BY'] = this.cREATEDBY;
    data['CREATED_AT'] = this.cREATEDAT;
    data['CREATED_APP_TYPE'] = this.cREATEDAPPTYPE;
    return data;
  }
}

class Firms {
  String? dOC1;
  String? dOC2;
  int? iD;
  int? sCFIRMID;
  int? sCSYNCID;
  int? sCCUSTID;
  String? sCBUSINESSTYPE;
  String? sCFIRMNAME;
  String? sCPERSONNM;
  String? sCADDRESS;
  String? sCCITY;
  String? sCSTATE;
  String? sCSTATECODE;
  String? sCZONE;
  String? sCPINCODE;
  String? sCMOBILE1;
  String? sCMOBILE2;
  String? sCEMAILID;
  String? sCUPI;
  String? sCGSTNO;
  String? sCGSTTYPE;
  String? sCPANNO;
  String? sCFSSAINO;
  dynamic sCREGISTRATIONNO1;
  dynamic sCREGISTRATIONNO2;
  String? sCDRUGLIC1;
  String? sCDRUGLIC2;
  String? sCDRUGLIC3;
  String? sCDLEXPDT1;
  String? sCDLEXPDT2;
  int? bLACKLIST;
  int? tERMCONDITION;
  int? pROMOTIONALAGREE;
  int? iSVERIFIED;
  int? iSLOCKED;
  String? cREATEDBY;
  dynamic uPDATEDBY;
  String? cREATEDAT;
  String? uPDATEDAT;
  String? cREATEDAPPTYPE;

  Firms(
      {this.dOC1,
        this.dOC2,
        this.iD,
        this.sCFIRMID,
        this.sCSYNCID,
        this.sCCUSTID,
        this.sCBUSINESSTYPE,
        this.sCFIRMNAME,
        this.sCPERSONNM,
        this.sCADDRESS,
        this.sCCITY,
        this.sCSTATE,
        this.sCSTATECODE,
        this.sCZONE,
        this.sCPINCODE,
        this.sCMOBILE1,
        this.sCMOBILE2,
        this.sCEMAILID,
        this.sCUPI,
        this.sCGSTNO,
        this.sCGSTTYPE,
        this.sCPANNO,
        this.sCFSSAINO,
        this.sCREGISTRATIONNO1,
        this.sCREGISTRATIONNO2,
        this.sCDRUGLIC1,
        this.sCDRUGLIC2,
        this.sCDRUGLIC3,
        this.sCDLEXPDT1,
        this.sCDLEXPDT2,
        this.bLACKLIST,
        this.tERMCONDITION,
        this.pROMOTIONALAGREE,
        this.iSVERIFIED,
        this.iSLOCKED,
        this.cREATEDBY,
        this.uPDATEDBY,
        this.cREATEDAT,
        this.uPDATEDAT,
        this.cREATEDAPPTYPE});

  Firms.fromJson(Map<String, dynamic> json) {
    dOC1 = json['DOC1'];
    dOC2 = json['DOC2'];
    iD = json['ID'];
    sCFIRMID = json['SC_FIRM_ID'];
    sCSYNCID = json['SC_SYNC_ID'];
    sCCUSTID = json['SC_CUST_ID'];
    sCBUSINESSTYPE = json['SC_BUSINESS_TYPE'];
    sCFIRMNAME = json['SC_FIRM_NAME'];
    sCPERSONNM = json['SC_PERSON_NM'];
    sCADDRESS = json['SC_ADDRESS'];
    sCCITY = json['SC_CITY'];
    sCSTATE = json['SC_STATE'];
    sCSTATECODE = json['SC_STATE_CODE'];
    sCZONE = json['SC_ZONE'];
    sCPINCODE = json['SC_PINCODE'];
    sCMOBILE1 = json['SC_MOBILE1'];
    sCMOBILE2 = json['SC_MOBILE2'];
    sCEMAILID = json['SC_EMAIL_ID'];
    sCUPI = json['SC_UPI'];
    sCGSTNO = json['SC_GST_NO'];
    sCGSTTYPE = json['SC_GST_TYPE'];
    sCPANNO = json['SC_PAN_NO'];
    sCFSSAINO = json['SC_FSSAI_NO'];
    sCREGISTRATIONNO1 = json['SC_REGISTRATION_NO1'];
    sCREGISTRATIONNO2 = json['SC_REGISTRATION_NO2'];
    sCDRUGLIC1 = json['SC_DRUG_LIC1'];
    sCDRUGLIC2 = json['SC_DRUG_LIC2'];
    sCDRUGLIC3 = json['SC_DRUG_LIC3'];
    sCDLEXPDT1 = json['SC_DL_EXPDT1'];
    sCDLEXPDT2 = json['SC_DL_EXPDT2'];
    bLACKLIST = json['BLACKLIST'];
    tERMCONDITION = json['TERM_CONDITION'];
    pROMOTIONALAGREE = json['PROMOTIONAL_AGREE'];
    iSVERIFIED = json['IS_VERIFIED'];
    iSLOCKED = json['IS_LOCKED'];
    cREATEDBY = json['CREATED_BY'];
    uPDATEDBY = json['UPDATED_BY'];
    cREATEDAT = json['CREATED_AT'];
    uPDATEDAT = json['UPDATED_AT'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DOC1'] = this.dOC1;
    data['DOC2'] = this.dOC2;
    data['ID'] = this.iD;
    data['SC_FIRM_ID'] = this.sCFIRMID;
    data['SC_SYNC_ID'] = this.sCSYNCID;
    data['SC_CUST_ID'] = this.sCCUSTID;
    data['SC_BUSINESS_TYPE'] = this.sCBUSINESSTYPE;
    data['SC_FIRM_NAME'] = this.sCFIRMNAME;
    data['SC_PERSON_NM'] = this.sCPERSONNM;
    data['SC_ADDRESS'] = this.sCADDRESS;
    data['SC_CITY'] = this.sCCITY;
    data['SC_STATE'] = this.sCSTATE;
    data['SC_STATE_CODE'] = this.sCSTATECODE;
    data['SC_ZONE'] = this.sCZONE;
    data['SC_PINCODE'] = this.sCPINCODE;
    data['SC_MOBILE1'] = this.sCMOBILE1;
    data['SC_MOBILE2'] = this.sCMOBILE2;
    data['SC_EMAIL_ID'] = this.sCEMAILID;
    data['SC_UPI'] = this.sCUPI;
    data['SC_GST_NO'] = this.sCGSTNO;
    data['SC_GST_TYPE'] = this.sCGSTTYPE;
    data['SC_PAN_NO'] = this.sCPANNO;
    data['SC_FSSAI_NO'] = this.sCFSSAINO;
    data['SC_REGISTRATION_NO1'] = this.sCREGISTRATIONNO1;
    data['SC_REGISTRATION_NO2'] = this.sCREGISTRATIONNO2;
    data['SC_DRUG_LIC1'] = this.sCDRUGLIC1;
    data['SC_DRUG_LIC2'] = this.sCDRUGLIC2;
    data['SC_DRUG_LIC3'] = this.sCDRUGLIC3;
    data['SC_DL_EXPDT1'] = this.sCDLEXPDT1;
    data['SC_DL_EXPDT2'] = this.sCDLEXPDT2;
    data['BLACKLIST'] = this.bLACKLIST;
    data['TERM_CONDITION'] = this.tERMCONDITION;
    data['PROMOTIONAL_AGREE'] = this.pROMOTIONALAGREE;
    data['IS_VERIFIED'] = this.iSVERIFIED;
    data['IS_LOCKED'] = this.iSLOCKED;
    data['CREATED_BY'] = this.cREATEDBY;
    data['UPDATED_BY'] = this.uPDATEDBY;
    data['CREATED_AT'] = this.cREATEDAT;
    data['UPDATED_AT'] = this.uPDATEDAT;
    data['CREATED_APP_TYPE'] = this.cREATEDAPPTYPE;
    return data;
  }
}
