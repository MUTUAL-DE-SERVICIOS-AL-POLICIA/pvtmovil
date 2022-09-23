import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/components/table_row.dart';
import 'package:muserpol_pvt/model/loan_model.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:theme_provider/theme_provider.dart';

class CardExpanded extends StatefulWidget {
  final Payload item;
  const CardExpanded({Key? key, required this.item}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.5),
        body: GestureDetector(
          child: Center(
            child: Hero(
                tag: widget.item.code!,
                child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContainerComponent(
                        height: MediaQuery.of(context).size.height / 1.7,
                        width: MediaQuery.of(context).size.width,
                        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                              child: HedersComponent(
                                title: widget.item.code!,
                                stateBack: true,
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Table(
                                            columnWidths: const {
                                              0: FlexColumnWidth(4),
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
                                      !stateLoading
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    getLoanPlan(context, widget.item.id!);
                                                  },
                                                  child: const ContainerComponent(
                                                    color: Color(0xff419388),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Text(
                                                        'PLAN DE PAGOS',
                                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const ContainerComponent(
                                                  color: Color(0xff419388),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Text(
                                                      'KARDEX',
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Center(
                                              child: Image.asset(
                                                'assets/images/load.gif',
                                                fit: BoxFit.cover,
                                                height: 15.sp,
                                              ),
                                            ),
                                    ])),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  getLoanPlan(BuildContext context, int loanId) async {
    setState(() => stateLoading = true);
    var response = await serviceMethod(mounted, context, 'get', null, servicePrintLoans(loanId), false, true);
    setState(() => stateLoading = false);
    if (response != null) {
      String pathFile = await saveFile('Lonas', 'plandepagos.pdf', response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }
}
