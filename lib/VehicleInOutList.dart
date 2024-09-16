import 'dart:async';
import 'dart:convert';
// import 'dart:html' hide File;
import 'dart:io';
import 'dart:ui';
import 'package:Logistic/CommonDrawer.dart';
import 'package:Logistic/VehicleIn.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' hide MultipartFile;
import 'package:dio/dio.dart' as _dio;
import 'package:http/http.dart' as http;
import 'package:Logistic/Welcomepage.dart';
import 'package:Logistic/addeditemployee.dart';
import 'package:Logistic/components/app_loader.dart';
import 'package:Logistic/components/appbar.dart';
import 'package:Logistic/constant/app_assets.dart';
import 'package:Logistic/constant/app_color.dart';
import 'package:Logistic/constant/app_fonts.dart';
import 'package:Logistic/constant/app_strings.dart';
import 'package:Logistic/constant/app_styles.dart';
import 'package:Logistic/Vehicle_In_Out_List_Model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' hide MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toast/toast.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class VehicleInOutList extends StatefulWidget {
  VehicleInOutList();

  @override
  _VehicleInOutListState createState() => _VehicleInOutListState();
}

class _VehicleInOutListState extends State<VehicleInOutList> {
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
  TextEditingController SearchController = TextEditingController();
  // TextEditingController _paymentModeController = new TextEditingController();
  TextEditingController ExpiryDateController = new TextEditingController();
  TextEditingController PaymentDateController = new TextEditingController();
  final TextEditingController filePdfController = TextEditingController();
  TextEditingController NoteController = new TextEditingController();
  GlobalKey<FormState> _renewalFormkey = GlobalKey<FormState>();

  bool _isLoading = false, IN = false, OUT = false;
  bool menu = false, user = false, face = false, home = false;
  String? _paymentModeController;
  List paymentModeData = [];
  List<File?> images = List<File?>.filled(4, null);
  List<List<int>> imageBytesList =
      List<List<int>>.filled(4, [], growable: false);
  List<Map<String, dynamic>> filesData = [];
  Response.Response? _response;

  List<File?> fileImages = List<File?>.filled(2, null);
  List<List<int>> fileImageBytesList =
      List<List<int>>.filled(2, [], growable: false);
  List<Map<String, dynamic>> filesImageData = [];
  List<String> dynamicImageAssets = [
    AppAssets.icInvoice,
    AppAssets.icEway,
  ];
  List<int>? invoicePdfFileBytes;
  late http.MultipartFile httpFile;
  String? personid,
      vCard,
      firstname,
      lastname,
      pic,
      logo,
      site,
      designation,
      department,
      workLocation,
      ImagePath,
      detail,
      businessname,
      organizationName,
      otherChapterName = '',
      _hasBeenPressedorganization = '',
      setVehicleId = '',
      setVehicleNumber = '',
      locationController,
      transferredTo,
      vehicleLoadingType,
      organizationtype,
      _hasBeenPressed = '',
      _hasBeenPressed1 = 'IN',
      _hasBeenPressed2 = '',
      Expirydate,
      Paymentdate;
  // RoleModel? paymentModeData;
  TextEditingController AmountController = new TextEditingController();
  bool status = false, isAllowedEdit = false;
  var decodedResult;
  var rmbDropDown;
  Future? userdata;
  late UserModel aUserModel;
  List dropdownList = [], locationList = [];
  List vehicleLoadingTypeList = [
    {"label": 'Empty', "value": 'Empty'},
    {"label": 'Half Loaded', "value": 'Half Loaded'},
  ];
  final _dio = Dio();
  @override
  void initState() {
    if (mounted) {
      detail = 'hide';
      store();
    }
    super.initState();
  }

  void store() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pic = prefs.getString('pic');
      personid = prefs.getString('personid');
      site = prefs.getString('site');
      designation = prefs.getString('designation');
      department = prefs.getString('department');
      workLocation = prefs.getString('workLocation');
      print(prefs.getString('workLocation'));
      locationController = prefs.getString('workLocation') ?? "";
    });

    userdata = getData();
    getLocationData();
  }

  getLocationData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    final url = (site! + 'workLocation/work-location-list');

    http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var designationBody = jsonDecode(response.body);
        setState(() {
          locationList = designationBody['workLocations'];
        });
      }
    });
  }

  Future<List<UserData>?> getData() async {
    print("Come....");
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');
    setState(() {
      _isLoading = true;
    });

    final url = (site! + 'vehicleIN/getvehicleListByStatus');

    http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        "status": _hasBeenPressed1!,
        "workLocation": designation != "Super Admin"
            ? workLocation ?? ""
            : locationController ?? "",
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      print("Res......");
      print(response);
      if (mounted) {
        setState(() {
          _isLoading = false;
          decodedResult = jsonDecode(response.body);
        });
      }
    });

    return null;
  }

  void setStatus(vehicleId, status) async {
    print("setStatus.....?");
    print(vehicleLoadingType);
    print(transferredTo);
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');
    final url = (site!) + 'vehicleIN/updateTransportStatus';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        "personId": personid!,
        "status": status,
        "vehicleId": vehicleId,
        "workLocation": transferredTo ?? "",
        "vehicleLoadingType": vehicleLoadingType ?? "",
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _hasBeenPressed1 = status;
        _isLoading = false;
      });
      Toast.show("Vehicle Moved Forwarded.",
          duration: Toast.lengthLong,
          gravity: Toast.center,
          backgroundColor: AppColors.primaryColor);

      getData();

      return;
    } else {
      throw Exception('Failed To Fetch Data');
    }
  }

  addLoadingImages(List<Map<String, dynamic>> files, vehicleId) async {
    print("add Loading Image... UU");
    print(files);
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    List<MultipartFile> loadingImages = files.map((file) {
      return MultipartFile.fromBytes(
        file['bytes'],
        filename: file['filename'] + (currentdate.toString()) + '.jpg',
        contentType: MediaType("application", 'jpg'),
      );
    }).toList();

    var formData = FormData.fromMap({
      "vehicleId": vehicleId,
      "images": loadingImages,
    });

    print("add Loading Image... loadingImages");
    print(loadingImages);
    print("add Loading Image... vehicleId");
    print(vehicleId);

    try {
      Dio _dio = Dio();
      _response =
          await _dio.post((site! + 'vehicleIN/uploadFourImages'), // Prod
              options: Options(
                contentType: 'multipart/form-data',
                followRedirects: false,
                validateStatus: (status) => true,
              ),
              data: formData);
      if (_response?.statusCode == 200) {
        setState(() {
          _hasBeenPressed1 = "LOADING";
          _isLoading = false;
        });
        setState(() {
          for (int i = 0; i < images.length; i++) {
            images[i] = null;
            filesData = [];
          }
        });

        Toast.show("Vehicle Loading Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        userdata = getData();
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => VehicleInOutList()));
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
      Toast.show("Error occurred",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  addFileImages(List<Map<String, dynamic>> files, vehicleId) async {
    print(files);
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    List<MultipartFile> loadingImages = files.map((file) {
      return MultipartFile.fromBytes(
        file['bytes'],
        filename: file['filename'] + (currentdate.toString()) + '.jpg',
        contentType: MediaType("application", 'jpg'),
      );
    }).toList();

    var formData = FormData.fromMap({
      "vehicleId": vehicleId,
      "images": loadingImages,
    });
    print("Check.....");
    print(vehicleId);
    print(loadingImages);

    try {
      Dio _dio = Dio();
      _response = await _dio.post((site! + 'vehicleIN/uploadTwoImages'), // Prod
          options: Options(
            contentType: 'multipart/form-data',
            followRedirects: false,
            validateStatus: (status) => true,
          ),
          data: formData);
      if (_response?.statusCode == 200) {
        setState(() {
          _hasBeenPressed1 = "LOADING";
          _isLoading = false;
        });
        setState(() {
          for (int i = 0; i < fileImages.length; i++) {
            fileImages[i] = null;
            filesImageData = [];
          }
        });

        Toast.show("Invoice & E-Way Bill Added Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        userdata = getData();
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => VehicleInOutList()));
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
      Toast.show("Error occurred",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  Future<void> getImage(int index, fileName) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      images[index] = image;

      // Compress the image and store the bytes
      var compressedBytes = await _compressImage(image);

      filesData.add({
        'bytes': compressedBytes,
        'filename': fileName,
      });

      setState(() {
        imageBytesList[index] = compressedBytes;
      });
    } else {}
  }

  Future<List<int>> _compressImage(File imageFile) async {
    var originalBytes = await imageFile.readAsBytes();
    var compressedBytes = await FlutterImageCompress.compressWithList(
      originalBytes,
      quality: 60,
    );

    return compressedBytes;
  }

// File Image Upload By Guard....

  Future<void> getFileImage(int index, fileName) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      fileImages[index] = image;

      // Compress the image and store the bytes
      var compressedBytes = await _compressFileImage(image);
      print("compressedBytes....");
      print(compressedBytes);
      filesImageData.add({
        'bytes': compressedBytes,
        'filename': fileName,
      });

      setState(() {
        fileImageBytesList[index] = compressedBytes;
      });
    } else {}
  }

  Future<List<int>> _compressFileImage(File imageFile) async {
    print("Compressed....");
    print(imageFile);
    var originalBytes = await imageFile.readAsBytes();
    var compressedBytes = await FlutterImageCompress.compressWithList(
      originalBytes,
      quality: 80,
    );
    print(originalBytes);
    print("kKkkkk");
    print(compressedBytes);
    return compressedBytes;
  }

//   void submitForm() {
//     if (_formKey.currentState!.validate() && images.every((image) => image != null)) {
//       // Make API call here with imageBytesList
//       // Example:
//       addLoadingImages(widget.personId, imageBytesList);
//       Navigator.of(context).pop();
//     } else {
//       // Show validation error if not all images are selected
//       Toast.show("Please upload all required images.",
//           duration: Toast.lengthLong,
//           gravity: Toast.center,
//           backgroundColor: Colors.red);
//     }
//   }

//   void addLoadingImages(String personId, List<List<int>> imageBytesList) {
//   // Implement your API call logic here
//   print('Person ID: $personId');
//   print('Images Bytes List Length: ${imageBytesList.length}');
// }

  inBox(context, String vehicleId) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      // 'Disable Member',
                      "IN Vehicle",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'HKGrotesk',
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          // 'Are you sure you want to disable this member?',
                          "Are you sure you want to in this vehicle.?",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            //  setMemberStatus('Inactive', personId);
                            setStatus(vehicleId, "IN");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'HKGrotesk',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Text(
                                'NO',
                                style: TextStyle(
                                    fontFamily: appFontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.redColor),
                              ),
                            )),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  outBox(context, String vehicleId) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      // 'Disable Member',
                      "OUT Vehicle",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'HKGrotesk',
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          // 'Are you sure you want to disable this member?',
                          "Are you sure you want to out this vehicle.?",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            //  setMemberStatus('Inactive', personId);
                            setStatus(vehicleId, "OUT");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'HKGrotesk',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Text(
                                'NO',
                                style: TextStyle(
                                    fontFamily: appFontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.redColor),
                              ),
                            )),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  cancelBox(context, String vehicleId) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      // 'Disable Member',
                      "Cancel Vehicle",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'HKGrotesk',
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          // 'Are you sure you want to disable this member?',
                          "Are you sure you want to cancel this vehicle.?",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            //  setMemberStatus('Inactive', personId);
                            setStatus(vehicleId, "CANCELED");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'HKGrotesk',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Text(
                                'NO',
                                style: TextStyle(
                                    fontFamily: appFontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.redColor),
                              ),
                            )),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        filePdfController.text = result.files.single.name;
      });
      print("File Upload..?");
      print(invoicePdfFileBytes);
      print(filePdfController.text);
    } else {
      // User canceled the file picker
    }
  }

  upload(List<int> bytes, String name, String vehicleId) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      'type': "Invoice",
      'vehicleId': vehicleId,
      "vechileInImage": MultipartFile.fromBytes(
        bytes,
        filename: (name + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", "pdf"),
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
          _hasBeenPressed1 = "LOADING";
          _isLoading = false;
        });

        Toast.show("Pdf File Uploaded Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.primaryColor);
        userdata = getData();
      }
    } catch (err) {
      print("Error");
    }
  }

  fileBox(BuildContext context, String vehicleNumber, String vehicleId) {
    final _formKey = GlobalKey<FormState>();
    // final List<File?> images = List<File?>.filled(4, null);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Invoice & E-Way Bill",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'HKGrotesk',
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                child:
                                    fileBox(context, vehicleNumber, vehicleId),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  for (int i = 0; i < 2; i++)
                    Column(
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                setVehicleId = vehicleNumber;
                                setVehicleNumber = vehicleId;
                              });
                              getFileImage(i, vehicleNumber);

                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: fileBox(
                                        context, vehicleNumber, vehicleId),
                                  );
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: fileImages[i] != null
                                  ? Image.file(
                                      fileImages[i]!,
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 200,
                                    )
                                  : Image.asset(
                                      dynamicImageAssets[i],
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 200,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: fileBox(context, vehicleNumber, vehicleId),
                          );
                        },
                      );
                      if (_formKey.currentState!.validate() &&
                          fileImages.every((image) => image != null)) {
                        Navigator.of(context).pop();

                        addFileImages(filesImageData, vehicleId);
                      } else {
                        // Show validation error if not all images are selected
                        Toast.show("Take Picture of Invoice & E-Way Bill.",
                            duration: Toast.lengthLong,
                            gravity: Toast.center,
                            backgroundColor: Colors.red);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HKGrotesk',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(21),
                              ),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: fileBox(context, vehicleNumber, vehicleId),
                            );
                          },
                        );
                        Navigator.of(context).pop();
                        setState(() {
                          for (int i = 0; i < images.length; i++) {
                            fileImages[i] = null;
                            filesImageData = [];
                          }
                        });
                      },
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontFamily: 'HKGrotesk',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  fileUploadBox(BuildContext context, String vehicleId) {
    final _fileKey = GlobalKey<FormState>();
    // final TextEditingController filePdfController = TextEditingController();

    return SingleChildScrollView(
      child: Form(
        key: _fileKey,
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Upload file",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'HKGrotesk',
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Upload Pdf File*",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: filePdfController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: AppStyles.textFieldInputDecoration
                              .copyWith(
                                  hintText: "Please Select Pdf File",
                                  fillColor: Color.fromARGB(255, 255, 255, 255)
                                      .withOpacity(0.5), // Your desired color
                                  filled: true,
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      _pickcocPDF();
                                    },
                                    icon: const Icon(Icons.open_in_browser),
                                  ),
                                  counterText: ''),
                          style: AppStyles.textInputTextStyle,
                          maxLines: 1,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Select Pdf File";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            if (_fileKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              print("transferredTo........POP");
                              upload((invoicePdfFileBytes ?? []),
                                  (filePdfController.text ?? ''), (vehicleId));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue, // Use your primary color here
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'HKGrotesk',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    fontFamily: 'HKGrotesk',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Colors.red), // Use your red color here
                              ),
                            )),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  transferredBox(BuildContext context, String vehicleId, String personId) {
    final _formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Transfer Vehicle",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'HKGrotesk',
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Transferred To*",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          decoration: AppStyles.textFieldInputDecoration
                              .copyWith(
                                  hintText: "Please Select Transferred To",
                                  counterText: '',
                                  contentPadding: EdgeInsets.all(10)),
                          borderRadius: BorderRadius.circular(20),
                          items: locationList
                              .map((label) => DropdownMenuItem(
                                    child: Text(label['workLocationName'],
                                        style: AppStyles.textInputTextStyle),
                                    value: label['WorkLocationId'].toString(),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              transferredTo = val!;
                            });
                          },
                          value: transferredTo != '' ? transferredTo : null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Select Transferred To';
                            }
                            return null; // Return null if the validation is successful
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Vehicle Loading Type*",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          decoration: AppStyles.textFieldInputDecoration
                              .copyWith(
                                  hintText:
                                      "Please Select Vehicle Loading Type",
                                  counterText: '',
                                  contentPadding: EdgeInsets.all(10)),
                          borderRadius: BorderRadius.circular(20),
                          items: vehicleLoadingTypeList
                              .map((label) => DropdownMenuItem(
                                    child: Text(label['label'],
                                        style: AppStyles.textInputTextStyle),
                                    value: label['value'].toString(),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              vehicleLoadingType = val!;
                            });
                          },
                          value: vehicleLoadingType != ''
                              ? vehicleLoadingType
                              : null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Select Vehicle Loading Type';
                            }
                            return null; // Return null if the validation is successful
                          },
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              print("transferredTo........POP");
                              print(transferredTo);

                              setStatus(vehicleId, "TRANSFERRED");
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue, // Use your primary color here
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: Text(
                                  'Transfer',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'HKGrotesk',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    fontFamily: 'HKGrotesk',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Colors.red), // Use your red color here
                              ),
                            )),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  contentBox(BuildContext context, String vehicleNumber, String vehicleId) {
    final _formKey = GlobalKey<FormState>();
    // final List<File?> images = List<File?>.filled(4, null);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Take Pictures of Vehicle",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'HKGrotesk',
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                child: contentBox(
                                    context, vehicleNumber, vehicleId),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  for (int i = 0; i < 4; i++)
                    Column(
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                setVehicleId = vehicleNumber;
                                setVehicleNumber = vehicleId;
                              });
                              getImage(i, vehicleNumber);

                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: contentBox(
                                        context, vehicleNumber, vehicleId),
                                  );
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: images[i] != null
                                  ? Image.file(
                                      images[i]!,
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 200,
                                    )
                                  : Image.asset(
                                      AppAssets.camera,
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 200,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child:
                                contentBox(context, vehicleNumber, vehicleId),
                          );
                        },
                      );
                      if (_formKey.currentState!.validate() &&
                          images.every((image) => image != null)) {
                        Navigator.of(context).pop();

                        addLoadingImages(filesData, vehicleId);
                      } else {
                        // Show validation error if not all images are selected
                        Toast.show("Please upload all required images.",
                            duration: Toast.lengthLong,
                            gravity: Toast.center,
                            backgroundColor: Colors.red);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HKGrotesk',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(21),
                              ),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child:
                                  contentBox(context, vehicleNumber, vehicleId),
                            );
                          },
                        );
                        Navigator.of(context).pop();
                        setState(() {
                          for (int i = 0; i < images.length; i++) {
                            images[i] = null;
                            filesData = [];
                          }
                        });
                      },
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontFamily: 'HKGrotesk',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> redirectto() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
        (Route<dynamic> route) => false);
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
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColors.appBackgroundColor,
                appBar: GautamAppBar(
                  organization: "organizationtype",
                  isBackRequired: true,
                  memberId: personid,
                  imgPath: "ImagePath",
                  memberPic: pic,
                  logo: "logo",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WelcomePage();
                    }));
                  },
                ),
                body: _isLoading
                    ? AppLoader(organization: organizationtype)
                    : RefreshIndicator(
                        color: Colors.white,
                        backgroundColor: AppColors.blueColor,
                        onRefresh: () async {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      VehicleInOutList()),
                              (Route<dynamic> route) => false);
                          return Future<void>.delayed(
                              const Duration(seconds: 3));
                        },
                        child: Container(
                          // margin: EdgeInsets.only(bottom: 80),
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: _userData()),
                        ),
                      ),
                // floatingActionButton: _getFAB(),

                // bottomNavigationBar: Container(
                //   height: 60,
                //   decoration: const BoxDecoration(
                //     color: Color.fromARGB(255, 98, 99, 100),
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
                //             Navigator.of(context).pushReplacement(
                //                 MaterialPageRoute(
                //                     builder: (BuildContext context) =>
                //                         WelcomePage()));
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
                //             Navigator.of(context).pushReplacement(
                //                 MaterialPageRoute(
                //                     builder: (BuildContext context) =>
                //                         VehicleInOutList()));
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
                //           // onTap: () {
                //           //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //           //       builder: (BuildContext context) => Attendance()));
                //           // },
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
                //             Navigator.of(context).pushReplacement(
                //                 MaterialPageRoute(
                //                     builder: (BuildContext context) =>
                //                         PublicDrawer()));
                //           },
                //           child: Image.asset(
                //               menu
                //                   ? AppAssets.imgSelectedMenu
                //                   : AppAssets.imgMenu,
                //               height: 25)),
                //     ],
                //   ),
                // ),
              ),
            )));
  }

  Widget _getFAB() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => VehicleIn()),
              (Route<dynamic> route) => false);
        },
        child: ClipOval(
          child: Image.asset(
            AppAssets.icPlusBlue,
            height: 60,
            width: 60,
          ),
        ),
      ),
    );
  }

// <List<UserData>> List<UserData>
  _userData() {
    return FutureBuilder(
      future: userdata,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          aUserModel = UserModel.fromJson(decodedResult);

          List<UserData> data = aUserModel.data!;

          return _user(aUserModel);
        } else if (snapshot.hasError) {
          return const AppLoader();
        }

        return const AppLoader();
      },
    );
  }

  Widget filter() {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //#1 IN
            InkWell(
                onTap: () {
                  setState(() {
                    _hasBeenPressed1 = 'IN';
                    _hasBeenPressed2 = '';
                  });
                  userdata = getData();
                },
                child: Text('IN',
                    style: TextStyle(
                        fontFamily: appFontFamily,
                        color: _hasBeenPressed1 == 'IN'
                            ? AppColors.blueColor
                            : AppColors.black,
                        fontWeight: _hasBeenPressed1 == 'IN'
                            ? FontWeight.w700
                            : FontWeight.normal))),

            const Text(
              ' | ',
              style: TextStyle(
                  fontFamily: appFontFamily,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w700),
            ),

            //#2 LOADING
            InkWell(
              onTap: () {
                setState(() {
                  _hasBeenPressed1 = 'LOADING';
                });
                userdata = getData();
              },
              child: Text(
                'LOADING',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: _hasBeenPressed1 == 'LOADING'
                        ? AppColors.blueColor
                        : AppColors.black,
                    fontWeight: _hasBeenPressed1 == 'LOADING'
                        ? FontWeight.w700
                        : FontWeight.normal),
              ),
            ),

            const Text(
              ' | ',
              style: TextStyle(
                  fontFamily: appFontFamily,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w700),
            ),

            //#2 LOADING TRANSFERRED
            InkWell(
              onTap: () {
                setState(() {
                  _hasBeenPressed1 = 'TRANSFERRED';
                });
                userdata = getData();
              },
              child: Text(
                'TRANSFERRED',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: _hasBeenPressed1 == 'TRANSFERRED'
                        ? AppColors.blueColor
                        : AppColors.black,
                    fontWeight: _hasBeenPressed1 == 'TRANSFERRED'
                        ? FontWeight.w700
                        : FontWeight.normal),
              ),
            ),

            const Text(
              ' | ',
              style: TextStyle(
                  fontFamily: appFontFamily,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w700),
            ),

            //#2 Inactive
            InkWell(
              onTap: () {
                setState(() {
                  _hasBeenPressed1 = 'OUT';
                });
                userdata = getData();
              },
              child: Text(
                'OUT',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: _hasBeenPressed1 == 'OUT'
                        ? AppColors.blueColor
                        : AppColors.black,
                    fontWeight: _hasBeenPressed1 == 'OUT'
                        ? FontWeight.w700
                        : FontWeight.normal),
              ),
            ),

            const Text(
              ' | ',
              style: TextStyle(
                  fontFamily: appFontFamily,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w700),
            ),

            //#3 Pending

            InkWell(
              onTap: () {
                setState(() {
                  _hasBeenPressed1 = 'CANCELED';
                });
                userdata = getData();
              },
              child: Text(
                'CANCELED',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: _hasBeenPressed1 == 'CANCELED'
                        ? AppColors.blueColor
                        : AppColors.black,
                    fontWeight: _hasBeenPressed1 == 'CANCELED'
                        ? FontWeight.w700
                        : FontWeight.normal),
              ),
            ),
            if (organizationtype == 'RMB Chapter' ||
                organizationtype == 'Me-connect Chapter')
              const Text(
                ' | ',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: AppColors.blueColor,
                    fontWeight: FontWeight.w700),
              ),

            //#4 Decline
            if (organizationtype == 'RMB Chapter' ||
                organizationtype == 'Me-connect Chapter')
              InkWell(
                onTap: () {
                  setState(() {
                    _hasBeenPressed1 = 'Decline';
                  });
                  userdata = getData();
                },
                child: Text(
                  'Declined',
                  style: TextStyle(
                      fontFamily: appFontFamily,
                      color: _hasBeenPressed1 == 'Decline'
                          ? AppColors.blueColor
                          : AppColors.black,
                      fontWeight: _hasBeenPressed1 == 'Decline'
                          ? FontWeight.w700
                          : FontWeight.normal),
                ),
              ),
          ],
        ));
  }

  Column _user(UserModel data) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.only(top: 15, left: 10, right: 10)),
      Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle In/Out List',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Color.fromARGB(255, 148, 8, 8))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF940808), // Text color
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  shadowColor: Colors.grey, // Shadow color for button
                  elevation: 5, // Elevation for a slight shadow
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => VehicleIn()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  'Vehicle In',
                  style: TextStyle(
                    fontSize: 14, // Larger text size for better visibility
                    fontWeight: FontWeight.w600, // Semi-bold text
                  ),
                ),
              ),
            ],
          )),
      const Padding(padding: EdgeInsets.only(top: 15, left: 10, right: 5)),
      Row(
        children: <Widget>[
          // Search TextField inside Expanded with larger flex
          Expanded(
            flex: 3, // Larger flex value to increase size
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                controller: SearchController,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: AppStyles.textFieldInputDecoration.copyWith(
                  hintText: "Search...",
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: AppColors.lightBlackColor,
                  ),
                ),
                style: AppStyles.textInputTextStyle,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),

          // Space between TextField and Dropdown
          // SizedBox(width: 10),

          // Unit DropdownButtonFormField inside Expanded with smaller flex
          Expanded(
            flex: 3, // Smaller flex value to decrease size
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField<String>(
                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                    hintText: "Unit",
                    counterText: '',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded borders
                    ),
                  ),
                  items: locationList
                      .map((label) => DropdownMenuItem(
                            child: Text(
                              label['workLocationName'],
                              style: AppStyles.textInputTextStyle,
                            ),
                            value: label['WorkLocationId'].toString(),
                          ))
                      .toList(),
                  onChanged: designation != "Super Admin"
                      ? null
                      : (val) {
                          setState(() {
                            locationController = val!;
                          });
                          getData();
                        },
                  value: locationController != '' ? locationController : null,
                )),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            filter(),
            SizedBox(
              height: 5,
            ),
            Text(
              data.data!.length > 1
                  ? '${data.data!.length} Vehicles'
                  : '${data.data!.length} Vehicle',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: appFontFamily,
                fontSize: 15,
                color: Color.fromARGB(255, 148, 8, 8),
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Expanded(
            child: ListView.builder(
                itemCount: data.data!.length,
                itemBuilder: (context, index) {
                  if (SearchController.text.isEmpty) {
                    return Container(
                        child: _tile(
                            data.data![index].vehicleNo ?? '',
                            data.data![index].partyName ?? '',
                            data.data![index].vehicleTypeName ?? '',
                            data.data![index].createdPerson ?? '',
                            data.data![index].driverNumber ?? '',
                            data.data![index].status ?? '',
                            data.data![index].transpotterName ?? '',
                            data.data![index].transferFrom ?? '',
                            data.data![index].location ?? '',
                            data.data![index].resultDate ?? '',
                            data.data![index].vehicleId ?? '',
                            data.data![index].vehicleImg ?? '',
                            data.data![index].vehicleImg1 ?? '',
                            data.data![index].vehicleImg2 ?? '',
                            data.data![index].vehicleImg3 ?? '',
                            data.data![index].vehicleImg4 ?? '',
                            data.data![index].resultTime ?? '',
                            data.data![index].vehicleLoadingType ?? '',
                            data.data![index].invoiceImg ?? '',
                            data.data![index].ewayBill ?? ''));
                  } else if ((data.data![index].vehicleNo ?? '')
                          .toLowerCase()
                          .contains((SearchController.text).toLowerCase()) ||
                      data.data![index].vehicleTypeName!
                          .toLowerCase()
                          .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].vehicleNo ?? '',
                            data.data![index].partyName ?? '',
                            data.data![index].vehicleTypeName ?? '',
                            data.data![index].createdPerson ?? '',
                            data.data![index].driverNumber ?? '',
                            data.data![index].status ?? '',
                            data.data![index].transpotterName ?? '',
                            data.data![index].transferFrom ?? '',
                            data.data![index].location ?? '',
                            data.data![index].resultDate ?? '',
                            data.data![index].vehicleId ?? '',
                            data.data![index].vehicleImg ?? '',
                            data.data![index].vehicleImg1 ?? '',
                            data.data![index].vehicleImg2 ?? '',
                            data.data![index].vehicleImg3 ?? '',
                            data.data![index].vehicleImg4 ?? '',
                            data.data![index].resultTime ?? '',
                            data.data![index].vehicleLoadingType ?? '',
                            data.data![index].invoiceImg ?? '',
                            data.data![index].ewayBill ?? ''));
                  } else if (data.data![index].partyName!
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].vehicleNo ?? '',
                            data.data![index].partyName ?? '',
                            data.data![index].vehicleTypeName ?? '',
                            data.data![index].createdPerson ?? '',
                            data.data![index].driverNumber ?? '',
                            data.data![index].status ?? '',
                            data.data![index].transpotterName ?? '',
                            data.data![index].transferFrom ?? '',
                            data.data![index].location ?? '',
                            data.data![index].resultDate ?? '',
                            data.data![index].vehicleId ?? '',
                            data.data![index].vehicleImg ?? '',
                            data.data![index].vehicleImg1 ?? '',
                            data.data![index].vehicleImg2 ?? '',
                            data.data![index].vehicleImg3 ?? '',
                            data.data![index].vehicleImg4 ?? '',
                            data.data![index].resultTime ?? '',
                            data.data![index].vehicleLoadingType ?? '',
                            data.data![index].invoiceImg ?? '',
                            data.data![index].ewayBill ?? ''));
                  } else if (data.data![index].createdPerson!
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].vehicleNo ?? '',
                            data.data![index].partyName ?? '',
                            data.data![index].vehicleTypeName ?? '',
                            data.data![index].createdPerson ?? '',
                            data.data![index].driverNumber ?? '',
                            data.data![index].status ?? '',
                            data.data![index].transpotterName ?? '',
                            data.data![index].transferFrom ?? '',
                            data.data![index].location ?? '',
                            data.data![index].resultDate ?? '',
                            data.data![index].vehicleId ?? '',
                            data.data![index].vehicleImg ?? '',
                            data.data![index].vehicleImg1 ?? '',
                            data.data![index].vehicleImg2 ?? '',
                            data.data![index].vehicleImg3 ?? '',
                            data.data![index].vehicleImg4 ?? '',
                            data.data![index].resultTime ?? '',
                            data.data![index].vehicleLoadingType ?? '',
                            data.data![index].invoiceImg ?? '',
                            data.data![index].ewayBill ?? ''));
                  } else if ((data.data![index].transpotterName!)
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].vehicleNo ?? '',
                            data.data![index].partyName ?? '',
                            data.data![index].vehicleTypeName ?? '',
                            data.data![index].createdPerson ?? '',
                            data.data![index].driverNumber ?? '',
                            data.data![index].status ?? '',
                            data.data![index].transpotterName ?? '',
                            data.data![index].transferFrom ?? '',
                            data.data![index].location ?? '',
                            data.data![index].resultDate ?? '',
                            data.data![index].vehicleId ?? '',
                            data.data![index].vehicleImg ?? '',
                            data.data![index].vehicleImg1 ?? '',
                            data.data![index].vehicleImg2 ?? '',
                            data.data![index].vehicleImg3 ?? '',
                            data.data![index].vehicleImg4 ?? '',
                            data.data![index].resultTime ?? '',
                            data.data![index].vehicleLoadingType ?? '',
                            data.data![index].invoiceImg ?? '',
                            data.data![index].ewayBill ?? ''));
                  } else if (data.data![index].location!
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].vehicleNo ?? '',
                            data.data![index].partyName ?? '',
                            data.data![index].vehicleTypeName ?? '',
                            data.data![index].createdPerson ?? '',
                            data.data![index].driverNumber ?? '',
                            data.data![index].status ?? '',
                            data.data![index].transpotterName ?? '',
                            data.data![index].transferFrom ?? '',
                            data.data![index].location ?? '',
                            data.data![index].resultDate ?? '',
                            data.data![index].vehicleId ?? '',
                            data.data![index].vehicleImg ?? '',
                            data.data![index].vehicleImg1 ?? '',
                            data.data![index].vehicleImg2 ?? '',
                            data.data![index].vehicleImg3 ?? '',
                            data.data![index].vehicleImg4 ?? '',
                            data.data![index].resultTime ?? '',
                            data.data![index].vehicleLoadingType ?? '',
                            data.data![index].invoiceImg ?? '',
                            data.data![index].ewayBill ?? ''));
                  } else {
                    return Container();
                  }
                })),
      ),
      const SizedBox(
        height: 20,
      )
    ]);
  }

  Widget _tile(
      String vehicleNo,
      String partyName,
      String vehicleTypeName,
      String name,
      String driverNumber,
      String status,
      String transpotterName,
      String transferFrom,
      String location,
      String createdOn,
      String vehicleId,
      String vehicleImg,
      String vehicleImg1,
      String vehicleImg2,
      String vehicleImg3,
      String vehicleImg4,
      String resultTime,
      String vehicleLoadingType,
      String invoiceImg,
      String ewayBill) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      child: Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    elevation: 0,
                                    backgroundColor:
                                        Color.fromARGB(0, 232, 131, 8),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25.0),
                                            bottomRight: Radius.circular(25.0),
                                            topRight: Radius.circular(25.0),
                                            bottomLeft: Radius.circular(25.0),
                                          )),
                                      child: CachedNetworkImage(
                                        width: 430,
                                        height: 400,
                                        imageUrl: (vehicleImg),
                                        errorWidget: (context, url, error) {
                                          return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.asset(
                                                AppAssets.camera,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ));
                                        },
                                        // placeholder: 'cupertinoActivityIndicator',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: vehicleImg,
                            height: 60,
                            width: 60,
                            placeholder: (context, url) {
                              return ClipOval(
                                child: Image.asset(
                                  AppAssets.camera,
                                  height: 60,
                                  width: 60,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return ClipOval(
                                child: Image.asset(
                                  AppAssets.camera,
                                  height: 60,
                                  width: 60,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Name
                        Row(children: <Widget>[
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Vehicle Number: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          appFontFamily, // replace with your actual font family
                                      fontSize: 19,
                                      color: Color.fromARGB(221, 0, 0,
                                          0), // color for "Machine Name:"
                                    ),
                                  ),
                                  TextSpan(
                                    text: vehicleNo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          appFontFamily, // replace with your actual font family
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 0, 123,
                                          255), // color for the dynamic value
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 255, 218, 7), // Background color
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: Add border radius for rounded corners
                            ),
                            child: Text(
                              vehicleTypeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color.fromARGB(
                                    255, 0, 0, 0), // Optional: Set text color
                              ),
                            ),
                          ),
                        ]),
                        if (partyName != "" && partyName != null)
                          Row(children: <Widget>[
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Party Name: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            appFontFamily, // replace with your actual font family
                                        fontSize: 18,
                                        color: Color.fromARGB(221, 0, 0,
                                            0), // color for "Machine Name:"
                                      ),
                                    ),
                                    TextSpan(
                                      text: partyName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            appFontFamily, // replace with your actual font family
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 0, 123,
                                            255), // color for the dynamic value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        if (transpotterName != "" && transpotterName != null)
                          const SizedBox(
                            height: 2,
                          ),
                        if (transpotterName != "" && transpotterName != null)
                          Row(children: <Widget>[
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Transporter Name: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            appFontFamily, // replace with your actual font family
                                        fontSize: 18,
                                        color: Color.fromARGB(221, 0, 0,
                                            0), // color for "Machine Name:"
                                      ),
                                    ),
                                    TextSpan(
                                      text: transpotterName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            appFontFamily, // replace with your actual font family
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 0, 123,
                                            255), // color for the dynamic value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        const SizedBox(
                          height: 2,
                        ),

                        Row(children: <Widget>[
                          //  vehicleLoadingType
                          if (driverNumber != "" && driverNumber != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    255, 0, 0, 0), // Background color
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: Add border radius for rounded corners
                              ),
                              child: Text(
                                "+91 ${driverNumber}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color:
                                      Colors.white, // Optional: Set text color
                                ),
                              ),
                            ),

                          if (vehicleLoadingType != "" &&
                              vehicleLoadingType != null)
                            SizedBox(
                              width: 2,
                            ),
                          if (vehicleLoadingType != "" &&
                              vehicleLoadingType != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255, 13, 103, 238), // Background color
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: Add border radius for rounded corners
                              ),
                              child: Text(
                                vehicleLoadingType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 255, 254,
                                      254), // Optional: Set text color
                                ),
                              ),
                            ),
                        ]),
                        if (transferFrom != "" && transferFrom != null)
                          const SizedBox(
                            height: 4,
                          ),
                        if (transferFrom != "" && transferFrom != null)
                          Row(children: <Widget>[
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Transfer From: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            appFontFamily, // replace with your actual font family
                                        fontSize: 18,
                                        color: Color.fromARGB(221, 0, 0,
                                            0), // color for "Machine Name:"
                                      ),
                                    ),
                                    TextSpan(
                                      text: transferFrom,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            appFontFamily, // replace with your actual font family
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 0, 123,
                                            255), // color for the dynamic value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        const SizedBox(
                          height: 4,
                        ),

                        if (location != "" && location != null)
                          Row(children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    255, 81, 241, 7), // Background color
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: Add border radius for rounded corners
                              ),
                              child: Text(
                                "Location: ${location}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Optional: Set text color
                                ),
                              ),
                            ),
                          ]),

                        Row(children: <Widget>[
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Guard Name: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          appFontFamily, // replace with your actual font family
                                      fontSize: 18,
                                      color: Color.fromARGB(221, 0, 0,
                                          0), // color for "Machine Name:"
                                    ),
                                  ),
                                  TextSpan(
                                    text: name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          appFontFamily, // replace with your actual font family
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 0, 123,
                                          255), // color for the dynamic value
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 5,
                        ),
                        Row(children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 255, 218, 7), // Background color
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: Add border radius for rounded corners
                            ),
                            child: Text(
                              "${DateFormat('d MMMM yyyy').format(DateTime.parse(createdOn))}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color.fromARGB(
                                    255, 0, 0, 0), // Optional: Set text color
                              ),
                            ),
                          ),
                          if (resultTime != null && resultTime != "")
                            SizedBox(
                              width: 2,
                            ),
                          if (resultTime != null && resultTime != "")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255, 7, 247, 171), // Background color
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: Add border radius for rounded corners
                              ),
                              child: Text(
                                resultTime,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Optional: Set text color
                                ),
                              ),
                            ),
                        ]),

                        const SizedBox(
                          height: 5,
                        ),

                        Row(children: <Widget>[
                          // SizedBox(
                          //   width: 10,
                          // ),
                          if (vehicleImg1 != "" && vehicleImg1 != null)
                            GestureDetector(
                              onTap: () {
                                UrlLauncher.launch(vehicleImg1);
                              },
                              child: ClipRRect(
                                child: Image.asset(
                                  AppAssets.icPdf,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                          if (vehicleImg2 != "" && vehicleImg2 != null)
                            SizedBox(
                              width: 5,
                            ),
                          if (vehicleImg2 != "" && vehicleImg2 != null)
                            GestureDetector(
                              onTap: () {
                                UrlLauncher.launch(vehicleImg2);
                              },
                              child: ClipRRect(
                                child: Image.asset(
                                  AppAssets.icPdf,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                          if (vehicleImg3 != "" && vehicleImg3 != null)
                            SizedBox(
                              width: 5,
                            ),
                          if (vehicleImg3 != "" && vehicleImg3 != null)
                            GestureDetector(
                              onTap: () {
                                UrlLauncher.launch(vehicleImg3);
                              },
                              child: ClipRRect(
                                child: Image.asset(
                                  AppAssets.icPdf,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                          if (vehicleImg4 != "" && vehicleImg4 != null)
                            SizedBox(
                              width: 5,
                            ),
                          if (vehicleImg4 != "" && vehicleImg4 != null)
                            GestureDetector(
                              onTap: () {
                                UrlLauncher.launch(vehicleImg4);
                              },
                              child: ClipRRect(
                                child: Image.asset(
                                  AppAssets.icPdf,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),

                          if (designation == "Super Admin" &&
                              status == "LOADING")
                            SizedBox(
                              width: 10,
                            ),
                          if (designation == "Super Admin" &&
                              status == "LOADING")
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VehicleIn(id: vehicleId)),
                                    (Route<dynamic> route) => false);
                              },
                              child: Image.asset(
                                AppAssets.icMemberEdit,
                                height: 45,
                                width: 45,
                              ),
                            ),

                          // InkWell(
                          //     child: Image.asset(
                          //       AppAssets.addPlusYellow,
                          //       height: 40,
                          //       width: 40,
                          //     ),
                          //     onTap: () {
                          //       showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return Dialog(
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(21),
                          //             ),
                          //             elevation: 0,
                          //             backgroundColor: Colors.transparent,
                          //             child: contentBox(
                          //                 context, machineMaintenanceId),
                          //           );
                          //         },
                          //       );
                          //     }),

                          // if (status == "LOADING" &&
                          //     designation == "Super Admin")
                          //   InkWell(
                          //     onTap: () {
                          //       showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return Dialog(
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(21),
                          //             ),
                          //             elevation: 0,
                          //             backgroundColor: Colors.transparent,
                          //             child: approveBox(context, vehicleId),
                          //           );
                          //         },
                          //       );

                          //       // setStatus(vehicleId, "APPROVED");
                          //     },
                          //     child: Image.asset(
                          //       AppAssets.icApprove,
                          //       height: 45,
                          //       width: 45,
                          //     ),
                          //   ),

                          if (status == "TRANSFERRED")
                            SizedBox(
                              width: 10,
                            ),
                          if (status == "TRANSFERRED")
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(21),
                                      ),
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      child: inBox(context, vehicleId),
                                    );
                                  },
                                );

                                // setStatus(vehicleId, "OUT");
                              },
                              child: Image.asset(
                                AppAssets.icIn,
                                height: 45,
                                width: 45,
                              ),
                            ),

                          if (status == "IN")
                            InkWell(
                                child: Image.asset(
                                  AppAssets.addImage,
                                  height: 45,
                                  width: 45,
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(21),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: contentBox(
                                            context, vehicleNo, vehicleId),
                                      );
                                    },
                                  );
                                }),
                          if (status == "IN")
                            SizedBox(
                              width: 10,
                            ),
                          if (status == "IN")
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VehicleIn(id: vehicleId)),
                                    (Route<dynamic> route) => false);
                              },
                              child: Image.asset(
                                AppAssets.icMemberEdit,
                                height: 45,
                                width: 45,
                              ),
                            ),

                          if (status == "IN")
                            SizedBox(
                              width: 10,
                            ),
                          if (status == "IN")
                            InkWell(
                                child: Image.asset(
                                  AppAssets.transferred,
                                  height: 45,
                                  width: 45,
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(21),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: transferredBox(
                                            context, vehicleId, personid!),
                                      );
                                    },
                                  );
                                }),
                          if (status == "IN")
                            SizedBox(
                              width: 10,
                            ),
                          if (status == "IN")
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(21),
                                      ),
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      child: cancelBox(context, vehicleId),
                                    );
                                  },
                                );
                              },
                              child: Image.asset(
                                AppAssets.icCancel,
                                height: 45,
                                width: 45,
                              ),
                            ),
                        ]),
                        if (status == "LOADING")
                          const SizedBox(
                            height: 5,
                          ),
                        if (status == "LOADING")
                          Row(children: <Widget>[
                            if (status == "LOADING")
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(21),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: fileBox(
                                            context, vehicleNo, vehicleId),
                                      );
                                    },
                                  );
                                },
                                child: Image.asset(
                                  AppAssets.icFileupload,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            if (invoiceImg != "" && invoiceImg != null)
                              SizedBox(
                                width: 10,
                              ),
                            if (invoiceImg != "" && invoiceImg != null)
                              GestureDetector(
                                onTap: () {
                                  UrlLauncher.launch(invoiceImg);
                                },
                                child: ClipRRect(
                                  child: Image.asset(
                                    AppAssets.icFileDownload,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                            if (ewayBill != "" && ewayBill != null)
                              SizedBox(
                                width: 10,
                              ),
                            if (ewayBill != "" && ewayBill != null)
                              GestureDetector(
                                onTap: () {
                                  UrlLauncher.launch(ewayBill);
                                },
                                child: ClipRRect(
                                  child: Image.asset(
                                    AppAssets.icFileDownload,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                            if (status == "LOADING" &&
                                (invoiceImg != "" &&
                                    invoiceImg != null &&
                                    ewayBill != "" &&
                                    ewayBill != null))
                              SizedBox(
                                width: 10,
                              ),
                            if (status == "LOADING" &&
                                (invoiceImg != "" &&
                                    invoiceImg != null &&
                                    ewayBill != "" &&
                                    ewayBill != null))
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(21),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: outBox(context, vehicleId),
                                      );
                                    },
                                  );

                                  // setStatus(vehicleId, "OUT");
                                },
                                child: Image.asset(
                                  AppAssets.icOut,
                                  height: 45,
                                  width: 45,
                                ),
                              ),
                          ]),

                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    )),
                  ),
                  // if (pdf != "" && pdf != null)
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           UrlLauncher.launch(pdf);
                  //         },
                  //         child: ClipRRect(
                  //           child: Image.asset(
                  //             AppAssets.icPdf,
                  //             width: 40,
                  //             height: 40,
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 10,
                  //       ),
                  //       // InkWell(
                  //       //     child: Image.asset(
                  //       //       AppAssets.addPlusYellow,
                  //       //       height: 40,
                  //       //       width: 40,
                  //       //     ),
                  //       //     onTap: () {
                  //       //       showDialog(
                  //       //         context: context,
                  //       //         builder: (BuildContext context) {
                  //       //           return Dialog(
                  //       //             shape: RoundedRectangleBorder(
                  //       //               borderRadius: BorderRadius.circular(21),
                  //       //             ),
                  //       //             elevation: 0,
                  //       //             backgroundColor: Colors.transparent,
                  //       //             child: contentBox(context, ""),
                  //       //           );
                  //       //         },
                  //       //       );
                  //       //     })
                  //     ],
                  //   )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColors.dividerColor,
              height: 2,
            )
          ],
        ),
      ),
    );
  }

  Widget appBarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Image.network(
                "https://st4.depositphotos.com/4329009/19956/v/600/depositphotos_199564354-stock-illustration-creative-vector-illustration-default-avatar.jpg",
                fit: BoxFit.cover,
                height: 50,
                width: 50),
          ),
        ),
        // Image.asset(
        //   AppAssets.icAppLogoHorizontal,
        //   width: 150,
        //   height: 45,
        // )
      ],
    );
  }
}
