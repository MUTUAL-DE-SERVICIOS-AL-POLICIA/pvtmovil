import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/bloc/loan/loan_bloc.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/provider/files_state.dart';
import 'package:muserpol_pvt/screens/inbox/notification.dart';
import 'package:muserpol_pvt/screens/switch.dart';
import 'package:muserpol_pvt/services/push_notifications.dart';
import 'package:muserpol_pvt/swipe/slider.dart';
import 'package:muserpol_pvt/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/notification/notification_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/check_auth_screen.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:theme_provider/theme_provider.dart';

import 'bloc/procedure/procedure_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'provider/app_state.dart';
import 'screens/contacts/screen_contact.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

SharedPreferences? prefs;
void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotificationService.initializeapp();
  HttpOverrides.global = MyHttpOverrides();
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
          BlocProvider(create: (_) => NotificationBloc()),
          BlocProvider(create: (_) => ContributionBloc()),
          BlocProvider(create: (_) => LoanBloc()),
        ],
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthService()),
              ChangeNotifierProvider(create: (_) => LoadingState()),
              ChangeNotifierProvider(create: (_) => TokenState()),
              ChangeNotifierProvider(create: (_) => FilesState()),
              ChangeNotifierProvider(create: (_) => ObservationState()),
              ChangeNotifierProvider(create: (_) => TabProcedureState()),
              ChangeNotifierProvider(create: (_) => ProcessingState()),
            ],
            child: ScreenUtilInit(
                designSize: const Size(360, 690),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) => ThemeProvider(
                    saveThemesOnChange: true, // Auto save any theme change we do
                    loadThemeOnInit: false, // Do not load the saved theme(use onInitCallback callback)
                    onInitCallback: (controller, previouslySavedThemeFuture) async {
                      String? savedTheme = await previouslySavedThemeFuture;

                      if (savedTheme != null) {
                        // If previous theme saved, use saved theme
                        controller.setTheme(savedTheme);
                      } else {
                        // If previous theme not found, use platform default
                        Brightness platformBrightness = SchedulerBinding.instance.window.platformBrightness;
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
                    child: const ThemeConsumer(child: Muserpol())))));
  }
}

class Muserpol extends StatefulWidget {
  const Muserpol({Key? key}) : super(key: key);

  @override
  State<Muserpol> createState() => _MuserpolState();
}

class _MuserpolState extends State<Muserpol> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updatebd();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    final window = WidgetsBinding.instance.window;

    // This callback is called every time the brightness changes.
    window.onPlatformBrightnessChanged = () {
      final brightness = window.platformBrightness;
      debugPrint('brightness ${brightness.name}');
      debugPrint('ThemeProvider.themeOf(context).id. ${ThemeProvider.themeOf(context).id}');
      if (brightness.name == 'dark' && ThemeProvider.themeOf(context).id.contains('light')) {
        ThemeProvider.controllerOf(context).nextTheme();
      }
      if (brightness.name == 'light' && ThemeProvider.themeOf(context).id.contains('dark')) {
        ThemeProvider.controllerOf(context).nextTheme();
      }
    };
    PushNotificationService.messagesStream.listen((message) {
      debugPrint('NO TI FI CA CION $message');
      final msg = json.decode(message);
      debugPrint('HOLA ${msg['origin']}');
      if (msg['origin'] == '_onMessageHandler') {
        _updatebd();
      } else {
        navigatorKey.currentState!.pushNamed('message', arguments: msg);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _updatebd() {
    Future.delayed(Duration.zero, () {
      final notificationBloc = BlocProvider.of<NotificationBloc>(context);
      DBProvider.db.getAllNotificationModel().then((res) => notificationBloc.add(UpdateNotifications(res)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        navigatorKey: navigatorKey,
        theme: ThemeProvider.themeOf(context).data,
        title: 'MUSERPOL PVT',
        initialRoute: 'check_auth',
        routes: {
          'check_auth': (_) => const CheckAuthScreen(),
          'slider': (_) => const PageSlider(),
          'switch': (_) => const ScreenSwitch(),
          'contacts': (_) => const ScreenContact(),
          'message': (_) => const ScreenNotification()
        });
  }
}
