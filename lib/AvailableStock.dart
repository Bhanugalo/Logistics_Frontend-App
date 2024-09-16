import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:Logistic/CommonDrawer.dart';
import 'package:Logistic/VehicleIn.dart';

import 'package:Logistic/Welcomepage.dart';
import 'package:Logistic/addeditemployee.dart';
import 'package:Logistic/components/app_loader.dart';
import 'package:Logistic/components/appbar.dart';
import 'package:Logistic/constant/app_assets.dart';
import 'package:Logistic/constant/app_color.dart';
import 'package:Logistic/constant/app_fonts.dart';
import 'package:Logistic/constant/app_strings.dart';
import 'package:Logistic/constant/app_styles.dart';
import 'package:Logistic/Available_Stock_Model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class AvailableStock extends StatefulWidget {
  AvailableStock();

  @override
  _AvailableStockState createState() => _AvailableStockState();
}

class _AvailableStockState extends State<AvailableStock> {
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
  TextEditingController SearchController = TextEditingController();
  // TextEditingController _paymentModeController = new TextEditingController();
  TextEditingController ExpiryDateController = new TextEditingController();
  TextEditingController PaymentDateController = new TextEditingController();

  TextEditingController NoteController = new TextEditingController();
  GlobalKey<FormState> _renewalFormkey = GlobalKey<FormState>();

  bool _isLoading = false, IN = false, OUT = false;
  bool menu = false, user = false, face = false, home = false;
  String? _paymentModeController;
  List paymentModeData = [];
  String? personid,
      vCard,
      firstname,
      lastname,
      pic,
      logo,
      site,
      designation,
      department,
      ImagePath,
      detail,
      businessname,
      organizationName,
      otherChapterName = '',
      _hasBeenPressedorganization = '',
      organizationtype,
      _hasBeenPressed = '',
      _hasBeenPressed1 = 'Active',
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
  List dropdownList = [];

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
    });

    userdata = getData();
  }

  Future<List<UserData>?> getData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');
    setState(() {
      _isLoading = true;
    });

    final url = (site! + 'Logistic/SparePartStockList');

    http.get(
      Uri.parse(url),
      // body: jsonEncode(<String, String>{}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          decodedResult = jsonDecode(response.body);
        });
      }
    });

    return null;
  }

  // void setMemberStatus(status, id) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final prefs = await SharedPreferences.getInstance();
  //   site = prefs.getString('site');
  //   final url = (site!) + 'Employee/DeleteEmployee';
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: jsonEncode(<String, String>{"PersonId": id, "Status": status}),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //   print("Response.....");
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     Toast.show("Employee Removed Successfully",
  //         duration: Toast.lengthLong,
  //         gravity: Toast.center,
  //         backgroundColor: AppColors.primaryColor);

  //     getData();

  //     return;
  //   } else {
  //     throw Exception('Failed To Fetch Data');
  //   }
  // }

  // contentBox(context, String personId) {
  //   return SingleChildScrollView(
  //     child: Form(
  //       child: Column(
  //         children: [
  //           Container(
  //             padding:
  //                 EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
  //             decoration: BoxDecoration(
  //               shape: BoxShape.rectangle,
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: SingleChildScrollView(
  //               physics: const BouncingScrollPhysics(),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Text(
  //                     // 'Disable Member',
  //                     "Machine Logistic",
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 20,
  //                       fontFamily: 'HKGrotesk',
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(height: 15),
  //                       const Text(
  //                         // 'Are you sure you want to disable this member?',
  //                         "Are you involved in this machine maintenance.?",
  //                         style: TextStyle(
  //                             fontSize: 15, fontWeight: FontWeight.bold),
  //                       ),
  //                       const SizedBox(height: 15),
  //                       InkWell(
  //                         onTap: () {
  //                           Navigator.of(context).pop();
  //                           // setMemberStatus('Inactive', personId);
  //                         },
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             color: AppColors.primaryColor,
  //                             borderRadius: BorderRadius.circular(20),
  //                           ),
  //                           child: const Padding(
  //                             padding: EdgeInsets.only(top: 10, bottom: 10),
  //                             child: Center(
  //                               child: Text(
  //                                 'Yes',
  //                                 style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontFamily: 'HKGrotesk',
  //                                     fontSize: 16.0,
  //                                     fontWeight: FontWeight.w700),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10.0),
  //                       InkWell(
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: const Center(
  //                             child: Text(
  //                               'NO',
  //                               style: TextStyle(
  //                                   fontFamily: appFontFamily,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: AppColors.redColor),
  //                             ),
  //                           )),
  //                       const SizedBox(height: 10.0),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                                      AvailableStock()),
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
                bottomNavigationBar: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 98, 99, 100),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WelcomePage()));
                          },
                          child: Image.asset(
                              home
                                  ? AppAssets.icHomeSelected
                                  : AppAssets.icHomeUnSelected,
                              height: 25)),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AvailableStock()));
                          },
                          child: Image.asset(
                              user
                                  ? AppAssets.imgSelectedPerson
                                  : AppAssets.imgPerson,
                              height: 25)),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          // onTap: () {
                          //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                          //       builder: (BuildContext context) => Attendance()));
                          // },
                          child: Image.asset(
                              face
                                  ? AppAssets.icSearchSelected
                                  : AppAssets.icSearchUnSelected,
                              height: 25)),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PublicDrawer()));
                          },
                          child: Image.asset(
                              menu
                                  ? AppAssets.imgSelectedMenu
                                  : AppAssets.imgMenu,
                              height: 25)),
                    ],
                  ),
                ),
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
            //#1 Active
            InkWell(
                onTap: () {
                  setState(() {
                    _hasBeenPressed1 = 'Active';
                    _hasBeenPressed2 = '';
                  });
                  userdata = getData();
                },
                child: Text('Active',
                    style: TextStyle(
                        fontFamily: appFontFamily,
                        color: _hasBeenPressed1 == 'Active'
                            ? AppColors.blueColor
                            : AppColors.black,
                        fontWeight: _hasBeenPressed1 == 'Active'
                            ? FontWeight.w700
                            : FontWeight.normal))),

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
                  _hasBeenPressed1 = 'Inactive';
                });
                userdata = getData();
              },
              child: Text(
                'Inactive',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: _hasBeenPressed1 == 'Inactive'
                        ? AppColors.blueColor
                        : AppColors.black,
                    fontWeight: _hasBeenPressed1 == 'Inactive'
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

            //#3 Pending
            if (organizationtype == 'RMB Chapter' ||
                organizationtype == 'Me-connect Chapter')
              InkWell(
                onTap: () {
                  setState(() {
                    _hasBeenPressed1 = 'Pending';
                  });
                  userdata = getData();
                },
                child: Text(
                  'Pending',
                  style: TextStyle(
                      fontFamily: appFontFamily,
                      color: _hasBeenPressed1 == 'Pending'
                          ? AppColors.blueColor
                          : AppColors.black,
                      fontWeight: _hasBeenPressed1 == 'Pending'
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
      const Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available Stocks',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: AppColors.blueColor)),
            ],
          )),
      const Padding(padding: EdgeInsets.only(top: 15, left: 10, right: 10)),
      Row(children: <Widget>[
        Container(
          child: Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  )),
              style: AppStyles.textInputTextStyle,
              onChanged: (value) {
                setState(() {});
              },
            ),
          )),
        ),
      ]),
      // Padding(
      //     padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       crossAxisAlignment: CrossAxisAlignment.end,
      //       children: [if (isAllowedEdit) filter()],
      //     )),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  data.data!.length > 1
                      ? '${data.data!.length} Spare Parts'
                      : '${data.data!.length} Spare Part',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: appFontFamily,
                      fontSize: 15,
                      color: AppColors.greyColor)),
              // if (isAllowedEdit) filter()
            ],
          )),
      Container(
        child: Expanded(
            child: ListView.builder(
                itemCount: data.data!.length,
                itemBuilder: (context, index) {
                  if (SearchController.text.isEmpty) {
                    return Container(
                        child: _tile(
                            data.data![index].sparePartStockId ?? '',
                            data.data![index].sparePartName ?? '',
                            data.data![index].spareModelNumber ?? '',
                            data.data![index].machineNames!.join(", ") ?? '',
                            data.data![index].availableStock ?? ''));
                  } else if ((data.data![index].sparePartName ?? '')
                          .toLowerCase()
                          .contains((SearchController.text).toLowerCase()) ||
                      data.data![index].spareModelNumber!
                          .toLowerCase()
                          .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].sparePartStockId ?? '',
                            data.data![index].sparePartName ?? '',
                            data.data![index].spareModelNumber ?? '',
                            data.data![index].machineNames!.join(", ") ?? '',
                            data.data![index].availableStock ?? ''));
                  } else if (data.data![index].machineNames!
                      .join(", ")
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].sparePartStockId ?? '',
                            data.data![index].sparePartName ?? '',
                            data.data![index].spareModelNumber ?? '',
                            data.data![index].machineNames!.join(", ") ?? '',
                            data.data![index].availableStock ?? ''));
                  } else if (data.data![index].availableStock!
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].sparePartStockId ?? '',
                            data.data![index].sparePartName ?? '',
                            data.data![index].spareModelNumber ?? '',
                            data.data![index].machineNames!.join(", ") ?? '',
                            data.data![index].availableStock ?? ''));
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
    String sparePartStockId,
    String sparePartName,
    String spareModelNumber,
    String machineNames,
    String availableStock,
  ) {
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
                                  TextSpan(
                                    text: "Spare Part Name: ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          appFontFamily, // replace with your actual font family
                                      fontSize: 19,
                                      color: Color.fromARGB(221, 0, 0,
                                          0), // color for "Machine Name:"
                                    ),
                                  ),
                                  TextSpan(
                                    text: sparePartName,
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
                        ]),

                        SizedBox(
                          height: 5,
                        ),

                        Row(children: <Widget>[
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Spare Part Model Number: ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          appFontFamily, // replace with your actual font family
                                      fontSize: 19,
                                      color: Color.fromARGB(221, 0, 0,
                                          0), // color for "Machine Name:"
                                    ),
                                  ),
                                  TextSpan(
                                    text: spareModelNumber,
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
                        ]),

                        const SizedBox(
                          height: 2,
                        ),

                        Row(children: <Widget>[
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Machine Name: ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          appFontFamily, // replace with your actual font family
                                      fontSize: 19,
                                      color: Color.fromARGB(221, 236, 116,
                                          3), // color for "Machine Name:"
                                    ),
                                  ),
                                  TextSpan(
                                    text: machineNames,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          appFontFamily, // replace with your actual font family
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 37, 132,
                                          233), // color for the dynamic value
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 248, 212, 10), // Background color
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: Add border radius for rounded corners
                            ),
                            child: Text(
                              "Available Stock: ${availableStock}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color.fromARGB(
                                    255, 0, 0, 0), // Optional: Set text color
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 4,
                        ),

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
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       InkWell(
                  //           child: Image.asset(
                  //             AppAssets.addPlusYellow,
                  //             height: 40,
                  //             width: 40,
                  //           ),
                  //           onTap: () {
                  //             showDialog(
                  //               context: context,
                  //               builder: (BuildContext context) {
                  //                 return Dialog(
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(21),
                  //                   ),
                  //                   elevation: 0,
                  //                   backgroundColor: Colors.transparent,
                  //                   child: contentBox(context, "id"),
                  //                 );
                  //               },
                  //             );
                  //           })
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
