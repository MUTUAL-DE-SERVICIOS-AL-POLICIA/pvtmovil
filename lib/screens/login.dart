import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/input.dart';
import 'package:muserpol_pvt/components/susessful.dart';
import 'package:muserpol_pvt/dialogs/dialog_back.dart';
import 'package:muserpol_pvt/main.dart';
import 'package:muserpol_pvt/model/user_model.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/modal_enrolled/modal.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController dniCtrl = TextEditingController();
  TextEditingController dniComCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool btnAccess = true;
  String dateCtrl = '';
  String? deviceId;
  String? dateCtrlText;
  bool dateState = false;
  bool dniComplement = false;
  DateTime currentDate = DateTime(1950, 1, 1);
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  FocusNode textSecondFocusNode = FocusNode();

  bool stateCom = false;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    initPlatformState();

    dniCtrl.addListener(() {
      if (dniCtrl.text == '') return;
      var text = dniCtrl.text.replaceAll(RegExp("[0-9]"), "");
      if (text != '') {
        setState(() {
          dniComplement = true;
        });

        Future.delayed(const Duration(milliseconds: 30), () {
          FocusScope.of(context).requestFocus(textSecondFocusNode);
          setState(() {
            dniCtrl.text = dniCtrl.text.replaceAll(RegExp("[-]"), "");
            dniCtrl.text = dniCtrl.text.replaceAll(RegExp("[.]"), "");
          });
        });
      }
    });
    dniComCtrl.addListener(() {
      if (dniComCtrl.text != '') {
        setState(() => stateCom = true);
      }
      if (stateCom) {
        if (dniComCtrl.text == '') {
          setState(() => dniComplement = false);
        }
      }
    });
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
      if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;
    setState(() => deviceId = deviceData['androidId']);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'androidId': build.androidId,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final node = FocusScope.of(context);
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Center(
                    child: SingleChildScrollView(
                        child: Column(children: [
                  Image(
                    image: AssetImage(
                      ThemeProvider.themeOf(context).id.contains('dark')
                          ? 'assets/images/muserpol-logo.png'
                          : 'assets/images/muserpol-logo2.png',
                    ),
                  ),
                  const Text('Plataforma Virtual de trámites',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 50),
                  if (btnAccess)
                    Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cédula de identidad:'),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: InputComponent(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.sp,
                                        color: const Color(0xff419388)),
                                    textInputAction: TextInputAction.next,
                                    controllerText: dniCtrl,
                                    onEditingComplete: () => node.nextFocus(),
                                    validator: (value) {
                                      if (value.length > 3) {
                                        return null;
                                      } else {
                                        return 'Ingrese su cédula de indentidad';
                                      }
                                    },
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9-.]"))
                                    ],
                                    keyboardType: TextInputType.number,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    icon: Icons.person,
                                    labelText: "Cédula de indentidad",
                                  ),
                                ),
                                if (dniComplement)
                                  Text(
                                    '  _  ',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: const Color(0xff419388)),
                                  ),
                                if (dniComplement)
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3.4,
                                    child: RawKeyboardListener(
                                        focusNode: FocusNode(),
                                        onKey: (event) {
                                          if (event.logicalKey ==
                                              LogicalKeyboardKey.backspace) {
                                            setState(
                                                () => dniComplement = false);
                                          }
                                        },
                                        child: InputComponent(
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.sp,
                                              color: const Color(0xff419388)),
                                          focusNode: textSecondFocusNode,
                                          textInputAction: TextInputAction.next,
                                          controllerText: dniComCtrl,
                                          inputFormatters: [
                                            new LengthLimitingTextInputFormatter(
                                                2),
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9a-zA-Z]"))
                                          ],
                                          onEditingComplete: () =>
                                              node.nextFocus(),
                                          validator: (value) {
                                            if (value.isNotEmpty) {
                                              return null;
                                            } else {
                                              return 'complemento';
                                            }
                                          },
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          icon: Icons.person,
                                          labelText: "Complemento",
                                        )),
                                  ), //container
                              ], //widget
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text('Fecha de nacimiento:'),
                            ButtonDate(
                                text: dateCtrl, onPressed: () => selectDate()),
                            if (dateState)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Ingrese su fecha de nacimiento',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15.sp),
                                ),
                              ),
                            SizedBox(
                              height: 20.h,
                            ),
                            ButtonComponent(
                                text: 'INGRESAR',
                                onPressed: () => initSession()),
                            ButtonWhiteComponent(
                                text: 'Contactos a nivel nacional',
                                onPressed: () => contacts()),
                            ButtonWhiteComponent(
                                text: 'Política de privacidad',
                                onPressed: () => privacyPolicy(context))
                          ],
                        )),
                  if (!btnAccess)
                    Center(
                        child: Image.asset(
                      'assets/images/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    )),
                ]))))));
  }

  privacyPolicy(BuildContext context) async {
    setState(() => btnAccess = false);
    var response = await serviceMethod(
        context, 'get', null, serviceGetPrivacyPolicy(), false, true);
    setState(() => btnAccess = true);
    if (response != null) {
      String pathFile = await saveFile(
          context, 'Políticas', 'Política de privacidad.pdf', response);
      await OpenFile.open(pathFile);
    }
  }

  selectDate() {
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
            backgroundColor:
                ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
            cancelStyle: TextStyle(color: Color(0xff419388), fontSize: 15.sp),
            doneStyle: TextStyle(color: Color(0xff419388), fontSize: 15.sp),
            itemStyle: TextStyle(color: Color(0xff419388), fontSize: 25.sp),
            itemHeight: 0.05.sh,
            containerHeight: 0.35.sh),
        showTitleActions: true,
        maxTime: DateTime.now(),
        minTime: DateTime(1900, 6, 7),
        currentTime: currentDate,
        locale: LocaleType.es, onChanged: (date) {
      setState(() {
        currentDate = date;
      });
    }, onConfirm: (date) {
      setState(() {
        dateCtrl = DateFormat(' dd, MMMM yyyy ', "es_ES").format(date);
        dateCtrlText = DateFormat('dd-MM-yyyy').format(date);
        dateState = false;
      });
      if (dniCtrl.text.trim() != '') {
        initSession();
      }
    });
  }

  initSession() async {
    FocusScope.of(context).unfocus();
    validateDate();
    if (formKey.currentState!.validate()) {
      final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final appState = Provider.of<AppState>(context, listen: false);
      // final files = Provider.of<AppState>(context, listen: false);
      if (dateCtrlText != null) {
        setState(() => btnAccess = false);
        final Map<String, dynamic> data = {
          "identity_card":
              '${dniCtrl.text.trim()}${dniComCtrl.text == '' ? '' : '-' + dniComCtrl.text.trim()}',
          "birth_date": dateCtrlText,
          "device_id": deviceId
          // "device_id": "8cf128a40f2c91e4"
        };
        var response = await serviceMethod(
            context, 'post', data, serviceAuthSession(), false, true);
        setState(() => btnAccess = true);
        if (response != null) {
          UserModel user = userModelFromJson(
              json.encode(json.decode(response.body)['data']));
          await authService.auxtoken(user.apiToken!);
          appState.updateStateAuxToken(true);
          userBloc.add(UpdateUser(user.user!));
          prefs!.setString(
              'user', json.encode(json.decode(response.body)['data']));
          prefs!.setString('ci', dniCtrl.text.trim());
          //add words validations for files
          // files.addKey('cianverso', dniCtrl.text.trim()); //num carnet
          // files.addKey('cireverso', dniCtrl.text.trim()); //num carnet
          // files.addKey('cireverso',
          //     '${response.data['data']['user']['full_name']}'); //nombre
          await Permission.storage.request();
          await Permission.manageExternalStorage.request();
          await Permission.accessMediaLocation.request();
          if (!json.decode(response.body)['data']['user']['enrolled']) {
            _showModalInside(user.apiToken!, data);
          } else {
            await authService.login(context, user.apiToken!, data);
            appState.updateStateAuxToken(false);
            return Navigator.pushReplacementNamed(context, 'navigator');
          }
        }
      }
    }
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
          Navigator.pushReplacementNamed(context, 'navigator');
        });
      }),
    );
  }

  validateDate() {
    if (dateCtrlText != null) {
      setState(() => dateState = false);
    } else {
      setState(() => dateState = true);
    }
  }

  contacts() async {
    return Navigator.pushNamed(context, 'contacts');
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const ComponentAnimate(child: DialogBack()));
  }
}
