import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/headers.dart';
import 'package:muserpol_pvt/components/table_row.dart';
import 'package:muserpol_pvt/model/contribution_model.dart';
import 'package:theme_provider/theme_provider.dart';

class CardExpanded extends StatefulWidget {
  final String index;
  final Contribution contribution;
  const CardExpanded({Key? key, required this.index, required this.contribution}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
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
                tag: widget.index,
                child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContainerComponent(
                        height: MediaQuery.of(context).size.height / 2.5,
                        width: 300,
                        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                        child: Center(
                          child: SingleChildScrollView(
                              child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: HedersComponent(
                                        titleHeader: widget.contribution.state!,
                                        title: DateFormat(' dd, MMMM yyyy ', "es_ES").format(widget.contribution.monthYear!),
                                        stateBack: true,
                                      ),
                                    ),
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
                                          tableInfo(
                                              'Cotizable',
                                              Text(
                                                widget.contribution.quotable!,
                                                style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                              )),
                                          if (widget.contribution.state == 'ACTIVO')
                                            tableInfo(
                                                'Fondo de retiro',
                                                Text(
                                                  widget.contribution.retirementFund!,
                                                  style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                )),
                                          if (widget.contribution.state == 'ACTIVO')
                                            tableInfo(
                                                'Cuota mortuoria',
                                                Text(
                                                  widget.contribution.mortuaryQuota!,
                                                  style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                                )),
                                          tableInfo(
                                              'Total',
                                              Text(
                                                widget.contribution.total!,
                                                style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                              )),
                                          if (widget.contribution.state == 'ACTIVO')
                                          tableInfo(
                                              'Total con reintegro',
                                              Text(
                                                '${widget.contribution.reimbursementTotal!} Bs',
                                                style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                              )),
                                        ])
                                  ]))),
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
}
