import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/image_ctrl_live.dart';
import 'package:muserpol_pvt/dialogs/dialog_action.dart';
import 'package:muserpol_pvt/model/liveness_data_model.dart';
import 'package:muserpol_pvt/model/user_model.dart';
import 'package:muserpol_pvt/screens/modal_enrolled/tab_info.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';

class ModalInsideModal extends StatefulWidget {
  final Function(String) nextScreen;
  const ModalInsideModal({Key? key, required this.nextScreen})
      : super(key: key);
  @override
  _ModalInsideModalState createState() => _ModalInsideModalState();
}

class _ModalInsideModalState extends State<ModalInsideModal>
    with TickerProviderStateMixin {
  TabController? tabController;
  String title = '';
  String subTitle = '';
  String textContent = '';
  String message = '';
  LivenesData? infoLivenes;
  // int step = 0;
  String titleback = '';

  // bool stateInfo = false;

  // late List<CameraDescription>? _availableCameras;
  // CameraController? controllerCam;

  @override
  void initState() {
    super.initState();
    getMessage();
    // _getAvailableCameras();
  }

  getMessage() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(
        context, 'get', null, serviceProcessEnrolled(), true, true);
    if (response != null) {
      userBloc.add(UpdateStateCam(true));
      setState(() {
        infoLivenes = livenesDataFromJson(response.body);
        // stateInfo = true;
        title = infoLivenes!.data!.dialog!.title!;
        titleback = infoLivenes!.data!.dialog!.title!;
        textContent = infoLivenes!.data!.dialog!.content!;
        message = infoLivenes!.data!.action!.message!;
        tabController = TabController(vsync: this, length: 2);
        //step = tabController!.index;
      });
    }
  }

  // @override
  // void dispose() {
  //   controllerCam!.dispose();
  //   super.dispose();
  // }

  // Future<void> _getAvailableCameras() async {
  //   _availableCameras = await availableCameras();
  //   _initCamera(_availableCameras!.last);
  // }

  // Future<void> _initCamera(CameraDescription description) async {
  //   final stateCam = BlocProvider.of<UserBloc>(context, listen: false);

  //   controllerCam = CameraController(description, ResolutionPreset.medium,
  //       enableAudio: false);
  //   try {
  //     await controllerCam!.initialize();
  //     stateCam.add(UpdateStateBtntoggleCameraLens(true));
  //     setState(() {});
  //   } catch (_) {}
  //   if (!mounted) return;
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              automaticallyImplyLeading: false,
              middle: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 17.sp),
                  ),
                  if (subTitle != '')
                    Text(
                      subTitle,
                      style: TextStyle(fontSize: 15.sp),
                    )
                ],
              )),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1,
            child: DefaultTabController(
                length: 2,
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    TabInfo(
                        text: textContent,
                        nextScreen: () {
                          setState(() => title = message);
                          tabController!.animateTo(tabController!.index + 1);
                        }),
                    // if (stateInfo)
                    // for (var i = 0; i < infoLivenes!.data!.totalActions!; i++)
                    // if (controllerCam != null)
                    ImageCtrlLive(
                      sendImage: (image) => sendImage(image),
                      // controllerCam: controllerCam!,
                      // toggleCameraLens: () => _toggleCameraLens()
                    )
                  ],
                )),
          ),
        ));
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ComponentAnimate(
            child: DialogTwoAction(
                message: '¿DESEAS CANCELAR EL $titleback?',
                actionCorrect: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                messageCorrect: 'Salir')));
  }

  sendImage(String image) async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    final Map<String, dynamic> data = {'image': image};
    var response = await serviceMethod(
        context, 'post', data, serviceProcessEnrolled(), true, true);
    userBloc.add(UpdateStateCam(true));

    if (response != null) {
      if (json.decode(response.body)['error']) {
        setState(() {
          title = json.decode(response.body)['message'];
          subTitle = json.decode(response.body)['data']['action']['message'];
        });
        callDialogAction(context, 'Oops. paso algo, intente de nuevo');
      } else {
        if (json.decode(response.body)['data']['completed']) {
          User user = userBloc.state.user!;
          user.enrolled = true;
          userBloc.add(UpdateUser(user));
          return widget.nextScreen(json.decode(response.body)['message']);
        } else {
          setState(() {
            title = json.decode(response.body)['data']['action']['message'];
            subTitle = '';
            tabController!.animateTo(tabController!.index + 1);
          });
        }
      }
    }
  }

  // void _toggleCameraLens() {
  //   final lensDirection = controllerCam!.description.lensDirection;
  //   CameraDescription newDescription;
  //   if (lensDirection == CameraLensDirection.front) {
  //     newDescription = _availableCameras!.firstWhere((description) =>
  //         description.lensDirection == CameraLensDirection.back);
  //   } else {
  //     newDescription = _availableCameras!.firstWhere((description) =>
  //         description.lensDirection == CameraLensDirection.front);
  //   }
  //   _initCamera(newDescription);
  // }
}
