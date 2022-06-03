import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';

class ImageCtrlLive extends StatefulWidget {
  final Function(String) sendImage;
  const ImageCtrlLive({Key? key, required this.sendImage}) : super(key: key);

  @override
  State<ImageCtrlLive> createState() => _ImageCtrlLiveState();
}

class _ImageCtrlLiveState extends State<ImageCtrlLive>
    with WidgetsBindingObserver {
  late List<CameraDescription>? _availableCameras;
  CameraController? controllerCam;
  bool? isCameraReady;
  Future<void>? _initializeControllerFuture;
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
      setState(() {
        _initializeControllerFuture = null;
        controllerCam != null;
        _getAvailableCameras();
      });
    }
  }

  Future<void> _getAvailableCameras() async {
    _availableCameras = await availableCameras();
    CameraDescription newDescription;
    newDescription = _availableCameras!.firstWhere((description) =>
        description.lensDirection == CameraLensDirection.front);
    _initCamera(newDescription);
  }

  Future<void> _initCamera(CameraDescription description) async {
    final stateCam = BlocProvider.of<UserBloc>(context, listen: false);
    controllerCam = CameraController(description, ResolutionPreset.high,
        enableAudio: false);
    _initializeControllerFuture = controllerCam!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controllerCam!.addListener(() {
        if (mounted) setState(() {});
        if (controllerCam!.value.hasError) {
          print('Camera error ${controllerCam!.value.errorDescription}');
        }
      });
      stateCam.add(UpdateStateBtntoggleCameraLens(true));
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateCam = BlocProvider.of<UserBloc>(context, listen: true).state;
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            stateCam.stateCam) {
          // If the Future is complete, display the preview.
          return CameraPreview(
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
          );
        } else {
          return Center(
              child: Image.asset(
            'assets/images/load.gif',
            fit: BoxFit.cover,
            height: 20,
          )); // Otherwise, display a loading indicator.
        }
      },
    );
  }

  switchCam() {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    if (userBloc.state.stateCam) {
      userBloc.add(UpdateStateBtntoggleCameraLens(false));
      _toggleCameraLens();
    }
  }

  takePhoto() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    try {
      if (userBloc.state.stateBtntoggleCameraLens) {
        userBloc.add(UpdateStateCam(false));
        XFile picture = await controllerCam!.takePicture();
        var imagebytes = await FlutterImageCompress.compressWithFile(
          picture.path,
          minWidth: 240,
          minHeight: 320,
          quality: 100,
        );
        String base64 = base64Encode(imagebytes!);
        // await Permission.storage.request();
        // await Permission.manageExternalStorage.request();
        // await Permission.accessMediaLocation.request();
        // Directory documentDirectory =
        //     await Directory('/storage/emulated/0/Muserpol/pruebas')
        //         .create(recursive: true);
        // String documentPath = documentDirectory.path;
        // var imagen = File(
        //     '$documentPath/imagen${DateTime.now().millisecondsSinceEpoch}.txt');
        // var imagen2 = File(
        //     '$documentPath/imagen${DateTime.now().millisecondsSinceEpoch}.jpg');
        // imagen.writeAsString('$base64');
        // final file = await picture.readAsBytes();
        // imagen2.writeAsBytesSync(file);
        widget.sendImage(base64);
      }
    } catch (_) {
      print('paso paso algo');
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
