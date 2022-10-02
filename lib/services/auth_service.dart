import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  Future biometric(BuildContext context, String value) async {
    await storage.write(key: 'biometric', value: value);
  }

  Future writeStateApp(BuildContext context, String value) async {
    await storage.write(key: 'stateApp', value: value);
    return;
  }

  Future user(BuildContext context, String value) async {
    await storage.write(key: 'user', value: value);
    return;
  }

  Future login(BuildContext context, String token, Map<String, dynamic> data) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'data', value: json.encode(data));
    return;
  }

  Future auxtoken(String token) async {
    await storage.write(key: 'auxToken', value: token);
    return;
  }

  Future logout() async {
    await storage.delete(key: 'user');
    await storage.delete(key: 'token');
    await storage.delete(key: 'data');
    await storage.delete(key: 'auxToken');
    await storage.delete(key: 'stateApp');

    return;
  }

  Future<String> readStateApp() async {
    return await storage.read(key: 'stateApp') ?? '';
  }

  Future<String> readUser() async {
    return await storage.read(key: 'user') ?? '';
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readAuxToken() async {
    return await storage.read(key: 'auxToken') ?? '';
  }

  Future<String> readData() async {
    return await storage.read(key: 'data') ?? '';
  }

  Future firstTime(BuildContext context) async {
    await storage.write(key: 'firstTime', value: 'true');
    return;
  }

  Future initialFirebase(BuildContext context) async {
    await storage.write(key: 'firebase', value: 'true');
    return;
  }

  Future<String> readFirstTime() async {
    return await storage.read(key: 'firstTime') ?? '';
  }

  Future<String> readInitialFirebase() async {
    return await storage.read(key: 'firebase') ?? '';
  }

  Future<String> readBiometric() async {
    return await storage.read(key: 'biometric') ?? '';
  }
}
