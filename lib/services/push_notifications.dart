import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:muserpol_pvt/main.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandle(RemoteMessage message) async {
    print('_backgroundHandle');
    _messageStream.add(message.data['type']);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('_onMessageHandler');

    // _messageStream.add(message.data['type']);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('_onMessageOpenApp');
    if (message.data['type'] == 'general') {
      _messageStream.add(json.encode(message.data));
    } else {
      _messageStream.add(message.data['type']);
    }
  }

  static Future initializeapp() async {
    //push notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('tokenNotification $token');
    prefs!.setString('tokenNotification', token!);

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandle);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //local notifications
  }

  static closeStreas() {
    _messageStream.close();
  }
}
