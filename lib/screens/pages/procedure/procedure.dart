import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/containers.dart';
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
  const ScreenProcedures(
      {Key? key, required this.current, required this.scroll})
      : super(key: key);

  @override
  State<ScreenProcedures> createState() => _ScreenProceduresState();
}

class _ScreenProceduresState extends State<ScreenProcedures> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final procedureBloc =
        BlocProvider.of<ProcedureBloc>(context, listen: true).state;
    final appState = Provider.of<AppState>(context, listen: true);
    return Scaffold(
        drawer: MenuDrawer(),
        body: Builder(
            builder: (context) => Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: Column(children: [
                  HedersComponent(
                      title: 'Complemento Económico',
                      menu: true,
                      onPressMenu: () => Scaffold.of(context).openDrawer()),
                  if (appState.messageObservation != null)
                    ContainerComponent(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(
                                appState.messageObservation!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ))
                            ],
                          ),
                        ),
                        color: const Color(0xffffdead)),
                  if (appState.stateProcessing && widget.current)
                  ButtonComponent(
                      text: 'CREAR TRÁMITE', onPressed: () => create()),
                  //   const CardNewProcedure(),
                  if (widget.current)
                    Expanded(
                        child: procedureBloc.existCurrentProcedures
                            ? procedureBloc.currentProcedures!.isEmpty
                                ? (appState.stateProcessing && widget.current)?
                                Container()
                                :const Center(
                                    child: Text('No se encontraron trámites'))
                                : ListView.builder(
                                    controller: widget.scroll,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        procedureBloc.currentProcedures!.length,
                                    itemBuilder: (c, i) => CardEc(
                                        item: procedureBloc
                                            .currentProcedures![i]))
                            : Center(
                                child: Image.asset(
                                'assets/images/load.gif',
                                fit: BoxFit.cover,
                                height: 20,
                              ))),
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
                ]))));
  }

  create() {
    return showBarModalBottomSheet(
      duration: Duration(milliseconds: 800),
      expand: false,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (context) => StepperProcedure(
        endProcedure:(response) => procedure(response),
      ),
    );
  }
  procedure(dynamic response){

    final appState = Provider.of<AppState>(context, listen: false);
    final procedureBloc = Provider.of<ProcedureBloc>(context, listen: false);
      return showSuccessful(context, 'Trámite registrado correctamente',
          () async {
        String pathFile = await saveFile(
          context,
          'Trámites',
          'sol_eco_com_${DateTime.now().millisecondsSinceEpoch}.pdf',
          response,
        );
        setState(() {
          appState.updateTabProcedure(0);
          appState.clearFiles();
        });
        await getEconomicComplement();
        await getProcessingPermit();
        await getObservations();
        procedureBloc.add(UpdateStateComplementInfo(false));
        await OpenFile.open(pathFile);
      });
  }
  getEconomicComplement() async {
    //REINICIO DEL LISTADO DE TRÁMITES VIGENTES
    final procedureBloc =
        BlocProvider.of<ProcedureBloc>(context, listen: false);
    var response = await serviceMethod(context, 'get', null,
        serviceGetEconomicComplements(0, true), true, true);
    if (response != null) {
      procedureBloc.add(UpdateCurrentProcedures(
          procedureModelFromJson(response.body).data!.data!));
    }
  }

  getObservations() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(context, 'get', null,
        serviceGetObservation(userBloc.state.user!.id!), true, true);
    if (response != null) {
      appState.updateObservation(json.decode(response.body)['message']);
    }
  }

  getProcessingPermit() async {
    //REVISANDO SI TIENE UN NUEVO TRÁMITE
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(context, 'get', null,
        serviceGetProcessingPermit(userBloc.state.user!.id!), true, true);
    if (response != null) {
      userBloc.add(UpdateCtrlLive(
          json.decode(response.body)['data']['liveness_success']));
      if (json.decode(response.body)['data']['liveness_success']) {
        if (userBloc.state.user!.verified!) {
          appState.updateTabProcedure(1 + appState.files.length);
          appState.updateStateLoadingProcedure(
              true); //MOSTRAMOS EL BTN DE CONTINUAR
        } else {
          appState.updateTabProcedure(1);

          appState.updateStateLoadingProcedure(
              false); //OCULTAMOS EL BTN DE CONTINUAR
        }
      } else {
        appState.updateTabProcedure(0);
        appState
            .updateStateLoadingProcedure(false); //OCULTAMOS EL BTN DE CONTINUAR
      }
      userBloc.add(UpdateProcedureId(
          json.decode(response.body)['data']['procedure_id']));
      userBloc.add(UpdatePhone(
          json.decode(response.body)['data']['cell_phone_number'][0]));
      appState.updateStateProcessing(true);
    }
  }
}
