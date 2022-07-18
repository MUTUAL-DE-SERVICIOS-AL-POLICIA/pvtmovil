import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/button.dart';

class CupertinoPickerWidget extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String) onEvent;
  const CupertinoPickerWidget(
      {Key? key,
      required this.title,
      required this.items,
      required this.onEvent})
      : super(key: key);

  @override
  State<CupertinoPickerWidget> createState() => _CupertinoPickerWidgetState();
}

class _CupertinoPickerWidgetState extends State<CupertinoPickerWidget> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      color: Colors.white,
      child: Scaffold(
          body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonWhiteComponent(
                text: 'Cancelar',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                },
              ),
              Text(widget.title),
              ButtonWhiteComponent(
                text: 'Elegir',
                onPressed: () {
                  widget.onEvent(widget.items[value]);
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                },
              )
            ],
          ),
          Expanded(
            child: CupertinoPicker(
              magnification: 1.5,
              backgroundColor: Colors.white,
              itemExtent: 50, //height of each item
              children: widget.items
                  .map((item) => Center(
                        child: Text(
                          item,
                        ),
                      ))
                  .toList(),
              onSelectedItemChanged: (index) => setState(() => value = index),
            ),
          ),
        ],
      )),
    );
  }
}
