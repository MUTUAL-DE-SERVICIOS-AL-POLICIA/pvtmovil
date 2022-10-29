// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/identity_card.dart';
import 'package:muserpol_pvt/components/input.dart';
import 'package:muserpol_pvt/components/susessful.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/main.dart';
import 'package:muserpol_pvt/model/biometric_user_model.dart';
import 'package:muserpol_pvt/model/user_model.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/model_update_pwd.dart';
import 'package:muserpol_pvt/screens/modal_enrolled/modal.dart';
import 'package:muserpol_pvt/screens/navigator_bar.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/push_notifications.dart';
// import 'package:muserpol_pvt/services/push_notifications.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

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
  Map<String, dynamic> body = {};

  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    verifyBiometric();
  }

  verifyBiometric() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    debugPrint('${widget.stateOfficeVirtual}');
    if (await authService.readBiometric() != "") {
      debugPrint('state ${widget.stateOfficeVirtual}');
      if (widget.stateOfficeVirtual) {
        if (biometricUserModelFromJson(await authService.readBiometric()).biometricVirtualOfficine!) {
          //BIOMETICO OFICINA VIRTUAL
          _authenticate();
        }
      } else {
        debugPrint('${biometricUserModelFromJson(await authService.readBiometric()).biometricComplement}');
        if (biometricUserModelFromJson(await authService.readBiometric()).biometricComplement!) {
          //BIOMETICO COMPLEMENTO
          _authenticate();
        }
      }
    }
  }

  Future<void> _authenticate() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'MUSERPOL',
        authMessages: [
          const AndroidAuthMessages(
            signInTitle: 'Autenticación Biometrica requerida',
            cancelButton: 'No Gracias',
            biometricHint: 'Verificar Identidad',
          ),
          const IOSAuthMessages(
            cancelButton: 'No Gracias',
          ),
        ],
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      debugPrint('HECHO');
    } on PlatformException catch (e) {
      debugPrint('$e');
      return;
    }
    if (!mounted) {
      return;
    }
    if (authenticated) {
      final biometric = biometricUserModelFromJson(await authService.readBiometric());
      if (widget.stateOfficeVirtual) {
        setState(() {
          dniCtrl.text = biometric.userVirtualOfficine!.identityCard!;
          passwordCtrl.text = biometric.userVirtualOfficine!.password!;
        });
      } else {
        setState(() {
          dniCtrl.text = biometric.userComplement!.identityCard!;
          dateCtrlText = biometric.userComplement!.dateBirth!;
          dateCtrl = biometric.userComplement!.dateBirth!;
        });
      }
      initSession();
    }
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
              Hero(
                  tag: 'image',
                  child: Image(
                    image: AssetImage(
                      ThemeProvider.themeOf(context).id.contains('dark') ? 'assets/images/muserpol-logo.png' : 'assets/images/muserpol-logo2.png',
                    ),
                  )),
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
                          IdentityCard(
                              dniComplement: dniComplement,
                              dniCtrl: dniCtrl,
                              dniComCtrl: dniComCtrl,
                              node: node,
                              selectDate: (context) => selectDate(context),
                              textSecondFocusNode: textSecondFocusNode),
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
                              child: ButtonWhiteComponent(
                                  text: 'Contactos a nivel nacional', onPressed: () => Navigator.pushNamed(context, 'contacts'))),
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
              setState(() {
                currentDate = newDataTime;
                dateCtrl = DateFormat(' dd, MMMM yyyy ', "es_ES").format(newDataTime);
                dateState = false;
                dateCtrlText = DateFormat('dd-MM-yyyy').format(currentDate);
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
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    final notificationBloc = BlocProvider.of<NotificationBloc>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final tokenState = Provider.of<TokenState>(context, listen: false);
    FocusScope.of(context).unfocus();
    if (!widget.stateOfficeVirtual) validateDate();
    if (formKey.currentState!.validate()) {
      if (dateCtrlText == null && !widget.stateOfficeVirtual) return;
      setState(() => btnAccess = false);
      if (await checkVersion(mounted, context)) {
        body['device_id'] = widget.deviceId;
        // body['firebase_token'] = await PushNotificationService.getTokenFirebase();
        body['firebase_token'] = '';
        if (!widget.stateOfficeVirtual) {
          body['identity_card'] = '${dniCtrl.text.trim()}${dniComCtrl.text == '' ? '' : '-${dniComCtrl.text.trim()}'}';
          body['birth_date'] = dateCtrlText;
          body['is_new_app'] = true;
          body['is_new_version'] = true;
        } else {
          body['username'] = '${dniCtrl.text.trim()}${dniComCtrl.text == '' ? '' : '-${dniComCtrl.text.trim()}'}';
          body['password'] = passwordCtrl.text.trim();
        }
        if (!mounted) return;
        var response = await serviceMethod(
            mounted, context, 'post', body, widget.stateOfficeVirtual ? serviceAuthSessionOF() : serviceAuthSession(null), false, true);
        setState(() => btnAccess = true);
        if (response != null) {
          await DBProvider.db.database;
          if (json.decode(response.body)['data']['status'] != null && json.decode(response.body)['data']['status'] == 'Pendiente') {
            return virtualOfficineUpdatePwd(json.decode(response.body)['message']);
          }
          UserModel user = userModelFromJson(json.encode(json.decode(response.body)['data']));
          await authService.writeAuxtoken(user.apiToken!);
          tokenState.updateStateAuxToken(true);
          if (!mounted) return;
          await authService.writeUser(context, userModelToJson(user));
          userBloc.add(UpdateUser(user.user!));
          final affiliateModel = AffiliateModel(idAffiliate: user.user!.id!);
          await DBProvider.db.newAffiliateModel(affiliateModel);
          notificationBloc.add(UpdateAffiliateId(user.user!.id!));
          if (widget.stateOfficeVirtual) {
            initSessionVirtualOfficine(response, UserVirtualOfficine(identityCard: body['username'], password: body['password']), user);
          } else {
            intSessionComplement(response, UserComplement(identityCard: body['identity_card'], dateBirth: body['birth_date']), user);
          }
        }
      }else{
        setState(() => btnAccess = true);
      }
    }
  }

  intSessionComplement(dynamic response, UserComplement userComplement, UserModel user) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final tokenState = Provider.of<TokenState>(context, listen: false);
    final biometric = await authService.readBiometric();
    final biometricUserModel = BiometricUserModel(
        biometricComplement: biometric == '' ? false : biometricUserModelFromJson(biometric).biometricComplement,
        biometricVirtualOfficine: biometric == '' ? false : biometricUserModelFromJson(biometric).biometricVirtualOfficine,
        affiliateId: user.user!.id,
        userComplement: userComplement,
        userVirtualOfficine: biometric == '' ? UserVirtualOfficine() : biometricUserModelFromJson(biometric).userVirtualOfficine);
    if (!mounted) return;
    await authService.writeBiometric(context, biometricUserModelToJson(biometricUserModel));
    prefs!.setBool('isDoblePerception', json.decode(response.body)['data']['is_doble_perception']);
    if (response.statusCode == 200) {
      if (!user.user!.enrolled!) {
        //proceso de enrolamiento
        // _showModalInside(user.apiToken!, false, await PushNotificationService.getTokenFirebase());
        _showModalInside(user.apiToken!, false, '');
      } else {
        if (!mounted) return;
        await authService.writeStateApp(context, 'complement');
        if (!mounted) return;
        await authService.writeToken(context, user.apiToken!);
        tokenState.updateStateAuxToken(false);
        if (!mounted) return;
        return Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => const NavigatorBar(stateApp: 'complement'), transitionDuration: const Duration(seconds: 0)));
      }
    } else {
      if (json.decode(response.body)['data']['update_device_id']) {
        //reconocimiento facial
        // return _showModalInside(user.apiToken!, true, await PushNotificationService.getTokenFirebase());
        return _showModalInside(user.apiToken!, true, '');
      } else {
        if (!mounted) return;
        return callDialogAction(context, json.decode(response.body)['message']);
      }
    }
  }

  _showModalInside(String token, bool facialRecognition, String firebaseToken) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final tokenState = Provider.of<TokenState>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 50));
    return showBarModalBottomSheet(
      expand: false,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (context) => ModalInsideModal(
          firebaseToken: firebaseToken,
          deviceId: widget.deviceId,
          stateFacialRecognition: facialRecognition,
          nextScreen: (message) {
            return showSuccessful(context, message, () async {
              if (!mounted) return;
              await authService.writeStateApp(context, 'complement');
              if (!mounted) return;
              await authService.writeToken(context, token);
              tokenState.updateStateAuxToken(false);
              if (!mounted) return;
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const NavigatorBar(stateApp: 'complement'), transitionDuration: const Duration(seconds: 0)));
            });
          }),
    );
  }

  initSessionVirtualOfficine(dynamic response, UserVirtualOfficine userVirtualOfficine, UserModel user) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final tokenState = Provider.of<TokenState>(context, listen: false);
    tokenState.updateStateAuxToken(false);
    final biometric = await authService.readBiometric();
    final biometricUserModel = BiometricUserModel(
        biometricVirtualOfficine: biometric == '' ? false : biometricUserModelFromJson(biometric).biometricVirtualOfficine,
        biometricComplement: biometric == '' ? false : biometricUserModelFromJson(biometric).biometricComplement,
        affiliateId: json.decode(response.body)['data']['user']['id'],
        userComplement: biometric == '' ? UserComplement() : biometricUserModelFromJson(biometric).userComplement,
        userVirtualOfficine: userVirtualOfficine);
    if (!mounted) return;
    await authService.writeBiometric(context, biometricUserModelToJson(biometricUserModel));
    if (!mounted) return;
    await authService.writeStateApp(context, 'virtualofficine');
    if (!mounted) return;
    await authService.writeToken(context, user.apiToken!);
    tokenState.updateStateAuxToken(false);
    if (!mounted) return;
    return Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => const NavigatorBar(stateApp: 'virtualofficine'), transitionDuration: const Duration(seconds: 0)));
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
            body['new_password'] = password;
            var response = await serviceMethod(mounted, context, 'patch', body, serviceChangePasswordOF(), false, true);
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

  validateDate() {
    if (dateCtrlText == null) return setState(() => dateState = true);
    return setState(() => dateState = false);
  }
}
