import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/components/input.dart';
import 'package:muserpol_pvt/components/table_row.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:provider/provider.dart';

class TabInfoEconomicComplement extends StatefulWidget {
  final TextEditingController phoneCtrl;
  final Function() onEditingComplete;
  const TabInfoEconomicComplement({Key? key, required this.phoneCtrl, required this.onEditingComplete}) : super(key: key);

  @override
  State<TabInfoEconomicComplement> createState() => _TabInfoEconomicComplementState();
}

class _TabInfoEconomicComplementState extends State<TabInfoEconomicComplement> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final procedureBloc = Provider.of<ProcedureBloc>(context, listen: true).state;
    final appState = Provider.of<AppState>(context, listen: true);
    return procedureBloc.existInfoComplementInfo && appState.stateLoadingProcedure
        ? Form(
            key: formKey,
            child: Column(
              children: [
                const Text('Número telefónico:'),
                InputComponent(
                  stateAutofocus: true,
                  textInputAction: TextInputAction.next,
                  controllerText: widget.phoneCtrl,
                  onEditingComplete: () => widget.onEditingComplete(),
                  validator: (value) {
                    if (value.isNotEmpty) {
                      return null;
                    } else {
                      return 'Ingrese su número telefónico';
                    }
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.characters,
                  icon: Icons.person,
                  labelText: "Número de contacto",
                ),
                Table(
                    columnWidths: const {
                      0: FlexColumnWidth(6),
                      1: FlexColumnWidth(0.3),
                      2: FlexColumnWidth(6),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        width: 0.5,
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                    ),
                    children: [for (var item in procedureBloc.economicComplementInfo!.data!.display!) tableInfo(item.key!, Text('${item.value}'))]),
              ],
            ))
        : Center(
            child: Image.asset(
            'assets/images/load.gif',
            fit: BoxFit.cover,
            height: 20,
          ));
  }
}
