import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muserpol_pvt/components/input.dart';

class PhoneNumber extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final bool focusState;
  final Function() onEditingComplete;
  const PhoneNumber({super.key, required this.phoneCtrl, required this.onEditingComplete, this.focusState = false});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Número telefónico:'),
      InputComponent(
        stateAutofocus: focusState,
        textInputAction: TextInputAction.next,
        controllerText: phoneCtrl,
        onEditingComplete: () => onEditingComplete(),
        validator: (value) {
          if (value.isNotEmpty) {
            return null;
          } else {
            return 'Ingrese su número telefónico';
          }
        },
        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.characters,
        icon: Icons.person,
        labelText: "Número de contacto",
      )
    ]);
  }
}
