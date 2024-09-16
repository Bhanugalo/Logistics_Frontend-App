import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/network_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_dropdown/widgets/hint_text.dart';
import 'package:multi_dropdown/widgets/selection_chip.dart';
import 'package:multi_dropdown/widgets/single_selected_item.dart';
import 'package:Logistic/CommonDrawer.dart';
import 'package:Logistic/Welcomepage.dart';
import 'package:Logistic/components/app_button_widget.dart';
import 'package:Logistic/components/app_loader.dart';
import 'package:Logistic/components/appbar.dart';
import 'package:Logistic/constant/app_assets.dart';
import 'package:Logistic/constant/app_color.dart';
import 'package:Logistic/constant/app_fonts.dart';
import 'package:Logistic/constant/app_helper.dart';
import 'package:Logistic/constant/app_styles.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class addSparePart extends StatefulWidget {
  final String? id;
  addSparePart({this.id});
  @override
  _addSparePartState createState() => _addSparePartState();
}

class _addSparePartState extends State<addSparePart> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController sparePartNameController = TextEditingController();
  TextEditingController masterSparePartNameController = TextEditingController();
  TextEditingController sparePartNumberController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController specificationController = TextEditingController();
  TextEditingController cycleTimeController = TextEditingController();
  TextEditingController hSNCodeController = TextEditingController();
  TextEditingController pCSInOneTimeController = TextEditingController();
  TextEditingController machineModelNumberController = TextEditingController();
  final MultiSelectController _controller = MultiSelectController();
  TextEditingController drawingPdfController = new TextEditingController();
  TextEditingController imageController = new TextEditingController();

  List<TextEditingController> sampleAControllers = [];
  List<TextEditingController> sampleBControllers = [];

  bool menu = false, user = false, face = false, home = false;
  int numberOfStringers = 0;
  bool _isLoading = false;
  String setPage = '', pic = '', site = '', personid = '';
  String invoiceDate = '';
  String date = '';
  String dateOfQualityCheck = '';

  bool? isBacksheetCuttingTrue;
  List<int>? referencePdfFileBytes;
  String selectedmachine = "";
  String selectedmachinemodel = "";
  String selectedspare = "";
  String selectedsparemodel = "";
  String selectedbrand = "";
  String _selectedValue = "Spare Part Name";
  List MachineData = [];
  List EquiSpareData = [];
  List sampleAInputtext = [];
  List sampleBInputText = [];
  List machineList = [];
  List<ValueItem> options = [];
  late String sendStatus;
  List<int>? imageBytes, drawingPdfFileBytes;
  List<Map<String, dynamic>> filesData = [];
  String status = '',
      jobCarId = '',
      machineNameController = "",
      approvalStatus = "Approved",
      designation = '',
      SparePartId = '',
      token = '',
      department = '';
  final _dio = Dio();
  List data = [];

  List<Map<String, String>> spareParts = [];
  List<MultiSelectItem<String>> _items = [];
  List<String> _selectedItems = [];

  Response.Response? _response;

  @override
  void initState() {
    super.initState();
    store();
  }

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
  }

  void _handleRadioValueChange(value) {
    setState(() {
      _selectedValue = value!;
    });
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      // Create a list to hold file properties

      // Iterate over each selected file
      for (var file in result.files) {
        File imageFile = File(file.path!);

        // Add file properties to the list
        filesData.add({
          'bytes': imageFile.readAsBytesSync(),
          'filename': file.name,
        });
        setState(() {
          imageController.text = file.name;
        });
      }

      print(filesData);

      // Update state if necessary
      setState(() {
        // Use filesData to update the UI or perform further operations
        // For example:
        // selectedFiles = filesData;
      });
    } else {
      // User canceled the file picker
    }
  }

  Future<void> _pickcocPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        drawingPdfFileBytes = pdffile.readAsBytesSync();
        drawingPdfController.text = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  getMachineModelNumber(machineId) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Logistic/MachineDetailById');

    http.post(
      Uri.parse(url),
      body: json.encode({"MachineId": machineId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var machineBody = jsonDecode(response.body);

        setState(() {
          machineModelNumberController.text =
              machineBody['data'][0]['MachineModelNumber'];
        });
        // print("machine list data");
        // print(machineModelNumberController.text);
      }
    });
  }

  // [{MachineId: 039b2111-93db-4615-be4e-286d6495d703, MachineName: Gautam1225345654675867}, {MachineId: 143cd0ea-fa88-4164-9a04-eb1cf1b8d782, MachineName: gear5}, {MachineId: 154f0b1f-2013-42dc-9ba4-b1c9d5a32b10, MachineName: gearj}];

  getEquiSparePartData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Logistic/Equ');

    http.post(
      Uri.parse(url),
      body: json.encode({
        "SparePartName": sparePartNameController.text,
        "MachineName": MachineData ?? []
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var machineBody = jsonDecode(response.body);
        setState(() {
          machineList = machineBody;
        });
        _items = machineList
            .map((part) =>
                MultiSelectItem<String>(part["SparePartId"]!, part["Value"]!))
            .toList();
        print("machine list data");
        print(machineList);
        print(_items);
        print("KKKKKKKKKKkkkkkk");
      }
    });
  }

  // Future<void> _pickReferencePDF() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );

  //   if (result != null) {
  //     File pdffile = File(result.files.single.path!);
  //     setState(() {
  //       referencePdfFileBytes = pdffile.readAsBytesSync();
  //       referencePdfController.text = result.files.single.name;
  //     });
  //   } else {
  //     // User canceled the file picker
  //   }
  // }

  uploadPDF(List<Map<String, dynamic>> files, List<int> drawingPdfBytes) async {
    print("Upload....");
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    List<MultipartFile> sparePartImages = files.map((file) {
      return MultipartFile.fromBytes(
        file['bytes'],
        filename: file['filename'] + (currentdate.toString()) + '.png',
        contentType: MediaType("application", 'png'),
      );
    }).toList();

    var formData = FormData.fromMap({
      "SparePartId": SparePartId,
      "SparePartImage": sparePartImages,
      "DrawingImage": MultipartFile.fromBytes(
        drawingPdfBytes,
        filename:
            (drawingPdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
    });

    try {
      _response = await _dio.post((site! + 'Logistic/SparePartsImage'), // Prod
          options: Options(
            contentType: 'multipart/form-data',
            followRedirects: false,
            validateStatus: (status) => true,
          ),
          data: formData);

      if (_response?.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        Toast.show("Spare Part Added Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => WelcomePage()));
      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show("Error In Server",
            duration: Toast.lengthLong, gravity: Toast.center);
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $err");
      Toast.show("Error occurred",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  Future createData() async {
    var data = {
      "MasterSparePartName": masterSparePartNameController.text,
      "SparePartName": sparePartNameController.text,
      "Specification": specificationController.text,
      "SpareNumber": sparePartNumberController.text,
      "BrandName": brandNameController.text,
      "MachineName": MachineData ?? [],
      "Equivalent": _selectedItems ?? [],
      "CycleTime": cycleTimeController.text,
      "HSNCode": hSNCodeController.text,
      "NumberOfPcs": pCSInOneTimeController.text,
      //  "MachineModelNumber": machineModelNumberController.text,
      "Status": "Active",
      "CurrentUser": personid
    };

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "Logistic/AddSparePart");

    final prefs = await SharedPreferences.getInstance();

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var objData = json.decode(response.body);

      if (objData['success'] == false) {
        setState(() {
          _isLoading = false;
        });
        Toast.show(objData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.redColor);
      } else {
        setState(() {
          SparePartId = objData['SparePartId'];
        });

        if ((filesData != null && filesData != "") ||
            (drawingPdfFileBytes != null && drawingPdfFileBytes != "")) {
          uploadPDF((filesData ?? []), (drawingPdfFileBytes ?? []));
        } else {
          Toast.show("Spare Part Added Successfully.",
              duration: Toast.lengthLong,
              gravity: Toast.center,
              backgroundColor: AppColors.blueColor);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => WelcomePage()),
              (Route<dynamic> route) => false);
        }
      }
    } else if (response.statusCode == 409) {
      setState(() {
        _isLoading = false;
      });
      Toast.show('This spare part model number is already exist.',
          duration: Toast.lengthLong,
          gravity: Toast.center,
          backgroundColor: AppColors.redColor);
    } else {
      setState(() {
        _isLoading = false;
      });
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
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
                return PublicDrawer();
              }));
            },
          ),
          body: _isLoading
              ? AppLoader()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 136, 240, 132)
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
                                      "Add New Spare Part",
                                      style: TextStyle(
                                        fontSize: 27,
                                        color: Color.fromARGB(255, 56, 57, 56),
                                        fontFamily: appFontFamily,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),

                                // **************** Document Number *******************
                                const SizedBox(
                                  height: 35,
                                ),

                                Text(
                                  "Master Spare Part Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                TextFormField(
                                  controller: masterSparePartNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText:
                                        "Please Enter Master Spare Part Name",
                                    fillColor: const Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Master Spare Part Name",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Spare Part Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: sparePartNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Spare Part Name",
                                    fillColor: const Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Spare Part Name",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Spare Part Model Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: sparePartNumberController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText:
                                        "Please Enter Spare Part Model Number",
                                    fillColor: const Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Spare Part Model Number",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Brand Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: brandNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Brand Name",
                                    fillColor: const Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Brand Name",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Specification",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: specificationController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Specification",
                                    fillColor: const Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Specification",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Machine Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                Container(
                                  child: MultiSelectDropDown.network(
                                    searchEnabled: true,
                                    onOptionSelected: (options) {
                                      MachineData = [];
                                      options.forEach((element) {
                                        MachineData.add(element.value!);
                                      });
                                      getEquiSparePartData();
                                    },
                                    networkConfig: NetworkConfig(
                                      url:
                                          'http://srv515471.hstgr.cloud:8080/Logistic/MachineDetailById',
                                      method: RequestMethod.get,
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                    ),
                                    fieldBackgroundColor: const Color.fromARGB(
                                        255, 187, 241, 185),
                                    chipConfig: const ChipConfig(
                                        backgroundColor: Colors.amber,
                                        labelColor: Colors.black,
                                        wrapType: WrapType.wrap),
                                    responseParser: (response) {
                                      final list =
                                          (response as List<dynamic>).map((e) {
                                        final item = e as Map<String, dynamic>;
                                        return ValueItem(
                                          label: item['MachineName'],
                                          value: item['MachineId'].toString(),
                                        );
                                      }).toList();

                                      return Future.value(list);
                                    },
                                    responseErrorBuilder: (context, body) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Error fetching the data'),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "No. Of PCS Uses In One Time",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: pCSInOneTimeController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText:
                                        "Please Enter No. Of PCS Uses In One Time",
                                    fillColor: const Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter No. Of PCS Uses In One Time",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Cycle Time In Days",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: cycleTimeController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Cycle Time",
                                    fillColor: const Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Cycle Time",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "HSN/SAC Code",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: hSNCodeController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter HSN/SAC Code",
                                    fillColor: const Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Upload Image",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: imageController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                          hintText: "Please Select Image",
                                          fillColor: const Color.fromARGB(
                                                  255, 187, 241, 185)
                                              .withOpacity(
                                                  0.5), // Your desired color
                                          filled: true,
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              _pickImage();
                                            },
                                            icon: const Icon(
                                                Icons.open_in_browser),
                                          ),
                                          counterText: ''),
                                  style: AppStyles.textInputTextStyle,
                                  maxLines: 1,
                                  readOnly: true,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Please Select Image";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Upload Drawing Pdf",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: drawingPdfController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                          hintText: "Please Select Drawing Pdf",
                                          fillColor: const Color.fromARGB(
                                                  255, 187, 241, 185)
                                              .withOpacity(
                                                  0.5), // Your desired color
                                          filled: true,
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              _pickcocPDF();
                                            },
                                            icon: const Icon(
                                                Icons.open_in_browser),
                                          ),
                                          counterText: ''),
                                  style: AppStyles.textInputTextStyle,
                                  maxLines: 1,
                                  readOnly: true,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Please Select Drawing Pdf";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                ),
                                if (_items.length > 0)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                if (_items.length > 0)
                                  const Text(
                                    "Equivalent Spare Part",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(
                                          242, 255, 125, 3), // Text color
                                    ),
                                  ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (_items.length > 0)
                                  MultiSelectDialogField(
                                    items: _items,
                                    title: const Text(
                                      "Equivalent Spare Parts",
                                      style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // Making the text bold
                                      ),
                                    ),
                                    selectedColor: Colors.blue,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),
                                    buttonIcon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.blue,
                                    ),
                                    buttonText: Text(
                                      "Select Equivalent Spare Parts",
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: 16,
                                      ),
                                    ),
                                    onConfirm: (results) {
                                      _selectedItems = results;
                                    },
                                  ),

                                const SizedBox(
                                  height: 25,
                                ),

                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                AppButton(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                  onTap: () {
                                    AppHelper.hideKeyboard(context);
                                    if (_registerFormKey.currentState!
                                        .validate()) {
                                      _registerFormKey.currentState!.save();
                                      print("bhanuuuuuu");
                                      print(MachineData);
                                      if (MachineData.isEmpty) {
                                        Toast.show(
                                            "Please Select Machine Name.",
                                            duration: Toast.lengthLong,
                                            gravity: Toast.center,
                                            backgroundColor:
                                                AppColors.redColor);
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
                                                            PublicDrawer()),
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
                  )),
        );
      }),
    );
  }
}
