import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/table_row.dart';
import 'package:muserpol_pvt/model/loan_model.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/loans/card_expanded.dart';
import 'package:theme_provider/theme_provider.dart';

class CardLoan extends StatelessWidget {
  final InProcess? itemProcess;
  final Color? color;
  final Current? itemCurrent;
  const CardLoan({Key? key, this.itemProcess,this.color, this.itemCurrent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
          transitionOnUserGestures: true,
          tag: itemProcess != null ? itemProcess!.code! : itemCurrent!.code!,
          child: Material(
              type: MaterialType.transparency,
              child: ContainerComponent(
                  color: color??ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
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
                            tableInfo(
                                'Prestamo',
                                Text(
                                  itemProcess != null ? itemProcess!.code! : itemCurrent!.code!,
                                  style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                )),
                            tableInfo(
                                'Estado',
                                Text(
                                  itemProcess != null ? itemProcess!.stateName! : itemCurrent!.state!,
                                  style: const TextStyle(color: Colors.black, fontFamily: 'Manrope'),
                                )),
                          ]),
                    ),
                  )))),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => CardExpanded(
                tag: itemProcess != null ? itemProcess!.stateName! : itemCurrent!.state!, inProcess: itemProcess, itemCurrent: itemCurrent),
          ),
        );
      },
    );
  }
}
