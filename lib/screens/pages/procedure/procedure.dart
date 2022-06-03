import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:muserpol_pvt/screens/pages/procedure/card_economic_complement.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/pages/procedure/new_procedure/card_new_procedure.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

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
                    const CardNewProcedure(),
                  if (widget.current)
                    Expanded(
                        child: procedureBloc.existCurrentProcedures
                            ? procedureBloc.currentProcedures!.isEmpty
                                ? const Center(
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
}
