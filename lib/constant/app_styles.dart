import 'package:flutter/material.dart';
// import 'package:lbn_flutter_project/constant/app_color.dart';
// import 'package:lbn_flutter_project/constant/app_fonts.dart';

import 'app_color.dart';
import 'app_fonts.dart';

class AppStyles {
  static TextStyle textfieldCaptionTextStyle = const TextStyle(
      color: AppColors.textFieldCaptionColor,
      fontSize: 17.0,
      fontFamily: appFontFamily,
      fontWeight: FontWeight.w500);

  static TextStyle drawerMenuTextStyle = const TextStyle(
      fontSize: 16,
      fontFamily: appFontFamily,
      fontWeight: FontWeight.w500,
      color: AppColors.black);

  static TextStyle textInputTextStyle = const TextStyle(
      fontFamily: appFontFamily, fontSize: 15.0, color: AppColors.black);

  static InputDecoration textFieldInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.only(left: 10, right: 10),
    fillColor: AppColors.textFieldBgColor,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(width: 0, color: AppColors.black)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(width: 0, color: AppColors.black)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(width: 0, color: AppColors.black)),
    hintStyle: const TextStyle(
        color: AppColors.hintTextColor,
        fontSize: 14.0,
        fontFamily: appFontFamily,
        fontWeight: FontWeight.w400),
  );
  //Radio Button Text Style
  static TextStyle radioButtonTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.lightBlackColor,
      fontFamily: appFontFamily);
}
