// To parse this JSON data, do
//
//     final roleModel = roleModelFromJson(jsonString);

import 'dart:convert';

RoleModel roleModelFromJson(String str) => RoleModel.fromJson(json.decode(str));

String roleModelToJson(RoleModel data) => json.encode(data.toJson());

class RoleModel {
  RoleModel({
    this.success,
    this.data,
  });

  bool? success;
  List<RoleList>? data;

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        success: json["success"],
        data:
            List<RoleList>.from(json["data"].map((x) => RoleList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RoleList {
  RoleList({
    this.stringmapid,
    this.stringmaptype,
    this.stringmapname,
    this.description,
    this.status,
  });

  String? stringmapid;
  String? stringmaptype;
  String? stringmapname;
  String? description;
  String? status;

  factory RoleList.fromJson(Map<String?, dynamic> json) => RoleList(
        stringmapid: json["stringmapid"],
        stringmaptype: json["stringmaptype"],
        stringmapname: json["stringmapname"],
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "stringmapid": stringmapid,
        "stringmaptype": stringmaptype,
        "stringmapname": stringmapname,
        "description": description,
        "status": status,
      };
}
