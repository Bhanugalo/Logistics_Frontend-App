import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool? status;
  String? message;
  List<UserData>? data;

  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    data = json['data'] == null
        ? []
        : List<UserData>.from(json['data'].map((x) => UserData.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  String? vehicleId;
  String? vehicleNo;
  String? status;
  String? driverNumber;
  String? resultDate;
  String? resultTime;
  String? vehicleImg;
  String? vehicleImg1;
  String? vehicleImg2;
  String? vehicleImg3;
  String? vehicleImg4;
  String? transpotterName;
  String? partyName;
  String? location;
  String? vehicleLoadingType;
  String? invoiceImg;
  String? ewayBill;
  String? updatedOn;
  String? transferFrom;
  String? vehicleTypeName;
  String? createdPerson;

  UserData(
      {this.vehicleId,
      this.vehicleNo,
      this.status,
      this.driverNumber,
      this.resultDate,
      this.resultTime,
      this.vehicleImg,
      this.vehicleImg1,
      this.vehicleImg2,
      this.vehicleImg3,
      this.vehicleImg4,
      this.invoiceImg,
      this.ewayBill,
      this.transpotterName,
      this.partyName,
      this.location,
      this.vehicleLoadingType,
      this.updatedOn,
      this.transferFrom,
      this.vehicleTypeName,
      this.createdPerson});

  UserData.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicleId'];
    vehicleNo = json['vehicleNo'];
    status = json['status'];
    driverNumber = json['driverNumber'];
    resultDate = json['resultDate'];
    resultTime = json['resultTime'];
    vehicleImg = json['vehicleImg'];
    vehicleImg1 = json['vehicleImg1'];
    vehicleImg2 = json['vehicleImg2'];
    vehicleImg3 = json['vehicleImg3'];
    vehicleImg4 = json['vehicleImg4'];
    invoiceImg = json['invoiceImg'];
    ewayBill = json['ewayBill'];
    transpotterName = json['transpotterName'];
    partyName = json['partyName'];
    location = json['location'];
    vehicleLoadingType = json['vehicleLoadingType'];
    updatedOn = json['updatedOn'];
    transferFrom = json['transferFrom'];
    vehicleTypeName = json['vehicleTypeName'];
    createdPerson = json['createdPerson'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleId'] = this.vehicleId;
    data['vehicleNo'] = this.vehicleNo;
    data['status'] = this.status;
    data['driverNumber'] = this.driverNumber;
    data['resultDate'] = this.resultDate;
    data['resultTime'] = this.resultTime;
    data['vehicleImg'] = this.vehicleImg;
    data['vehicleImg1'] = this.vehicleImg1;
    data['vehicleImg2'] = this.vehicleImg2;
    data['vehicleImg3'] = this.vehicleImg3;
    data['vehicleImg4'] = this.vehicleImg4;
    data['invoiceImg'] = this.invoiceImg;
    data['ewayBill'] = this.ewayBill;
    data['transpotterName'] = this.transpotterName;
    data['partyName'] = this.partyName;
    data['location'] = this.location;
    data['vehicleLoadingType'] = this.vehicleLoadingType;
    data['updatedOn'] = this.updatedOn;
    data['transferFrom'] = this.transferFrom;
    data['vehicleTypeName'] = this.vehicleTypeName;
    data['createdPerson'] = this.createdPerson;
    return data;
  }
}
