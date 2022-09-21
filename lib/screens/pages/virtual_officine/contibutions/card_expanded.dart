import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/components/containers.dart';
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
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          child: Center(
            child: Hero(
                tag: widget.index,
                child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContainerComponent(
                        height: MediaQuery.of(context).size.height / 3,
                        width: 300,
                        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                        child: Center(
                          child: SingleChildScrollView(
                              child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(DateFormat(' dd, MMMM yyyy ', "es_ES").format(widget.contribution.monthYear!),
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(widget.contribution.state!, style: const TextStyle(fontWeight: FontWeight.bold))
                                      ],
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
                                          tableInfo('Cotizable', widget.contribution.quotable!),
                                          tableInfo('Fondo de retiro', widget.contribution.retirementFund!),
                                          tableInfo('Cuota mortuoria', widget.contribution.mortuaryQuota!),
                                          tableInfo('Total', widget.contribution.total!),
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
