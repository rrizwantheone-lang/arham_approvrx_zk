class DepartmentResponse {
  String? message;
  List<DepartmentModel>? data;

  DepartmentResponse({this.message, this.data});

  DepartmentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DepartmentModel>[];
      json['data'].forEach((v) {
        data!.add(new DepartmentModel.fromJson(v));
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

class DepartmentModel {
  dynamic dEPTCD;
  dynamic dEPTNAME;
  dynamic gROUPING;
  dynamic sYNCID;

  DepartmentModel({this.dEPTCD, this.dEPTNAME, this.gROUPING, this.sYNCID});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    dEPTCD = json['DEPT_CD'];
    dEPTNAME = json['DEPT_NAME'];
    gROUPING = json['GROUPING'];
    sYNCID = json['SYNC_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DEPT_CD'] = dEPTCD;
    data['DEPT_NAME'] = dEPTNAME;
    data['GROUPING'] = gROUPING;
    data['SYNC_ID'] = sYNCID;
    return data;
  }
}
