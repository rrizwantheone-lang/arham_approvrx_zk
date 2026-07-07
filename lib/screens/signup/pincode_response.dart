class PinCodeResponse {
  String? message;
  String? status;
  List<PinCodeModel>? postOffice;

  PinCodeResponse({this.message, this.status, this.postOffice});

  PinCodeResponse.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['PostOffice'] != null) {
      postOffice = <PinCodeModel>[];
      json['PostOffice'].forEach((v) {
        postOffice!.add(new PinCodeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.postOffice != null) {
      data['PostOffice'] = this.postOffice!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '''
Status: $status
Message: $message
Post Offices:
${postOffice?.map((e) => e.toString()).join('\n') ?? 'No Post Offices'}
''';
  }
}

class PinCodeModel {
  String? name;
  String? description;
  String? branchType;
  String? deliveryStatus;
  String? circle;
  String? district;
  String? division;
  String? region;
  String? block;
  String? state;
  String? country;
  String? pincode;

  PinCodeModel({
    this.name,
    this.description,
    this.branchType,
    this.deliveryStatus,
    this.circle,
    this.district,
    this.division,
    this.region,
    this.block,
    this.state,
    this.country,
    this.pincode,
  });

  PinCodeModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    description = json['Description'];
    branchType = json['BranchType'];
    deliveryStatus = json['DeliveryStatus'];
    circle = json['Circle'];
    district = json['District'];
    division = json['Division'];
    region = json['Region'];
    block = json['Block'];
    state = json['State'];
    country = json['Country'];
    pincode = json['Pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Description'] = this.description;
    data['BranchType'] = this.branchType;
    data['DeliveryStatus'] = this.deliveryStatus;
    data['Circle'] = this.circle;
    data['District'] = this.district;
    data['Division'] = this.division;
    data['Region'] = this.region;
    data['Block'] = this.block;
    data['State'] = this.state;
    data['Country'] = this.country;
    data['Pincode'] = this.pincode;
    return data;
  }

  @override
  String toString() {
    return '''
Name: $name
Branch Type: $branchType
Delivery Status: $deliveryStatus
Circle: $circle
District: $district
Division: $division
Region: $region
Block: $block
State: $state
Country: $country
Pincode: $pincode
''';
  }
}
