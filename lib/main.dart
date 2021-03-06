import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muserpol_pvt/utils/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/check_auth_screen.dart';
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // _deleteCacheDir();
    _deleteAppDir();
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

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
            ChangeNotifierProvider(create: (_) => AppState()),
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
                      styleLigth2(),
                      styleDark2(),
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
                                'switch': (_) => const CheckAuthScreen(),
                                'check_auth': (_) => const CheckAuthScreen(),
                                'navigator': (_) => const NavigatorBar(),
                                'contacts': (_) => const ScreenContact(),
                              })),
                    ),
                  )),
        ));
  }
}
