import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/dialogs/dialog_back.dart';
import 'package:muserpol_pvt/model/procedure_model.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/inbox/screen_inbox.dart';
import 'package:muserpol_pvt/screens/pages/procedure/procedure.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'dart:math' as math;

class NavigatorBar extends StatefulWidget {
  final bool tutorial;
  const NavigatorBar({Key? key, this.tutorial = true}) : super(key: key);

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  ProcedureModel? procedureCurrent;
  ProcedureModel? procedureHistory;
  final ScrollController _scrollController = ScrollController();
  var _currentIndex = 0;

  int pageCurrent = 1;
  int pageHistory = 1;
  bool stateProcessing = false;

  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyCreateProcedure = GlobalKey();
  GlobalKey keyNotification = GlobalKey();
  GlobalKey keyMenu = GlobalKey();
  GlobalKey keyRefresh = GlobalKey();

  List<Widget> pageList = [];

  @override
  void initState() {
    setState(() {
      pageList = [
        ScreenProcedures(
            current: true,
            scroll: _scrollController,
            keyProcedure: keyCreateProcedure,
            keyMenu: keyMenu,
            keyRefresh: keyRefresh),
        ScreenProcedures(current: false, scroll: _scrollController),
      ];
    });
    if (widget.tutorial) {
      Future.delayed(Duration.zero, showTutorial);
    } else {
      getEconomicComplement(true);
      getEconomicComplement(false);
    }
    super.initState();
    checkVersion(mounted,context);
    getProcessingPermit();
    getObservations();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_currentIndex == 0 && procedureCurrent!.data!.nextPageUrl != null) {
          getEconomicComplement(true);
        }
        if (_currentIndex == 1 && procedureHistory!.data!.nextPageUrl != null) {
          getEconomicComplement(false);
        }
      }
    });
  }

  getEconomicComplement(bool current) async {
    final procedureBloc =
        BlocProvider.of<ProcedureBloc>(context, listen: false);

    var response = await serviceMethod(
        mounted,
        context,
        'get',
        null,
        serviceGetEconomicComplements(
            current ? pageCurrent : pageHistory, current),
        true,
        true);
    if (response != null) {
      setState(() {
        if (current) {
          procedureCurrent = procedureModelFromJson(response.body);
          procedureBloc
              .add(AddCurrentProcedures(procedureCurrent!.data!.data!));
        } else {
          procedureHistory = procedureModelFromJson(response.body);
          procedureBloc
              .add(AddHistoryProcedures(procedureHistory!.data!.data!));
        }
        if (current) {
          pageCurrent++;
        } else {
          pageHistory++;
        }
      });
    }
  }

  getObservations() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceGetObservation(userBloc.state.user!.id!), true, true);
    if (response != null) {
      appState.updateObservation(response.body);
      if (json.decode(response.body)['data']['enabled']) {
        appState.updateStateProcessing(true);
      }
    }
  }

  getProcessingPermit() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceGetProcessingPermit(userBloc.state.user!.id!), true, false);
    if (response != null) {
      userBloc.add(UpdateCtrlLive(
          json.decode(response.body)['data']['liveness_success']));
      if (json.decode(response.body)['data']['liveness_success']) {
        appState.updateTabProcedure(1);
        if (userBloc.state.user!.verified!) {
          appState.updateStateLoadingProcedure(
              true); //MOSTRAMOS EL BTN DE CONTINUAR
          setState(() {});
        } else {
          appState.updateStateLoadingProcedure(
              false); //OCULTAMOS EL BTN DE CONTINUAR
          setState(() {});
        }
      } else {
        appState.updateTabProcedure(0);
        appState
            .updateStateLoadingProcedure(false); //OCULTAMOS EL BTN DE CONTINUAR
      }
      userBloc.add(UpdateProcedureId(
          json.decode(response.body)['data']['procedure_id']));
      if (json.decode(response.body)['data']['cell_phone_number'].length > 0) {
        userBloc.add(UpdatePhone(
            json.decode(response.body)['data']['cell_phone_number'][0]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    final notificationBloc =
        BlocProvider.of<NotificationBloc>(context, listen: true).state;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          floatingActionButton: Badge(
            key: keyNotification,
            animationDuration: const Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeColor: notificationBloc.existNotifications
                ? notificationBloc.listNotifications!
                        .where((e) => e.read == false)
                        .isNotEmpty
                    ? Colors.red
                    : Colors.transparent
                : Colors.transparent,
            elevation: 0,
            badgeContent: notificationBloc.existNotifications &&
                    notificationBloc.listNotifications!
                        .where((e) => e.read == false)
                        .isNotEmpty
                ? Text(
                    notificationBloc.listNotifications!
                        .where((e) => e.read == false)
                        .length
                        .toString(),
                    style: const TextStyle(color: Colors.white),
                  )
                : Container(),
            child: IconBtnComponent(
                iconText: 'assets/icons/email.svg',
                onPressed: () => dialogInbox(context)),
          ),
          body: pageList.elementAt(_currentIndex),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: Stack(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: SizedBox(
                        key: keyBottomNavigation1,
                        height: 40,
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                    )),
                    Expanded(
                        child: Center(
                      child: SizedBox(
                        key: keyBottomNavigation2,
                        height: 40,
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                    )),
                  ],
                ),
              ),
              ConvexAppBar(
                  height: 65,
                  elevation: 0,
                  backgroundColor: const Color(0xff419388),
                  // color: Color(0xff419388),
                  style: TabStyle.react,
                  items: [
                    TabItem(
                        isIconBlend: true,
                        icon: SvgPicture.asset(
                          'assets/icons/newProcedure.svg',
                          height: 30.sp,
                          color: Colors.white,
                        ),
                        title: "Trámites Vigentes"),
                    TabItem(
                        isIconBlend: true,
                        icon: SvgPicture.asset(
                          'assets/icons/historyProcedure.svg',
                          height: 30.sp,
                          color: Colors.white,
                        ),
                        title: "Trámites Históricos"),
                  ],
                  initialActiveIndex: 0,
                  onTap: (int i) => {setState(() => _currentIndex = i)}),
            ],
          ),
        ));
  }

  dialogInbox(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const ScreenInbox());
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const ComponentAnimate(child: DialogBack()));
  }

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xff419388),
      textSkip: "OMITIR",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        debugPrint("finish");
        getEconomicComplement(true);
        getEconomicComplement(false);
      },
      onClickTarget: (target) {
        debugPrint('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        debugPrint("target: $target");
        debugPrint(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        debugPrint('onClickOverlay: $target');
      },
      onSkip: () {
        debugPrint("skip");
        getEconomicComplement(true);
        getEconomicComplement(false);
      },
    )..show(context:context);
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        "Aquí podrás ver tus Tramites disponibles ",
                        style: TextStyle(color: Colors.white),
                      )),
                  Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(180),
                      child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(15 / 180),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/images/arrow.png',
                              color: Colors.white,
                              height: 100,
                            ),
                          ))),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: keyBottomNavigation2,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        "Aquí podrás ver el historial de tus tramites ",
                        style: TextStyle(color: Colors.white),
                      )),
                  Transform.rotate(
                    angle: math.pi / 7,
                    child: Image.asset(
                      'assets/images/arrow.png',
                      color: Colors.white,
                      height: 100,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyCreateProcedure",
        keyTarget: keyCreateProcedure,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                const Text(
                  "CREACIÓN DE TRÁMITE",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Si ves el botón de color verde, puedes crear tu trámite correspondiente al semestre",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 20,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyNotification",
        keyTarget: keyNotification,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "BUZÓN DE MENSAJES",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Acá podrás observar todos los mensajes que la MUSERPOL tiene para ti ",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyMenu",
        keyTarget: keyMenu,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  const Text(
                    "MENÚ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Aquí podras observar un menú donde encontraras tus datos y diferentes opciones",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyRefresh",
        keyTarget: keyRefresh,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "ACTUALIZAR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "con este botón podrás refrescar la pantalla",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
