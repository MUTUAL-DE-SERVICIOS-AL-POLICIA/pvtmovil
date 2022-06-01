import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageCtrlLive extends StatefulWidget {
  final Function(String) sendImage;
  // final CameraController controllerCam;
  // final Function() toggleCameraLens;
  const ImageCtrlLive({
    Key? key,
    required this.sendImage,
    // required this.controllerCam,
    // required this.toggleCameraLens
  }) : super(key: key);

  @override
  State<ImageCtrlLive> createState() => _ImageCtrlLiveState();
}

class _ImageCtrlLiveState extends State<ImageCtrlLive>
    with WidgetsBindingObserver {
  bool stateCamera = false;
  late List<CameraDescription>? _availableCameras;
  CameraController? controllerCam;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getAvailableCameras();
  }

  @override
  void dispose() {
    controllerCam!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print('CERRANDO CAMARA');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('REGRESE');
      _getAvailableCameras();
    }
  }

  Future<void> _getAvailableCameras() async {
    _availableCameras = await availableCameras();
    _initCamera(_availableCameras!.last);
  }

  Future<void> _initCamera(CameraDescription description) async {
    print('INICIANDO CAMARA');
    final stateCam = BlocProvider.of<UserBloc>(context, listen: false);

    controllerCam = CameraController(description, ResolutionPreset.high,
        enableAudio: false);
    try {
      await controllerCam!.initialize();
      stateCam.add(UpdateStateBtntoggleCameraLens(true));
      setState(() {});
    } catch (_) {
      print('paso paso algo');
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final stateCam = BlocProvider.of<UserBloc>(context, listen: true).state;
    return controllerCam != null
        ? CameraPreview(
            controllerCam!,
            child: stateCam.stateBtntoggleCameraLens
                ? Positioned(
                    bottom: 20,
                    right: 20,
                    left: 20,
                    child: Row(
                      children: [
                        Expanded(
                            child: ButtonComponent(
                                text: 'CAPTURAR',
                                onPressed: () => takePhoto())),
                        IconBtnComponent(
                          icon: Icons.cameraswitch_outlined,
                          onPressed: () => switchCam(),
                        )
                      ],
                    ))
                : Container(),
          )
        : Center(
            child: Image.asset(
            'assets/images/load.gif',
            fit: BoxFit.cover,
            height: 20,
          ));
  }

  switchCam() {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    if (userBloc.state.stateCam) {
      userBloc.add(UpdateStateBtntoggleCameraLens(false));
      // widget.toggleCameraLens();
      _toggleCameraLens();
    }
  }

  takePhoto() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    if (userBloc.state.stateBtntoggleCameraLens) {
      userBloc.add(UpdateStateCam(false));
      XFile picture = await controllerCam!.takePicture();
      File picturer = await FlutterNativeImage.compressImage(picture.path,
          quality: 100, targetWidth: 320, targetHeight: 240);
      Uint8List imagebytes = await picturer.readAsBytes();
      String base64 = base64Encode(imagebytes);
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      await Permission.accessMediaLocation.request();
      Directory documentDirectory =
          await Directory('/storage/emulated/0/Muserpol/pruebas')
              .create(recursive: true);
      String documentPath = documentDirectory.path;
      var imagen = File(
          '$documentPath/imagen${DateTime.now().millisecondsSinceEpoch}.txt');
      imagen.writeAsString('$base64');
      widget.sendImage(base64);
      // controllerCam!.dispose();
    }
  }

  void _toggleCameraLens() {
    final lensDirection = controllerCam!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }
    _initCamera(newDescription);
  }
}
