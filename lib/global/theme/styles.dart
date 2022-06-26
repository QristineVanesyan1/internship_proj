import 'dart:ui';

import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class Styles {
  static Color themeColor = const Color(0xFFFFFC00);
  static Color usersBtnColor = const Color(0xFF36633c);
  static Color apiBtnColor = const Color(0xFF8e24aa);
  static Color loginBtnColor = const Color(0xFFd83c3c);
  static Color signUpBtnColor = const Color(0xFF03a9f4);
  static Color whiteThemeColor = const Color(0xFFffffff);
  static Color errorMessageColor = const Color(0xFFF44336);
  static Color cntButtonActiveColor = const Color(0xFF02a9f4);
  static Color cntButtonInactiveColor = const Color(0xFFbcbcbc);
  static Color subTextColor = const Color(0xFFbcbcbc);
  static Color backIconColor = const Color(0xFF03a9f4);
  static Color subTextLinkColor = const Color(0xFF03a9f4);
  static Color primarySwatchColor = const Color(0xFFbcbcbc);
  static Color headerColor = const Color(0xFFbcbcbc);
  static Color textColor = const Color(0xFF000000);
  static Color userCardColor = const Color(0xFFfafafa);

  static TextStyle hintTextStyle = TextStyle(color: subTextColor);
  static TextStyle errorMessageStyle =
      TextStyle(color: Styles.errorMessageColor, fontSize: 11);
  static TextStyle notificationMsgStyle = const TextStyle(fontSize: 11);
  static TextStyle subTextStyle =
      TextStyle(color: subTextColor, fontSize: 11, letterSpacing: 0.5);
  static TextStyle subTextLinkStyle =
      TextStyle(color: subTextLinkColor, fontSize: 11, letterSpacing: 0.5);
  static TextStyle subTitleStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: subTextColor);
  static TextStyle userDataText = TextStyle(color: textColor, fontSize: 15);
  static TextStyle linkLabelStyle = TextStyle(
    fontSize: 11,
    color: subTextLinkColor,
    fontWeight: FontWeight.w500,
  );
  static TextStyle pageTitleStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle countryCodePickerStyle = TextStyle(color: subTextLinkColor);
}
