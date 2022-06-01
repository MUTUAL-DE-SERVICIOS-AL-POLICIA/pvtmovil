import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/components/input.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:provider/provider.dart';

class TabInfoEconomicComplement extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final Function() onEditingComplete;
  final Function() onTap;
  const TabInfoEconomicComplement(
      {Key? key,
      required this.phoneCtrl,
      required this.onEditingComplete,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final procedureBloc =
        Provider.of<ProcedureBloc>(context, listen: true).state;
    final appState = Provider.of<AppState>(context, listen: true);
    return procedureBloc.existInfoComplementInfo &&
            appState.stateLoadingProcedure
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Text(procedureBloc.economicComplementInfo!.data!.title!),
                  // const SizedBox(height: 20),
                  Text('Número telefónico:'),
                  InputComponent(
                    textInputAction: TextInputAction.next,
                    controllerText: phoneCtrl,
                    onEditingComplete: () => onEditingComplete(),
                    onTap: () => onTap(),
                    onTapInput: () => onTap(),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese su número telefónico';
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.characters,
                    icon: Icons.person,
                    labelText: "Número de contacto",
                  ),
                  Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        for (var item in procedureBloc
                            .economicComplementInfo!.data!.display!)
                          TableRow(children: [
                            Text('${item.key!}  :', textAlign: TextAlign.right),
                            Text('${item.value}')
                          ])
                      ]),
                ],
              ),
            ))
        : Center(
            child: Image.asset(
            'assets/images/load.gif',
            fit: BoxFit.cover,
            height: 20,
          ));
  }
}
