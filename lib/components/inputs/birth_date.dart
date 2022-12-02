import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/components/button.dart';

class BirthDate extends StatefulWidget {
  final bool dateState;
  final DateTime currentDate;
  final Function(String, DateTime, String) selectDate;
  final String dateCtrl;
  const BirthDate({Key? key, required this.dateState, required this.currentDate, required this.selectDate, required this.dateCtrl}) : super(key: key);

  @override
  State<BirthDate> createState() => _BirthDateState();
}

class _BirthDateState extends State<BirthDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fecha de nacimiento:'),
        ButtonDate(text: widget.dateCtrl, onPressed: () => select(context)),
        if (widget.dateState)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Ingrese su fecha de nacimiento',
              style: TextStyle(color: Colors.red, fontSize: 15.sp),
            ),
          ),
      ],
    );
  }

  select(BuildContext context) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[_buildDateTimePicker()],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Elegir'),
              onPressed: () {
                widget.selectDate(
                  DateFormat(' dd, MMMM yyyy ', "es_ES").format(widget.currentDate),
                  widget.currentDate,
                  DateFormat('yyyy-MM-dd').format(widget.currentDate));
                Navigator.of(context, rootNavigator: true).pop("Discard");
                FocusScope.of(context).unfocus();
              },
            ),
          );
        });
  }

  Widget _buildDateTimePicker() {
    return SizedBox(
        height: 200,
        child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: widget.currentDate,
            onDateTimeChanged: (DateTime newDataTime) {
              widget.selectDate(
                DateFormat(' dd, MMMM yyyy ', "es_ES").format(newDataTime),
                newDataTime,
                DateFormat('dd-MM-yyyy').format(newDataTime));
            }));
  }
}
