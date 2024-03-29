import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:muserpol_pvt/database/db_provider.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future initializeapp() async {
    //push notifications
    await Firebase.initializeApp();
    await requestPermission();
    token = await FirebaseMessaging.instance.getToken();
    debugPrint('tokenNotification $token');

    //cuando esta en segundo plano la app
    FirebaseMessaging.onBackgroundMessage(_backgroundHandle);
    //cuando esta en primer plano la app
    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) {})
        .onData((data) => _onMessageHandler(data));
    //cuando se abre la app desde la notificacion y la app esta en segundo plano pero no esta cerrado del todo
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    return token!;
  }

  static Future _backgroundHandle(RemoteMessage message) async {
    debugPrint('_backgroundHandle ${json.encode(message.data)}');
    final notification = NotificationModel(
        title: message.data['title'],
        content: json.encode(message.data),
        read: false,
        date: DateTime.now());
    await DBProvider.db.newNotificationModel(notification);
    debugPrint('REGISTRADO');
  }

  static _onMessageHandler(RemoteMessage data) async {
    debugPrint('data from stream: ${data.data}');
    final notification = NotificationModel(
        title: data.data['title'],
        content: json.encode(data.data),
        read: false,
        date: DateTime.now());
    await DBProvider.db.newNotificationModel(notification);
    debugPrint('REGISTRADO');
    data.data['origin'] = '_onMessageHandler';
    _messageStream.add(json.encode(data.data));
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    debugPrint('_onMessageOpenApp');
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

  static closeStreams() {
    _messageStream.close();
  }
}
