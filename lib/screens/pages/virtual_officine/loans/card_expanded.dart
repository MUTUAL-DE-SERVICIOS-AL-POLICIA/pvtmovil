import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/headers.dart';
import 'package:muserpol_pvt/components/table_row.dart';
import 'package:muserpol_pvt/model/loan_model.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:theme_provider/theme_provider.dart';

class CardExpanded extends StatefulWidget {
  final String tag;
  final InProcess? inProcess;
  final Current? itemCurrent;
  const CardExpanded({Key? key, required this.tag, this.inProcess, this.itemCurrent}) : super(key: key);

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
                tag: widget.tag,
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
                                title: widget.inProcess != null ? widget.inProcess!.code! : widget.itemCurrent!.code!,
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
                                              2: FlexColumnWidth(6),
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
                                              if (widget.inProcess != null)
                                                tableInfo(
                                                    'Tipo de trámite',
                                                    Text(
                                                      widget.inProcess!.procedureTypeName!,
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                    )),
                                              if (widget.itemCurrent != null)
                                                tableInfo(
                                                    'Modalidad',
                                                    Text(
                                                      widget.itemCurrent!.procedureModality!,
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                    )),
                                              if (widget.itemCurrent != null)
                                                tableInfo(
                                                    'Monto',
                                                    Text(
                                                      '${widget.itemCurrent!.amountRequested!} Bs.',
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                    )),
                                              if (widget.itemCurrent != null)
                                                tableInfo(
                                                    'Porcentaje de Interés',
                                                    Text(
                                                      '${widget.itemCurrent!.interest} %',
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                    )),
                                              if (widget.itemCurrent != null)
                                                tableInfo(
                                                    'Plazos',
                                                    Text(
                                                      '${widget.itemCurrent!.loanTerm} meses',
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                    )),
                                              if (widget.itemCurrent != null)
                                                tableInfo(
                                                    'Tipo de pago',
                                                    Text(
                                                      widget.itemCurrent!.paymentType!,
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                    )),
                                              if (widget.itemCurrent != null)
                                                tableInfo(
                                                    'Destino',
                                                    Text(
                                                      widget.itemCurrent!.destinyId!,
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                    )),
                                              if (widget.itemCurrent != null)
                                                tableInfo(
                                                    'Apertura',
                                                    Text(
                                                      DateFormat(' dd, MMMM yyyy ', "es_ES").format(widget.itemCurrent!.requestDate!),
                                                      style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                    )),
                                            ]),
                                      ),
                                      if (widget.itemCurrent != null)
                                        !stateLoading
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      getLoanPlan(context, widget.itemCurrent!.id!);
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
                                                   GestureDetector(
                                                    onTap: () {
                                                      getLoanKardex(context, widget.itemCurrent!.id!);
                                                    },
                                                    child: const ContainerComponent(
                                                    color: Color(0xff419388),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Text(
                                                        'KARDEX',
                                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                      ),
                                                    ),
                                                  )),
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
    var response = await serviceMethod(mounted, context, 'get', null, servicePrintLoans(loanId), true, true);
    setState(() => stateLoading = false);
    if (response != null) {
      String pathFile = await saveFile('Loans', 'plandepagos.pdf', response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }
  getLoanKardex(BuildContext context, int loanId) async {
    setState(() => stateLoading = true);
    var response = await serviceMethod(mounted, context, 'get', null, servicePrintKadex(loanId), true, true);
    setState(() => stateLoading = false);
    if (response != null) {
      String pathFile = await saveFile('Loans', 'kardex.pdf', response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }
}
