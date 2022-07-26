import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/heders.dart';

class ScreenWorkFlow extends StatefulWidget {
  const ScreenWorkFlow({Key? key}) : super(key: key);

  @override
  State<ScreenWorkFlow> createState() => _ScreenWorkFlowState();
}

class _ScreenWorkFlowState extends State<ScreenWorkFlow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Column(children: const [
              HedersComponent(title: 'Seguimiento', stateBack: true),
            ])));
  }
}
