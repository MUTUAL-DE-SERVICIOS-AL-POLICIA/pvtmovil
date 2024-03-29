import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/card_observation.dart';
import 'package:muserpol_pvt/components/susessful.dart';
import 'package:muserpol_pvt/model/procedure_model.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:muserpol_pvt/screens/pages/procedure/card_economic_complement.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/pages/procedure/new_procedure/card_procedure.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class ScreenProcedures extends StatefulWidget {
  final bool current;
  final ScrollController scroll;
  final GlobalKey? keyProcedure;
  final GlobalKey? keyMenu;
  final GlobalKey? keyRefresh;
  const ScreenProcedures(
      {Key? key,
      required this.current,
      required this.scroll,
      this.keyProcedure,
      this.keyMenu,
      this.keyRefresh})
      : super(key: key);

  @override
  State<ScreenProcedures> createState() => _ScreenProceduresState();
}

class _ScreenProceduresState extends State<ScreenProcedures> {
  bool stateLoad = false;
  bool stateBtn = true;
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    final procedureBloc =
        BlocProvider.of<ProcedureBloc>(context, listen: true).state;
    final appState = Provider.of<AppState>(context, listen: true);
    return Scaffold(
        drawer: const MenuDrawer(),
        body: Builder(
            builder: (context) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                    child: HedersComponent(
                        title: 'Complemento Económico',
                        menu: true,
                        keyMenu: widget.keyMenu,
                        onPressMenu: () => Scaffold.of(context).openDrawer()),
                  ),
                  if (appState.messageObservation != "")
                    const CardObservation(),
                  if (widget.current && stateBtn)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ButtonComponent(
                          key: widget.keyProcedure,
                          text: 'CREAR TRÁMITE',
                          onPressed: stateBtn && appState.stateProcessing
                              ? () => create()
                              : null),
                    ),
                  if (!stateBtn)
                    Image.asset(
                      'assets/images/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ),
                  if (widget.current)
                    Expanded(
                        child: procedureBloc.existCurrentProcedures
                            ? procedureBloc.currentProcedures!.isEmpty
                                ? (appState.stateProcessing && widget.current)
                                    ? stateInfo()
                                    : Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                                'No se encontraron trámites'),
                                            stateInfo()
                                          ],
                                        ),
                                      )
                                : SingleChildScrollView(
                                    controller: widget.scroll,
                                    child: Column(
                                      children: [
                                        for (var item
                                            in procedureBloc.currentProcedures!)
                                          CardEc(item: item),
                                        stateInfo()
                                      ],
                                    ))
                            : stateInfo()),
                  if (!widget.current)
                    Expanded(
                        child: procedureBloc.existHistoricalProcedures
                            ? procedureBloc.historicalProcedures!.isEmpty
                                ? const Center(
                                    child: Text('No se encontraron trámites'))
                                : ListView.builder(
                                    controller: widget.scroll,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: procedureBloc
                                        .historicalProcedures!.length,
                                    itemBuilder: (c, i) => CardEc(
                                        item: procedureBloc
                                            .historicalProcedures![i]))
                            : Center(
                                child: Image.asset(
                                'assets/images/load.gif',
                                fit: BoxFit.cover,
                                height: 20,
                              ))),
                ])));
  }

  Widget stateInfo() {
    return Center(
        child: stateLoad
            ? Image.asset(
                'assets/images/load.gif',
                fit: BoxFit.cover,
                height: 20,
              )
            : IconBtnComponent(
                key: widget.keyRefresh,
                iconText: 'assets/icons/reload.svg',
                onPressed: () async {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  appState.updateTabProcedure(0);
                  for (var element in appState.files) {
                    appState.updateFile(element.id!, null);
                  }
                  appState.updateStateProcessing(false);
                  setState(() => stateLoad = true);
                  await getEconomicComplement();
                  await getObservations();
                  setState(() => stateLoad = false);
                }));
  }

  create() async {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() => stateBtn = false);
    await controleVerified();
    await getProcessingPermit();
    setState(() => stateBtn = true);
    for (var element in appState.files) {
      appState.updateFile(element.id!, null);
    }
    return showBarModalBottomSheet(
      duration: const Duration(milliseconds: 800),
      expand: false,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (context) => StepperProcedure(
        endProcedure: (response) => procedure(response),
      ),
    );
  }

  procedure(dynamic response) {
    final appState = Provider.of<AppState>(context, listen: false);
    final procedureBloc = Provider.of<ProcedureBloc>(context, listen: false);
    return showSuccessful(context, 'Trámite registrado correctamente',
        () async {
      String pathFile = await saveFile(
          'Documents',
          'sol_eco_com_${DateTime.now().millisecondsSinceEpoch}.pdf',
          response.bodyBytes);
      setState(() {
        appState.updateTabProcedure(0);
        appState.clearFiles();
      });
      await getEconomicComplement();
      await getObservations();
      procedureBloc.add(UpdateStateComplementInfo(false));
      await OpenFile.open(pathFile);
    });
  }

  getEconomicComplement() async {
    //REINICIO DEL LISTADO DE TRÁMITES VIGENTES
    final procedureBloc =
        BlocProvider.of<ProcedureBloc>(context, listen: false);
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceGetEconomicComplements(0, true), true, true);
    if (response != null) {
      procedureBloc.add(UpdateCurrentProcedures(
          procedureModelFromJson(response.body).data!.data!));
    } else {
      return setState(() => stateLoad = false);
    }
  }

  getObservations() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceGetObservation(userBloc.state.user!.id!), true, true);
    if (response != null) {
      appState.updateObservation(response.body);
      if (json.decode(response.body)['data']['enabled']) {
        appState.updateStateProcessing(true);
      }
    } else {
      return setState(() => stateLoad = false);
    }
  }

  controleVerified() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(
        mounted, context, 'get', null, serviceGetMessageFace(), true, true);
    if (response != null) {
      userBloc.add(UpdateVerifiedDocument(
          json.decode(response.body)['data']['verified']));
    }
  }

  getProcessingPermit() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
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
        setState(() {});
      }
      userBloc.add(UpdateProcedureId(
          json.decode(response.body)['data']['procedure_id']));
      if (json.decode(response.body)['data']['cell_phone_number'].length > 0) {
        userBloc.add(UpdatePhone(
            json.decode(response.body)['data']['cell_phone_number'][0]));
      }
    }
  }
}
