import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  Future login(
      BuildContext context, String token, Map<String, dynamic> data) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'data', value: json.encode(data));
    return;
  }

  Future auxtoken(String token) async {
    await storage.write(key: 'auxToken', value: token);
    return;
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'data');
    await storage.delete(key: 'auxToken');
    return;
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
}
