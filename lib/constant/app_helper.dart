// ignore_for_file: avoid_print, prefer_const_constructors, body_might_complete_normally_nullable

import 'dart:io';
import 'package:Logistic/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

class AppHelper {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (Platform.isIOS) {
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    } else if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void changeScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => screen,
      ),
    );
  }

  static Future<dynamic> changeScreenForResult(
      BuildContext context, Widget screen,
      {bool fullscreenDialog = false}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: fullscreenDialog,
        builder: (BuildContext context) => screen,
      ),
    );
  }

  static void changeScreenReplace(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => screen,
      ),
    );
  }

  static void changeScreenClearStack(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
      (route) => false,
    );
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void showProgressBar() {
    SpinKitFadingCircle(
      color: AppColors.primaryColor,
      size: 50.0,
    );
  }

  static void showLog(String message) {
    //print(message.toString());
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isPhoneNoValid(String phoneNo) {
    if (phoneNo == null) return false;
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNo);
  }

  static Color getColorFromHex(String hexColor) {
    return Color(
      int.parse((hexColor).replaceAll('#', '0xff')),
    );
  }
}
