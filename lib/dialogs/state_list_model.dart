// To parse this JSON data, do
//
//     final stateRoleModel = stateRoleModelFromJson(jsonString);

import 'dart:convert';

List<StateRoleModel> stateRoleModelFromJson(String str) =>
    List<StateRoleModel>.from(
        json.decode(str).map((x) => StateRoleModel.fromJson(x)));

String stateRoleModelToJson(List<StateRoleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StateRoleModel {
  int? id;
  String? name;
  String? iso2;

  StateRoleModel({
    this.id,
    this.name,
    this.iso2,
  });

  factory StateRoleModel.fromJson(Map<String, dynamic> json) => StateRoleModel(
        id: json["id"],
        name: json["name"],
        iso2: json["iso2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iso2": iso2,
      };
}
