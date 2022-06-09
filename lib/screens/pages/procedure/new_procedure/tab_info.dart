import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/components/input.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:provider/provider.dart';

class TabInfoEconomicComplement extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final Function() onEditingComplete;
  const TabInfoEconomicComplement(
      {Key? key, required this.phoneCtrl, required this.onEditingComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final procedureBloc =
        Provider.of<ProcedureBloc>(context, listen: true).state;
    final appState = Provider.of<AppState>(context, listen: true);
    return procedureBloc.existInfoComplementInfo &&
            appState.stateLoadingProcedure
        ? Column(
            children: [
              Text('Número telefónico:'),
              InputComponent(
                textInputAction: TextInputAction.next,
                controllerText: phoneCtrl,
                onEditingComplete: () => onEditingComplete(),
                validator: (value) {
                  if (value.isNotEmpty) {
                    return null;
                  } else {
                    return 'Ingrese su número telefónico';
                  }
                },
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.characters,
                icon: Icons.person,
                labelText: "Número de contacto",
              ),
              Table(
                  columnWidths: {
                    0: FlexColumnWidth(6),
                    1: FlexColumnWidth(0.3),
                    2: FlexColumnWidth(6),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      width: 0.5,
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                  ),
                  children: [
                    for (var item
                        in procedureBloc.economicComplementInfo!.data!.display!)
                      TableRow(children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Text('${item.key!}',
                                textAlign: TextAlign.right)),
                        Text(':'),
                        Text('${item.value}')
                      ])
                  ]),
            ],
          )
        : Center(
            child: Image.asset(
            'assets/images/load.gif',
            fit: BoxFit.cover,
            height: 20,
          ));
  }
}
