import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/bloc/loan/loan_bloc.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/target.dart';
import 'package:muserpol_pvt/components/dialog_action.dart';
import 'package:muserpol_pvt/model/biometric_user_model.dart';
import 'package:muserpol_pvt/model/contribution_model.dart';
import 'package:muserpol_pvt/model/loan_model.dart';
import 'package:muserpol_pvt/model/procedure_model.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/inbox/screen_inbox.dart';
import 'package:muserpol_pvt/screens/pages/complement/procedure.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/contibutions/contribution.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/loans/loan.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'dart:math' as math;

class NavigatorBar extends StatefulWidget {
  final bool tutorial;
  final String stateApp;
  const NavigatorBar({Key? key, this.tutorial = true, required this.stateApp})
      : super(key: key);

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
  GlobalKey keyBottomHeader = GlobalKey();
  GlobalKey keyCreateProcedure = GlobalKey();
  GlobalKey keyNotification = GlobalKey();
  GlobalKey keyMenu = GlobalKey();
  GlobalKey keyRefresh = GlobalKey();

  List<Widget> pageList = [];

  @override
  void initState() {
    super.initState();
    generateMenu();
    services();
  }

  generateMenu() {
    if (widget.stateApp == 'complement') {
      setState(() => pageList = [
            ScreenProcedures(
                current: true,
                scroll: _scrollController,
                keyProcedure: keyCreateProcedure,
                keyMenu: keyMenu,
                keyRefresh: keyRefresh),
            ScreenProcedures(
                current: false, scroll: _scrollController, keyMenu: keyMenu),
          ]);
    } else {
      setState(() => pageList = [
            ScreenContributions(
                keyMenu: keyMenu, keyBottomHeader: keyBottomHeader),
            ScreenPageLoans(keyMenu: keyMenu)
          ]);
    }
  }

  services() async {
    if (await checkVersion(mounted, context)) {
      if (widget.stateApp == 'complement') {
        getProcessingPermit();
        getObservations();
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            if (_currentIndex == 0 &&
                procedureCurrent!.data!.nextPageUrl != null) {
              getEconomicComplement(true);
            }
            if (_currentIndex == 1 &&
                procedureHistory!.data!.nextPageUrl != null) {
              getEconomicComplement(false);
            }
          }
        });
      }
      if (widget.tutorial) {
        Future.delayed(const Duration(milliseconds: 500), showTutorial);
      } else {
        if (widget.stateApp == 'complement') {
          getEconomicComplement(true);
          getEconomicComplement(false);
        } else {
          debugPrint('OBTENINENDO TODOS LOS APORTES Y PRESTAMOS');
          getContributions();
          getLoans();
        }
      }
    }
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
    final observationState =
        Provider.of<ObservationState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    final processingState =
        Provider.of<ProcessingState>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceGetObservation(userBloc.state.user!.id!), true, true);
    if (response != null) {
      observationState.updateObservation(response.body);
      if (json.decode(response.body)['data']['enabled']) {
        processingState.updateStateProcessing(true);
      }
    }
  }

  getProcessingPermit() async {
    final loadingState = Provider.of<LoadingState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    final tabProcedureState =
        Provider.of<TabProcedureState>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceGetProcessingPermit(userBloc.state.user!.id!), true, false);
    if (response != null) {
      userBloc.add(UpdateCtrlLive(
          json.decode(response.body)['data']['liveness_success']));
      if (json.decode(response.body)['data']['liveness_success']) {
        tabProcedureState.updateTabProcedure(1);
        if (userBloc.state.user!.verified!) {
          loadingState.updateStateLoadingProcedure(
              true); //MOSTRAMOS EL BTN DE CONTINUAR
          setState(() {});
        } else {
          loadingState.updateStateLoadingProcedure(
              false); //OCULTAMOS EL BTN DE CONTINUAR
          setState(() {});
        }
      } else {
        tabProcedureState.updateTabProcedure(0);
        loadingState
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

  getContributions() async {
    final contributionBloc =
        BlocProvider.of<ContributionBloc>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final biometric =
        biometricUserModelFromJson(await authService.readBiometric());
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceContributions(biometric.affiliateId!), true, true);
    if (response != null) {
      contributionBloc
          .add(UpdateContributions(contributionModelFromJson(response.body)));
    }
  }

  getLoans() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final loanBloc = BlocProvider.of<LoanBloc>(context, listen: false);
    final biometric =
        biometricUserModelFromJson(await authService.readBiometric());
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceLoans(biometric.affiliateId!), true, true);
    if (response != null) {
      loanBloc.add(UpdateLoan(loanModelFromJson(response.body)));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        .where((e) =>
                            e.read == false &&
                            e.idAffiliate == notificationBloc.affiliateId)
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
                        .where((e) =>
                            e.read == false &&
                            e.idAffiliate == notificationBloc.affiliateId)
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
              if (widget.stateApp == 'complement')
                StyleProvider(
                    style: Style(),
                    child: ConvexAppBar(
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
                                height: 25.sp,
                                color: Colors.white,
                              ),
                              title: "Solicitud de Pago"),
                          TabItem(
                              isIconBlend: true,
                              icon: SvgPicture.asset(
                                'assets/icons/historyProcedure.svg',
                                height: 25.sp,
                                color: Colors.white,
                              ),
                              title: "Trámites Históricos"),
                        ],
                        initialActiveIndex: 0,
                        onTap: (int i) => {setState(() => _currentIndex = i)})),
              if (widget.stateApp == 'virtualofficine')
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
                          title: "Aportes"),
                      TabItem(
                          isIconBlend: true,
                          icon: SvgPicture.asset(
                            'assets/icons/historyProcedure.svg',
                            height: 30.sp,
                            color: Colors.white,
                          ),
                          title: "Prestamos"),
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
        builder: (BuildContext context) {
          return ComponentAnimate(
              child: DialogTwoAction(
                  message:
                      '¿Estás seguro de salir de la aplicación MUSERPOL PVT?',
                  actionCorrect: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                  messageCorrect: 'Salir'));
        });
  }

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xff419388),
      textSkip: "OMITIR",
      textStyleSkip: const TextStyle(
          color: Color(0xffffdead), fontWeight: FontWeight.bold),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () async {
        if (await checkVersion(mounted, context)) {
          if (widget.stateApp == 'complement') {
            getEconomicComplement(true);
            getEconomicComplement(false);
          } else {
            debugPrint('OBTENINENDO TODOS LOS APORTES Y PRESTAMOS');
            getContributions();
            getLoans();
          }
        }
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
      onSkip: () async {
        debugPrint("skip");
        if (await checkVersion(mounted, context)) {
        if (widget.stateApp == 'complement') {
          getEconomicComplement(true);
          getEconomicComplement(false);
        } else {
          debugPrint('OBTENINENDO TODOS LOS APORTES Y PRESTAMOS');
          getContributions();
          getLoans();
        }}
      },
    )..show(context: context);
  }

  void initTargets() {
    targets.clear();
    targets.add(target(
        "keyBottomNavigation1",
        keyBottomNavigation1,
        ContentAlign.top,
        Alignment.topRight,
        widget.stateApp == 'complement'
            ? "Aquí podrá ver su trámite solicitado"
            : "Aquí podrá ver sus aportes",
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
        null,
        null,
        null));
    if (widget.stateApp != 'complement') {
      targets.add(target(
          "keyBottomHeader",
          keyBottomHeader,
          ContentAlign.bottom,
          null,
          "Aquí puedes ver la certificación de tus aportes como titular o pasivo",
          Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(90),
              child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(130 / 180),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/images/arrow.png',
                      color: Colors.white,
                      height: 80,
                    ),
                  ))),
          ShapeLightFocus.RRect,
          20,
          VerticalDirection.up));
    }
    targets.add(target(
        "keyBottomNavigation2",
        keyBottomNavigation2,
        ContentAlign.top,
        Alignment.topRight,
        widget.stateApp == 'complement'
            ? "Aquí podrá ver el historial de sus trámites"
            : "Aquí podrá ver sus prestamos",
        Transform.rotate(
          angle: math.pi / 7,
          child: Image.asset(
            'assets/images/arrow.png',
            color: Colors.white,
            height: 100,
          ),
        ),
        null,
        null,
        null));
    if (widget.stateApp == 'complement') {
      targets.add(target(
          "keyCreateProcedure",
          keyCreateProcedure,
          ContentAlign.bottom,
          null,
          "Para crear su trámite debe presionar el botón CREAR TRÁMITE, cuando se encuentre en color verde",
          Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(45),
              child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(130 / 180),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/images/arrow.png',
                      color: Colors.white,
                      height: 80,
                    ),
                  ))),
          ShapeLightFocus.RRect,
          20,
          VerticalDirection.up));
    } else {}

    targets.add(target(
        "keyNotification",
        keyNotification,
        ContentAlign.top,
        Alignment.topRight,
        "BUZÓN DE MENSAJES\nAquí podrá observar todos los mensajes enviados por la MUSERPOL",
        Transform.rotate(
          angle: math.pi / 7,
          child: Image.asset(
            'assets/images/arrow.png',
            color: Colors.white,
            height: 100,
          ),
        ),
        null,
        null,
        null));
    targets.add(target(
        "keyMenu",
        keyMenu,
        ContentAlign.bottom,
        null,
        "MENU\nAquí podrá ingresar al menú de datos y configuraciones",
        RotationTransition(
            turns: const AlwaysStoppedAnimation(100 / 180),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/images/arrow.png',
                color: Colors.white,
                height: 80,
              ),
            )),
        null,
        null,
        VerticalDirection.up));
    targets.add(target(
        "keyRefresh",
        keyRefresh,
        ContentAlign.top,
        null,
        "ACTUALIZAR\nPresionando este botón usted podrá actualizar la pantalla",
        Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(10),
            child: RotationTransition(
                turns: const AlwaysStoppedAnimation(40 / 180),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/arrow.png',
                    color: Colors.white,
                    height: 80,
                  ),
                ))),
        null,
        null,
        null));
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color, String? s) {
    return TextStyle(fontSize: 13.sp, color: color);
  }
}
