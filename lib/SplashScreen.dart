import 'dart:async';
import 'dart:convert';

import 'package:Logistic/LoginPage.dart';

import 'package:Logistic/Welcomepage.dart';
import 'package:Logistic/constant/app_assets.dart';
import 'package:Logistic/directory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:lbn_flutter_project/LoginPage.dart';
// import 'package:lbn_flutter_project/constant/app_assets.dart';
// import 'package:lbn_flutter_project/constant/app_strings.dart';
// import 'package:lbn_flutter_project/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  final String? apptype;

  SplashScreen({this.apptype});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List splashscreen = [];
  String? screen;
  late String pic, site, designation, department, personid;
  // _get() async {
  //   print("Bhanuuuuuuuu.....>???");
  //   print(widget.apptype);
  //   final Alert = (AppStrings.path + 'login/SplashScreen');

  //   var params = {
  //     "OrganizationChapter": widget.apptype,
  //   };
  //   var response = await http.post(
  //     Uri.parse(Alert),
  //     body: json.encode(params),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     var resAlert = json.decode(response.body);
  //     print(resAlert);
  //     print(resAlert['data']);
  //     setState(() {
  //       splashscreen = resAlert['data'];
  //       screen = splashscreen[0]['stringmapname'] ?? '';
  //     });
  //   } else {
  //     print("Error");
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // _get();
    Future.delayed(Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isLoggedIn = prefs.getBool('islogin');
      if (isLoggedIn ?? false) {
        Timer(
            Duration(seconds: 2),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => WelcomePage())));
      } else {
        Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginPage())));
      }
    });
    getLocalData();
  }

  void getLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pic = prefs.getString('pic')!;
      personid = prefs.getString('personid')!;
      site = prefs.getString('site')!;
      designation = prefs.getString('designation')!;
      department = prefs.getString('department')!;
    });
    print(designation);
    print(department);
    print("Hi...?");
  }

  @override
  Widget build(BuildContext context) {
    String Apptype = widget.apptype ?? '';
    return Scaffold(
        backgroundColor: Colors.white,
        body: CachedNetworkImage(
          imageUrl: screen ?? '',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
          errorWidget: (context, url, error) {
            return Image.asset(
              AppAssets.splashscreen,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            );
          },
        )

        //   Image.asset(
        // AppAssets.imgSplashBg,
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        // fit: BoxFit.fill,
        // ),
        );
  }
}
