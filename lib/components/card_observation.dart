import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/table_row.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:provider/provider.dart';

class CardObservation extends StatelessWidget {
  const CardObservation({super.key});

  @override
  Widget build(BuildContext context) {
    final observationState = Provider.of<ObservationState>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Text(
                json.decode(observationState.messageObservation)['message'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Manrope'),
              ))
            ],
          ),
          if (json
                  .decode(observationState.messageObservation)['data']['display']
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
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  for (var itemx in json
                      .decode(observationState.messageObservation)['data']['display'])
                    tableInfo(
                      '${itemx['key']!}',
                      itemx['value'] is List
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var itemy in itemx['value'])
                                  Text(
                                    '• $itemy',
                                    style:
                                        const TextStyle(fontFamily: 'Manrope'),
                                  )
                              ],
                            )
                          : Text(
                              '${itemx['value']}',
                              style: const TextStyle(
                                  color: Colors.black, fontFamily: 'Manrope'),
                            ),
                    ),
                ]),
        ],
      ),
    );
  }
}
