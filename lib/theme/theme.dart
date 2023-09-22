import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xoecollect/shared/widgets/app_input.dart';

import 'colors.dart';

class AppTheme {
  // 1
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: TextStyle(fontFamily: "EuclidCircularA", fontSize: 14.0.sp, fontWeight: FontWeight.w700, color: kDark),
    bodyMedium: TextStyle(fontFamily: "EuclidCircularA", fontSize: 14.0.sp, fontWeight: FontWeight.normal, color: kDark),
    displayLarge: TextStyle(fontFamily: "EuclidCircularA", fontSize: 28.0.sp, fontWeight: FontWeight.bold, color: kDark),
    displayMedium: TextStyle(fontFamily: "EuclidCircularA", fontSize: 18.0.sp, fontWeight: FontWeight.w500, color: kDark),
    displaySmall: TextStyle(fontFamily: "EuclidCircularA", fontSize: 12.0.sp, fontWeight: FontWeight.w600, color: kDark),
    titleMedium: TextStyle(fontFamily: "EuclidCircularA", fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: kDark),
    labelMedium: TextStyle(fontSize: 14.0.sp, color: kGrey, fontWeight: FontWeight.w500),
  );

  // 2
  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: TextStyle(fontFamily: "EuclidCircularA", fontSize: 14.0.sp, fontWeight: FontWeight.w700, color: kWhite),
    bodyMedium: TextStyle(fontFamily: "EuclidCircularA", fontSize: 14.0.sp, fontWeight: FontWeight.normal, color: kWhite),
    displayLarge: TextStyle(fontFamily: "EuclidCircularA", fontSize: 28.0.sp, fontWeight: FontWeight.bold, color: kWhite),
    displayMedium: TextStyle(fontFamily: "EuclidCircularA", fontSize: 18.0.sp, fontWeight: FontWeight.w500, color: kWhite),
    displaySmall: TextStyle(fontFamily: "EuclidCircularA", fontSize: 14.0.sp, fontWeight: FontWeight.w600, color: kWhite),
    titleMedium: TextStyle(fontFamily: "EuclidCircularA", fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: kWhite),
    labelMedium: TextStyle(fontFamily: "EuclidCircularA", fontSize: 14.0.sp, color: kGrey, fontWeight: FontWeight.w500),
  );

  // 3
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, primary: primaryColor, brightness: Brightness.light),
      brightness: Brightness.light,
      primaryColor: primaryColor,
      textTheme: lightTextTheme,
      scaffoldBackgroundColor: kBackground,
      primaryColorDark: kDark,
      primaryColorLight: kWhite,
      shadowColor: Colors.grey,
      bottomAppBarTheme: BottomAppBarTheme(color: kWhite),
      hoverColor: kSuccess,
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: primaryColor, foregroundColor: kWhite),
      inputDecorationTheme: InputDecorationTheme(
        border: mainBorder(),
        errorBorder: errorBorder(),
        focusedBorder: mainfocusBorder(),
        filled: true,
        fillColor: kGrey.withOpacity(0.2),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kBackground,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: kDark),
        iconTheme: IconThemeData(color: kDark),
        titleTextStyle: TextStyle(fontFamily: "EuclidCircularA", color: kDark, fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  // 4
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      textTheme: darkTextTheme,
      cardColor: kDarkCard,
      scaffoldBackgroundColor: kDark,
      primaryColorDark: kWhite,
      primaryColorLight: kDark,
      shadowColor: kDarkCard,
      hoverColor: kSuccess,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, primary: primaryColor, brightness: Brightness.dark),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: primaryColor, foregroundColor: kWhite),
      appBarTheme: AppBarTheme(
        backgroundColor: kDark,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: kWhite),
        iconTheme: IconThemeData(color: kWhite),
        titleTextStyle: TextStyle(fontFamily: "EuclidCircularA", color: kWhite, fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}
