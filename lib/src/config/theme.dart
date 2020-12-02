import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: primaryColor,
      fontFamily: "Roboto",
      textTheme: textTheme(),
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black)),
      ),
      backgroundColor: backgroundColor);
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: textColor),
    bodyText2: TextStyle(color: textColor),
    headline1:
        TextStyle(fontSize: 25, color: textColor, fontWeight: FontWeight.w800),
    headline2: TextStyle(fontSize: 18),
  );
}
