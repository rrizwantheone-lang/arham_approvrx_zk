class LoginFirmResponse {
  String? message;
  List<LoginFirmModel>? data;

  LoginFirmResponse({this.message, this.data});

  LoginFirmResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <LoginFirmModel>[];
      json['data'].forEach((v) {
        data!.add(new LoginFirmModel.fromJson(v));
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

class LoginFirmModel {
  num? sCFIRMID;
  num? sCSYNCID;
  num? sCCUSTID;
  String? sCFIRMNAME;
  String? sCPERSONNM;
  String? sCADDRESS;
  String? sCCITY;
  String? sCSTATE;
  String? sCSTATECODE;
  String? sCPINCODE;
  String? sCMOBILE1;
  String? sCEMAILID;
  String? sCGSTNO;
  String? sCGSTTYPE;
  String? sCBUSINESSTYPE;

  LoginFirmModel({
    this.sCFIRMID,
    this.sCSYNCID,
    this.sCCUSTID,
    this.sCFIRMNAME,
    this.sCPERSONNM,
    this.sCADDRESS,
    this.sCCITY,
    this.sCSTATE,
    this.sCSTATECODE,
    this.sCPINCODE,
    this.sCMOBILE1,
    this.sCEMAILID,
    this.sCGSTNO,
    this.sCGSTTYPE,
    this.sCBUSINESSTYPE,
  });

  LoginFirmModel.fromJson(Map<String, dynamic> json) {
    sCFIRMID = json['SC_FIRM_ID'];
    sCSYNCID = json['SC_SYNC_ID'];
    sCCUSTID = json['SC_CUST_ID'];
    sCFIRMNAME = json['SC_FIRM_NAME'];
    sCPERSONNM = json['SC_PERSON_NM'];
    sCADDRESS = json['SC_ADDRESS'];
    sCCITY = json['SC_CITY'];
    sCSTATE = json['SC_STATE'];
    sCSTATECODE = json['SC_STATE_CODE'];
    sCPINCODE = json['SC_PINCODE'];
    sCMOBILE1 = json['SC_MOBILE1'];
    sCEMAILID = json['SC_EMAIL_ID'];
    sCGSTNO = json['SC_GST_NO'];
    sCGSTTYPE = json['SC_GST_TYPE'];
    sCBUSINESSTYPE = json['SC_BUSINESS_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SC_FIRM_ID'] = this.sCFIRMID;
    data['SC_SYNC_ID'] = this.sCSYNCID;
    data['SC_CUST_ID'] = this.sCCUSTID;
    data['SC_FIRM_NAME'] = this.sCFIRMNAME;
    data['SC_PERSON_NM'] = this.sCPERSONNM;
    data['SC_ADDRESS'] = this.sCADDRESS;
    data['SC_CITY'] = this.sCCITY;
    data['SC_STATE'] = this.sCSTATE;
    data['SC_STATE_CODE'] = this.sCSTATECODE;
    data['SC_PINCODE'] = this.sCPINCODE;
    data['SC_MOBILE1'] = this.sCMOBILE1;
    data['SC_EMAIL_ID'] = this.sCEMAILID;
    data['SC_GST_NO'] = this.sCGSTNO;
    data['SC_GST_TYPE'] = this.sCGSTTYPE;
    data['SC_BUSINESS_TYPE'] = this.sCBUSINESSTYPE;
    return data;
  }
}
