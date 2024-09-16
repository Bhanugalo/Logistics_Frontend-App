class AllMemberListModel {
  bool? success;
  Data? data;

  AllMemberListModel({this.success, this.data});

  AllMemberListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  List<Person>? person;

  Data({this.person});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['person'] != null) {
      person = <Person>[];
      json['person'].forEach((v) {
        person!.add(new Person.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.person != null) {
      data['person'] = this.person!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Person {
  String? businessname;
  String? businesscategory;
  String? personid;
  // Null title;
  String? firstname;
  String? middlename;
  String? lastname;
  Null suffix;
  String? profilepicture;
  String? dob;
  String? status;
  String? addrline1;
  String? addrline2;
  String? city;
  String? state;
  String? country;
  String? area;
  String? postalcode;
  String? countrycode;
  String? phonenum;

  Person(
      {this.businessname,
      this.businesscategory,
      this.personid,
      // this.title,
      this.firstname,
      this.middlename,
      this.lastname,
      this.suffix,
      this.profilepicture,
      this.dob,
      this.status,
      this.addrline1,
      this.addrline2,
      this.city,
      this.state,
      this.country,
      this.area,
      this.postalcode,
      this.countrycode,
      this.phonenum});

  Person.fromJson(Map<String, dynamic> json) {
    businessname = json['businessname'];
    businesscategory = json['businesscategory'];
    personid = json['personid'];
    // title = json['title'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    lastname = json['lastname'];
    suffix = json['suffix'];
    profilepicture = json['profilepicture'];
    dob = json['dob'];
    status = json['status'];
    addrline1 = json['addrline1'];
    addrline2 = json['addrline2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    area = json['area'];
    postalcode = json['postalcode'];
    countrycode = json['countrycode'];
    phonenum = json['phonenum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessname'] = this.businessname;
    data['businesscategory'] = this.businesscategory;
    data['personid'] = this.personid;
    // data['title'] = this.title;
    data['firstname'] = this.firstname;
    data['middlename'] = this.middlename;
    data['lastname'] = this.lastname;
    data['suffix'] = this.suffix;
    data['profilepicture'] = this.profilepicture;
    data['dob'] = this.dob;
    data['status'] = this.status;
    data['addrline1'] = this.addrline1;
    data['addrline2'] = this.addrline2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['area'] = this.area;
    data['postalcode'] = this.postalcode;
    data['countrycode'] = this.countrycode;
    data['phonenum'] = this.phonenum;
    return data;
  }
}
