import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_provider/theme_provider.dart';

AppTheme styleLigth2() {
  return AppTheme.light().copyWith(
      id: 'light',
      data: ThemeData.light().copyWith(
          inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
                focusedErrorBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Color(0xff419388))),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.grey, width: 2)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color(0xff419388),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                iconColor: Colors.black,
                errorStyle: TextStyle(fontSize: 15.sp).apply(color: Colors.red, fontFamily: 'Poppins'),
              ),
          buttonTheme: ButtonThemeData(
              padding: const EdgeInsets.all(0),
              splashColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textTheme: ButtonTextTheme.accent),
              
          textTheme: ThemeData.light()
              .textTheme
              .copyWith(
                bodyText1: TextStyle(color: const Color(0xff21232A), fontSize: 17.sp),
                bodyText2: TextStyle(color: const Color(0xff21232A), fontSize: 17.sp),
                button: TextStyle(fontSize: 17.sp),
              )
              .apply(
                fontFamily: 'Poppins',
              ),
          primaryTextTheme: ThemeData.light()
              .textTheme
              .copyWith(
                bodyText1: TextStyle(fontSize: 20.sp),
                bodyText2: TextStyle(fontSize: 20.sp),
              )
              .apply(fontFamily: 'Poppins'),
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color(0xff419388), secondary: const Color(0xff419388)),
          primaryColor: const Color(0xff419388),
          cardColor: const Color(0xfff2f2f2),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          dialogBackgroundColor: const Color(0xfff2f2f2),
          scaffoldBackgroundColor: const Color(0xfff2f2f2),
          primaryColorDark: const Color(0xff21232A),
          iconTheme: const IconThemeData(color: Color(0xff419388))));
}

AppTheme styleDark2() {
  return AppTheme.dark().copyWith(
      id: 'dark',
      data: ThemeData.dark().copyWith(
          drawerTheme: const DrawerThemeData(
              elevation: 0,
              backgroundColor: Color(0xff060d09),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(8)))),
          inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
                focusedErrorBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Color(0xff419388))),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Color(0xffE8EAED))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color(0xff419388),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                iconColor: Colors.white,
                errorStyle: TextStyle(fontSize: 15.sp).apply(color: Colors.red, fontFamily: 'Poppins'),
              ),
          buttonTheme: ButtonThemeData(
              padding: const EdgeInsets.all(0),
              splashColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textTheme: ButtonTextTheme.accent),
          textTheme: ThemeData.dark()
              .textTheme
              .copyWith(
                bodyText1: TextStyle(fontSize: 17.sp),
                bodyText2: TextStyle(fontSize: 17.sp),
                button: TextStyle(fontSize: 17.sp),
              )
              .apply(
                fontFamily: 'Poppins',
              ),
          primaryTextTheme: ThemeData.dark()
              .textTheme
              .copyWith(
                bodyText1: TextStyle(fontSize: 20.sp),
                bodyText2: TextStyle(fontSize: 20.sp),
              )
              .apply(fontFamily: 'Poppins'),
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color(0xff419388), secondary: const Color(0xff419388)),
          primaryColor: const Color(0xff419388),
          cardColor: const Color(0xff060d09),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          dialogBackgroundColor: const Color(0xff060d09),
          scaffoldBackgroundColor: const Color(0xff060d09),
          primaryColorDark: const Color(0xfff2f2f2),
          iconTheme: const IconThemeData(color: Color(0xff419388))));
}
