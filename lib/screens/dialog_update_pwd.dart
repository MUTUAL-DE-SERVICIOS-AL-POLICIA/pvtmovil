import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/input.dart';

class DialogUpdatePwd extends StatefulWidget {
  final String message;
  final Function(String) onPressed;
  const DialogUpdatePwd(
      {Key? key, required this.message, required this.onPressed})
      : super(key: key);

  @override
  State<DialogUpdatePwd> createState() => _DialogUpdatePwdState();
}

class _DialogUpdatePwdState extends State<DialogUpdatePwd> {
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController newPasswordConfirmCtrl = TextEditingController();

  bool hidePassword = true;
  bool hidePasswordConfirm = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return ComponentAnimate(
        child: AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height:  170,
                child: SingleChildScrollView(
                          child: Column(children: [
                const Text('Nueva Contraseña:'),
                InputComponent(
                    textInputAction: TextInputAction.done,
                    controllerText: newPasswordCtrl,
                    onEditingComplete: () => node.nextFocus(),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        if (value.length >= 4) {
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
                    onTap: () => setState(() => hidePassword = !hidePassword),
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
                      if (value.isNotEmpty) {
                        if (value.length >= 4) {
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
                    onTap: () => setState(
                        () => hidePasswordConfirm = !hidePasswordConfirm),
                    iconOnTap: hidePasswordConfirm
                        ? Icons.lock_outline
                        : Icons.lock_open_sharp)])),
              )
            ],
          )),
      actions: <Widget>[
        ButtonWhiteComponent(
          text: 'Cancelar',
          onPressed: () => Navigator.of(context).pop(),
        ),
        ButtonWhiteComponent(
            text: 'Actualizar', onPressed: () => updatePassword())
      ],
    ));
  }

  updatePassword() {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    widget.onPressed(newPasswordConfirmCtrl.text.trim());
  }
}
