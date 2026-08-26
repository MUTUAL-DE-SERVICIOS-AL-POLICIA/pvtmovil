import 'dart:convert';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/bloc/loan/loan_bloc.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/model/register_number/files_state_veritify.dart';
import 'package:muserpol_pvt/provider/app_session_state.dart';
import 'package:muserpol_pvt/provider/files_state.dart';
import 'package:muserpol_pvt/screens/access/newlogin.dart';
import 'package:muserpol_pvt/screens/inbox/notification.dart';
import 'package:muserpol_pvt/services/push_notifications.dart';
import 'package:muserpol_pvt/swipe/slider.dart';
import 'package:muserpol_pvt/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/notification/notification_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/check_auth_screen.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'bloc/procedure/procedure_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'provider/app_state.dart';
import 'screens/contacts/screen_contact.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:muserpol_pvt/firebase_options.dart';

/// ---------------------------------------------------------
/// 1. CONFIGURACIÓN DE SEGURIDAD (LISTA BLANCA HTTP)
/// ---------------------------------------------------------
class SecureHttpOverrides extends HttpOverrides {
  final List<String> whitelistedHosts;

  SecureHttpOverrides(this.whitelistedHosts);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Si el host está en la lista blanca del .env, permitimos la conexión
        final isAllowed = whitelistedHosts.contains(host);
        if (isAllowed) {
          debugPrint(
              '⚠️ SECURITY BYPASS: Permitiendo conexión insegura a $host');
          return true;
        }
        // Para el resto, rechazamos certificados inválidos
        return false;
      };
  }
}

SharedPreferences? prefs;

/// ---------------------------------------------------------
/// 2. FUNCIÓN MAIN
/// ---------------------------------------------------------
Future<void> main() async {
  // Asegura binding
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  // Configuración de Seguridad HTTP (Lista Blanca)
  // Leemos la variable ALLOW_INSECURE_HOSTS del .env
  final insecureHostsRaw = dotenv.env['ALLOW_INSECURE_HOSTS'] ?? '';
  final insecureHostsList = insecureHostsRaw
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  // Aplicamos el override personalizado
  HttpOverrides.global = SecureHttpOverrides(insecureHostsList);

  // Configuración de Orientación y UI
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Habilitar edge-to-edge (compatible con Android 15+)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  // Configurar barras del sistema transparentes
  // Nota: En Android 15+, estas configuraciones son manejadas por WindowCompat
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Inicializar Firebase
  // Usamos la variable importada desde firebase_config.dart
  await Firebase.initializeApp(options: firebaseOptionsFromEnv);

  // Configuración de Notificaciones
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await PushNotificationService.initializeapp();

  // Cargar preferencias y tema
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  prefs = await SharedPreferences.getInstance();

  // Arrancar la app
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

/// ---------------------------------------------------------
/// 3. WIDGETS DE LA APLICACIÓN
/// ---------------------------------------------------------

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
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
          ChangeNotifierProvider(create: (_) => FilesStateVeritify()),
          ChangeNotifierProvider(create: (_) => AppSessionState()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => Muserpol(savedThemeMode: savedThemeMode),
        ),
      ),
    );
  }
}

class Muserpol extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const Muserpol({super.key, this.savedThemeMode});

  @override
  State<Muserpol> createState() => _MuserpolState();
}

class _MuserpolState extends State<Muserpol> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    PushNotificationService.messagesStream.listen((message) {
      debugPrint('NO TI FI CA CION $message');
      final msg = json.decode(message);
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _updatebd();
  }

  void _updatebd() {
    Future.delayed(Duration.zero, () {
      final notificationBloc = BlocProvider.of<NotificationBloc>(context);
      DBProvider.db.getAllNotificationModel().then(
            (res) => notificationBloc.add(UpdateNotifications(res)),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: styleLigth(),
      dark: styleDark(),
      debugShowFloatingThemeButton: false,
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
        ),
        child: MaterialApp(
          localizationsDelegates: const [
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', 'ES'),
            Locale('en', 'US'),
          ],
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: theme,
          darkTheme: darkTheme,
          title: 'MUSERPOL PVT',
          initialRoute: 'check_auth',
          routes: {
            'check_auth': (_) => const CheckAuthScreen(),
            'slider': (_) => const PageSlider(),
            'newlogin': (_) => const ScreenNewLogin(),
            'contacts': (_) => const ScreenContact(),
            'message': (_) => const ScreenNotification(),
          },
        ),
      ),
    );
  }
}
