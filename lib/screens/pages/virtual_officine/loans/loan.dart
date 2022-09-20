import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/bloc/loan/loan_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/model/loan_model.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:theme_provider/theme_provider.dart';

class ScreenPageLoans extends StatefulWidget {
  final GlobalKey? keyMenu;
  const ScreenPageLoans({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<ScreenPageLoans> createState() => _ScreenPageLoansState();
}

class _ScreenPageLoansState extends State<ScreenPageLoans> {
  @override
  Widget build(BuildContext context) {
    final loanBloc = BlocProvider.of<LoanBloc>(context, listen: true);
    return Scaffold(
      drawer: const MenuDrawer(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: HedersComponent(
              title: 'Mis Prestamos',
              menu: true,
              keyMenu: widget.keyMenu,
              onPressMenu: () {
                debugPrint('hola');
                Scaffold.of(context).openDrawer();
              }),
        ),
        Expanded(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            if (loanBloc.state.existLoan)
              for (var item in loanBloc.state.loan!.payload!) CardLoan(item: item),
          ]),
        ))),
      ]),
    );
  }
}

class CardLoan extends StatelessWidget {
  final Payload item;
  const CardLoan({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
          transitionOnUserGestures: true,
          tag: item.code!,
          child: Material(
              type: MaterialType.transparency,
              child: ContainerComponent(
                  color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(item.code!),
                        Text(item.state!),
                      ],
                    )),
                  )))),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => CardExpanded(item: item),
          ),
        );
      },
    );
  }
}

class CardExpanded extends StatefulWidget {
  final Payload item;
  const CardExpanded({Key? key, required this.item}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: widget.item.code!,
      child: Material(
          type: MaterialType.transparency, // likely needed
          child: Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                  child: HedersComponent(title: widget.item.code!, stateBack: true),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(0.3),
                        2: FlexColumnWidth(5),
                      },
                      border: const TableBorder(
                        horizontalInside: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        tableInfo('Modalidad', widget.item.procedureModality!),
                        tableInfo('Monto', '${widget.item.amountRequested!} Bs.'),
                        tableInfo('Porcentaje de Interés', '${widget.item.interest} %'),
                        tableInfo('Plazos', '${widget.item.loanTerm} meses'),
                        tableInfo('Tipo de pago', widget.item.paymentType!),
                        tableInfo('Destino', widget.item.destinyId!),
                        tableInfo('Apertura', DateFormat(' dd, MMMM yyyy ', "es_ES").format(widget.item.requestDate!)),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ButtonComponent(text: 'VER PLAN DE PAGOS', onPressed: () {}),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(15),
                //   child: ButtonComponent(text: 'KARDEX', onPressed: () {}),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      for (var i = 0; i <= 10; i++)
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ContainerComponent(
                                color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Cuota N° ${i + 1}'),
                                      Table(
                                          columnWidths: const {
                                            0: FlexColumnWidth(5),
                                            1: FlexColumnWidth(0.3),
                                            2: FlexColumnWidth(5),
                                          },
                                          border: const TableBorder(
                                            horizontalInside: BorderSide(
                                              width: 0.5,
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          children: [
                                            tableInfo('Cuota', '{itemx.value}'),
                                            tableInfo('Monto pagado', '{itemx.value}'),
                                            tableInfo('Estado de la cuota', '{itemx.value}'),
                                            tableInfo('PAGADO', '{itemx.value}'),
                                          ]),
                                    ],
                                  )),
                                )))
                    ]),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  TableRow tableInfo(String text, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Manrope'),
        ),
      ),
      const Text(':'),
      Text(
        value,
        style: const TextStyle(fontFamily: 'Manrope'),
      ),
    ]);
  }
}
