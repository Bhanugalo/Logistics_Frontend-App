// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:Logistic/constant/app_color.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  // final Color backgroundColor;
  final Color textColor;
  final BorderSide side;
  final Function onTap;
  final BorderRadius? borderRadius;
  final double height;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextStyle textStyle;
  final String organization;

  AppButton(
      {this.label = '',
      this.textColor = AppColors.black,
      //  this.backgroundColor = AppColors.primaryColor(organizationtype)(organization),
      this.side = const BorderSide(style: BorderStyle.none),
      this.borderRadius,
      required this.onTap,
      this.height = 43,
      this.fontWeight,
      this.fontSize = 16,
      required this.textStyle,
      required this.organization});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: TextButton(
          onPressed: () => onTap(),
          style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 14, 76, 245),
            elevation: 3,
            shape: RoundedRectangleBorder(
              side: side,
              borderRadius: borderRadius ?? BorderRadius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: textStyle ??
                  Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: textColor,
                        fontWeight: fontWeight,
                        fontSize: fontSize,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Function onTap;
  final double height;
  final double width;
  final FontWeight fontWeight;

  final Widget prefixWidget;

  const AppIconButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.height = 20,
    required this.fontWeight,
    required this.prefixWidget,
    this.width = 32,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            color: backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(
                12,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white60,
                blurRadius: 1,
                spreadRadius: 2,
                offset: Offset(2, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefixWidget,
              SizedBox(
                width: 12,
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: textColor,
                      fontWeight: fontWeight,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
