// To parse this JSON data, do
//
//     final cityRoleModel = cityRoleModelFromJson(jsonString);

import 'dart:convert';

List<CityRoleModel> cityRoleModelFromJson(String str) =>
    List<CityRoleModel>.from(
        json.decode(str).map((x) => CityRoleModel.fromJson(x)));

String cityRoleModelToJson(List<CityRoleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityRoleModel {
  int? id;
  String? name;

  CityRoleModel({
    this.id,
    this.name,
  });

  factory CityRoleModel.fromJson(Map<String, dynamic> json) => CityRoleModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
