import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/headers.dart';
import 'package:muserpol_pvt/components/input.dart';
import 'package:muserpol_pvt/components/dialog_action.dart';

class ModalUpdatePwd extends StatefulWidget {
  final String message;
  final Function(String) onPressed;
  const ModalUpdatePwd(
      {Key? key, required this.message, required this.onPressed})
      : super(key: key);

  @override
  State<ModalUpdatePwd> createState() => _ModalUpdatePwdState();
}

class _ModalUpdatePwdState extends State<ModalUpdatePwd>
    with TickerProviderStateMixin {
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController newPasswordConfirmCtrl = TextEditingController();

  bool hidePassword = true;
  bool hidePasswordConfirm = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body:  Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: HedersComponent(title: widget.message, center: true)),
          Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment : CrossAxisAlignment.start,
                        children: [
                          const Text('Nueva Contraseña:'),
                          InputComponent(
                              textInputAction: TextInputAction.done,
                              controllerText: newPasswordCtrl,
                              onEditingComplete: () => node.nextFocus(),
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  if (value.length >= 6) {
                                    return null;
                                  } else {
                                    return 'Debe tener un mínimo de 6 caracteres.';
                                  }
                                } else {
                                  return 'Ingrese su contraseña';
                                }
                              },
                              keyboardType: TextInputType.text,
                              icon: Icons.lock,
                              labelText: "Contraseña",
                              obscureText: hidePassword,
                              onTap: () =>
                                  setState(() => hidePassword = !hidePassword),
                              iconOnTap: hidePassword
                                  ? Icons.lock_outline
                                  : Icons.lock_open_sharp),
                          SizedBox(
                            height: 10.h,
                          ),
                          const Text('Confirme su contraseña:'),
                          InputComponent(
                              textInputAction: TextInputAction.done,
                              controllerText: newPasswordConfirmCtrl,
                              onEditingComplete: () => updatePassword(),
                              validator: (value) {
                                if (value == newPasswordCtrl.text) {
                                  return null;
                                } else {
                                  return 'No coincide la contraseña';
                                }
                              },
                              keyboardType: TextInputType.text,
                              icon: Icons.lock,
                              labelText: "Contraseña",
                              obscureText: hidePasswordConfirm,
                              onTap: () => setState(() =>
                                  hidePasswordConfirm = !hidePasswordConfirm),
                              iconOnTap: hidePasswordConfirm
                                  ? Icons.lock_outline
                                  : Icons.lock_open_sharp),
                        ],
                      )
                    ],
                  ),
          )),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            child: Row(
                mainAxisAlignment : MainAxisAlignment.spaceBetween ,
                children: [
                  ButtonWhiteComponent(
                      text: 'Cancelar',
                      onPressed: () => _onBackPressed(),
                    ),
                  ButtonComponent(
                      text: 'Actualizar', onPressed: () => updatePassword())
                ],
              ),
          )
        ])));
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ComponentAnimate(
            child: DialogTwoAction(
                message: '¿Deseas salir de la actualización de contraseña?',
                actionCorrect: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                messageCorrect: 'Salir')));
  }

  updatePassword() {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    widget.onPressed(newPasswordConfirmCtrl.text.trim());
  }
}
