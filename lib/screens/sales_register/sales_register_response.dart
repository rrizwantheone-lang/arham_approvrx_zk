class SalesRegisterResponse {
  String? message;
  List<SalesRegisterModel>? data;

  SalesRegisterResponse({this.message, this.data});

  SalesRegisterResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <SalesRegisterModel>[];
      json['data'].forEach((v) {
        data!.add(SalesRegisterModel.fromJson(v));
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

class SalesRegisterModel {
  dynamic vOUCHDT;
  dynamic bOOKCD;
  dynamic pARTYBL;
  dynamic pARTYCD;
  dynamic nARRATION;
  dynamic vOUCHTYPE;
  dynamic vOUCHAMT;
  dynamic vOUCHNO;
  Account? account;

  SalesRegisterModel({
    this.vOUCHDT,
    this.bOOKCD,
    this.pARTYBL,
    this.pARTYCD,
    this.nARRATION,
    this.vOUCHTYPE,
    this.vOUCHAMT,
    this.vOUCHNO,
    this.account,
  });

  SalesRegisterModel.fromJson(Map<String, dynamic> json) {
    vOUCHDT = json['VOUCH_DT'];
    bOOKCD = json['BOOK_CD'];
    pARTYBL = json['PARTY_BL'];
    pARTYCD = json['PARTY_CD'];
    nARRATION = json['NARRATION'];
    vOUCHTYPE = json['VOUCH_TYPE'];
    vOUCHAMT = json['VOUCH_AMT'];
    vOUCHNO = json['VOUCH_NO'];
    account =
        json['account'] != null ? Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VOUCH_DT'] = vOUCHDT;
    data['BOOK_CD'] = bOOKCD;
    data['PARTY_BL'] = pARTYBL;
    data['PARTY_CD'] = pARTYCD;
    data['NARRATION'] = nARRATION;
    data['VOUCH_TYPE'] = vOUCHTYPE;
    data['VOUCH_AMT'] = vOUCHAMT;
    data['VOUCH_NO'] = vOUCHNO;
    if (account != null) {
      data['account'] = account!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ACC_NAME'] = aCCNAME;
    data['ACC_CD'] = aCCCD;
    return data;
  }
}
