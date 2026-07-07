class OutstandingResponse {
  String? message;
  List<OutstanidngModel>? data;

  OutstandingResponse({this.message, this.data});

  OutstandingResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <OutstanidngModel>[];
      json['data'].forEach((v) {
        data!.add(OutstanidngModel.fromJson(v));
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

class OutstanidngModel {
  dynamic dUEDAYS;
  dynamic vOUCHNO;
  dynamic vOUCHDT;
  dynamic bOOKCD;
  dynamic pARTYBL;
  dynamic pARTYCD;
  dynamic vOUCHAMT;
  dynamic pAIDAMT;
  dynamic oSAMT;
  dynamic nARRATION;
  dynamic sYNCID;
  dynamic cRDAYS;
  dynamic dUEDATE;
  dynamic vOUCHTYPE;
  Account? account;

  OutstanidngModel(
      {this.dUEDAYS,
        this.vOUCHNO,
        this.vOUCHDT,
        this.bOOKCD,
        this.pARTYBL,
        this.pARTYCD,
        this.vOUCHAMT,
        this.pAIDAMT,
        this.oSAMT,
        this.nARRATION,
        this.sYNCID,
        this.cRDAYS,
        this.dUEDATE,
        this.vOUCHTYPE,
        this.account});

  OutstanidngModel.fromJson(Map<String, dynamic> json) {
    dUEDAYS = json['DUE_DAYS'];
    vOUCHNO = json['VOUCH_NO'];
    vOUCHDT = json['VOUCH_DT'];
    bOOKCD = json['BOOK_CD'];
    pARTYBL = json['PARTY_BL'];
    pARTYCD = json['PARTY_CD'];
    vOUCHAMT = json['VOUCH_AMT'];
    pAIDAMT = json['PAID_AMT'];
    oSAMT = json['OS_AMT'];
    nARRATION = json['NARRATION'];
    sYNCID = json['SYNC_ID'];
    cRDAYS = json['CR_DAYS'];
    dUEDATE = json['DUE_DATE'];
    vOUCHTYPE = json['VOUCH_TYPE'];
    account =
    json['account'] != null ? new Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DUE_DAYS'] = this.dUEDAYS;
    data['VOUCH_NO'] = this.vOUCHNO;
    data['VOUCH_DT'] = this.vOUCHDT;
    data['BOOK_CD'] = this.bOOKCD;
    data['PARTY_BL'] = this.pARTYBL;
    data['PARTY_CD'] = this.pARTYCD;
    data['VOUCH_AMT'] = this.vOUCHAMT;
    data['PAID_AMT'] = this.pAIDAMT;
    data['OS_AMT'] = this.oSAMT;
    data['NARRATION'] = this.nARRATION;
    data['SYNC_ID'] = this.sYNCID;
    data['CR_DAYS'] = this.cRDAYS;
    data['DUE_DATE'] = this.dUEDATE;
    data['VOUCH_TYPE'] = this.vOUCHTYPE;
    if (this.account != null) {
      data['account'] = this.account!.toJson();
    }
    return data;
  }
}

class Account {
  dynamic aCCNAME;
  dynamic aCCCD;

  Account({this.aCCNAME, this.aCCCD});

  Account.fromJson(Map<String, dynamic> json) {
    aCCNAME = json['ACC_NAME'];
    aCCCD = json['ACC_CD'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ACC_NAME'] = this.aCCNAME;
    data['ACC_CD'] = this.aCCCD;
    return data;
  }
}
