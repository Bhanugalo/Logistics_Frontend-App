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
  String? sparePartStockId;
  String? sparePartName;
  String? spareModelNumber;
  List<String>? machineNames;
  String? availableStock;

  UserData(
      {this.sparePartStockId,
      this.sparePartName,
      this.spareModelNumber,
      this.machineNames,
      this.availableStock});

  UserData.fromJson(Map<String, dynamic> json) {
    sparePartStockId = json['Spare_Part_Stock_Id'];
    sparePartName = json['SparePartName'];
    spareModelNumber = json['Spare_Model_Number'];
    machineNames = json['Machine_Names'].cast<String>();
    availableStock = json['Available_Stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Spare_Part_Stock_Id'] = this.sparePartStockId;
    data['SparePartName'] = this.sparePartName;
    data['Spare_Model_Number'] = this.spareModelNumber;
    data['Machine_Names'] = this.machineNames;
    data['Available_Stock'] = this.availableStock;
    return data;
  }
}
