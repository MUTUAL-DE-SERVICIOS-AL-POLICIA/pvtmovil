import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/dialogs/dialog_back.dart';
import 'package:muserpol_pvt/model/procedure_model.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/pages/procedure/procedure.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:theme_provider/theme_provider.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({Key? key}) : super(key: key);

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  ProcedureModel? procedureCurrent;
  ProcedureModel? procedureHistory;
  final ScrollController _scrollController = ScrollController();
  var _currentIndex = 0;

  int pageCurrent = 1;
  int pageHistory = 1;
  bool stateProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkVersion();
    getProcessingPermit();
    getObservations();
    getEconomicComplement(true);
    getEconomicComplement(false);
    _scrollController.addListener(() {
      print('SCROLL');
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

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.muserpol.pvt",
    );
    final status = await newVersion.getVersionStatus();
    print("DEVICE : " + status!.localVersion);
    print("STORE : " + status.storeVersion);
    if (status.localVersion == status.storeVersion) return;
    newVersion.showUpdateDialog(
      context: context,
      allowDismissal: false,
      versionStatus: status!,
      dialogTitle: "Actualiza la nueva versión",
      dialogText:
          "Para mejorar la experiencia, Porfavor actualiza la nueva versión de ${status.localVersion} a la ${status.storeVersion}",
      updateButtonText: "Actualizar",
    );
  }

  getEconomicComplement(bool current) async {
    final procedureBloc =
        BlocProvider.of<ProcedureBloc>(context, listen: false);
    var response = await serviceMethod(
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
    var response = await serviceMethod(context, 'get', null,
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
    var response = await serviceMethod(context, 'get', null,
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    List<Widget> pageList = [
      ScreenProcedures(current: true, scroll: _scrollController),
      ScreenProcedures(current: false, scroll: _scrollController),
    ];
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: pageList.elementAt(_currentIndex),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              SalomonBottomBarItem(
                  icon: const Icon(Icons.home),
                  title: const Text("Trámites Vigentes"),
                  unselectedColor:
                      ThemeProvider.themeOf(context).data.primaryColorDark),
              SalomonBottomBarItem(
                  icon: const Icon(Icons.history),
                  title: const Text("Trámites Históricos"),
                  unselectedColor:
                      ThemeProvider.themeOf(context).data.primaryColorDark),
            ],
          ),
        ));
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const ComponentAnimate(child: DialogBack()));
  }
}
