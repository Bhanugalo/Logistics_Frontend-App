// To parse this JSON data, do
//
//     final countryRoleModel = countryRoleModelFromJson(jsonString);

import 'dart:convert';

CountryRoleModel countryRoleModelFromJson(String str) =>
    CountryRoleModel.fromJson(json.decode(str));

String countryRoleModelToJson(CountryRoleModel data) =>
    json.encode(data.toJson());

class CountryRoleModel {
  bool? success;
  List<Datum>? data;

  CountryRoleModel({
    this.success,
    this.data,
  });

  factory CountryRoleModel.fromJson(Map<String, dynamic> json) =>
      CountryRoleModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? countrycodeid;
  String? iso;
  String? name;
  String? nicename;
  String? iso3;
  int? numcode;
  String? phonecode;
  dynamic countryflagurl;

  Datum({
    this.countrycodeid,
    this.iso,
    this.name,
    this.nicename,
    this.iso3,
    this.numcode,
    this.phonecode,
    this.countryflagurl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        countrycodeid: json["countrycodeid"],
        iso: json["iso"],
        name: json["name"],
        nicename: json["nicename"],
        iso3: json["iso3"],
        numcode: json["numcode"],
        phonecode: json["phonecode"],
        countryflagurl: json["countryflagurl"],
      );

  Map<String, dynamic> toJson() => {
        "countrycodeid": countrycodeid,
        "iso": iso,
        "name": name,
        "nicename": nicename,
        "iso3": iso3,
        "numcode": numcode,
        "phonecode": phonecode,
        "countryflagurl": countryflagurl,
      };
}
