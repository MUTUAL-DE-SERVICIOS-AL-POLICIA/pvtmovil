import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Obtiene las opciones de Firebase desde el archivo .env
/// dependiendo de la plataforma actual.
FirebaseOptions get firebaseOptionsFromEnv {
  // Variables comunes
  final projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  final messagingSenderId = dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  final storageBucket = dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  if (kIsWeb) {
    return FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_WEB_API_KEY'] ?? '',
      appId: dotenv.env['FIREBASE_WEB_APP_ID'] ?? '',
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket,
      authDomain: dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'],
      measurementId: dotenv.env['FIREBASE_WEB_MEASUREMENT_ID'],
    );
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? '',
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
      );
    case TargetPlatform.iOS:
      return FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_IOS_APP_ID'] ?? '',
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
        iosClientId: dotenv.env['FIREBASE_IOS_CLIENT_ID'],
        iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'],
        androidClientId: dotenv.env['FIREBASE_IOS_ANDROID_CLIENT_ID'],
      );
    case TargetPlatform.macOS:
      return FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_MACOS_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_MACOS_APP_ID'] ?? '',
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
        iosClientId: dotenv.env['FIREBASE_MACOS_CLIENT_ID'],
        iosBundleId: dotenv.env['FIREBASE_MACOS_BUNDLE_ID'],
        androidClientId: dotenv.env['FIREBASE_IOS_ANDROID_CLIENT_ID'],
      );
    default:
      throw UnsupportedError('Plataforma no soportada');
  }
}
