class AccountLedgerResponse {
  String? message;
  List<AccountLedgerModel>? data;

  AccountLedgerResponse({this.message, this.data});

  AccountLedgerResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <AccountLedgerModel>[];
      json['data'].forEach((v) {
        data!.add(AccountLedgerModel.fromJson(v));
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

class AccountLedgerModel {
  dynamic vOUCHDT;
  dynamic bOOKCD;
  dynamic vOUCHNO;
  dynamic bILLNO;
  dynamic aCCNAME;
  dynamic dRAMT;
  dynamic cRAMT;
  dynamic nARRATION;
  dynamic aCCCD;
  dynamic pARTYTCD;
  dynamic pARTYCD;
  dynamic sYNCID;
  dynamic cLBAL;

  AccountLedgerModel({
    this.vOUCHDT,
    this.bOOKCD,
    this.vOUCHNO,
    this.bILLNO,
    this.aCCNAME,
    this.dRAMT,
    this.cRAMT,
    this.nARRATION,
    this.aCCCD,
    this.pARTYTCD,
    this.pARTYCD,
    this.sYNCID,
    this.cLBAL,
  });

  AccountLedgerModel.fromJson(Map<String, dynamic> json) {
    vOUCHDT = json['VOUCH_DT'];
    bOOKCD = json['BOOK_CD'];
    vOUCHNO = json['VOUCH_NO'];
    bILLNO = json['BILL_NO'];
    aCCNAME = json['ACC_NAME'];
    dRAMT = json['DR_AMT'];
    cRAMT = json['CR_AMT'];
    nARRATION = json['NARRATION'];
    aCCCD = json['ACC_CD'];
    pARTYTCD = json['PARTY_TCD'];
    pARTYCD = json['PARTY_CD'];
    sYNCID = json['SYNC_ID'];
    cLBAL = json['CL_BAL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VOUCH_DT'] = vOUCHDT;
    data['BOOK_CD'] = bOOKCD;
    data['VOUCH_NO'] = vOUCHNO;
    data['BILL_NO'] = bILLNO;
    data['ACC_NAME'] = aCCNAME;
    data['DR_AMT'] = dRAMT;
    data['CR_AMT'] = cRAMT;
    data['NARRATION'] = nARRATION;
    data['ACC_CD'] = aCCCD;
    data['PARTY_TCD'] = pARTYTCD;
    data['PARTY_CD'] = pARTYCD;
    data['SYNC_ID'] = sYNCID;
    data['CL_BAL'] = cLBAL;
    return data;
  }
}
