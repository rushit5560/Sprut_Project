import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';

class AppThemes {
  AppThemes._privateConstructor();
  static final circleBubbleColor = Color(0xff25b7a6);

  static final lightTextColor = Color(0xff3A3A3A);
  static final greyThree = Color(0xff828282);
  static final colorRed = Color(0xffEB5757);
  static final lightBlue = Color(0xff223263);
  static final lightColor = Color(0xffeaefff);
  static final borderColor = Color(0xffeaefff);
  static final bottomSheetBg = Color(0xfff5f5f5);
  static final primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff233a72), Color(0xff435789)],
  );

  static final pointColor = Color(0xffffebd3);

  static final darkGrey = Color(0xff646464);
  static final dark = Color(0xff212121);
  static final lightGrey = Color(0xffAAAAAA);

  static final lightThemeData = ThemeData.light();
  static final darkThemeData = ThemeData.dark();
  static final lightPrimary = Color(0x668370dc);
  static final primary = Color(0xff8370DC);
  static final primaryMaterialTheme = lightThemeData.copyWith(
      colorScheme: ColorScheme(
        primary: Color(0xff8370DC),
        primaryContainer: Color(0xff435789),
        secondary: Color(0xffAAAAAA),
        secondaryContainer: Color(0xff9098b1),
        background: Colors.white,
        brightness: Brightness.light,
        error: Color(0xffDB2424),
        onBackground: Color.fromRGBO(245, 245, 245, 1),
        onError: Color(0xffe1d7df),
        onSecondary: Color(0xff40bfff),
        onPrimary: Color(0xfffaa236),
        onSurface: Color(0xffbb6bd9),
        surface: Color(0xff575a5f),
      ),
      textTheme: lightThemeData.textTheme.copyWith(
        bodyText1: TextStyle(
            color: Color(0xff9098b1),
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w400,
            fontSize: 10.sp),
        bodyText2: TextStyle(
            color: Color(0xff8370DC),
            fontSize: 10.sp,
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w500),
        labelMedium: TextStyle(
          fontFamily: AppConstants.fontFamily,
          color: Color(0xff2d2b2e),
        ),
        headline1: TextStyle(
            color: Color(0xff4f4f4f),
            fontWeight: FontWeight.w700,
            fontFamily: AppConstants.fontFamily),
        headline2: TextStyle(
            fontSize: 15.sp,
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w700,
            color: Color(0xff223263)),
        headline4: TextStyle(
          color: Color(0xff2d2b2e),
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w600,
        ),
        headline5: TextStyle(
          color: Color(0xff9098b1),
          fontSize: 12.sp,
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.50,
        ),
        button: TextStyle(fontSize: 16.0, letterSpacing: 1),
        subtitle2: TextStyle(
          fontFamily: AppConstants.fontFamily,
          color: Color(0xff9098b1),
          fontSize: 9.sp,
        ),
        headline3: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: AppConstants.fontFamily),
      ));

  final darkMaterialTheme = darkThemeData.copyWith(
    colorScheme: ColorScheme(
      primary: Colors.white,
      primaryContainer: Colors.white,
      secondary: Color.fromRGBO(0, 149, 246, 1),
      secondaryVariant: Colors.white,
      background: Colors.white,
      brightness: Brightness.light,
      error: Colors.red,
      onBackground: Colors.white,
      onError: Colors.red,
      onSecondary: Colors.white,
      onPrimary: Colors.black,
      onSurface: Colors.white,
      surface: Color.fromRGBO(0, 149, 246, 1),
    ),
    textTheme: darkThemeData.textTheme.apply(
      fontFamily: 'Open Sans',
    ),
  );

  //FOOD DELIVERY
  //food screen bg color
  static final cashBackCardBgColor = Color(0xff17191E);
  static final foodBgColor = Color(0xff272728);
  static final colorWhite = Color(0xffffffff);
  static final colorBorderLine = Color(0xff838383);
  static final colorTextLight = Color(0xff838383);
  static final colorSearchViewTextLight = Color(0xffAAAAAA);
  static final offWhiteColor = Color(0xFFC0C0C0);
  static final lightLineColor = Color(0xFFA4A4A4);
  static final lightLineColor2 = Color(0xFF323232);
  static final orderCompletedStatusColor = Color(0xFF34C759);

  final primaryCupertinoTheme = CupertinoThemeData(
    primaryColor: CupertinoDynamicColor.withBrightness(
      color: Colors.purple,
      darkColor: Colors.cyan,
    ),
  );
}
