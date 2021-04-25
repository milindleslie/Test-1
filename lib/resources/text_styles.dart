import 'dart:ui';

import 'package:flutter/material.dart';

import 'constants.dart';

class AppTextStyles {
  static TextStyle whiteFont600 = TextStyle(fontFamily: AppConstants.primaryFontFamily, color: Colors.white, fontWeight: FontWeight.w600);
  static TextStyle whiteFont700 = TextStyle(fontFamily: AppConstants.primaryFontFamily, color: Colors.white, fontWeight: FontWeight.w700);
  static TextStyle whiteFontNormal = TextStyle(fontFamily: AppConstants.primaryFontFamily, color: Colors.white);

  static TextStyle blackFont600 = TextStyle(fontFamily: AppConstants.primaryFontFamily, color: Colors.black, fontWeight: FontWeight.w600);
  static TextStyle blackFont700 = TextStyle(fontFamily: AppConstants.primaryFontFamily, color: Colors.black, fontWeight: FontWeight.w700);
  static TextStyle blackFontNormal = TextStyle(fontFamily: AppConstants.primaryFontFamily, color: Colors.black);
}
