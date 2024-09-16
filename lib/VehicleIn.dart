import 'dart:convert';
import 'dart:io';

import 'package:Logistic/VehicleInOutList.dart';
import 'package:Logistic/Welcomepage.dart';
import 'package:Logistic/components/app_loader.dart';
import 'package:dio/src/response.dart' as Response;
import 'package:Logistic/components/app_button_widget.dart';
import 'package:Logistic/directory.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'components/appbar.dart';
import 'constant/app_assets.dart';
import 'constant/app_color.dart';
import 'constant/app_fonts.dart';
import 'constant/app_strings.dart';
import 'constant/app_styles.dart';

class VehicleIn extends StatefulWidget {
  final String? id;
  VehicleIn({this.id});
  _VehicleState createState() => _VehicleState();
}

class _VehicleState extends State<VehicleIn> {
  File? _image, personPreview;
  List<int>? vehicleBytes, pdfFileBytes;
  List data = [];
  List statedata1 = [];
  List citydata1 = [];
  bool sameAsPresentAddress = false;

  final _dio = Dio();
  // Response? _response;
  Response.Response? _response;
  String? _genderType = 'Male',
      _employeementType = 'Internal',
      _maritalstatus = 'Married',
      bloodGroupController,
      PresentStateController,
      PresentCityController,
      token,
      PermanentStateController,
      PermanentCityController,
      departmentController,
      vehicleTypeController,
      reportingManagerController,
      designationController,
      profilepicture,
      personLogoname,
      personid,
      designation,
      department,
      setvehicleid,
      firstname,
      workLocation,
      _selectedFileName,
      lastname,
      pic,
      ImagePath,
      logo,
      site,
      businessname,
      organizationtype,
      dobdate,
      dojdate,
      doidate,
      announcementId,
      endDate,
      announcementStatus,
      Status = "";
  bool _isLoading = false;

  List bloodGroupList = [
    {"label": 'A+', "value": 'A+'},
    {"label": 'A-', "value": 'A-'},
    {"label": 'AB+', "value": 'AB+'},
    {"label": 'AB-', "value": 'AB-'},
    {"label": 'B+', "value": 'B+'},
    {"label": 'B-', "value": 'B-'},
    {"label": 'O+', "value": 'O+'},
    {"label": 'O-', "value": 'O-'},
  ];

  List departmentList = [],
      designationList = [],
      reportingManagerList = [],
      vehicleTypeList = [];

  SharedPreferences? prefs;
  TextEditingController vehicleNumberController = new TextEditingController();
  TextEditingController partyNameController = new TextEditingController();
  TextEditingController mobileNumberController = new TextEditingController();
  TextEditingController fathernameController = TextEditingController();

  TextEditingController joblocationController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController transporterNameController = TextEditingController();
  // TextEditingController transferFromController = TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController officialMobileController = new TextEditingController();
  TextEditingController personalMobileController = new TextEditingController();
  TextEditingController officialEmailController = new TextEditingController();
  TextEditingController personalEmailController = new TextEditingController();
  TextEditingController presentFulladdressController = TextEditingController();
  TextEditingController _PresentStatecontroller = new TextEditingController();
  TextEditingController _PresentCitycontroller = new TextEditingController();
  TextEditingController PresentPinCodeController = new TextEditingController();

  TextEditingController permanentFulladdressController =
      TextEditingController();
  TextEditingController _PermanentStatecontroller = new TextEditingController();
  TextEditingController _PermanentCitycontroller = new TextEditingController();
  TextEditingController PermanentPinCodeController =
      new TextEditingController();

  TextEditingController doiController = new TextEditingController();
  TextEditingController dojController = new TextEditingController();
  TextEditingController banknameController = TextEditingController();
  TextEditingController accountNumberController = new TextEditingController();
  TextEditingController ifsccodeController = TextEditingController();
  TextEditingController pannumberController = TextEditingController();
  TextEditingController branchaddressController = TextEditingController();
  TextEditingController familynameController = TextEditingController();
  TextEditingController familyrelationController = TextEditingController();
  TextEditingController familyaddressController = TextEditingController();
  TextEditingController familycontactnumberController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        pdfFileBytes = pdffile.readAsBytesSync();
        _selectedFileName = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  @override
  void initState() {
    store();
    getVehicleTypeData();

    getDepartmentData();
    getDsignationData();

    super.initState();
  }

  void store() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      designation = prefs.getString('designation');
      department = prefs.getString('department');
      pic = prefs.getString('pic');
      personid = prefs.getString('personid');
      site = prefs.getString('site');
      workLocation = prefs.getString('workLocation');
      token = prefs.getString('token');
    });
    _get();
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      // cameraDevice: CameraDevice.rear,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _compressImage(_image!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _compressImage(File imageFile) async {
    var _imageBytesOriginal = imageFile.readAsBytesSync();
    vehicleBytes = await FlutterImageCompress.compressWithList(
      _imageBytesOriginal!,
      quality: 60,
    );
  }

  Future _get() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.id != '' && widget.id != null) {
        _isLoading = true;
      }
      site = prefs.getString('site');
    });
    final EmployeeData = ((site!) + 'vehicleIN/getTransportById');
    final employeeData = await http.post(
      Uri.parse(EmployeeData),
      body: jsonEncode(<String, String>{"vehicleId": widget.id ?? ''}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var resBody = json.decode(employeeData.body);
    if (mounted) {
      setState(() {
        data = resBody['data'];

        if (data != null && data.length > 0) {
          _isLoading = false;
          final dataMap = data.asMap();
          vehicleNumberController.text = dataMap[0]['vehicleNo'] ?? '';
          vehicleTypeController = dataMap[0]['vehicleType'] ?? '';
          profilepicture = dataMap[0]['vehicleImg'] ?? '';
          mobileNumberController.text = dataMap[0]['driverNumber'] ?? '';
          locationController.text = dataMap[0]['location'] ?? '';
          partyNameController.text = dataMap[0]['partyName'] ?? '';
          transporterNameController.text = dataMap[0]['transpotterName'] ?? '';
          // transferFromController.text = dataMap[0]['transferFrom'] ?? '';
          Status = dataMap[0]['status'] ?? '';
        }
      });
    }
  }

  Future<bool> redirectto() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return designation != 'Super Admin'
          ? VehicleInOutList()
          : VehicleInOutList();
    }));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        // ignore: deprecated_member_use
        child: WillPopScope(
            // ignore: missing_return
            onWillPop: redirectto,
            child: Scaffold(
              appBar: GautamAppBar(
                organization: "organizationtype",
                isBackRequired: true,
                memberId: personid,
                imgPath: "ImagePath",
                memberPic: pic,
                logo: "logo",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return designation != 'Super Admin'
                        ? VehicleInOutList()
                        : VehicleInOutList();
                  }));
                },
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 15),
                child: _isLoading ? AppLoader() : _user(),
              ),
            )));
  }

  TextFormField textvehicleNumber() {
    return TextFormField(
      controller: vehicleNumberController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Vehicle Number",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: widget.id != '' && widget.id != null && Status == "LOADING"
          ? true
          : false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter vehicle number';
        }
        return null;
      },
    );
  }

  TextFormField textpartyName() {
    return TextFormField(
      controller: partyNameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Party Name",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      // readOnly: widget.id != '' && widget.id != null ? true : false,
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return 'Please enter party name';
      //   }
      //   return null;
      // },
    );
  }

  TextFormField textmobileNumber() {
    return TextFormField(
      controller: mobileNumberController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      maxLength: 10, // Set maximum length to 10 digits
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Mobile Number",
          counterText:
              '', // This will hide the character counter below the TextFormField
          contentPadding: const EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: widget.id != '' && widget.id != null && Status == "LOADING"
          ? true
          : false,
      validator: (value) {
        if (value != "" && value!.length != 10) {
          return 'Please enter valid mobile number';
        }
        return null;
      },
    );
  }

  TextFormField textLocation() {
    return TextFormField(
      controller: locationController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Location",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,

      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return 'Please enter location';
      //   }
      //   return null;
      // },
    );
  }

  TextFormField textTransporterName() {
    return TextFormField(
      controller: transporterNameController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Transporter Name",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: widget.id != '' && widget.id != null && Status == "LOADING"
          ? true
          : false,
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return 'Please enter transporter name';
      //   }
      //   return null;
      // },
    );
  }

  // TextFormField textTransferFrom() {
  //   return TextFormField(
  //     controller: transferFromController,
  //     minLines: 1,
  //     maxLines: null,
  //     keyboardType: TextInputType.text,
  //     textInputAction: TextInputAction.next,
  //     decoration: AppStyles.textFieldInputDecoration.copyWith(
  //         hintText: "Please Enter Transfer From",
  //         counterText: '',
  //         contentPadding: EdgeInsets.all(10)),
  //     style: AppStyles.textInputTextStyle,
  //     readOnly: widget.id != '' && widget.id != null && Status == "LOADING"
  //         ? true
  //         : false,
  //     // validator: (value) {
  //     //   if (value!.isEmpty) {
  //     //     return 'Please enter transfer from';
  //     //   }
  //     //   return null;
  //     // },
  //   );
  // }

  getDepartmentData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    final url = (site! + 'department/department-list');

    http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var departmentBody = jsonDecode(response.body);
        setState(() {
          departmentList = departmentBody['departmentList'];
        });
      }
    });
  }

  getDsignationData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    final url = (site! + 'dsignation/designation-list');

    http.get(
      Uri.parse(url),
      // body: jsonEncode(<String, String>{"departmentid": departmentId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var designationBody = jsonDecode(response.body);
        setState(() {
          designationList = designationBody['designationList'];
        });
      }
    });
  }

  getVehicleTypeData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    final url = (site! + 'vehicle/vehicle-types');

    http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var designationBody = jsonDecode(response.body);
        setState(() {
          vehicleTypeList = designationBody['vehicleTypes'];
        });
      }
    });
  }

  // DropdownButtonFormField textLocation() {
  //   return DropdownButtonFormField<String>(
  //     decoration: InputDecoration(
  //       hintText: 'Please Select Work Location', // Add hint text here
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //     borderRadius: BorderRadius.circular(20),
  //     items: vehicleTypeList
  //         .map((label) => DropdownMenuItem(
  //               child: Text(label['Location'],
  //                   style: AppStyles.textInputTextStyle),
  //               value: label['LocationID'].toString(),
  //             ))
  //         .toList(),
  //     onChanged: (val) {
  //       setState(() {
  //         vehicleTypeController = val!;
  //       });
  //     },
  //     value: vehicleTypeController != '' ? vehicleTypeController : null,
  //   );
  // }
  DropdownButtonFormField textvehicleType() {
    return DropdownButtonFormField<String>(
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Select Vehicle Type",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      borderRadius: BorderRadius.circular(20),
      items: vehicleTypeList
          .map((label) => DropdownMenuItem(
                child: Text(label['vehicleTypeName'],
                    style: AppStyles.textInputTextStyle),
                value: label['vehicleTypeId'].toString(),
              ))
          .toList(),
      onChanged: widget.id != '' && widget.id != null && Status == "LOADING"
          ? null
          : (val) {
              setState(() {
                vehicleTypeController = val!;
              });
            },
      value: vehicleTypeController != '' ? vehicleTypeController : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a vehicle type';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField textDepartment() {
    return DropdownButtonFormField<String>(
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Select Department",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      borderRadius: BorderRadius.circular(20),
      items: departmentList
          .map((label) => DropdownMenuItem(
                child: Text(label['DepartmentName'],
                    style: AppStyles.textInputTextStyle),
                value: label['DepartmentId'].toString(),
              ))
          .toList(),
      onChanged:
          widget.id != '' && widget.id != null && designation != "Super Admin"
              ? null
              : (val) {
                  setState(() {
                    departmentController = val!;
                  });
                },
      value: departmentController != '' ? departmentController : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a department';
        }
        return null; // Return null if the validation is successful
      },
    );
  }

  DropdownButtonFormField textDesignation() {
    return DropdownButtonFormField<String>(
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Select Designation",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      borderRadius: BorderRadius.circular(20),
      items: designationList
          .map((label) => DropdownMenuItem(
                child: Text(label['DesignationName'],
                    style: AppStyles.textInputTextStyle),
                value: label['DesignationId'].toString(),
              ))
          .toList(),
      onChanged:
          widget.id != '' && widget.id != null && designation != "Super Admin"
              ? null
              : (val) {
                  setState(() {
                    designationController = val!;
                  });
                },
      value: designationController != '' ? designationController : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a designation';
        }
        return null; // Return null if the validation is successful
      },
    );
  }

  Future createData(
    String vehicleNumber,
    String vehicleType,
    String mobileNumber,
    String partyName,
    String location,
    String transportName,
  ) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    final url = (site! + 'vehicleIN/vehicle-entry');
    var params = {
      "vehicleId":
          widget.id != '' && widget.id != null ? widget.id.toString() : '',
      "workLocation": workLocation ?? "",
      "currentUser": personid ?? '',
      "vehicleNo": vehicleNumber,
      "vehicleType": vehicleType,
      "transpotterName": transportName,
      "location": location,
      "partyName": partyName,
      "driverNumber": mobileNumber,
    };

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(params),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['message'] == 'Vehicle entry updated successfully') {
        if (vehicleBytes != null && vehicleBytes != '') {
          setState(() {
            setvehicleid = data['vehicleId'];
          });
          upload((vehicleBytes ?? []), (vehicleNumber ?? ''));
        } else {
          setState(() {
            _isLoading = false;
          });
          Toast.show(
              widget.id != '' && widget.id != null
                  ? "Vehicle In Updated Successfully."
                  : "Vehicle In Successfully.",
              duration: Toast.lengthLong,
              gravity: Toast.center,
              backgroundColor: AppColors.primaryColor);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => VehicleInOutList()),
              (Route<dynamic> route) => false);
        }
      } else {
        setState(() {
          setvehicleid = data['vehicleId'];
        });
        if (vehicleBytes != null && vehicleBytes != '') {
          upload((vehicleBytes ?? []), (vehicleNumber ?? ''));
          // pdfFileUpload((pdfFileBytes ?? []), (personLogoname ?? ''));
        } else {
          Toast.show(
              widget.id != '' && widget.id != null
                  ? "Vehicle In Updated Successfully."
                  : "Vehicle In Successfully.",
              duration: Toast.lengthLong,
              gravity: Toast.center,
              backgroundColor: AppColors.primaryColor);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => VehicleInOutList()),
              (Route<dynamic> route) => false);
        }
      }
    } else if (response.statusCode == 400) {
      setState(() {
        _isLoading = false;
      });
      Toast.show("This Login Id is Already Active.",
          duration: Toast.lengthLong,
          gravity: Toast.center,
          backgroundColor: Colors.redAccent);
    } else {
      setState(() {
        _isLoading = false;
      });
      Toast.show("Error on Server",
          duration: Toast.lengthLong,
          gravity: Toast.center,
          backgroundColor: Colors.redAccent);
    }
  }

  upload(List<int> bytes, String name) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      'type': "IN",
      'vehicleId': setvehicleid != '' && setvehicleid != null
          ? setvehicleid
          : widget.id != '' && widget.id != null
              ? widget.id.toString()
              : '',
      "vechileInImage": MultipartFile.fromBytes(
        bytes,
        filename: (name + (currentdate.toString()) + '.jpg'),
        contentType: MediaType("image", 'jpg'),
      ),
    });

    _response =
        await _dio.post((site! + 'vehicleIN/upload-vehicleIn-image'), // Prod

            options: Options(
              contentType: 'multipart/form-data',
              followRedirects: false,
              validateStatus: (status) => true,
            ),
            data: formData);

    try {
      if (_response!.data != null) {
        setState(() {
          _isLoading = false;
        });

        Toast.show(
            widget.id != '' && widget.id != null
                ? "Vehicle In Updated Successfully."
                : "Vehicle In Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.primaryColor);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => VehicleInOutList()),
            (Route<dynamic> route) => false);
      }
    } catch (err) {
      print("Error");
    }
  }

  Widget _user() {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: ListView(
          children: [
            // Padding(padding: EdgeInsets.only(top: 10)),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
              ),
            ),
            //  Padding(padding: EdgeInsets.only(top: 5)),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    widget.id != '' && widget.id != null
                        ? 'Vehicle In Edit'
                        : 'Vehicle In',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        fontFamily: appFontFamily,
                        color: AppColors.blueColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _image == null
                      ? Container(
                          width: 200,
                          height: 200,
                          child: GestureDetector(
                            onTap: () {
                              if ((widget.id != '' &&
                                      widget.id != null &&
                                      Status == "IN") ||
                                  (widget.id == '' || widget.id == null)) {
                                getImage();
                              }
                            },
                            child: widget.id != "" && widget.id != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: profilepicture != "" &&
                                            profilepicture != null
                                        ? Image.network(
                                            profilepicture!, // profilepicture should be the URL string
                                            fit: BoxFit.cover,
                                            width: 250,
                                            height: 250,
                                          )
                                        : Image.asset(
                                            AppAssets.camera,
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 200,
                                          ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      AppAssets.camera,
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 200,
                                    ),
                                  ),
                          ),
                        )
                      : Container(
                          width: 300,
                          height: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: 300,
                              height: 300,
                            ),
                          ),
                        ),

                  // personPreview != null
                  //     ? Center(
                  //         child: CircleAvatar(
                  //             radius: 100,
                  //             child: ClipOval(
                  //                 child: Image.file(
                  //               personPreview!,
                  //               width: 100,
                  //               height: 100,
                  //               fit: BoxFit.cover,
                  //             ))),
                  //       )
                  //     : profilepicture != ""
                  //         ? InkWell(
                  //             onTap: () async {
                  //               FilePickerResult? result =
                  //                   await FilePicker.platform.pickFiles(
                  //                       type: FileType.image, withData: true);
                  //               CroppedFile? croppedprofilepicture =
                  //                   await ImageCropper().cropImage(
                  //                       cropStyle: CropStyle.circle,
                  //                       maxWidth: 500,
                  //                       compressFormat: ImageCompressFormat.jpg,
                  //                       sourcePath:
                  //                           (result!.files.single.path ?? ''),
                  //                       aspectRatio: const CropAspectRatio(
                  //                           ratioX: 15, ratioY: 15));
                  //               if (result != null) {
                  //                 var name = locationController.text;
                  //                 setState(() {
                  //                   personPreview =
                  //                       File(croppedprofilepicture!.path);
                  //                 });
                  //                 if (result != null) {
                  //                   var _imageBytesOriginal =
                  //                       personPreview!.readAsBytesSync();
                  //                   personlogoBytes = await FlutterImageCompress
                  //                       .compressWithList(
                  //                     _imageBytesOriginal!,
                  //                     quality: 60,
                  //                   );

                  //                   // personlogoBytes =
                  //                   //     await croppedprofilepicture!
                  //                   //         .readAsBytes();

                  //                   personLogoname = locationController.text;
                  //                 }
                  //               }
                  //             },
                  //             child: Center(
                  //               child: CircleAvatar(
                  //                 radius: 75,
                  //                 child: ClipOval(
                  //                     child: CachedNetworkImage(
                  //                   imageUrl: ((profilepicture ?? '')),
                  //                   height: 100,
                  //                   width: 100,
                  //                   fit: BoxFit.fill,
                  //                   placeholder: (context, url) {
                  //                     return CircleAvatar(
                  //                       radius: 75,
                  //                       child: ClipOval(
                  //                         child: Image.asset(
                  //                           AppAssets.camera,
                  //                           height: 100,
                  //                           width: 100,
                  //                         ),
                  //                       ),
                  //                     );
                  //                   },
                  //                   errorWidget: (context, url, error) {
                  //                     return CircleAvatar(
                  //                       radius: 75,
                  //                       child: ClipOval(
                  //                         child: Image.asset(
                  //                           AppAssets.camera,
                  //                           height: 100,
                  //                           width: 100,
                  //                         ),
                  //                       ),
                  //                     );
                  //                   },
                  //                 )),
                  //               ),
                  //             ))
                  //         : InkWell(
                  //             onTap: () async {
                  //               FilePickerResult? result =
                  //                   await FilePicker.platform.pickFiles(
                  //                       type: FileType.image, withData: true);
                  //               CroppedFile? croppedprofilepicture =
                  //                   await ImageCropper().cropImage(
                  //                       cropStyle: CropStyle.circle,
                  //                       maxWidth: 500,
                  //                       compressFormat: ImageCompressFormat.jpg,
                  //                       sourcePath:
                  //                           (result!.files.single.path ?? ''),
                  //                       aspectRatio: const CropAspectRatio(
                  //                           ratioX: 15, ratioY: 15));

                  //               if (result != null) {
                  //                 var name = locationController.text;
                  //                 setState(() {
                  //                   personPreview =
                  //                       File(croppedprofilepicture!.path);
                  //                 });
                  //                 if (result != null) {
                  //                   await croppedprofilepicture!.readAsBytes();
                  //                   var _imageBytesOriginal =
                  //                       personPreview!.readAsBytesSync();
                  //                   personlogoBytes = await FlutterImageCompress
                  //                       .compressWithList(
                  //                     _imageBytesOriginal!,
                  //                     quality: 60,
                  //                   );
                  //                   personLogoname = locationController.text;
                  //                 }
                  //               }
                  //             },
                  //             child: Center(
                  //               child: Container(
                  //                 width: 70,
                  //                 height: 70,
                  //                 decoration: const BoxDecoration(
                  //                   color: AppColors.blueColor,
                  //                   shape: BoxShape.circle,
                  //                 ),
                  //                 child: const Center(
                  //                   child: Text(
                  //                     "Upload Vehicle Picture",
                  //                     textAlign: TextAlign.center,
                  //                     style: TextStyle(
                  //                         fontFamily: appFontFamily,
                  //                         fontWeight: FontWeight.w700,
                  //                         fontSize: 14,
                  //                         color: AppColors.white),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  const Padding(padding: EdgeInsets.only(left: 10.0)),
                ]),

            Text(
              "Vehicle Number*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            textvehicleNumber(),
            const SizedBox(
              height: 15,
            ),

            Text(
              "Vehicle Type*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textvehicleType(),

            const SizedBox(
              height: 15,
            ),

            Text(
              "Driver's Mobile Number",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            textmobileNumber(),
            const SizedBox(
              height: 15,
            ),

            Text(
              "Party Name",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            textpartyName(),
            const SizedBox(
              height: 15,
            ),

            Text(
              "Location",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textLocation(),
            const SizedBox(height: 15),

            Text(
              "Transporter Name",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            textTransporterName(),
            const SizedBox(
              height: 15,
            ),

            SizedBox(height: 20),

            AppButton(
              organization: (organizationtype ?? ''),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  fontSize: 16),
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  if ((widget.id == '' || widget.id == null) &&
                      (vehicleBytes != null && vehicleBytes != '')) {
                    createData(
                        vehicleNumberController.text,
                        vehicleTypeController ?? "",
                        mobileNumberController.text,
                        partyNameController.text,
                        locationController.text,
                        transporterNameController.text);
                  } else if ((widget.id != '' && widget.id != null)) {
                    createData(
                        vehicleNumberController.text,
                        vehicleTypeController ?? "",
                        mobileNumberController.text,
                        partyNameController.text,
                        locationController.text,
                        transporterNameController.text);
                  } else {
                    Toast.show("Please Take Vehicle Picture.",
                        duration: Toast.lengthLong,
                        gravity: Toast.center,
                        backgroundColor: Colors.redAccent);
                  }
                }
              },
              label: AppStrings.SAVE,
            ),
            SizedBox(height: 10),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                VehicleInOutList()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: appFontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.redColor),
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        ));
  }
}
