import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/firebase_options.dart'; // IMPORTAMOS NUESTRA CONFIG
import 'package:flutter_dotenv/flutter_dotenv.dart'; // NECESARIO PARA CARGAR .ENV

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future initializeapp() async {
    // No es necesario inicializar Firebase aquí si ya se hizo en main,
    // pero si lo necesitas por seguridad, asegúrate de que main ya haya corrido.
    // Generalmente se quita esta inicialización si main.dart lo hace primero.

    await requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance.getToken().then((v) {}).catchError((err) {
      debugPrint('error $err');
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundHandle);

    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) {})
        .onData((data) => _onMessageHandler(data));

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandle(RemoteMessage message) async {
    // 1. Inicializar bindings (necesario para plugins y dotenv)
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Cargar variables de entorno (ES CLAVE EN BACKGROUND ISOLATE)
    await dotenv.load(fileName: ".env");

    // 3. Inicializar Firebase con nuestras opciones dinámicas
    await Firebase.initializeApp(options: firebaseOptionsFromEnv);

    debugPrint('_backgroundHandle ${json.encode(message.data)}');
    final affiliateId = await DBProvider.db.getAffiliateModelById();
    final notification = NotificationModel(
        title: message.data['title'],
        idAffiliate: affiliateId,
        content: json.encode(message.data),
        read: false,
        date: DateTime.now());

    await DBProvider.db.newNotificationModel(notification);
    debugPrint('REGISTRADO');
  }

  static _onMessageHandler(RemoteMessage message) async {
    debugPrint('_onMessageHandler ${message.data}');
    final affiliateId = await DBProvider.db.getAffiliateModelById();
    final notification = NotificationModel(
        title: message.data['title'],
        idAffiliate: affiliateId,
        content: json.encode(message.data),
        read: false,
        date: DateTime.now());
    await DBProvider.db.newNotificationModel(notification);
    debugPrint('REGISTRADO');
    message.data['origin'] = '_onMessageHandler';
    _messageStream.add(json.encode(message.data));
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    debugPrint('_onMessageOpenApp');
    debugPrint(message.data.toString());
    _messageStream.add(json.encode(message.data));
  }

  static requestPermission() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        badge: true, alert: true, sound: true);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() async {
    // _messageStream.close();
  }

  static Future getTokenFirebase() async {
    return await FirebaseMessaging.instance.getToken();
  }
}

// Función top-level para el handler de background (definida fuera de la clase)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 1. Inicializar bindings
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Cargar .env
  await dotenv.load(fileName: ".env");

  // 3. Inicializar Firebase usando la config del archivo auxiliar
  try {
    await Firebase.initializeApp(
      options: firebaseOptionsFromEnv,
    );

    debugPrint('_backgroundHandle ${json.encode(message.data)}');

    final affiliateId = await DBProvider.db.getAffiliateModelById();
    final notification = NotificationModel(
      title: message.data['title'],
      idAffiliate: affiliateId,
      content: json.encode(message.data),
      read: false,
      date: DateTime.now(),
    );
    await DBProvider.db.newNotificationModel(notification);
    debugPrint('REGISTRADO');
  } catch (e, st) {
    debugPrint('BG handler error: $e\n$st');
  }
}
