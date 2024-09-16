import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool? status;
  String? message;
  List<UserData>? allList;

  UserModel({this.status, this.message, this.allList});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    allList = json['allList'] == null
        ? []
        : List<UserData>.from(json['allList'].map((x) => UserData.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;

    if (this.allList != null) {
      data['allList'] = this.allList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  String? personId;
  String? userName;
  String? employeeId;
  String? mobileNumber;
  String? workLocation;
  String? department;
  String? designation;
  String? userProfile;
  String? createdOn;
  String? updatedOn;
  String? createdBy;
  Null? updatedBy;
  String? status;
  String? password;

  UserData(
      {this.personId,
      this.userName,
      this.employeeId,
      this.mobileNumber,
      this.workLocation,
      this.department,
      this.designation,
      this.userProfile,
      this.createdOn,
      this.updatedOn,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.password});

  UserData.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    userName = json['userName'];
    employeeId = json['employeeId'];
    mobileNumber = json['mobileNumber'];
    workLocation = json['workLocation'];
    department = json['department'];
    designation = json['designation'];
    userProfile = json['userProfile'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    status = json['status'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['userName'] = this.userName;
    data['employeeId'] = this.employeeId;
    data['mobileNumber'] = this.mobileNumber;
    data['workLocation'] = this.workLocation;
    data['department'] = this.department;
    data['designation'] = this.designation;
    data['userProfile'] = this.userProfile;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['status'] = this.status;
    data['password'] = this.password;
    return data;
  }
}
