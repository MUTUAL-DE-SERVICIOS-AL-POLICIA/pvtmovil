import 'dart:async';
import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/cupertino.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/dialogs/dialog_back.dart';
import 'package:muserpol_pvt/screens/login.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenSwitch extends StatefulWidget {
  const ScreenSwitch({Key? key}) : super(key: key);

  @override
  ScreenSwitchState createState() => ScreenSwitchState();
}

class ScreenSwitchState extends State<ScreenSwitch> {
  String? deviceId;
  final deviceInfo = DeviceInfoPlugin();
  DateTime? dateTime;
  Duration initialtimer = const Duration();
  int value = 0;
  final itemsRequisitos = [
    "Complemento Económico",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
  ];
  final itemsSimulacion = [
    "Corto Plazo",
    "Largo Plazo",
    "Item 3",
    "Item 4",
    "Item 5",
  ];
  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'CON FLASH');
  final _flashOffController = TextEditingController(text: 'SIN FLASH');
  final _cancelController = TextEditingController(text: 'ATRAS');

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
  @override
  void initState() {
    super.initState();
    checkVersion(context);
    initializeDateFormatting();
    getId();
  }

  Future<void> getId() async {
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      debugPrint('iosDeviceInfo $iosDeviceInfo');
      return setState(() => deviceId = iosDeviceInfo.identifierForVendor);
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      debugPrint('androidDeviceInfo ${androidDeviceInfo.androidId}');
      return setState(() => deviceId = androidDeviceInfo.androidId);
    }
  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: -1,
        autoEnableFlash: false,
        android: const AndroidOptions(
          aspectTolerance: 0.00,
          useAutoFocus: true,
        ),
      );
      var result = await BarcodeScanner.scan(options: options);
      setState(() => scanResult = result);
      if (scanResult!.rawContent != '') {
        final Uri url = Uri.parse(scanResult!.rawContent);

        debugPrint('scanResult!.rawContent ${scanResult!.rawContent}');
        await launchUrl(mode: LaunchMode.externalApplication, url);
      }
    } on PlatformException catch (e) {
      debugPrint('error $e ');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
          child: Column(
            children: [
              const HedersComponent(title: 'Mutual de servicios al policía'),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenLogin(
                                      title: 'Complemento Económico',
                                      stateOfficeVirtual: false,
                                      deviceId: deviceId!,
                                    )),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/couple.png',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Complemento Económico',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20.sp),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScreenLogin(
                                            title: 'Oficina Virtual',
                                            deviceId: deviceId!,
                                          )),
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Oficina Virtual',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20.sp),
                                  ),
                                ),
                                const Expanded(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/computer.png',
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff419388),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    children: <Widget>[
                      BottonTool(
                          icon: 'assets/icons/qr.svg',
                          text: 'QR',
                          onPress: () => scan()),
                      BottonTool(
                          icon: 'assets/icons/requisites.svg',
                          text: 'REQUISITOS',
                          onPress: () =>
                              select(context, 'REQUISITOS', itemsRequisitos)),
                      BottonTool(
                          icon: 'assets/icons/calculator.svg',
                          text: 'SIMULAR',
                          onPress: () =>
                              select(context, 'SIMULACIÓN', itemsSimulacion)),
                    ],
                  ))
            ],
          ),
        )));
  }

  select(BuildContext context, String title, List<String> items) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPickerWidget(
            title: title,
            items: items,
            onEvent: (s) {
              debugPrint('ssss $s');
            },
          );
        });
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const ComponentAnimate(child: DialogBack()));
  }
}

class BottonTool extends StatelessWidget {
  final String icon;
  final String text;
  final Function() onPress;
  const BottonTool(
      {Key? key, required this.icon, required this.text, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
            onTap: onPress,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Column(
                children: [
                  SvgPicture.asset(
                    icon,
                    height: 20.sp,
                    color: Colors.white,
                  ),
                  Text(text,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 17)),
                ],
              ),
            )));
  }
}
