import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/components/input.dart';

class IdentityCard extends StatelessWidget {
  final bool dniComplement;
  final TextEditingController dniCtrl;
  final TextEditingController dniComCtrl;
  final FocusScopeNode node;
  final Function(BuildContext) selectDate;
  final FocusNode textSecondFocusNode;
  const IdentityCard(
      {Key? key,
      required this.dniComplement,
      required this.dniCtrl,
      required this.dniComCtrl,
      required this.node,
      required this.selectDate,
      required this.textSecondFocusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: InputComponent(
            textInputAction: TextInputAction.next,
            controllerText: dniCtrl,
            onEditingComplete: () => dniComplement ? node.nextFocus() : selectDate(context),
            validator: (value) {
              if (value.length > 3) {
                return null;
              } else {
                return 'Ingrese su cédula de indentidad';
              }
            },
            inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.characters,
            icon: Icons.person,
            labelText: "Cédula de indentidad",
          ),
        ),
        if (dniComplement)
          Text(
            '  _  ',
            style: TextStyle(fontSize: 15.sp, color: const Color(0xff419388)),
          ),
        if (dniComplement)
          SizedBox(
            width: MediaQuery.of(context).size.width / 3.4,
            child: InputComponent(
              focusNode: textSecondFocusNode,
              textInputAction: TextInputAction.next,
              controllerText: dniComCtrl,
              inputFormatters: [LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
              onEditingComplete: () => selectDate(context),
              validator: (value) {
                if (value.isNotEmpty) {
                  return null;
                } else {
                  return 'complemento';
                }
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              icon: Icons.person,
              labelText: "Complemento",
            ),
          ), //container
      ], //widget
    );
  }
}
