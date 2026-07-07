class OrderReportResponse {
  String? message;
  List<OrderReportModel>? data;
  double? grandTotal;
  Pagination? pagination;

  OrderReportResponse({this.message, this.data, this.grandTotal, this.pagination,});

  OrderReportResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderReportModel>[];
      json['data'].forEach((v) {
        data!.add(OrderReportModel.fromJson(v));
      });
    }

    if (json['Grand_total'] != null) {
      grandTotal = double.tryParse(json['Grand_total'].toString()) ?? 0.0;
    } else {
      grandTotal = 0.0;
    }

    if (json['pagination'] != null) {
      pagination = Pagination.fromJson(json['pagination']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['Grand_total'] = grandTotal;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class OrderReportModel {
  dynamic pARTYCD;
  dynamic bILLNO;
  dynamic bILLDT;
  num? nETAMT;
  num? oRAMT;
  dynamic oRDERNO;
  dynamic vOUCHDT;
  num? oId;
  dynamic uSERCD;
  dynamic nARRATION;
  dynamic cLIENTCD;
  num? sYNCID;
  List<Ordritms>? ordritms;
  dynamic pARTYNAME;
  dynamic mOBILE1;
  dynamic mOBILE2;

  OrderReportModel(
      {this.pARTYCD,
        this.bILLNO,
        this.bILLDT,
        this.nETAMT,
        this.oRAMT,
        this.oRDERNO,
        this.vOUCHDT,
        this.oId,
        this.uSERCD,
        this.nARRATION,
        this.cLIENTCD,
        this.sYNCID,
        this.ordritms,
        this.pARTYNAME,
        this.mOBILE1,
        this.mOBILE2});

  OrderReportModel.fromJson(Map<String, dynamic> json) {
    pARTYCD = json['PARTY_CD'];
    bILLNO = json['BILL_NO'];
    bILLDT = json['BILL_DT'];
    nETAMT = json['NET_AMT'];
    oRAMT = json['OR_AMT'];
    oRDERNO = json['ORDER_NO'];
    vOUCHDT = json['VOUCH_DT'];
    oId = json['oId'];
    uSERCD = json['USER_CD'];
    nARRATION = json['NARRATION'];
    cLIENTCD = json['CLIENT_CD'];
    sYNCID = json['SYNC_ID'];
    if (json['ordritms'] != null) {
      ordritms = <Ordritms>[];
      json['ordritms'].forEach((v) {
        ordritms!.add(new Ordritms.fromJson(v));
      });
    }
    pARTYNAME = json['PARTY_NAME'];
    mOBILE1 = json['MOBILE1'];
    mOBILE2 = json['MOBILE2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PARTY_CD'] = this.pARTYCD;
    data['BILL_NO'] = this.bILLNO;
    data['BILL_DT'] = this.bILLDT;
    data['NET_AMT'] = this.nETAMT;
    data['OR_AMT'] = this.oRAMT;
    data['ORDER_NO'] = this.oRDERNO;
    data['VOUCH_DT'] = this.vOUCHDT;
    data['oId'] = this.oId;
    data['USER_CD'] = this.uSERCD;
    data['NARRATION'] = this.nARRATION;
    data['CLIENT_CD'] = this.cLIENTCD;
    data['SYNC_ID'] = this.sYNCID;
    if (this.ordritms != null) {
      data['ordritms'] = this.ordritms!.map((v) => v.toJson()).toList();
    }
    data['PARTY_NAME'] = pARTYNAME;
    data['MOBILE1'] = mOBILE1;
    data['MOBILE2'] = mOBILE2;
    return data;
  }
}

class Ordritms {
  dynamic odId;
  dynamic oId;
  dynamic iTEMSR;
  dynamic vOUCHDT;
  dynamic vOUCHTIME;
  dynamic pCD;
  dynamic iTEMCD;
  dynamic qUANTITY;
  dynamic rATE;
  dynamic nRATE;
  dynamic lRATE;
  dynamic aMOUNT;
  dynamic oTHERDESC;
  dynamic fLD5;
  dynamic sYNCID;
  dynamic cREATEDBY;
  dynamic cREATEDAT;
  dynamic uPDATEDBY;
  dynamic uPDATEDAT;
  dynamic cREATEDAPPTYPE;
  dynamic mODULENO;
  Item? item;

  Ordritms(
      {this.odId,
        this.oId,
        this.iTEMSR,
        this.vOUCHDT,
        this.vOUCHTIME,
        this.pCD,
        this.iTEMCD,
        this.qUANTITY,
        this.rATE,
        this.nRATE,
        this.lRATE,
        this.aMOUNT,
        this.oTHERDESC,
        this.fLD5,
        this.sYNCID,
        this.cREATEDBY,
        this.cREATEDAT,
        this.uPDATEDBY,
        this.uPDATEDAT,
        this.cREATEDAPPTYPE,
        this.mODULENO,
        this.item});

  Ordritms.fromJson(Map<String, dynamic> json) {
    odId = json['odId'];
    oId = json['oId'];
    iTEMSR = json['ITEM_SR'];
    vOUCHDT = json['VOUCH_DT'];
    vOUCHTIME = json['VOUCH_TIME'];
    pCD = json['P_CD'];
    iTEMCD = json['ITEM_CD'];
    qUANTITY = json['QUANTITY'];
    rATE = json['RATE'];
    nRATE = json['NRATE'];
    lRATE = json['LRATE'];
    aMOUNT = json['AMOUNT'];
    oTHERDESC = json['OTHER_DESC'];
    fLD5 = json['FLD5'];
    sYNCID = json['SYNC_ID'];
    cREATEDBY = json['CREATED_BY'];
    cREATEDAT = json['CREATED_AT'];
    uPDATEDBY = json['UPDATED_BY'];
    uPDATEDAT = json['UPDATED_AT'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    mODULENO = json['MODULE_NO'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['odId'] = this.odId;
    data['oId'] = this.oId;
    data['ITEM_SR'] = this.iTEMSR;
    data['VOUCH_DT'] = this.vOUCHDT;
    data['VOUCH_TIME'] = this.vOUCHTIME;
    data['P_CD'] = this.pCD;
    data['ITEM_CD'] = this.iTEMCD;
    data['QUANTITY'] = this.qUANTITY;
    data['RATE'] = this.rATE;
    data['NRATE'] = this.nRATE;
    data['LRATE'] = this.lRATE;
    data['AMOUNT'] = this.aMOUNT;
    data['OTHER_DESC'] = this.oTHERDESC;
    data['FLD5'] = this.fLD5;
    data['SYNC_ID'] = this.sYNCID;
    data['CREATED_BY'] = this.cREATEDBY;
    data['CREATED_AT'] = this.cREATEDAT;
    data['UPDATED_BY'] = this.uPDATEDBY;
    data['UPDATED_AT'] = this.uPDATEDAT;
    data['CREATED_APP_TYPE'] = this.cREATEDAPPTYPE;
    data['MODULE_NO'] = this.mODULENO;
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    return data;
  }
}

class Item {
  dynamic iTEMCD;
  dynamic iTEMNAME;
  dynamic iTEMSNAME;
  dynamic iTEMLNAME;
  dynamic dEPTCD;
  dynamic sRATE1;
  dynamic sDISC;
  dynamic cSTK;
  dynamic lASTSIZE;

  Item(
      {this.iTEMCD,
        this.iTEMNAME,
        this.iTEMSNAME,
        this.iTEMLNAME,
        this.dEPTCD,
        this.sRATE1,
        this.sDISC,
        this.cSTK,
        this.lASTSIZE});

  Item.fromJson(Map<String, dynamic> json) {
    iTEMCD = json['ITEM_CD'];
    iTEMNAME = json['ITEM_NAME'];
    iTEMSNAME = json['ITEM_SNAME'];
    iTEMLNAME = json['ITEM_LNAME'];
    dEPTCD = json['DEPT_CD'];
    sRATE1 = json['SRATE1'];
    sDISC = json['SDISC'];
    cSTK = json['C_STK'];
    lASTSIZE = json['LAST_SIZE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ITEM_CD'] = this.iTEMCD;
    data['ITEM_NAME'] = this.iTEMNAME;
    data['ITEM_SNAME'] = this.iTEMSNAME;
    data['ITEM_LNAME'] = this.iTEMLNAME;
    data['DEPT_CD'] = this.dEPTCD;
    data['SRATE1'] = this.sRATE1;
    data['SDISC'] = this.sDISC;
    data['C_STK'] = this.cSTK;
    data['LAST_SIZE'] = this.lASTSIZE;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? pageSize;
  int? totalRecords;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPreviousPage;

  Pagination(
      {this.currentPage,
        this.pageSize,
        this.totalRecords,
        this.totalPages,
        this.hasNextPage,
        this.hasPreviousPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    hasPreviousPage = json['hasPreviousPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    data['totalPages'] = this.totalPages;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPreviousPage'] = this.hasPreviousPage;
    return data;
  }
}