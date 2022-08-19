import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:flutter/material.dart';

class DialogAction extends StatelessWidget {
  final String message;
  const DialogAction({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ComponentAnimate(
        child: AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        ButtonComponent(
            text: 'Aceptar', onPressed: () => Navigator.pop(context))
      ],
    ));
  }
}

class DialogOneFunction extends StatelessWidget {
  final String title;
  final String message;
  final String textButton;
  final Function() onPressed;
  const DialogOneFunction(
      {Key? key,
      required this.title,
      required this.message,
      required this.textButton,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: ComponentAnimate(
            child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                message,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          actions: <Widget>[
            ButtonComponent(text: textButton, onPressed: () => onPressed())
          ],
        )));
  }

  Future<bool> _onBackPressed() async {
    return false;
  }
}

class DialogTwoAction extends StatelessWidget {
  final String message;
  final Function() actionCorrect;
  final String messageCorrect;

  const DialogTwoAction(
      {Key? key,
      required this.message,
      required this.actionCorrect,
      required this.messageCorrect})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ComponentAnimate(
        child: AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        ButtonWhiteComponent(
          text: 'Cancelar',
          onPressed: () => Navigator.of(context).pop(),
        ),
        ButtonWhiteComponent(
            text: messageCorrect, onPressed: () => actionCorrect())
      ],
    ));
  }
}
