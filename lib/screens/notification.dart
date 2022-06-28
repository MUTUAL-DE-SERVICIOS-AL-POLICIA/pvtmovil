import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/heders.dart';

class ScreenNotification extends StatelessWidget {
  const ScreenNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Column(children: [
              const HedersComponent(title: 'Notificación', stateBack: true),
              Expanded(child: Container()),
            ])));
  }
}
