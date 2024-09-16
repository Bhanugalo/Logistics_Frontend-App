import 'dart:convert';
import 'dart:io';

import 'package:Logistic/AvailableStock.dart';
import 'package:Logistic/CommonDrawer.dart';
import 'package:Logistic/MachineMaintenance.dart';
import 'package:Logistic/MachineMaintenanceList.dart';
import 'package:Logistic/VehicleInOutList.dart';

import 'package:Logistic/components/appbar.dart';
import 'package:Logistic/constant/app_color.dart';
import 'package:Logistic/constant/app_fonts.dart';
import 'package:Logistic/constant/app_styles.dart';
import 'package:Logistic/directory.dart';
import 'package:Logistic/VehicleIn.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../BoxCricket.dart';
import '../constant/app_assets.dart';
import '../main.dart';
// import 'package:shimmer/shimmer.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  String? firstname,
      designation,
      department,
      lastname,
      personid,
      pic,
      VersionNo,
      ImagePath,
      site,
      businessname,
      clubname,
      organizationName,
      organizationtype,
      vCard,
      userGuideLink;
  bool isAllowedEdit = false,
      menu = false,
      user = false,
      face = false,
      home = true;
  var decodedResult;

  late AnimationController _controller1;
  late Animation<double> _animation1;
  late AnimationController _controller2;
  late Animation<double> _animation2;
  late bool showFirst;
  void store() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      designation = prefs.getString('designation');
      department = prefs.getString('department');
      personid = prefs.getString('personid');
      firstname = prefs.getString('firstname');
      lastname = prefs.getString('lastname');
      pic = prefs.getString('pic');
      VersionNo = prefs.getString('versionNo');
      clubname = prefs.getString('clubname');
      businessname = prefs.getString('businessname');
      organizationName = prefs.getString('organizationName');
      organizationtype = prefs.getString('organizationtype');
      site = prefs.getString('site');
      ImagePath = prefs.getString('imagePath');
      vCard = prefs.getString('Vcard');
    });
    //  getStatus();
  }

  // void getStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   site = prefs.getString('site');
  //   final url = (site!) + 'Employee/CheckActive';
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: jsonEncode(<String, String>{"personid": personid!}),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //   print("Response.....");
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     var objData = json.decode(response.body);
  //     print(objData['status']);
  //     if (objData['status'] == "Inactive") {
  //       prefs.remove('site');

  //       prefs.remove('personid');
  //       prefs.remove('fullname');
  //       prefs.remove('department');
  //       prefs.remove('pic');

  //       prefs.setBool('islogin', false);
  //       prefs.remove('designation');
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (BuildContext context) => MyApp()),
  //           (Route<dynamic> route) => false);
  //     }
  //     return;
  //   } else {
  //     throw Exception('Failed To Fetch Data');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    store();

    _controller1 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation1 = Tween<double>(
      begin: 0.85,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.linear,
      ),
    );

    _controller2 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation2 = Tween<double>(
      begin: 1.05,
      end: 0.85,
    ).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.linear,
      ),
    );

    showFirst = true;

    // Switch cards every 3 seconds
    _switchCards();
  }

  void _switchCards() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showFirst = !showFirst;
        if (showFirst) {
          _controller1.forward(from: 0.0);
          _controller2.reverse(from: 1.0);
        } else {
          _controller1.reverse(from: 1.0);
          _controller2.forward(from: 0.0);
        }
      });
      _switchCards();
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  adminbuttons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // buttonAttendance(),
        // buttonReport(),
      ],
    );
  }

  Future<bool> redirectto() async {
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
    //     (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: GautamAppBar(
        organization: "organizationtype",
        isBackRequired: false,
        memberId: personid,
        imgPath: "ImagePath",
        memberPic: pic,
        logo: "logo",
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EmployeeList();
          }));
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              // if (designation != 'Logistic Engineer')
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       Expanded(
              //           child: availableStock(
              //               'Available Stock', AppAssets.imgStock, () {
              //         Navigator.of(context).pushAndRemoveUntil(
              //             MaterialPageRoute(
              //                 builder: (BuildContext context) =>
              //                     AvailableStock()),
              //             (Route<dynamic> route) => false);
              //       })),
              //       const SizedBox(
              //         width: 10,
              //       ),
              //     ],
              //   ),
              //  if (designation != 'Logistic Engineer')
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  // if (designation != 'Logistic Engineer')
                  Expanded(
                      child: inSpareParts(
                          'Vehicle In/Out', AppAssets.imgWelcome, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                VehicleInOutList()),
                        (Route<dynamic> route) => false);
                  })),
                  const SizedBox(
                    width: 10,
                  ),
                  // if (designation != 'Spare Part Store Manager')
                  //   Expanded(
                  //       child: outSpareParts(
                  //           'Machine Logistic', AppAssets.Laminator1, () {
                  //     Navigator.of(context).pushAndRemoveUntil(
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 MachineMaintenance()),
                  //         (Route<dynamic> route) => false);
                  //   })),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     if (designation != 'Logistic Engineer')
              //       Expanded(
              //           child: sparePartInList(
              //               'Spare Parts In List', AppAssets.imgSparePartList,
              //               () {
              //         Navigator.of(context).pushAndRemoveUntil(
              //             MaterialPageRoute(
              //                 builder: (BuildContext context) =>
              //                     SparePartInList()),
              //             (Route<dynamic> route) => false);
              //       })),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     if (designation != 'Spare Part Store Manager')
              //       Expanded(
              //           child: machineMaintenanceList(
              //               'Machine Logistic List',
              //               AppAssets.imgMachineList, () {
              //         Navigator.of(context).pushAndRemoveUntil(
              //             MaterialPageRoute(
              //                 builder: (BuildContext context) =>
              //                     MachineMaintenanceList()),
              //             (Route<dynamic> route) => false);
              //       })),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 236, 46, 46),
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => WelcomePage()));
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
                  if (designation == 'Super Admin') {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => EmployeeList()));
                  }
                },
                child: Image.asset(
                    user ? AppAssets.imgSelectedPerson : AppAssets.imgPerson,
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => PublicDrawer()));
                },
                child: Image.asset(
                    menu ? AppAssets.imgSelectedMenu : AppAssets.imgMenu,
                    height: 25)),
          ],
        ),
      ),
    );
  }

  InkWell buttonDashboard() {
    return InkWell(
        onTap: () {
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => WelcomePage()),
          //     (Route<dynamic> route) => false);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Material(
                  shape: RoundedRectangleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: new Image.asset(AppAssets.icDashboard,
                      height: 18.0, width: 18.0, color: AppColors.greyColor),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text("Dashboard", style: AppStyles.drawerMenuTextStyle),
            ]));
  }

  InkWell buttonDirectory() {
    return InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => EmployeeList()),
              (Route<dynamic> route) => false);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Material(
                  shape: RoundedRectangleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(AppAssets.icDirectory,
                      height: 18.0, width: 18.0, color: AppColors.greyColor),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text("Directory", style: AppStyles.drawerMenuTextStyle),
            ]));
  }

  Item? selectedUser;
  List<Item> users = <Item>[
    const Item('1-2-1', "images/drawer-p2p.png"),
    const Item('Referral', "images/drawer-referral.png"),
    const Item('TYN', "images/drawer-tyn.png"),
    const Item('Testimonial', "images/drawer-testimonials.png"),
    const Item('Visitor', "images/drawer-visitors.png"),
  ];

  Item1? selectedUser1;
  List<Item1> users1 = <Item1>[
    const Item1('Meeting', "images/drawer-add-meeting.png"),
    const Item1('Training', "images/drawer-training.png"),
  ];

  Item2? selectedUser2;
  List<Item2> users2 = <Item2>[
    const Item2('Activity', "images/drawer-referral.png"),
    const Item2('1-2-1', "images/drawer-p2p.png"),
    const Item2('Referral', "images/drawer-referral.png"),
    const Item2('TYN', "images/drawer-tyn.png"),
    const Item2('Attendance', 'icons/attendance.png'),
  ];
  Item3? selectedUser3;
  List<Item3> users3 = <Item3>[
    const Item3('TYN', "images/drawer-tyn.png"),
    const Item3('Referral', "images/drawer-referral.png"),
    const Item3('1-2-1', "images/drawer-p2p.png"),
    const Item3('Overall', "images/drawer-visitors.png"),
  ];

  Widget availableStock(String title, String img, final Function onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: AnimatedBuilder(
        animation: _animation1,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation1.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 159, 28),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 255,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 150,
                  width: 155,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: AssetImage(AppAssets.imgStock),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 15),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: appFontFamily,
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      height: 36,
                      width: 36,
                      child: Image.asset(
                        img,
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inSpareParts(String title, String img, final Function onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: AnimatedBuilder(
        animation: _animation1,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation1.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 180, 67, 33),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 555,
          child: Stack(
            children: [
              Positioned(
                bottom: 80,
                right: 50,
                child: Container(
                  height: 250,
                  width: 255,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: AssetImage(AppAssets.imgWelcome),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 15),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: appFontFamily,
                        fontSize: 25,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      height: 56,
                      width: 56,
                      child: Image.asset(
                        img,
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sparePartInList(String title, String img, final Function onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: AnimatedBuilder(
        animation: _animation1,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation1.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 253, 229, 11),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 255,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 150,
                  width: 155,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: AssetImage(AppAssets.imgSparePartList),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 15),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: appFontFamily,
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      height: 36,
                      width: 36,
                      child: Image.asset(
                        img,
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget outSpareParts(String title, String img, final Function onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: AnimatedBuilder(
          animation: _animation2,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation2.value,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 255,
            child: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: AssetImage(
                                AppAssets.Laminator1,
                              ),
                              fit: BoxFit.fill)),
                      // child: Image.asset(
                      //   AppAssets.icEllipse,
                      //   fit: BoxFit.fill,
                      //   height: 50,
                      //   width: 155,
                      // ),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 15),
                      child: Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: appFontFamily,
                              fontSize: 16,
                              color: Color.fromARGB(249, 0, 0, 0))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: Container(
                            height: 36,
                            width: 36,
                            child: Image.asset(
                              img,
                              height: 36,
                              width: 36,
                              //fit: BoxFit.cover,
                            )))
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget machineMaintenanceList(
      String title, String img, final Function onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: AnimatedBuilder(
          animation: _animation2,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation2.value,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 21, 228, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 255,
            child: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: AssetImage(
                                AppAssets.imgMachineList,
                              ),
                              fit: BoxFit.fill)),
                      // child: Image.asset(
                      //   AppAssets.icEllipse,
                      //   fit: BoxFit.fill,
                      //   height: 50,
                      //   width: 155,
                      // ),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 15),
                      child: Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: appFontFamily,
                              fontSize: 16,
                              color: Color.fromARGB(249, 0, 0, 0))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: Container(
                            height: 36,
                            width: 36,
                            child: Image.asset(
                              img,
                              height: 36,
                              width: 36,
                              //fit: BoxFit.cover,
                            )))
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class Item {
  const Item(this.name, this.path);
  final String name;
  final String path;
}

class Item1 {
  const Item1(this.name, this.path);
  final String name;
  final String path;
}

class Item2 {
  const Item2(this.name, this.path);
  final String name;
  final String path;
}

class Item3 {
  const Item3(this.name, this.path);
  final String name;
  final String path;
}

// Widget tabDashboard(String title, String img, final Function onPressed) {
//   return InkWell(
//     onTap: () {
//       onPressed();
//     },
//     child: AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _animation.value,
//             child: child,
//           );
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           height: 215,
//           child: Stack(
//             children: [
//               Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     height: 150,
//                     width: 155,
//                     decoration: BoxDecoration(
//                         borderRadius:
//                             BorderRadius.only(bottomRight: Radius.circular(10)),
//                         image: DecorationImage(
//                             image: AssetImage(
//                               AppAssets.busbar,
//                             ),
//                             fit: BoxFit.fill)),
//                     // child: Image.asset(
//                     //   AppAssets.icEllipse,
//                     //   fit: BoxFit.fill,
//                     //   height: 50,
//                     //   width: 155,
//                     // ),
//                   )),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 18.0, top: 15),
//                     child: Text(title,
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontFamily: appFontFamily,
//                             fontSize: 16,
//                             color: AppColors.textFieldCaptionColor)),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Center(
//                       child: Container(
//                           height: 36,
//                           width: 36,
//                           child: Image.asset(
//                             img,
//                             height: 36,
//                             width: 36,
//                             //fit: BoxFit.cover,
//                           )))
//                 ],
//               )
//             ],
//           ),
//         )),
//   );
// }
