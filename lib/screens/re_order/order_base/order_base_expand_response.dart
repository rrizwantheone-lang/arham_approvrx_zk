class OrderBaseExpandResponse {
  String? message;
  List<OrderBaseExpandModel>? data;

  OrderBaseExpandResponse({this.message, this.data});

  OrderBaseExpandResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderBaseExpandModel>[];
      json['data'].forEach((v) {
        data!.add(new OrderBaseExpandModel.fromJson(v));
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

class OrderBaseExpandModel {
  String? vOUCHDT;
  String? bOOKCD;
  String? rEFNO;
  int? qUANTITY;
  String? oTHERDESC;
  double? rATE;
  double? vOUCHAMT;

  OrderBaseExpandModel({
    this.vOUCHDT,
    this.bOOKCD,
    this.rEFNO,
    this.qUANTITY,
    this.oTHERDESC,
    this.rATE,
    this.vOUCHAMT,
  });

  OrderBaseExpandModel.fromJson(Map<String, dynamic> json) {
    vOUCHDT = json['VOUCH_DT'];
    bOOKCD = json['BOOK_CD'];
    rEFNO = json['REF_NO'];
    qUANTITY = json['QUANTITY'];
    oTHERDESC = json['OTHER_DESC'];
    rATE = json['RATE'];
    vOUCHAMT = json['VOUCH_AMT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VOUCH_DT'] = this.vOUCHDT;
    data['BOOK_CD'] = this.bOOKCD;
    data['REF_NO'] = this.rEFNO;
    data['QUANTITY'] = this.qUANTITY;
    data['OTHER_DESC'] = this.oTHERDESC;
    data['RATE'] = this.rATE;
    data['VOUCH_AMT'] = this.vOUCHAMT;
    return data;
  }
}
