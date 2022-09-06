import 'dart:async';
import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/dialogs/dialog_back.dart';
import 'package:muserpol_pvt/model/qr_model.dart';
import 'package:muserpol_pvt/screens/flowQR/flow.dart';
import 'package:muserpol_pvt/screens/login.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:muserpol_pvt/services/services.dart';

class ScreenSwitch extends StatefulWidget {
  const ScreenSwitch({Key? key}) : super(key: key);

  @override
  ScreenSwitchState createState() => ScreenSwitchState();
}

class ScreenSwitchState extends State<ScreenSwitch> {
  String? deviceId;
  final deviceInfo = DeviceInfoPlugin();
  int value = 0;

  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'CON FLASH');
  final _flashOffController = TextEditingController(text: 'SIN FLASH');
  final _cancelController = TextEditingController(text: 'ATRAS');

  static final _possibleFormats = BarcodeFormat.values.toList()..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
  @override
  void initState() {
    super.initState();
    checkVersion(mounted, context);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
          child: Column(
            children: [
              const HedersComponent(title: 'Mutual de Servicios al Policía'),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BottonTool(
                          title: 'Complemento Económico',
                          description: 'Creación de tramites y seguimiento para el pago del Complemento Económico',
                          onPress: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenLogin(
                                      title: 'Complemento Económico',
                                      stateOfficeVirtual: false,
                                      deviceId: deviceId!,
                                    )),
                          ),
                          child: const Image(
                            image: AssetImage(
                              'assets/images/couple.png',
                            ),
                          ),
                        ),
                        BottonTool(
                          title: 'Oficina Virtual',
                          description: 'Seguimiento de Aportes y Prestamos',
                          textDirection: TextDirection.rtl,
                          onPress: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenLogin(
                                      title: 'Oficina Virtual',
                                      deviceId: deviceId!,
                                    )),
                          ),
                          child: const Image(
                            image: AssetImage(
                              'assets/images/computer.png',
                            ),
                          ),
                        ),
                        BottonTool(
                          title: 'Seguimiento de trámites',
                          description: 'Seguimiento de trámites con QR',
                          onPress: () => scan(),
                          child: SvgPicture.asset(
                            'assets/icons/qr.svg',
                            height: 100.sp,
                            color: const Color(0xff419388),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
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
        debugPrint('scanResult!.rawContent ${scanResult!.rawContent}');
        if (!mounted) return;
        var response = await serviceMethod(mounted, context, 'get', null, serviceGetQr(scanResult!.rawContent), false, false);
        if (response != null) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScreenWorkFlow(qrModel: qrModelFromJson(response.body))),
          );
        } else {
          if (!mounted) return;
          callDialogAction(context, 'No pudimos encontrar el trámite');
        }
      }
    } on PlatformException catch (e) {
      debugPrint('error $e ');
      return;
    }
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(barrierDismissible: false, context: context, builder: (context) => const ComponentAnimate(child: DialogBack()));
  }
}

class BottonTool extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final Function() onPress;
  final TextDirection? textDirection;
  const BottonTool({Key? key, required this.child, required this.title, required this.description, required this.onPress, this.textDirection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: ContainerComponent(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              textDirection: textDirection,
              children: [
                Expanded(
                  child: Padding(padding: const EdgeInsets.all(8.0), child: child),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(description)
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
