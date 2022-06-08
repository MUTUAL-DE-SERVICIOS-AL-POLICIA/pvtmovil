import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/components/image_ctrl_live.dart';
import 'package:muserpol_pvt/dialogs/dialog_action.dart';
import 'package:muserpol_pvt/model/liveness_data_model.dart';
import 'package:muserpol_pvt/model/user_model.dart';
import 'package:muserpol_pvt/screens/modal_enrolled/tab_info.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:theme_provider/theme_provider.dart';

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
  String textContent = '';
  String message = '';
  LivenesData? infoLivenes;
  String titleback = '';

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  getMessage() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(
        context, 'get', null, serviceProcessEnrolled(), true, true);
    if (response != null) {
      userBloc.add(UpdateStateCam(true));
      setState(() {
        infoLivenes = livenesDataFromJson(response.body);
        title = infoLivenes!.data!.dialog!.title!;
        titleback = infoLivenes!.data!.dialog!.title!;
        textContent = infoLivenes!.data!.dialog!.content!;
        message = infoLivenes!.data!.action!.message!;
        tabController = TabController(vsync: this, length: 2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: SizedBox(
                child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: HedersComponent(title: title)),
          Expanded(
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
                    ImageCtrlLive(sendImage: (image) => sendImage(image))
                  ],
                )),
          ),
        ]))));
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
          // title = json.decode(response.body)['message'];
          title = json.decode(response.body)['data']['action']['message'];
        });
        callDialogAction(context, json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body)['data']['completed']) {
          User user = userBloc.state.user!;
          user.enrolled = true;
          userBloc.add(UpdateUser(user));
          return widget.nextScreen(json.decode(response.body)['message']);
        } else {
          setState(() {
            title = json.decode(response.body)['data']['action']['message'];
          });
        }
      }
    }
  }
}
