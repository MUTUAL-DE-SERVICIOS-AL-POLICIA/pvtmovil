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
  final CameraController controllerCam;
  final Function() toggleCameraLens;
  const ImageCtrlLive(
      {Key? key,
      required this.sendImage,
      required this.controllerCam,
      required this.toggleCameraLens})
      : super(key: key);

  @override
  State<ImageCtrlLive> createState() => _ImageCtrlLiveState();
}

class _ImageCtrlLiveState extends State<ImageCtrlLive> {
  bool stateCamera = false;

  @override
  Widget build(BuildContext context) {
    final stateCam = BlocProvider.of<UserBloc>(context, listen: true).state;
    return stateCam.stateCam
        ? Transform.scale(
            scale: 1,
            alignment: Alignment.topCenter,
            child: CameraPreview(
              widget.controllerCam,
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
            ))
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
      widget.toggleCameraLens();
    }
  }

  takePhoto() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    if (userBloc.state.stateBtntoggleCameraLens) {
      userBloc.add(UpdateStateCam(false));
      XFile picture = await widget.controllerCam.takePicture();
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
    }
  }
}
