import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:provider/provider.dart';

class CardObservation extends StatelessWidget {
  const CardObservation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    debugPrint('app ${appState.messageObservation}');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0xffffdead),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                      json.decode(appState.messageObservation)['message'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black, fontFamily: 'Manrope'),
                    ))
                  ],
                ),
                if (json
                        .decode(appState.messageObservation)['data']['display']
                        .length >
                    0)
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
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        for (var itemx
                            in json.decode(appState.messageObservation)['data']
                                ['display'])
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              child: Text(
                                '${itemx['key']!}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontFamily: 'Manrope'),
                              ),
                            ),
                            const Text(':'),
                            itemx['value'] is List
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var itemy in itemx['value'])
                                        Text(
                                          '• $itemy',
                                          style: const TextStyle(
                                              fontFamily: 'Manrope'),
                                        )
                                    ],
                                  )
                                : Text(
                                    '${itemx['value']}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Manrope'),
                                  ),
                          ]),
                      ]),
              ],
            ),
          )),
    );
  }
}
