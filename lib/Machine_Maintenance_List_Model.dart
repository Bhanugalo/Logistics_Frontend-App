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
  String? machineMaintenanceId;
  String? sparePartName;
  String? sparePartModelNumber;
  String? machineName;
  String? machineModelNumber;
  String? issue;
  String? breakDownStartTime;
  String? breakDownEndTime;
  String? breakDownTotalTime;
  String? quantity;
  String? solutionProcess;
  String? line;
  // List<String>? chamber;
  String? imageURL;
  String? stockAfterUsage;
  List<String>? maintenancedBy;
  String? maintenanceDate;
  String? isSparePartChanged;
  String? maintenanceType;

  UserData(
      {this.machineMaintenanceId,
      this.sparePartName,
      this.sparePartModelNumber,
      this.machineName,
      this.machineModelNumber,
      this.issue,
      this.breakDownStartTime,
      this.breakDownEndTime,
      this.breakDownTotalTime,
      this.quantity,
      this.solutionProcess,
      this.line,
      // this.chamber,
      this.imageURL,
      this.stockAfterUsage,
      this.maintenancedBy,
      this.maintenanceDate,
      this.isSparePartChanged,
      this.maintenanceType});

  UserData.fromJson(Map<String, dynamic> json) {
    machineMaintenanceId = json['Machine_Maintenance_Id'];
    sparePartName = json['Spare Part Name'];
    sparePartModelNumber = json['Spare Part Model Number'];
    machineName = json['Machine Name'];
    machineModelNumber = json['Machine Model Number'];
    issue = json['Issue'];
    breakDownStartTime = json['BreakDown Start Time'];
    breakDownEndTime = json['BreakDown End Time'];
    breakDownTotalTime = json['BreakDown Total Time'];
    quantity = json['Quantity'];
    solutionProcess = json['Solution Process'];
    line = json['Line'];
    // if (json['Chamber'] != null) {
    //   chamber = <String>[];
    //   json['Chamber'].forEach((v) {
    //     chamber!.add(chamber.fromJson(v));
    //   });
    // }
    imageURL = json['Image_URL'];
    stockAfterUsage = json['Stock After Usage'];
    maintenancedBy = json['Maintenanced by'].cast<String>();
    maintenanceDate = json['Logistic Date'];
    isSparePartChanged = json['Is Spare Part Changed'];
    maintenanceType = json['Logistic Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Machine_Maintenance_Id'] = this.machineMaintenanceId;
    data['Spare Part Name'] = this.sparePartName;
    data['Spare Part Model Number'] = this.sparePartModelNumber;
    data['Machine Name'] = this.machineName;
    data['Machine Model Number'] = this.machineModelNumber;
    data['Issue'] = this.issue;
    data['BreakDown Start Time'] = this.breakDownStartTime;
    data['BreakDown End Time'] = this.breakDownEndTime;
    data['BreakDown Total Time'] = this.breakDownTotalTime;
    data['Quantity'] = this.quantity;
    data['Solution Process'] = this.solutionProcess;
    data['Line'] = this.line;
    // if (this.chamber != null) {
    //   data['Chamber'] = this.chamber!.map((v) => v.toJson()).toList();
    // }
    data['Image_URL'] = this.imageURL;
    data['Stock After Usage'] = this.stockAfterUsage;
    data['Maintenanced by'] = this.maintenancedBy;
    data['Logistic Date'] = this.maintenanceDate;
    data['Is Spare Part Changed'] = this.isSparePartChanged;
    data['Logistic Type'] = this.maintenanceType;
    return data;
  }
}
