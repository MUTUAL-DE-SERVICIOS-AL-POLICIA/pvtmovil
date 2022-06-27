import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/dialogs/dialog_action.dart';
import 'package:muserpol_pvt/main.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:new_version/new_version.dart';

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
  if (await InternetConnectionChecker().connectionStatus ==
      await InternetConnectionStatus.disconnected) {
    return callDialogAction(context, 'Verifique su conexión a Internet');
  }
  try {
    var url = Uri.parse(urlAPI);
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    print('url $url');
    print('body $body');
    switch (method) {
      case 'get':
        return await http
            .get(url, headers: headers)
            .timeout(const Duration(seconds: 40))
            .then((value) {
          print('statusCode ${value.statusCode}');
          print('value ${value.body}');
          switch (value.statusCode) {
            case 200:
              return value;
            default:
              if (errorState) {
                return confirmDeleteSession(context);
                // callDialogAction(
                //     context, json.decode(value.body)['message']);
              }
              return null;
          }
        }).catchError((err) {
          print('errA $err');
          if ('$err'.contains('html')) {
            callDialogAction(context,
                'Tenemos un problema con nuestro servidor, intente luego');
          } else if ('$err' == 'Software caused connection abort') {
            callDialogAction(context, 'Verifique su conexión a Internet');
          } else {
            callDialogAction(
                context, 'Lamentamos los inconvenientes, intentalo de nuevo');
          }
          return null;
        });
      case 'post':
        return await http
            .post(url, headers: headers, body: json.encode(body))
            .timeout(const Duration(seconds: 40))
            .then((value) {
          print('statusCode ${value.statusCode}');
          print('value ${value.body}');
          switch (value.statusCode) {
            case 200:
              return value;
            default:
              callDialogAction(context, json.decode(value.body)['message']);
              return null;
          }
        }).catchError((err) {
          print('errA $err');
          if ('$err'.contains('html')) {
            callDialogAction(context,
                'Tenemos un problema con nuestro servidor, intente luego');
          } else if ('$err' == 'Software caused connection abort') {
            callDialogAction(context, 'Verifique su conexión a Internet');
          } else {
            callDialogAction(
                context, 'Lamentamos los inconvenientes, intentalo de nuevo');
          }
          return null;
        });
    }
  } on TimeoutException catch (e) {
    print('errB $e');
    return callDialogAction(
        context, 'Tenemos un problema con nuestro servidor, intente luego');
  } on SocketException catch (e) {
    print('errC $e');
    return callDialogAction(context, 'Verifique su conexión a Internet');
  } on ClientException catch (e) {
    print('errD $e');
    return callDialogAction(context, 'Verifique su conexión a Internet');
  } on MissingPluginException catch (e) {
    print('errF $e');
    return callDialogAction(context, 'Verifique su conexión a Internet');
  } catch (e) {
    print('errG $e');
    return callDialogAction(context, '$e');
  }
}

confirmDeleteSession(BuildContext context) async {
  final procedureBloc = BlocProvider.of<ProcedureBloc>(context, listen: false);
  final authService = Provider.of<AuthService>(context, listen: false);
  final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
  final appState = Provider.of<AppState>(context, listen: false);
  // var response = await serviceMethod( context, 'delete', null, serviceAuthSession(), true);
  // if ( response != null ) {
  prefs!.getKeys();
  for (String key in prefs!.getKeys()) {
    prefs!.remove(key);
  }
  for (var element in appState.files) {
    appState.updateFile(element.id!, null);
  }
  userBloc.add(UpdateCtrlLive(false));
  var appDir = (await getTemporaryDirectory()).path;
  new Directory(appDir).delete(recursive: true);
  authService.logout();
  procedureBloc.add(ClearProcedures());
  appState.updateTabProcedure(0);
  appState.updateStateProcessing(false);
  Navigator.pushReplacementNamed(context, 'login');
  // }
}

checkVersion(BuildContext context) async {
  if (await InternetConnectionChecker().connectionStatus ==
      await InternetConnectionStatus.disconnected) {
    return callDialogAction(context, 'Verifique su conexión a Internet');
  }
  final newVersion = NewVersion(
    iOSId: 'com.muserpol.pvt',
    androidId: "com.muserpol.pvt",
  );
  final status = await newVersion.getVersionStatus();
  print('status $status' );
  if (status != null) {
    if (status.localVersion == status.storeVersion) return;
    return newVersion.showUpdateDialog(
      context: context,
      allowDismissal: false,
      versionStatus: status,
      dialogTitle: "Actualiza la nueva versión",
      dialogText:
          "Para mejorar la experiencia, Porfavor actualiza la nueva versión",
      updateButtonText: "Actualizar",
    );
  }
}
