import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/io_client.dart';
import 'package:muserpol_pvt/dialogs/dialog_action.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:provider/provider.dart';

Future<dynamic> serviceMethod(
    BuildContext context,
    String method,
    Map<String, dynamic>? body,
    String urlAPI,
    bool accessToken,
    bool errorState) async {
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  if (accessToken) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.stateAuxToken) {
      headers["Authorization"] = "Bearer ${await authService.readAuxToken()}";
    } else {
      headers["Authorization"] = "Bearer ${await authService.readToken()}";
    }
  }

  try {
    var url = Uri.parse(urlAPI);
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('url $url');
      print('body $body');
      switch (method) {
        case 'get':
          return await http
              .get(url, headers: headers)
              .timeout(const Duration(seconds: 20))
              .then((value) {
            switch (value.statusCode) {
              case 200:
                return value;
              default:
                callDialogAction(context, json.decode(value.body)['message']);
                return null;
            }
          }).catchError((err) {
            callDialogAction(context, err);
            return null;
          });
        case 'post':
          return await http
              .post(url, headers: headers, body: json.encode(body))
              .timeout(const Duration(seconds: 40))
              .then((value) {
            switch (value.statusCode) {
              case 200:
                return value;
              default:
                if (errorState) {
                  callDialogAction(context, json.decode(value.body)['message']);
                }
                return null;
            }
          }).catchError((err) {
            callDialogAction(context, err);
            return null;
          });
      }
    }
  } on TimeoutException catch (e) {
    callDialogAction(context, '${e.message} ');
    return;
  } on SocketException catch (_) {
    return callDialogAction(context, 'Verifique su conexión a Internet');
  } catch (e) {
    callDialogAction(context, '${e} ');
    return;
  }
}
