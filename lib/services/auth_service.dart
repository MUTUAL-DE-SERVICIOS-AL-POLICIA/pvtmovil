import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  Future writeBiometric(BuildContext context, String value) async {
    await storage.write(key: 'biometric', value: value);
  }

  Future writeStateApp(BuildContext context, String value) async {
    await storage.write(key: 'stateApp', value: value);
    return;
  }

  Future writeUser(BuildContext context, String value) async {
    await storage.write(key: 'user', value: value);
    return;
  }

  Future writeToken(BuildContext context, String token) async {
    await storage.write(key: 'tokenv2.2.0', value: token);
    return;
  }

  Future writeAuxtoken(String token) async {
    await storage.write(key: 'auxToken', value: token);
    return;
  }

  Future writeFirstTime(BuildContext context) async {
    await storage.write(key: 'firstTime', value: 'true');
    return;
  }

  Future logout() async {
    await storage.delete(key: 'user');
    await storage.delete(key: 'tokenRegister');
    await storage.delete(key: 'auxToken');
    await storage.delete(key: 'stateApp');

    return;
  }

  Future<String> readBiometric() async {
    return await storage.read(key: 'biometric') ?? '';
  }

  Future<String> readStateApp() async {
    return await storage.read(key: 'stateApp') ?? '';
  }

  Future<String> readUser() async {
    return await storage.read(key: 'user') ?? '';
  }

  Future<String> readToken() async {
    return await storage.read(key: 'tokenv2.2.0') ?? '';
  }

  Future<String> readAuxToken() async {
    return await storage.read(key: 'auxToken') ?? '';
  }

  Future<String> readFirstTime() async {
    return await storage.read(key: 'firstTime') ?? '';
  }
}
