import 'package:muserpol_pvt/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogBack extends StatelessWidget {
  const DialogBack({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Column(
        children: const [
          Text(
            '¿Estás seguro de salir de Muserpol?',
          ),
        ],
      ),
      actions: <Widget>[
        ButtonWhiteComponent(
            text: 'Salir',
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop')),
        ButtonWhiteComponent(
          text: 'Cancelar',
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
