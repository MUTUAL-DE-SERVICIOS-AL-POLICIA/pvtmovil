import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/table_row.dart';
import 'package:muserpol_pvt/model/loan_model.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/loans/card_expanded.dart';

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
                  color: item.state! == 'Vigente' ? const Color.fromARGB(255, 149, 212, 151) : const Color.fromARGB(255, 247, 145, 145),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
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
                            tableInfo('Prestamo', item.code!),
                            tableInfo('Estado', item.state!),
                          ]),
                    ),
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