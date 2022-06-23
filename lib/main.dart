
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/check_auth_screen.dart';
import 'package:muserpol_pvt/screens/login.dart';
import 'package:muserpol_pvt/screens/navigator_bar.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

import 'bloc/procedure/procedure_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'provider/app_state.dart';
import 'screens/contacts/screen_contact.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

SharedPreferences? prefs;
void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => UserBloc()),
          BlocProvider(create: (_) => ProcedureBloc()),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthService()),
            ChangeNotifierProvider(create: (_) => AppState())
          ],
          child: ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) => ThemeProvider(
                    saveThemesOnChange:
                        true, // Auto save any theme change we do
                    loadThemeOnInit:
                        false, // Do not load the saved theme(use onInitCallback callback)
                    onInitCallback:
                        (controller, previouslySavedThemeFuture) async {
                      String? savedTheme = await previouslySavedThemeFuture;

                      if (savedTheme != null) {
                        // If previous theme saved, use saved theme
                        controller.setTheme(savedTheme);
                      } else {
                        // If previous theme not found, use platform default
                        Brightness platformBrightness =
                            SchedulerBinding.instance.window.platformBrightness;
                        if (platformBrightness == Brightness.dark) {
                          controller.setTheme('dark');
                        } else {
                          controller.setTheme('light');
                        }
                        // Forget the saved theme(which were saved just now by previous lines)
                        controller.forgetSavedTheme();
                      }
                    },
                    themes: [
                      AppTheme.light().copyWith(
                          id: 'light',
                          data: ThemeData.light().copyWith(
                              drawerTheme: DrawerThemeData(
                                  elevation: 0,
                                  backgroundColor: const Color(0xffF2F2F2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(8)))),
                              inputDecorationTheme: ThemeData.light()
                                  .inputDecorationTheme
                                  .copyWith(
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xff419388))),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xffE8EAED))),
                                      // fillColor: const Color(0xfff2f2f2),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xff419388),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                      ),
                                      iconColor: const Color(0xffBCBCBC),
                                      suffixStyle: TextStyle(fontSize: 17.sp),
                                      helperStyle: TextStyle(fontSize: 17.sp),
                                      prefixStyle: TextStyle(fontSize: 17.sp),
                                      counterStyle: TextStyle(fontSize: 17.sp),
                                      errorStyle: TextStyle(
                                          fontSize: 15.sp, color: Colors.red),
                                      hintStyle: TextStyle(fontSize: 17.sp),
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.center,
                                      floatingLabelStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff419388)),
                                      labelStyle: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff419388),
                                      )),
                              colorScheme: ColorScheme.fromSwatch()
                                  .copyWith(primary: const Color(0xff419388), secondary: const Color(0xff419388)),
                              primaryColor: const Color(0xff419388),
                              cardColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              textTheme: ThemeData.light().textTheme.copyWith(bodyText2: TextStyle(color: const Color(0xff21232A), fontSize: 15.sp)),
                              primaryTextTheme: ThemeData.light()
                                  .textTheme
                                  .copyWith(
                                    bodyText1: TextStyle(fontSize: 20.sp),
                                    bodyText2: TextStyle(fontSize: 20.sp),
                                  )
                                  .apply(fontFamily: 'Ubuntu'),
                              dialogBackgroundColor: const Color(0xfff2f2f2),
                              scaffoldBackgroundColor: const Color(0xfff2f2f2),
                              primaryColorDark: const Color(0xff21232A),
                              iconTheme: const IconThemeData(color: Color(0xff419388)))),
                      AppTheme.dark().copyWith(
                          id: 'dark',
                          data: ThemeData.dark().copyWith(
                              drawerTheme: DrawerThemeData(
                                  elevation: 0,
                                  backgroundColor: const Color(0xff060d09),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(8)))),
                              inputDecorationTheme: ThemeData.dark()
                                  .inputDecorationTheme
                                  .copyWith(
                                      iconColor: const Color(0xffBCBCBC),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xff419388))),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xffE8EAED))),
                                      // fillColor: const Color(0xfff2f2f2),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xff419388),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                      ),
                                      suffixStyle: TextStyle(fontSize: 17.sp),
                                      helperStyle: TextStyle(fontSize: 17.sp),
                                      prefixStyle: TextStyle(fontSize: 17.sp),
                                      counterStyle: TextStyle(fontSize: 17.sp),
                                      errorStyle: TextStyle(
                                          fontSize: 15.sp, color: Colors.red),
                                      hintStyle: TextStyle(fontSize: 17.sp),
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.center,
                                      floatingLabelStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff419388)),
                                      labelStyle:
                                          TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: const Color(0xff419388))),
                              colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color(0xff419388), secondary: const Color(0xff419388)),
                              primaryColor: const Color(0xff419388),
                              cardColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              textTheme: ThemeData.dark().textTheme.copyWith(bodyText2: TextStyle(color: const Color(0xfff2f2f2), fontSize: 15.sp)),
                              primaryTextTheme: ThemeData.dark()
                                  .textTheme
                                  .copyWith(
                                    bodyText1: TextStyle(fontSize: 20.sp),
                                    bodyText2: TextStyle(fontSize: 20.sp),
                                  )
                                  .apply(fontFamily: 'Ubuntu'),
                              dialogBackgroundColor: const Color(0xff21232A),
                              scaffoldBackgroundColor: const Color(0xff060d09),
                              primaryColorDark: const Color(0xfff2f2f2),
                              iconTheme: const IconThemeData(color: Color(0xff419388)))),
                    ],
                    child: ThemeConsumer(
                      child: Builder(
                          builder: (themeContext) => MaterialApp(
                              localizationsDelegates: const [
                                GlobalMaterialLocalizations.delegate,
                                GlobalWidgetsLocalizations.delegate,
                                GlobalCupertinoLocalizations.delegate,
                              ],
                              supportedLocales: const [
                                Locale('es', 'ES'), // Spanish
                                Locale('en', 'US'), // English
                              ],
                              debugShowCheckedModeBanner: false,
                              theme: ThemeProvider.themeOf(themeContext).data,
                              title: 'MUSERPOL PVT',
                              initialRoute: 'check_auth',
                              routes: {
                                'check_auth': (_) => const CheckAuthScreen(),
                                'login': (_) => const ScreenLogin(),
                                'navigator': (_) => const NavigatorBar(),
                                'contacts': (_) => const ScreenContact(),
                              })),
                    ),
                  )),
        ));
  }
}
