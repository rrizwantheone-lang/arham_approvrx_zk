class UserExitsResponse {
  bool? status;
  String? message;
  UserExitsModel? data;

  UserExitsResponse({this.status, this.message, this.data});

  UserExitsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new UserExitsModel.fromJson(json['data']) : null;
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

class UserExitsModel {
  String? sCUSERCD;
  int? sCCUSTID;
  String? sCUSERNAME;
  String? sCMOBILENO;
  int? iSVERIFIED;

  UserExitsModel(
      {this.sCUSERCD,
        this.sCCUSTID,
        this.sCUSERNAME,
        this.sCMOBILENO,
        this.iSVERIFIED});

  UserExitsModel.fromJson(Map<String, dynamic> json) {
    sCUSERCD = json['SC_USER_CD'];
    sCCUSTID = json['SC_CUST_ID'];
    sCUSERNAME = json['SC_USER_NAME'];
    sCMOBILENO = json['SC_MOBILENO'];
    iSVERIFIED = json['IS_VERIFIED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SC_USER_CD'] = this.sCUSERCD;
    data['SC_CUST_ID'] = this.sCCUSTID;
    data['SC_USER_NAME'] = this.sCUSERNAME;
    data['SC_MOBILENO'] = this.sCMOBILENO;
    data['IS_VERIFIED'] = this.iSVERIFIED;
    return data;
  }
}

