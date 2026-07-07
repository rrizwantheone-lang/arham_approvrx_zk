class DashboardImageResponse {
  bool? status;
  String? appType;
  num? count;
  List<Images>? images;

  DashboardImageResponse({this.status, this.appType, this.count, this.images});

  DashboardImageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    appType = json['appType'];
    count = json['count'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['appType'] = this.appType;
    data['count'] = this.count;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  num? iD;
  String? iMAGEURL;
  String? cREATEDAPPTYPE;

  Images({this.iD, this.iMAGEURL, this.cREATEDAPPTYPE});

  Images.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iMAGEURL = json['IMAGE_URL'];
    cREATEDAPPTYPE = json['CREATED_APP_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IMAGE_URL'] = this.iMAGEURL;
    data['CREATED_APP_TYPE'] = this.cREATEDAPPTYPE;
    return data;
  }
}
