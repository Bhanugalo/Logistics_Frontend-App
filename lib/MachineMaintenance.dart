import 'dart:convert';
import 'dart:io';
import 'package:Logistic/MachineMaintenanceList.dart';
import 'package:Logistic/VehicleInOutList.dart';
import 'package:Logistic/Welcomepage.dart';
import 'package:Logistic/components/app_button_widget.dart';
import 'package:Logistic/components/appbar.dart';
import 'package:Logistic/constant/app_assets.dart';
import 'package:Logistic/constant/app_color.dart';
import 'package:Logistic/constant/app_fonts.dart';
import 'package:Logistic/constant/app_helper.dart';
import 'package:Logistic/constant/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:Logistic/constant/app_color.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class MachineMaintenance extends StatefulWidget {
  final String? id;
  MachineMaintenance({this.id});
  @override
  _MachineMaintenanceState createState() => _MachineMaintenanceState();
}

class _MachineMaintenanceState extends State<MachineMaintenance> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController specificationController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController solutionProcessController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController issueController = TextEditingController();
  TextEditingController sparePartNameController = TextEditingController();
  TextEditingController invoicePdfController = TextEditingController();
  TextEditingController maintenanceStartTimeController =
      TextEditingController();
  TextEditingController maintenanceEndTimeController = TextEditingController();
  TextEditingController maintenanceTimeController = TextEditingController();
  TextEditingController machineNumberController = TextEditingController();

  String Chamber1 = "", Chamber2 = "", Chamber3 = "", Chamber4 = "";
  TextEditingController chamber1Controller = TextEditingController();
  TextEditingController chamber2Controller = TextEditingController();
  TextEditingController chamber3Controller = TextEditingController();
  TextEditingController chamber4Controller = TextEditingController();

  File? _image;
  List<int>? _imageBytes;
  List sparePartsNameList = [];
  List POList = [];
  List<dynamic> chamber = [];
  List sparePartModelNoList = [];
  List allList = [];
  List machineList = [];
  List currencyList = [];
  List<String> selectedMachineItems = [];
  List<dynamic> Mach = [];
  List lineList = [
    {"label": 'Line A', "value": 'Line A'},
    {"label": 'Line B', "value": 'Line B'},
    {"label": 'None', "value": 'None'},
  ];

  List<int>? invoicePdfFileBytes;

  bool menu = false, user = false, face = false, home = false;

  bool _isLoading = false;
  String setPage = '', pic = '', site = '', personid = '';

  List<int>? referencePdfFileBytes;
  String selectedmachine = "", AvailableStock = "", lineController = "";
  String selectedmachinemodel = "";
  String selectedspare = "";
  String selectedsparemodel = "",
      isSparePartChanged = "Yes",
      maintenanceType = "Breakdown",
      sendSelectedsparemodel = "",
      recvSelectedsparemodel = "",
      selectMachineName = "",
      remainingQuantity = "",
      sendSelectedMachine = "";
  String selectedCurrency = "";
  String selectedPO = "", editImage = "";

  String status = '',
      machineMaintenanceId = '',
      designation = '',
      token = '',
      department = '';
  final _dio = Dio();
  List data = [];

  Response.Response? _response;

  @override
  void initState() {
    super.initState();
    store();
    quantityController.addListener(updateTotalCost);
    priceController.addListener(updateTotalCost);
  }

  @override
  void dispose() {
    quantityController.removeListener(updateTotalCost);
    priceController.removeListener(updateTotalCost);

    quantityController.dispose();
    priceController.dispose();

    totalCostController.dispose();

    super.dispose();
  }

  void updateTotalCost() {
    double priceAmount = 0.0;
    double receiveQuantity = 0.0;

    // Check if the text fields are not empty before parsing
    if (priceController.text.isNotEmpty) {
      priceAmount = double.parse(priceController.text);
    }

    if (quantityController.text.isNotEmpty) {
      receiveQuantity = double.parse(quantityController.text);
    }

    double totalCost = priceAmount * receiveQuantity;

    setState(() {
      totalCostController.text =
          totalCost.toStringAsFixed(2) + " " + selectedCurrency;
    });
  }

  // *******  Send the Data where will be Used to Backend *******

  void store() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pic = prefs.getString('pic')!;
      personid = prefs.getString('personid')!;
      site = prefs.getString('site')!;
      designation = prefs.getString('designation')!;
      department = prefs.getString('department')!;
      token = prefs.getString('token')!;
    });
    // setState(() {
    //   selectMachineName = " Framing Machine";
    // });
    getMachineListData();
    if (widget.id != "" && widget.id != null) {
      getDataById();
    }
  }

  getDataById() async {
    print("widget.id, Bhanu...............???");
    print(widget.id);
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;
    setState(() {
      _isLoading = true;
    });

    final url = (site! + 'Logistic/GetMachineMaintenanceList');

    http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        "MachineMaintenanceId": widget.id!,
        "PersonId": "",
        "reqData": ""
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var decodedResult = jsonDecode(response.body);
        print("respo..........??");
        print(decodedResult['data'][0]);
        setState(() {
          _isLoading = false;
          sendSelectedMachine = decodedResult['data'][0]['MachineId'];
          selectMachineName = decodedResult['data'][0]['Machine Name'];
          machineNumberController.text =
              decodedResult['data'][0]['Machine Number'];
          lineController = decodedResult['data'][0]['Line'] ?? "";
          //  chamber,
          if (decodedResult['data'][0]['Chamber'].length > 0) {
            Chamber1 =
                decodedResult['data'][0]['Chamber']?[0]['Chamber1'] ?? "";
            chamber1Controller.text = decodedResult['data'][0]['Chamber']?[0]
                    ['ChamberQuantity'] ??
                "";

            Chamber2 =
                decodedResult['data'][0]?['Chamber']?[1]['Chamber2'] ?? "";
            chamber2Controller.text = decodedResult['data'][0]['Chamber']?[1]
                    ['ChamberQuantity'] ??
                "";

            Chamber3 =
                decodedResult['data'][0]['Chamber']?[2]['Chamber3'] ?? "";
            chamber3Controller.text = decodedResult['data'][0]['Chamber']?[2]
                    ['ChamberQuantity'] ??
                "";

            Chamber4 =
                decodedResult['data'][0]['Chamber']?[3]['Chamber4'] ?? "";
            chamber4Controller.text = decodedResult['data'][0]['Chamber']?[3]
                    ['ChamberQuantity'] ??
                "";
          }

          issueController.text = decodedResult['data'][0]['Issue'] ?? "";
          maintenanceStartTimeController.text =
              decodedResult['data'][0]['BreakDown Start Time'] ?? "";
          maintenanceEndTimeController.text =
              decodedResult['data'][0]['BreakDown End Time'] ?? "";
          maintenanceTimeController.text =
              decodedResult['data'][0]['BreakDown Total Time'] ?? "";
          selectedsparemodel =
              decodedResult['data'][0]['Spare Part Model Number'] ?? "";
          sendSelectedsparemodel =
              decodedResult['data'][0]['SparePartId'] ?? "";
          recvSelectedsparemodel =
              decodedResult['data'][0]['SparePartId'] ?? "";
          sparePartNameController.text =
              decodedResult['data'][0]['Spare Part Name'] ?? "";
          AvailableStock = decodedResult['data'][0]['Available_Stock'] ?? "";
          quantityController.text =
              decodedResult['data'][0]['Quantity'] == "0" ||
                      decodedResult['data'][0]['Quantity'] == null ||
                      decodedResult['data'][0]['Quantity'] == ""
                  ? ""
                  : decodedResult['data'][0]['Quantity'];
          remarksController.text = decodedResult['data'][0]['Remark'] ?? "";
          solutionProcessController.text =
              decodedResult['data'][0]['Solution Process'] ?? "";
          editImage = decodedResult['data'][0]['Image_URL'] ?? "";
          if (decodedResult['data'][0]['Machine Name'] != "" &&
              decodedResult['data'][0]['Machine Name'] != null) {
            getSparePartModelNoListData(
                decodedResult['data'][0]['Machine Name']);
          }
          maintenanceType = decodedResult['data'][0]['Logistic Type'] ?? "";
          isSparePartChanged =
              decodedResult['data'][0]['Is Spare Part Changed'] ?? "";
        });
      }
    });

    return null;
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
    _imageBytes = await FlutterImageCompress.compressWithList(
      _imageBytesOriginal!,
      quality: 60,
    );
    print("kya hai bytes??");
    print(_imageBytes);
  }

  Future<void> _pickcocPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        invoicePdfFileBytes = pdffile.readAsBytesSync();
        invoicePdfController.text = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  getMachineListData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Logistic/MachineList');

    http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var machineBody = jsonDecode(response.body);
        print("machine.....?");
        print(machineBody);
        setState(() {
          machineList = machineBody['data'];
        });
      }
    });
  }

  getSparePartModelNoListData(machineName) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Logistic/GetStockByMachine');

    http.post(
      Uri.parse(url),
      body: json.encode({"MachineName": machineName}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var machineBody = jsonDecode(response.body);

        setState(() {
          sparePartModelNoList = machineBody;
        });
      }
    });
  }

  getPONumberListData(PartyId, SparepartModelId) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Logistic/GetVoucherList');

    http.post(
      Uri.parse(url),
      body: json.encode({"SparePartId": SparepartModelId, "PartyId": PartyId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var poBody = jsonDecode(response.body);
        setState(() {
          POList = poBody;
        });
      }
    });
  }

  getAllDataFromPONumber(SparePartId, PurchaseOrderId) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Logistic/GetPO&SparePartDetail');

    http.post(
      Uri.parse(url),
      body: json.encode(
          {"SparePartId": SparePartId, "PurchaseOrderId": PurchaseOrderId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var allBody = jsonDecode(response.body);
        print("Raajjj.....?");
        print(allBody);

        setState(() {
          // allList = allBody;
          issueController.text = allBody['BrandName'];

          priceController.text = allBody['Price'];
          specificationController.text = allBody['Specification'];
          quantityController.text = allBody['Quantity'];

          currencyController.text = allBody['Currency'];
          solutionProcessController.text = allBody['Unit'];
          Mach = allBody['Machine'];
          selectedMachineItems = Mach.where((element) => element is String)
              .cast<String>()
              .toList();
        });
      }
    });
  }

  Future createData() async {
    print("Person Id......?");
    print(personid);
    chamber = [
      {"Chamber1": Chamber1, "ChamberQuantity": chamber1Controller.text},
      {"Chamber2": Chamber2, "ChamberQuantity": chamber2Controller.text},
      {"Chamber3": Chamber3, "ChamberQuantity": chamber3Controller.text},
      {"Chamber4": Chamber4, "ChamberQuantity": chamber4Controller.text}
    ];

    var data = {
      "MachineMaintenanceId": widget.id ?? "",
      "CreatedBy": personid,
      "MachineName": sendSelectedMachine,
      "Line": lineController,
      "Chamber": chamber,
      "Issue": issueController.text,
      "BreakDownStartTime": maintenanceStartTimeController.text,
      "BreakDownEndTime": maintenanceEndTimeController.text,
      "BreakDownTotalTime": maintenanceTimeController.text,
      "SparePartModelNumber": sendSelectedsparemodel,
      "Quantity": quantityController.text,
      "Remarks": remarksController.text,
      "SolutionProcess": solutionProcessController.text,
      "isSparePartChanged": isSparePartChanged,
      "maintenanceType": maintenanceType,
      "Status": "Active"
    };

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "Logistic/SparePartOut");

    final prefs = await SharedPreferences.getInstance();

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("response......?");
    print(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var objData = json.decode(response.body);
      print("objData['SparePartInId']");
      print(objData['data'][0]['stockCheck']);
      print("...................................");
      setState(() {
        machineMaintenanceId = objData['data'][0]['stockCheck'];
      });
      print("................NNNNNNNNNNN...................");

      print(invoicePdfFileBytes);
      if (_imageBytes != '' && _imageBytes != null) {
        uploadImage((_imageBytes ?? []));
      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show("Machine Logistic Successfully Completed.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => MachineMaintenanceList()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  uploadImage(List<int> imageBytes) async {
    print("PDF......");
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      "SparePartId": machineMaintenanceId,
      "MachineMaintenancePdf": MultipartFile.fromBytes(
        imageBytes,
        filename:
            (invoicePdfController.text + (currentdate.toString()) + '.jpg'),
        contentType: MediaType("image", 'jpg'),
      ),
    });

    _response = await _dio.post((site! + 'Logistic/SparePartsImage'),
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
          validateStatus: (status) => true,
        ),
        data: formData);

    try {
      print("Image Response........");
      print(_response?.statusCode);
      print(_response);
      if (_response?.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        Toast.show("Machine Logistic Successfully Completed.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => MachineMaintenanceList()),
            (Route<dynamic> route) => false);
      } else {
        Toast.show("Error In Image Server",
            duration: Toast.lengthLong, gravity: Toast.center);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print("Error");
    }
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
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.white,
          appBar: GautamAppBar(
            organization: "organizationtype",
            isBackRequired: true,
            memberId: personid,
            imgPath: "ImagePath",
            memberPic: pic,
            logo: "logo",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MachineMaintenanceList();
              }));
            },
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: setPage == ''
                ? Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _registerFormKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppAssets.imgLogo,
                                              height: 100,
                                              width: 230,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Machine Logistic",
                                      style: TextStyle(
                                        fontSize: 27,
                                        color: Color.fromARGB(255, 56, 57, 56),
                                        fontFamily: appFontFamily,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                Text(
                                  "Machine Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),

                                (widget.id != '' && widget.id != null)
                                    ? DropdownButtonFormField<String>(
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Select Machine Name",
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
                                          fillColor: const Color.fromARGB(
                                                  255, 255, 255, 255)
                                              .withOpacity(0.5),
                                          filled:
                                              true, // Set your desired fill color here
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        items: machineList
                                            .map((label) => DropdownMenuItem(
                                                  child: Text(
                                                    label['MachineName'],
                                                    style: AppStyles
                                                        .textInputTextStyle,
                                                  ),
                                                  value: label['MachineId']
                                                      .toString(),
                                                ))
                                            .toList(),
                                        onChanged: widget.id != '' &&
                                                widget.id != null
                                            ? null
                                            : (val) {
                                                setState(() {
                                                  sendSelectedMachine = val!;
                                                });
                                              },
                                        value: sendSelectedMachine != ''
                                            ? sendSelectedMachine
                                            : null,
                                        // validator: (value) {
                                        //   if (value == null || value.isEmpty) {
                                        //     return 'Please select a work location';
                                        //   }
                                        //   return null; // Return null if the validation is successful
                                        // },
                                      )
                                    : DropdownSearch<String>(
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Select Machine Name",
                                            counterText: '',
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            fillColor: Color.fromARGB(
                                                    255, 255, 255, 255)
                                                .withOpacity(
                                                    0.5), // Your desired color
                                            filled: true,
                                          ),
                                        ),
                                        items: machineList
                                            .map((label) =>
                                                label['MachineName'].toString())
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            selectMachineName = val!;
                                            selectedsparemodel = "";
                                            sendSelectedsparemodel = "";
                                            sparePartNameController.text = "";
                                          });

                                          final selectedMachineName =
                                              machineList.firstWhere(
                                                  (element) =>
                                                      element['MachineName'] ==
                                                      val);

                                          getSparePartModelNoListData(
                                              selectedMachineName['MachineName']
                                                  .toString());
                                          setState(() {
                                            sendSelectedMachine =
                                                selectedMachineName['MachineId']
                                                    .toString();
                                            machineNumberController.text =
                                                selectedMachineName[
                                                        'MachineNumber']
                                                    .toString();
                                          });
                                        },
                                        selectedItem: selectMachineName != ''
                                            ? selectMachineName
                                            : null,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Select Machine Name';
                                          }
                                          return null;
                                        },
                                        popupProps: const PopupProps.menu(
                                          showSearchBox: true,
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText:
                                                  'Search Machine Name...',
                                            ),
                                          ),
                                        ),
                                      ),

                                // DropdownSearch<String>(
                                //   dropdownDecoratorProps:
                                //       DropDownDecoratorProps(
                                //     dropdownSearchDecoration: AppStyles
                                //         .textFieldInputDecoration
                                //         .copyWith(
                                //       hintText: "Please Select Machine Name",
                                //       counterText: '',
                                //       contentPadding: const EdgeInsets.all(10),
                                //       fillColor:
                                //           Color.fromARGB(255, 255, 255, 255)
                                //               .withOpacity(
                                //                   0.5), // Your desired color
                                //       filled: true,
                                //     ),
                                //   ),
                                //   items: machineList
                                //       .map((label) =>
                                //           label['MachineName'].toString())
                                //       .toList(),
                                //   onChanged: (val) {
                                //     setState(() {
                                //       selectMachineName = val!;
                                //     });

                                //     final selectedMachineName =
                                //         machineList.firstWhere((element) =>
                                //             element['MachineName'] == val);

                                //     getSparePartModelNoListData(
                                //         selectedMachineName['MachineName']
                                //             .toString());
                                //     setState(() {
                                //       sendSelectedMachine =
                                //           selectedMachineName['MachineId']
                                //               .toString();
                                //       machineNumberController.text =
                                //           selectedMachineName['MachineNumber']
                                //               .toString();
                                //     });
                                //   },
                                //   selectedItem: selectMachineName != ''
                                //       ? selectMachineName
                                //       : null,
                                //   validator: (value) {
                                //     if (value == null || value.isEmpty) {
                                //       return 'Please Select Machine Name';
                                //     }
                                //     return null;
                                //   },
                                //   popupProps: const PopupProps.menu(
                                //     showSearchBox: true,
                                //     searchFieldProps: TextFieldProps(
                                //       decoration: InputDecoration(
                                //         border: OutlineInputBorder(),
                                //         hintText: 'Search Machine Name...',
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Machine Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: machineNumberController,
                                  keyboardType: TextInputType.text,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: 'Please Enter Machine Number',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(0.5),
                                  ),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Machine Number';
                                    }
                                    return null;
                                  },
                                ),
                                if (selectMachineName == "Stringer Machine(AMO50FS)-1" ||
                                    selectMachineName ==
                                        "Stringer Machine(AMO50FS)-2" ||
                                    selectMachineName ==
                                        "Stringer Machine(AMO50FS)-3" ||
                                    selectMachineName ==
                                        "Stringer Machine(MS40K)-1" ||
                                    selectMachineName ==
                                        "Stringer Machine(MS40K)-2")
                                  const SizedBox(
                                    height: 15,
                                  ),

                                if (selectMachineName == "Stringer Machine(AMO50FS)-1" ||
                                    selectMachineName ==
                                        "Stringer Machine(AMO50FS)-2" ||
                                    selectMachineName ==
                                        "Stringer Machine(AMO50FS)-3" ||
                                    selectMachineName ==
                                        "Stringer Machine(MS40K)-1" ||
                                    selectMachineName ==
                                        "Stringer Machine(MS40K)-2")
                                  Text(
                                    "Line",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                if (selectMachineName == "Stringer Machine(AMO50FS)-1" ||
                                    selectMachineName ==
                                        "Stringer Machine(AMO50FS)-2" ||
                                    selectMachineName ==
                                        "Stringer Machine(AMO50FS)-3" ||
                                    selectMachineName ==
                                        "Stringer Machine(MS40K)-1" ||
                                    selectMachineName ==
                                        "Stringer Machine(MS40K)-2")
                                  const SizedBox(
                                    height: 4,
                                  ),
                                if (selectMachineName == "Stringer Machine(AMO50FS)-1" ||
                                    selectMachineName ==
                                        "Stringer Machine(AMO50FS)-2" ||
                                    selectMachineName ==
                                        "Stringer Machine(AMO50FS)-3" ||
                                    selectMachineName ==
                                        "Stringer Machine(MS40K)-1" ||
                                    selectMachineName ==
                                        "Stringer Machine(MS40K)-2")
                                  DropdownButtonFormField<String>(
                                    decoration: AppStyles
                                        .textFieldInputDecoration
                                        .copyWith(
                                      hintText: "Please Select Line",
                                      counterText: '',
                                      contentPadding: EdgeInsets.all(10),
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 255, 255, 255)
                                              .withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    items: lineList
                                        .map((label) => DropdownMenuItem(
                                              child: Text(label['label'],
                                                  style: AppStyles
                                                      .textInputTextStyle),
                                              value: label['value'].toString(),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        lineController = val!;
                                      });
                                    },
                                    value: lineController != ''
                                        ? lineController
                                        : null,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a line';
                                      }
                                      return null;
                                    },
                                  ),
                                if (selectMachineName ==
                                        "Laminator (Jinchen)" ||
                                    selectMachineName == "Laminator (GMEE)")
                                  const SizedBox(
                                    height: 15,
                                  ),
                                if (selectMachineName ==
                                        "Laminator (Jinchen)" ||
                                    selectMachineName == "Laminator (GMEE)")
                                  Row(
                                    children: [
                                      Text(
                                        "Chamber 1",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Checkbox(
                                        value: Chamber1 == "Chamber1",
                                        onChanged: (bool? value) {
                                          setState(() {
                                            print(value);
                                            Chamber1 =
                                                value == true ? "Chamber1" : "";
                                            print(Chamber1);
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      if (Chamber1 == "Chamber1")
                                        Expanded(
                                          child: TextFormField(
                                            controller: chamber1Controller,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText: "Please Enter Quantity",
                                              fillColor: const Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  .withOpacity(
                                                      0.5), // Your desired color
                                              filled: true,
                                            ),
                                            style: AppStyles.textInputTextStyle,
                                            readOnly: false,
                                          ),
                                        ),
                                    ],
                                  ),
                                if (selectMachineName ==
                                        "Laminator (Jinchen)" ||
                                    selectMachineName == "Laminator (GMEE)")
                                  const SizedBox(
                                    height: 15,
                                  ),
                                if (selectMachineName ==
                                        "Laminator (Jinchen)" ||
                                    selectMachineName == "Laminator (GMEE)")
                                  Row(
                                    children: [
                                      Text(
                                        "Chamber 2",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Checkbox(
                                        value: Chamber2 == "Chamber2",
                                        onChanged: (bool? value) {
                                          setState(() {
                                            print(value);
                                            Chamber2 =
                                                value == true ? "Chamber2" : "";
                                            print(Chamber2);
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      if (Chamber2 == "Chamber2")
                                        Expanded(
                                          child: TextFormField(
                                            controller: chamber2Controller,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText: "Please Enter Quantity",
                                              fillColor: const Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  .withOpacity(
                                                      0.5), // Your desired color
                                              filled: true,
                                            ),
                                            style: AppStyles.textInputTextStyle,
                                            readOnly: false,
                                          ),
                                        ),
                                    ],
                                  ),
                                if (selectMachineName ==
                                        "Laminator (Jinchen)" ||
                                    selectMachineName == "Laminator (GMEE)")
                                  const SizedBox(
                                    height: 15,
                                  ),
                                if (selectMachineName ==
                                        "Laminator (Jinchen)" ||
                                    selectMachineName == "Laminator (GMEE)")
                                  Row(
                                    children: [
                                      Text(
                                        "Chamber 3",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Checkbox(
                                        value: Chamber3 == "Chamber3",
                                        onChanged: (bool? value) {
                                          setState(() {
                                            print(value);
                                            Chamber3 =
                                                value == true ? "Chamber3" : "";
                                            print(Chamber3);
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      if (Chamber3 == "Chamber3")
                                        Expanded(
                                          child: TextFormField(
                                            controller: chamber3Controller,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText: "Please Enter Quantity",
                                              fillColor: const Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  .withOpacity(
                                                      0.5), // Your desired color
                                              filled: true,
                                            ),
                                            style: AppStyles.textInputTextStyle,
                                            readOnly: false,
                                          ),
                                        ),
                                    ],
                                  ),
                                if (selectMachineName ==
                                        "Laminator (Jinchen)" ||
                                    selectMachineName == "Laminator (GMEE)")
                                  const SizedBox(
                                    height: 15,
                                  ),
                                if (selectMachineName ==
                                        "Laminator (Jinchen)" ||
                                    selectMachineName == "Laminator (GMEE)")
                                  Row(
                                    children: [
                                      Text(
                                        "Chamber 4",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Checkbox(
                                        value: Chamber4 == "Chamber4",
                                        onChanged: (bool? value) {
                                          setState(() {
                                            print(value);
                                            Chamber4 =
                                                value == true ? "Chamber4" : "";
                                            print(Chamber4);
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      if (Chamber4 == "Chamber4")
                                        Expanded(
                                          child: TextFormField(
                                            controller: chamber4Controller,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText: "Please Enter Quantity",
                                              fillColor: const Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  .withOpacity(
                                                      0.5), // Your desired color
                                              filled: true,
                                            ),
                                            style: AppStyles.textInputTextStyle,
                                            readOnly: false,
                                          ),
                                        ),
                                    ],
                                  ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Logistic Type",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio<String>(
                                      value: 'Breakdown',
                                      groupValue: maintenanceType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          maintenanceType = value!;
                                          print(maintenanceType);
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Breakdown',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16), // Makes the text bold
                                    ),
                                    SizedBox(
                                        width:
                                            20), // Optional: Adds space between the options
                                    Radio<String>(
                                      value: 'Preventive',
                                      groupValue: maintenanceType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          maintenanceType = value!;
                                          print(maintenanceType);
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Preventive',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16), // Makes the text bold
                                    ),
                                  ],
                                ),

                                Text(
                                  "Issue",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: issueController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Issue",
                                    fillColor: const Color.fromARGB(
                                            255, 255, 255, 255)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: false,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Issue",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // Time ...
                                Text(
                                  "Breakdown Start Time",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: maintenanceStartTimeController,
                                  keyboardType: TextInputType.text,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: 'e.g., 14:30 (HH:MM)',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(0.5),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Breakdown Start Time';
                                    }
                                    final timeRegex =
                                        RegExp(r'^[0-2]\d:[0-5]\d$');
                                    if (!timeRegex.hasMatch(value)) {
                                      return 'Invalid time format (HH:MM)';
                                    }
                                    final parts = value.split(':');
                                    final hours = int.parse(parts[0]);
                                    final minutes = int.parse(parts[1]);

                                    if (hours < 0 || hours > 23) {
                                      return 'Hours must be between 00 and 23';
                                    }
                                    if (minutes < 0 || minutes > 59) {
                                      return 'Minutes must be between 00 and 59';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    String endTime =
                                        maintenanceEndTimeController.text;

                                    DateTime startDateTime =
                                        DateTime.parse('2024-01-01 $value:00');
                                    DateTime? endDateTime;
                                    try {
                                      endDateTime = DateTime.parse(
                                          '2024-01-01 $endTime:00');
                                    } catch (e) {
                                      endDateTime = null;
                                    }

                                    if (endDateTime != null) {
                                      Duration difference =
                                          endDateTime.difference(startDateTime);
                                      int hours = difference.inHours;
                                      int minutes =
                                          difference.inMinutes.remainder(60);
                                      print(
                                          'Difference: $hours hours and $minutes minutes');
                                      setState(() {
                                        maintenanceTimeController.text =
                                            '$hours Hours And $minutes Minutes';
                                      });
                                    }
                                  },
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Breakdown End Time",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),

                                TextFormField(
                                  controller: maintenanceEndTimeController,
                                  keyboardType: TextInputType.text,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: 'e.g., 18:05 (HH:MM)',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(0.5),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Breakdown End Time';
                                    }
                                    final timeRegex =
                                        RegExp(r'^[0-2]\d:[0-5]\d$');
                                    if (!timeRegex.hasMatch(value)) {
                                      return 'Invalid time format (HH:MM)';
                                    }
                                    final parts = value.split(':');
                                    final hours = int.parse(parts[0]);
                                    final minutes = int.parse(parts[1]);

                                    if (hours < 0 || hours > 23) {
                                      return 'Hours must be between 00 and 23';
                                    }
                                    if (minutes < 0 || minutes > 59) {
                                      return 'Minutes must be between 00 and 59';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    String startTime =
                                        maintenanceStartTimeController.text;

                                    DateTime startDateTime = DateTime.parse(
                                        '2024-01-01 $startTime:00');
                                    DateTime? endDateTime;
                                    try {
                                      endDateTime = DateTime.parse(
                                          '2024-01-01 $value:00');
                                    } catch (e) {
                                      endDateTime = null;
                                    }

                                    if (endDateTime != null) {
                                      Duration difference =
                                          endDateTime.difference(startDateTime);
                                      int hours = difference.inHours;
                                      int minutes =
                                          difference.inMinutes.remainder(60);
                                      print(
                                          'Difference: $hours hours and $minutes minutes');
                                      setState(() {
                                        maintenanceTimeController.text =
                                            '$hours Hours And $minutes Minutes';
                                      });
                                    }
                                  },
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Breakdown Total Time",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: maintenanceTimeController,
                                  keyboardType: TextInputType.text,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: 'Please Enter Breakdown Time',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(0.5),
                                  ),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Breakdown Time';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Is Spare Part Changed..?",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio<String>(
                                      value: 'Yes',
                                      groupValue: isSparePartChanged,
                                      onChanged: (String? value) {
                                        setState(() {
                                          isSparePartChanged = value!;
                                          print(isSparePartChanged);
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Yes',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16), // Makes the text bold
                                    ),
                                    SizedBox(
                                        width:
                                            20), // Optional: Adds space between the options
                                    Radio<String>(
                                      value: 'No',
                                      groupValue: isSparePartChanged,
                                      onChanged: (String? value) {
                                        setState(() {
                                          isSparePartChanged = value!;
                                          print(isSparePartChanged);
                                        });
                                      },
                                    ),
                                    const Text(
                                      'No',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16), // Makes the text bold
                                    ),
                                  ],
                                ),
                                if (isSparePartChanged == "Yes")
                                  const SizedBox(
                                    height: 15,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  Text(
                                    "Spare Part Model No",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  const SizedBox(
                                    height: 4,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: widget.id != '' &&
                                                widget.id != null &&
                                                (recvSelectedsparemodel != "" &&
                                                    recvSelectedsparemodel !=
                                                        null)
                                            ? DropdownButtonFormField<String>(
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Select Spare Part Model No",
                                                  counterText: '',
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  fillColor:
                                                      const Color.fromARGB(255,
                                                              255, 255, 255)
                                                          .withOpacity(0.5),
                                                  filled:
                                                      true, // Set your desired fill color here
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                items: sparePartModelNoList
                                                    .map((label) =>
                                                        DropdownMenuItem(
                                                          child: Text(
                                                            label[
                                                                'SpareNumber'],
                                                            style: AppStyles
                                                                .textInputTextStyle,
                                                          ),
                                                          value: label[
                                                                  'Spare_Part_Id']
                                                              .toString(),
                                                        ))
                                                    .toList(),
                                                onChanged: widget.id != '' &&
                                                        widget.id != null &&
                                                        (recvSelectedsparemodel !=
                                                                "" &&
                                                            recvSelectedsparemodel !=
                                                                null)
                                                    ? null
                                                    : (val) {
                                                        setState(() {
                                                          sendSelectedsparemodel =
                                                              val!;
                                                        });
                                                      },
                                                value:
                                                    sendSelectedsparemodel != ''
                                                        ? sendSelectedsparemodel
                                                        : null,
                                                // validator: (value) {
                                                //   if (value == null || value.isEmpty) {
                                                //     return 'Please select a work location';
                                                //   }
                                                //   return null; // Return null if the validation is successful
                                                // },
                                              )
                                            : DropdownSearch<String>(
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                    hintText:
                                                        "Please Select Spare Part Model No",
                                                    counterText: '',
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    fillColor:
                                                        const Color.fromARGB(
                                                                255,
                                                                255,
                                                                255,
                                                                255)
                                                            .withOpacity(0.5),
                                                    filled: true,
                                                  ),
                                                ),
                                                items: sparePartModelNoList
                                                    .map((label) =>
                                                        label['SpareNumber']
                                                            .toString())
                                                    .toList(),
                                                onChanged: (val) {
                                                  setState(() {
                                                    selectedsparemodel = val!;
                                                  });
                                                  print(val);
                                                  final selectedModel =
                                                      sparePartModelNoList
                                                          .firstWhere((element) =>
                                                              element[
                                                                  'SpareNumber'] ==
                                                              val);
                                                  sendSelectedsparemodel =
                                                      selectedModel[
                                                              'Spare_Part_Id']
                                                          .toString();
                                                  sparePartNameController.text =
                                                      selectedModel[
                                                              'SparePartName']
                                                          .toString();
                                                  AvailableStock =
                                                      selectedModel[
                                                              'Available_Stock']
                                                          .toString();
                                                },
                                                selectedItem:
                                                    selectedsparemodel != ''
                                                        ? selectedsparemodel
                                                        : null,

                                                // validator: (value) {
                                                //   if (value == null || value.isEmpty) {
                                                //     return 'Please Select Spare Part Model No';
                                                //   }
                                                //   return null;
                                                // },
                                                popupProps:
                                                    const PopupProps.menu(
                                                  showSearchBox: true,
                                                  searchFieldProps:
                                                      TextFieldProps(
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText:
                                                          'Search Spare Part Model No',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Define what the button should do here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        child: Text("Stock: $AvailableStock"),
                                      ),
                                    ],
                                  ),
                                if (isSparePartChanged == "Yes")
                                  const SizedBox(
                                    height: 15,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  Text(
                                    "Spare Part Name",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  const SizedBox(
                                    height: 4,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  TextFormField(
                                    controller: sparePartNameController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: AppStyles
                                        .textFieldInputDecoration
                                        .copyWith(
                                      hintText: "Please Enter Spare Part Name",
                                      fillColor:
                                          Color.fromARGB(255, 255, 255, 255)
                                              .withOpacity(
                                                  0.5), // Your desired color
                                      filled: true,
                                    ),
                                    style: AppStyles.textInputTextStyle,
                                    readOnly: true,
                                    // validator: MultiValidator(
                                    //   [
                                    //     RequiredValidator(
                                    //       errorText:
                                    //           "Please Enter Spare Part Name",
                                    //     ),
                                    //   ],
                                    // ),
                                  ),
                                if (isSparePartChanged == "Yes")
                                  const SizedBox(
                                    height: 15,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  Text(
                                    "Quantity",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  const SizedBox(
                                    height: 5,
                                  ),
                                if (isSparePartChanged == "Yes")
                                  TextFormField(
                                      controller: quantityController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Quantity",
                                        fillColor:
                                            Color.fromARGB(255, 255, 255, 255)
                                                .withOpacity(
                                                    0.5), // Your desired color
                                        filled: true,
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: AvailableStock != "" &&
                                              (recvSelectedsparemodel == "" ||
                                                  recvSelectedsparemodel ==
                                                      null)
                                          ? false
                                          : true,
                                      validator: selectedsparemodel != ""
                                          ? (value) {
                                              print("Value kya aaya..?");
                                              print(value);
                                              if ((value == null &&
                                                      selectedsparemodel !=
                                                          "") ||
                                                  (value!.isEmpty &&
                                                      selectedsparemodel !=
                                                          "")) {
                                                return 'Please Enter Quantity.';
                                              } else if (int.parse(value) < 1 &&
                                                  selectedsparemodel != "") {
                                                return 'Please Enter Valid Quantity.';
                                              } else if (int.parse(value) >
                                                      int.parse(
                                                          AvailableStock) &&
                                                  selectedsparemodel != "" &&
                                                  (recvSelectedsparemodel ==
                                                          "" ||
                                                      recvSelectedsparemodel ==
                                                          null)) {
                                                return 'Stock Is Insufficient.';
                                              }
                                              return null;
                                            }
                                          : (value) {
                                              return;
                                            }),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Remarks",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: remarksController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Remarks",
                                    fillColor: Color.fromARGB(
                                            255, 255, 255, 255)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  minLines: 3,
                                  maxLines: 5,
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Solution Process",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: solutionProcessController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Solution Process",
                                    fillColor: Color.fromARGB(
                                            255, 255, 255, 255)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  minLines: 5,
                                  maxLines: 10,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Solution Process",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Upload Picture",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // TextFormField(
                                //   controller: invoicePdfController,
                                //   keyboardType: TextInputType.text,
                                //   textInputAction: TextInputAction.next,
                                //   decoration: AppStyles.textFieldInputDecoration
                                //       .copyWith(
                                //           hintText: "Please Select Picture",
                                //           fillColor: Color.fromARGB(
                                //                   255, 255, 255, 255)
                                //               .withOpacity(
                                //                   0.5), // Your desired color
                                //           filled: true,
                                //           suffixIcon: IconButton(
                                //             onPressed: () async {
                                //               _pickcocPDF();
                                //             },
                                //             icon: const Icon(
                                //                 Icons.open_in_browser),
                                //           ),
                                //           counterText: ''),
                                //   style: AppStyles.textInputTextStyle,
                                //   maxLines: 1,
                                //   readOnly: true,
                                //   validator: (value) {
                                //     if (value!.isEmpty) {
                                //       return "Please Select Picture";
                                //     } else {
                                //       return null;
                                //     }
                                //   },
                                // ),

                                _image == null
                                    ? Container(
                                        width: 300,
                                        height: 300,
                                        child: GestureDetector(
                                          onTap: () {
                                            print("image.....?");
                                            print(_image);
                                            getImage();
                                          },
                                          child: widget.id != "" &&
                                                  widget.id != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: _image != "" &&
                                                          _image != null
                                                      ? Image.file(
                                                          _image!,
                                                          fit: BoxFit.cover,
                                                          width: 300,
                                                          height: 300,
                                                        )
                                                      : editImage != "" &&
                                                              editImage != null
                                                          ? CachedNetworkImage(
                                                              imageUrl:
                                                                  ((editImage)),
                                                              fit: BoxFit.cover,
                                                              width: 300,
                                                              height: 300,
                                                            )
                                                          : Image.asset(
                                                              AppAssets.camera,
                                                              fit: BoxFit.cover,
                                                              width: 300,
                                                              height: 300,
                                                            ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.asset(
                                                    AppAssets.camera,
                                                    fit: BoxFit.cover,
                                                    width: 300,
                                                    height: 300,
                                                  ),
                                                ),
                                        ),
                                      )
                                    : Container(
                                        width: 300,
                                        height: 300,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                            width: 300,
                                            height: 300,
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                _isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : AppButton(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.white,
                                          fontSize: 16,
                                        ),
                                        onTap: () {
                                          AppHelper.hideKeyboard(context);
                                          if (_registerFormKey.currentState!
                                              .validate()) {
                                            _registerFormKey.currentState!
                                                .save();
                                            print("bhanuuuuuu");
                                            if ((_imageBytes == "" ||
                                                    _imageBytes == null) &&
                                                (widget.id == "" ||
                                                    widget.id == null) &&
                                                (sendSelectedsparemodel != "" &&
                                                    sendSelectedsparemodel !=
                                                        null)) {
                                              Toast.show("Please Take Picture.",
                                                  duration: Toast.lengthLong,
                                                  gravity: Toast.center,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 128, 6, 6));
                                            } else {
                                              createData();
                                            }
                                          }
                                        },
                                        label: "Save",
                                        organization: '',
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            WelcomePage()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                      child: const Text(
                                        'BACK',
                                        style: TextStyle(
                                            fontFamily: appFontFamily,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.redColor),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Powered By Gautam Solar Pvt. Ltd.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: appFontFamily,
                                          color: AppColors.greyColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
          ),
          // floatingActionButton: (status == "Pending") ? null : _getFAB(),
          // bottomNavigationBar: Container(
          //   height: 60,
          //   decoration: const BoxDecoration(
          //     color: Color.fromARGB(255, 245, 203, 19),
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(20),
          //       topRight: Radius.circular(20),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       InkWell(
          //           onTap: () {
          //             Navigator.of(context).pushReplacement(MaterialPageRoute(
          //                 builder: (BuildContext context) =>
          //                     department == 'IPQC' &&
          //                             designation != 'Super Admin'
          //                         ? IpqcPage()
          //                         : WelcomePage()));
          //           },
          //           child: Image.asset(
          //               home
          //                   ? AppAssets.icHomeSelected
          //                   : AppAssets.icHomeUnSelected,
          //               height: 25)),
          //       const SizedBox(
          //         width: 8,
          //       ),
          //       InkWell(
          //           onTap: () {
          //             // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //             //     builder: (BuildContext context) => AddEditProfile()));
          //           },
          //           child: Image.asset(
          //               user
          //                   ? AppAssets.imgSelectedPerson
          //                   : AppAssets.imgPerson,
          //               height: 25)),
          //       const SizedBox(
          //         width: 8,
          //       ),
          //       InkWell(
          //           child: Image.asset(
          //               face
          //                   ? AppAssets.icSearchSelected
          //                   : AppAssets.icSearchUnSelected,
          //               height: 25)),
          //       const SizedBox(
          //         width: 8,
          //       ),
          //       InkWell(
          //           onTap: () {
          //             Navigator.of(context).pushReplacement(MaterialPageRoute(
          //                 builder: (BuildContext context) => PublicDrawer()));
          //           },
          //           child: Image.asset(
          //               menu ? AppAssets.imgSelectedMenu : AppAssets.imgMenu,
          //               height: 25)),
          //     ],
          //   ),
          // ),
        );
      }),
    );
  }
}
