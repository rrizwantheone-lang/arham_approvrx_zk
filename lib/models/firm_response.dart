class FirmResponse {
  String? message;
  List<FirmModel>? data;

  FirmResponse({this.message, this.data});

  FirmResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <FirmModel>[];
      json['data'].forEach((v) {
        data!.add(FirmModel.fromJson(v));
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

class FirmModel {
  final String accCD;
  final String userCD;
  final String firmId;
  final String custId;
  final String syncId;
  final String firmName;
  final String? add1;
  final String? add2;
  final String? add3;
  final String? add4;
  final String? add5;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? zone;
  final String? pinCode;
  final String? mobile1;
  final String? mobile2;
  final String? personName;
  final String? emailId;
  final String? upi;
  final String? gstNo;
  final String? gstType;
  final String? panNo;
  final String? fssaiNo;
  final String? regNo1;
  final String? regNo2;
  final String isLocked;
  final String footer1;
  final String? footer2;
  final String? footer3;
  final String? footer4;
  final String? footer5;

  //ClientFirmLink? clientFirmLink;
  List<ClientFirmLinks>? clientFirmLinks;

  FirmModel({
    required this.userCD,
    required this.firmId,
    required this.custId,
    required this.syncId,
    required this.firmName,
    required this.accCD,
    this.add1,
    this.add2,
    this.add3,
    this.add4,
    this.add5,
    this.city,
    this.state,
    this.stateCode,
    this.zone,
    this.pinCode,
    this.mobile1,
    this.mobile2,
    this.personName,
    this.emailId,
    this.upi,
    this.gstNo,
    this.gstType,
    this.panNo,
    this.fssaiNo,
    this.regNo1,
    this.regNo2,
    required this.isLocked,
    required this.footer1,
    this.footer2,
    this.footer3,
    this.footer4,
    this.footer5,
    this.clientFirmLinks,
  });

  factory FirmModel.fromJson(Map<String, dynamic> json) {
    return FirmModel(
      accCD: json['ACC_CD'].toString(),
      userCD: json['USER_CD'].toString(),
      firmId: json['FIRM_ID'].toString(),
      custId: json['CUST_ID'].toString(),
      syncId: json['SYNC_ID'].toString(),
      firmName: json['FIRM_NAME'].toString(),
      add1: json['ADD1']?.toString(),
      add2: json['ADD2']?.toString(),
      add3: json['ADD3']?.toString(),
      add4: json['ADD4']?.toString(),
      add5: json['ADD5']?.toString(),
      city: json['CITY']?.toString(),
      state: json['STATE']?.toString(),
      stateCode: json['STATE_CODE']?.toString(),
      zone: json['ZONE']?.toString(),
      pinCode: json['PINCODE']?.toString(),
      mobile1: json['MOBILE1']?.toString(),
      mobile2: json['MOBILE2']?.toString(),
      personName: json['PERSON_NM']?.toString(),
      emailId: json['EMAIL_ID']?.toString(),
      upi: json['UPI']?.toString(),
      gstNo: json['GST_NO']?.toString(),
      gstType: json['GST_TYPE']?.toString(),
      panNo: json['PAN_NO']?.toString(),
      fssaiNo: json['FSSAI_NO']?.toString(),
      regNo1: json['REG_NO_1']?.toString(),
      regNo2: json['REG_NO_2']?.toString(),
      isLocked: json['IS_LOCKED']?.toString() ?? 'false',
      footer1: json['FOOTER1'].toString(),
      footer2: json['FOOTER2']?.toString(),
      footer3: json['FOOTER3']?.toString(),
      footer4: json['FOOTER4']?.toString(),
      footer5: json['FOOTER5']?.toString(),
      // clientFirmLink:
      //     json['client_firm_link'] != null
      //         ? new ClientFirmLink.fromJson(json['client_firm_link'])
      //         : null,
      clientFirmLinks:
          json['sc_scfirm_firm_link'] != null
              ? List<ClientFirmLinks>.from(
                json['sc_scfirm_firm_link'].map(
                  (v) => ClientFirmLinks.fromJson(v),
                ),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ACC_CD': accCD,
      'USER_CD': userCD,
      'FIRM_ID': firmId,
      'CUST_ID': custId,
      'SYNC_ID': syncId,
      'FIRM_NAME': firmName,
      'ADD1': add1,
      'ADD2': add2,
      'ADD3': add3,
      'ADD4': add4,
      'ADD5': add5,
      'CITY': city,
      'STATE': state,
      'STATE_CODE': stateCode,
      'ZONE': zone,
      'PINCODE': pinCode,
      'MOBILE1': mobile1,
      'MOBILE2': mobile2,
      'PERSON_NM': personName,
      'EMAIL_ID': emailId,
      'UPI': upi,
      'GST_NO': gstNo,
      'GST_TYPE': gstType,
      'PAN_NO': panNo,
      'FSSAI_NO': fssaiNo,
      'REG_NO_1': regNo1,
      'REG_NO_2': regNo2,
      'IS_LOCKED': isLocked,
      'FOOTER1': footer1,
      'FOOTER2': footer2,
      'FOOTER3': footer3,
      'FOOTER4': footer4,
      'FOOTER5': footer5,
      'sc_scfirm_firm_link': clientFirmLinks?.map((v) => v.toJson()).toList(),
    };
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
  String? uPDATEDAT;
  String? cREATEDAT;

  ClientFirmLinks({
    this.iD,
    this.cLIENTCD,
    this.aCCCD,
    this.aCCESSRIGHT,
    this.sYNCID,
    this.cREATEDBY,
    this.cREATEDAPPTYPE,
    this.uPDATEDAT,
    this.cREATEDAT,
  });

  ClientFirmLinks.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    cLIENTCD = json['CLIENT_CD'];
    aCCCD = json['ACC_CD'];
    aCCESSRIGHT = json['ACCESS_RIGHT'];
    sYNCID = json['SYNC_ID'];
    cREATEDBY = json['CREATED_BY'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
    uPDATEDAT = json['UPDATED_AT'];
    cREATEDAT = json['CREATED_AT'];
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
    data['UPDATED_AT'] = this.uPDATEDAT;
    data['CREATED_AT'] = this.cREATEDAT;
    return data;
  }
}
