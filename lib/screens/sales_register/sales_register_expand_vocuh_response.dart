class SalesRegisterExpandVouchResponse {
  String? message;
  List<SalesRegisterExpandVocuhModel>? data;

  SalesRegisterExpandVouchResponse({this.message, this.data});

  SalesRegisterExpandVouchResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <SalesRegisterExpandVocuhModel>[];
      json['data'].forEach((v) {
        data!.add(SalesRegisterExpandVocuhModel.fromJson(v));
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

class SalesRegisterExpandVocuhModel {
  dynamic bLBOOKCD;
  dynamic bLVDT;
  dynamic bLBILLNO;
  dynamic bLAMOUNT;
  dynamic bLPAID;

  SalesRegisterExpandVocuhModel({
    this.bLBOOKCD,
    this.bLVDT,
    this.bLBILLNO,
    this.bLAMOUNT,
    this.bLPAID,
  });

  SalesRegisterExpandVocuhModel.fromJson(Map<String, dynamic> json) {
    bLBOOKCD = json['BL_BOOK_CD'];
    bLVDT = json['BL_V_DT'];
    bLBILLNO = json['BL_BILL_NO'];
    bLAMOUNT = json['BL_AMOUNT'];
    bLPAID = json['BL_PAID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BL_BOOK_CD'] = bLBOOKCD;
    data['BL_V_DT'] = bLVDT;
    data['BL_BILL_NO'] = bLBILLNO;
    data['BL_AMOUNT'] = bLAMOUNT;
    data['BL_PAID'] = bLPAID;
    return data;
  }
}
