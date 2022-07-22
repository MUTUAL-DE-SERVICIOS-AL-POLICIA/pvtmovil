import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/main.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandle(RemoteMessage message) async {
    debugPrint('_backgroundHandle');
    //cuando el telefono esta bloqueado
    debugPrint('message ${json.encode(message.data)}');
    final notification = NotificationModel(
        title: message.data['title'],
        content: json.encode(message.data),
        read: false,
        date: DateTime.now(),
        selected: false);
    await DBProvider.db.newNotificationModel(notification);
    debugPrint('REGISTRADO');
    // _messageStream.add(message.data['type']);
    _messageStream.add(json.encode(message.data));
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    debugPrint('_onMessageHandler');
    message.data['origin'] = '_onMessageHandler';
    // _messageStream.add(message.data['type']);
    _messageStream.add(json.encode(message.data));
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    debugPrint('_onMessageOpenApp');
    //cuando abres la app por el mensaje
    _messageStream.add(json.encode(message.data));
  }

  static Future initializeapp() async {
    //push notifications
    await Firebase.initializeApp();
    await requestPermission();
    token = await FirebaseMessaging.instance.getToken();
    debugPrint('tokenNotification $token');
    prefs!.setString('tokenNotification', token!);

    //Handlers
    // FirebaseMessaging.onBackgroundMessage(
    // (message) => _backgroundHandle(context, message));
    FirebaseMessaging.onBackgroundMessage(_backgroundHandle);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  //apple web
  static requestPermission() async {
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

  static closeStreas() {
    _messageStream.close();
  }
}
