import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de autenticación y almacenamiento seguro
/// Usa flutter_secure_storage con AES-GCM EXCLUSIVAMENTE (sin CBC)
/// Configuración forzada para evitar vulnerabilidades de padding oracle
class AuthService extends ChangeNotifier {
  
  /// Instancia de flutter_secure_storage con AES-GCM forzado
  /// IMPORTANTE: Usa SOLO AES-GCM, nunca CBC
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      // Forzar AES-GCM explícitamente (sin CBC)
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
  );

  /// Método privado para obtener la instancia de SharedPreferences
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Guarda el token principal de sesión, asociado a la versión actual
  Future<void> writeToken(BuildContext context, String token) async {
    await _secureStorage.write(
      key: 'tokenv${dotenv.env['version']}',
      value: token,
    );
  }

  /// Recupera el token principal de sesión
  Future<String> readToken() async {
    final token = await _secureStorage.read(key: 'tokenv${dotenv.env['version']}');
    return token ?? '';
  }

  /// Guarda un token auxiliar, por ejemplo usado temporalmente antes de iniciar sesión completa
  Future<void> writeAuxtoken(String token) async {
    await _secureStorage.write(key: 'auxToken', value: token);
  }

  /// Recupera el token auxiliar
  Future<String> readAuxToken() async {
    final token = await _secureStorage.read(key: 'auxToken');
    return token ?? '';
  }

  /// Guarda los datos del usuario autenticado (en formato JSON)
  Future<void> writeUser(BuildContext context, String value) async {
    await _secureStorage.write(key: 'user', value: value);
  }

  /// Recupera los datos del usuario (en formato JSON)
  Future<String> readUser() async {
    final user = await _secureStorage.read(key: 'user');
    return user ?? '';
  }

  /// Guarda el identificador único del dispositivo
  Future<void> writeDeviceId(String deviceId) async {
    await _secureStorage.write(key: 'device_id', value: deviceId);
  }

  /// Recupera el identificador único del dispositivo
  Future<String> readDeviceId() async {
    final deviceId = await _secureStorage.read(key: 'device_id');
    return deviceId ?? '';
  }

  /// Elimina los datos de autenticación biométrica
  Future<void> deleteBiometric() async {
    await _secureStorage.delete(key: 'biometric');
  }

  /// Elimina los datos de sesión al cerrar sesión del usuario
  Future<void> logout() async {
    await _secureStorage.delete(key: 'user');
    await _secureStorage.delete(key: 'tokenv${dotenv.env['version']}');
    await _secureStorage.delete(key: 'auxToken');
    await _secureStorage.delete(key: 'device_id');
  }

  /// Borra absolutamente todo el contenido del almacenamiento seguro y persistente
  /// Útil para depuración o reinicio completo de sesión
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  /// Lee si es la primera vez que se abre la app
  Future<String> readFirstTime() async {
    final prefs = await _getPrefs();
    return prefs.getString('firstTime') ?? '';
  }

  /// Guarda si el usuario tiene activada la autenticación biométrica
  Future<void> writeBiometric(BuildContext context, String value) async {
    await _secureStorage.write(key: 'biometric', value: value);
  }

  /// Lee si la autenticación biométrica está activada
  Future<String> readBiometric() async {
    final biometric = await _secureStorage.read(key: 'biometric');
    return biometric ?? '';
  }

  /// Guarda si es la primera vez que se abre la app (ej. para mostrar onboarding)
  Future<void> writeFirstTime(BuildContext context) async {
    final prefs = await _getPrefs();
    await prefs.setString('firstTime', 'true');
  }
}

