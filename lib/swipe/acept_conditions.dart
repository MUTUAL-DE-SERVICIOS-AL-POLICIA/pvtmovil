import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ModalAceptTermin extends StatefulWidget {
  const ModalAceptTermin({Key? key}) : super(key: key);

  @override
  State<ModalAceptTermin> createState() => _ModalAceptTerminState();
}

class _ModalAceptTerminState extends State<ModalAceptTermin> {
  bool stateTermsConditions = false;
  bool stateNotificationsPush = false;
  bool btnAccess = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: Column(children: [
                  const HedersComponent(title: 'Terminos y Condiciones', stateBack: true),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            btnAccess
                                ? OptionTermCondition(
                                    onChanged: (val) => setState(() => stateTermsConditions = !stateTermsConditions),
                                    state: stateTermsConditions,
                                    child: GestureDetector(
                                      onTap: () => privacyPolicy(context),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(text: 'Acepto ', style: TextStyle(color: ThemeProvider.themeOf(context).data.primaryColorDark, fontSize: 17.sp)),
                                        TextSpan(
                                            text: 'Términos y condiciones ',
                                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 17.sp)),
                                        TextSpan(
                                            text: 'de uso de la aplicación móvil "MUSERPOL PVT"',
                                            style: TextStyle(color: ThemeProvider.themeOf(context).data.primaryColorDark, fontSize: 17.sp))
                                      ])),
                                    ),
                                  )
                                : Center(
                                    child: Image.asset(
                                    'assets/images/load.gif',
                                    fit: BoxFit.cover,
                                    height: 20,
                                  )),
                            OptionTermCondition(
                              onChanged: (val) => setState(() => stateNotificationsPush = !stateNotificationsPush),
                              state: stateNotificationsPush,
                              child: const Text('Acepto que me envien notificaciones push'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonComponent(
                        text: 'INGRESAR',
                        onPressed: stateTermsConditions && stateNotificationsPush ? () =>  getInto(context): null),
                  ),
                ]))));
  }

  privacyPolicy(BuildContext context) async {
    setState(() => btnAccess = false);

    var response = await serviceMethod(mounted, context, 'get', null, serviceGetPrivacyPolicy(), false, false);
    setState(() => btnAccess = true);
    if (response != null) {
      String pathFile = await saveFile('Documents', 'MUSERPOL_POLITICA_PRIVACIDAD.pdf', response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }
  getInto(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.firstTime(context);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, 'switch');
  }
}

class OptionTermCondition extends StatelessWidget {
  final Function(bool) onChanged;
  final bool state;
  final Widget child;
  const OptionTermCondition({Key? key, required this.onChanged, required this.state, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Checkbox(value: state, onChanged: (val) => onChanged(val!)), Flexible(child: child)],
    );
  }
}
