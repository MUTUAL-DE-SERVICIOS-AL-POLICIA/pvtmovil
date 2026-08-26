import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppLog {
  static bool get _isProdEnv => (dotenv.env['STATE_PROD'] ?? 'false').toLowerCase() == 'true';

  // SEGURIDAD: Solo permite logs fuera de producción para evitar fuga de información sensible
  static void d(String message) {
    if (_isProdEnv) return;
    
    // Solo se imprime en modo debug o desarrollo
    debugPrint(message);
  }
}
