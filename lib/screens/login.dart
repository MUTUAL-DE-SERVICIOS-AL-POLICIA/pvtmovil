import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/input.dart';
import 'package:muserpol_pvt/components/susessful.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/dialogs/dialog_action.dart';
import 'package:muserpol_pvt/main.dart';
import 'package:muserpol_pvt/model/user_model.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/model_update_pwd.dart';
import 'package:muserpol_pvt/screens/modal_enrolled/modal.dart';
import 'package:muserpol_pvt/screens/navigator_bar.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/push_notifications.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ScreenLogin extends StatefulWidget {
  final String title;
  final bool stateOfficeVirtual;
  final String deviceId;
  const ScreenLogin({Key? key, required this.title, this.stateOfficeVirtual = true, required this.deviceId}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController dniCtrl = TextEditingController();
  TextEditingController dniComCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final deviceInfo = DeviceInfoPlugin();
  bool hidePassword = true;
  bool btnAccess = true;
  String dateCtrl = '';
  DateTime? dateTime;
  String? dateCtrlText;
  bool dateState = false;
  bool dniComplement = false;
  DateTime currentDate = DateTime(1950, 1, 1);
  FocusNode textSecondFocusNode = FocusNode();
  final tooltipController = JustTheController();
  bool stateCom = false;
  Map<String, dynamic> data = {};
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final node = FocusScope.of(context);
    return Scaffold(
        body: Column(children: [
      Expanded(
          child: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(children: [
              Image(
                image: AssetImage(
                  ThemeProvider.themeOf(context).id.contains('dark') ? 'assets/images/muserpol-logo.png' : 'assets/images/muserpol-logo2.png',
                ),
              ),
              Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20.h,
              ),
              if (btnAccess)
                Stack(children: [
                  Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cédula de identidad:'),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: InputComponent(
                                  textInputAction: TextInputAction.next,
                                  controllerText: dniCtrl,
                                  onEditingComplete: () => dniComplement ? node.nextFocus() : selectDate(context),
                                  validator: (value) {
                                    if (value.length > 3) {
                                      return null;
                                    } else {
                                      return 'Ingrese su cédula de indentidad';
                                    }
                                  },
                                  inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                  keyboardType: TextInputType.number,
                                  textCapitalization: TextCapitalization.characters,
                                  icon: Icons.person,
                                  labelText: "Cédula de indentidad",
                                ),
                              ),
                              if (dniComplement)
                                Text(
                                  '  _  ',
                                  style: TextStyle(fontSize: 15.sp, color: const Color(0xff419388)),
                                ),
                              if (dniComplement)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3.4,
                                  child: InputComponent(
                                    focusNode: textSecondFocusNode,
                                    textInputAction: TextInputAction.next,
                                    controllerText: dniComCtrl,
                                    inputFormatters: [LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
                                    onEditingComplete: () => selectDate(context),
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'complemento';
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.characters,
                                    icon: Icons.person,
                                    labelText: "Complemento",
                                  ),
                                ), //container
                            ], //widget
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          if (!widget.stateOfficeVirtual)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Fecha de nacimiento:'),
                                ButtonDate(text: dateCtrl, onPressed: () => selectDate(context)),
                                if (dateState)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      'Ingrese su fecha de nacimiento',
                                      style: TextStyle(color: Colors.red, fontSize: 15.sp),
                                    ),
                                  ),
                              ],
                            ),
                          if (widget.stateOfficeVirtual)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Contraseña:'),
                                InputComponent(
                                    textInputAction: TextInputAction.done,
                                    controllerText: passwordCtrl,
                                    onEditingComplete: () => initSession(),
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        if (value.length >= 4) {
                                          return null;
                                        } else {
                                          return 'Debe tener un mínimo de 4 caracteres.';
                                        }
                                      } else {
                                        return 'Ingrese su contraseña';
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    icon: Icons.lock,
                                    labelText: "Contraseña",
                                    obscureText: hidePassword,
                                    onTap: () => setState(() => hidePassword = !hidePassword),
                                    iconOnTap: hidePassword ? Icons.lock_outline : Icons.lock_open_sharp),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ButtonComponent(text: 'INGRESAR', onPressed: () => initSession()),
                          SizedBox(
                            height: 20.h,
                          ),
                          Center(
                            child:
                                ButtonWhiteComponent(text: 'Contactos a nivel nacional', onPressed: () => Navigator.pushNamed(context, 'contacts')),
                          ),
                          Center(
                            child: ButtonWhiteComponent(text: 'Política de privacidad', onPressed: () => privacyPolicy(context)),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                            child: Text('Versión ${dotenv.env['version']}'),
                          )
                        ],
                      )),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Buttontoltip(
                        tooltipController: tooltipController,
                        onPressed: (bool state) => functionToltip(state),
                      ))
                ]),
              if (!btnAccess)
                Center(
                    child: Image.asset(
                  'assets/images/load.gif',
                  fit: BoxFit.cover,
                  height: 20,
                )),
            ])),
      ))
    ]));
  }

  functionToltip(bool state) async {
    setState(() {
      if (!state) dniComCtrl.text = '';
      dniComplement = state;
      tooltipController.hideTooltip();
    });
  }

  privacyPolicy(BuildContext context) async {
    setState(() => btnAccess = false);

    var response = await serviceMethod(mounted, context, 'get', null, serviceGetPrivacyPolicy(), false, false);
    setState(() => btnAccess = true);
    if (response != null) {
      String pathFile = await saveFile('Documents', 'MUSERPOL_POLITICA_PRIVACIDAD.pdf', response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }

  Widget _buildDateTimePicker() {
    return SizedBox(
        height: 200,
        child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: currentDate,
            onDateTimeChanged: (DateTime newDataTime) {
              debugPrint('date $newDataTime');
              setState(() {
                currentDate = newDataTime;
                dateCtrl = DateFormat(' dd, MMMM yyyy ', "es_ES").format(newDataTime);
                dateState = false;
              });
            }));
  }

  selectDate(BuildContext context) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[_buildDateTimePicker()],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Elegir'),
              onPressed: () {
                setState(() {
                  dateCtrl = DateFormat(' dd, MMMM yyyy ', "es_ES").format(currentDate);
                  dateCtrlText = DateFormat('dd-MM-yyyy').format(currentDate);
                });
                Navigator.of(context, rootNavigator: true).pop("Discard");
                FocusScope.of(context).unfocus();
              },
            ),
          );
        });
  }

  initSession() async {
    FocusScope.of(context).unfocus();
    if (!widget.stateOfficeVirtual) validateDate();
    if (formKey.currentState!.validate()) {
      final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final appState = Provider.of<AppState>(context, listen: false);
      if (dateCtrlText == null && !widget.stateOfficeVirtual) return;
      setState(() => btnAccess = false);
      if (await InternetConnectionChecker().connectionStatus == InternetConnectionStatus.disconnected) {
        setState(() => btnAccess = true);
        // return callDialogAction(context, 'Verifique su conexión a Internet');
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => const DialogAction(message: 'Verifique su conexión a Internet'));
      }
      await checkVersion(mounted, context);
      
      data['device_id'] = widget.deviceId;
      data['firebase_token'] = await PushNotificationService.getTokenFirebase();
      if (!widget.stateOfficeVirtual) {
        data['identity_card'] = '${dniCtrl.text.trim()}${dniComCtrl.text == '' ? '' : '-${dniComCtrl.text.trim()}'}';
        data['birth_date'] = dateCtrlText;
        data['is_new_app'] = true;
      } else {
        data['username'] = '${dniCtrl.text.trim()}${dniComCtrl.text == '' ? '' : '-${dniComCtrl.text.trim()}'}';
        data['password'] = passwordCtrl.text.trim();
      }
      if (!mounted) return;
      var response = await serviceMethod(
          mounted, context, 'post', data, widget.stateOfficeVirtual ? serviceAuthSessionOF() : serviceAuthSession(null), false, true);
      setState(() => btnAccess = true);
      if (response != null) {
        await DBProvider.db.database;
        if (!widget.stateOfficeVirtual) {
          UserModel user = userModelFromJson(json.encode(json.decode(response.body)['data']));
          await authService.auxtoken(user.apiToken!);
          appState.updateStateAuxToken(true);
          userBloc.add(UpdateUser(user.user!));
          if (!mounted) return;
          await authService.user(context, json.encode(json.decode(response.body)['data']));
          prefs!.setInt('idAffiliate', json.decode(response.body)['data']['user']['id']);
          //add words validations for files
          // files.addKey('cianverso', dniCtrl.text.trim()); //num carnet
          // files.addKey('cireverso', dniCtrl.text.trim()); //num carnet
          // files.addKey('cireverso',
          //     '${response.data['data']['user']['full_name']}'); //nombre
          // await Permission.storage.request();
          // await Permission.manageExternalStorage.request();
          // await Permission.accessMediaLocation.request();
          if (!mounted) return;
          await authService.stateApp(context, 'complement');
          if (!json.decode(response.body)['data']['user']['enrolled']) {
            _showModalInside(user.apiToken!, data);
          } else {
            if (!mounted) return;
            await authService.login(context, user.apiToken!, data);

            appState.updateStateAuxToken(false);
            if (!mounted) return;
            return Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const NavigatorBar(stateApp: 'complement'), transitionDuration: const Duration(seconds: 0)));
          }
        } else {
          switch (json.decode(response.body)['data']['status']) {
            case 'Pendiente':
              return virtualOfficineUpdatePwd(json.decode(response.body)['message']);
            case 'Activo':
              if (!mounted) return;
              await authService.login(context, json.decode(response.body)['data']['user']['api_token'], data);
              if (!mounted) return;
              await authService.stateApp(context, 'virtualofficine');
              prefs!.setInt('idAffiliate', json.decode(response.body)['data']['user']['affiliate_id']);
              if (!mounted) return;
              return Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const NavigatorBar(tutorial: false, stateApp: 'virtualofficine'),
                      transitionDuration: const Duration(seconds: 0)));
          }
        }
      }
    }
  }

  virtualOfficineUpdatePwd(String message) {
    return showBarModalBottomSheet(
      expand: false,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (context) => ModalUpdatePwd(
          message: message,
          onPressed: (password) async {
            data['new_password'] = password;
            var response = await serviceMethod(mounted, context, 'patch', data, serviceChangePasswordOF(), false, true);
            if (response != null) {
              if (!mounted) return;
              return showSuccessful(context, json.decode(response.body)['message'], () {
                debugPrint('res ${response.body}');
                setState(() => passwordCtrl.text = '');
                Navigator.of(context).pop();
              });
            }
          }),
    );
  }

  _showModalInside(String token, Map<String, dynamic> data) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 50));
    return showBarModalBottomSheet(
      expand: false,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (context) => ModalInsideModal(nextScreen: (message) {
        return showSuccessful(context, message, () async {
          await authService.login(context, token, data);
          appState.updateStateAuxToken(false);
          if (!mounted) return;
           Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const NavigatorBar(stateApp: 'complement'), transitionDuration: const Duration(seconds: 0)));
        });
      }),
    );
  }

  validateDate() {
    if (dateCtrlText == null) return setState(() => dateState = true);
    return setState(() => dateState = false);
  }
}
