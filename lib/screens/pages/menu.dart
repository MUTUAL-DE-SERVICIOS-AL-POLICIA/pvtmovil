import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/section_title.dart';
import 'package:muserpol_pvt/dialogs/dialog_action.dart';
import 'package:muserpol_pvt/main.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool colorValue = false;
  bool autentificaction = false;
  String? fullPaths;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (ThemeProvider.themeOf(context).id.contains('dark')) {
        setState(() => colorValue = true);
      }
    });
  }

  bool status = true;
  bool sendNotifications = true;
  bool darkTheme = false;

  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    final userBloc =
        BlocProvider.of<UserBloc>(context, listen: true).state.user;
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image(
                image: AssetImage(
                  ThemeProvider.themeOf(context).id.contains('dark')
                      ? 'assets/images/muserpol-logo.png'
                      : 'assets/images/muserpol-logo2.png',
                ),
              ),
              const Text(
                'Mis datos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconName(
                icon: Icons.person_outline,
                text: userBloc!.fullName!,
              ),
              if (userBloc.degree != null)
                IconName(
                  icon: Icons.local_police_outlined,
                  text: 'GRADO: ${userBloc.degree!}',
                ),
              IconName(
                icon: Icons.contact_page_outlined,
                text: 'C.I.: ${userBloc.identityCard!}',
              ),
              if (userBloc.category != null)
                IconName(
                  icon: Icons.av_timer,
                  text: 'CATEGORÍA: ${userBloc.category!}',
                ),
              IconName(
                icon: Icons.account_balance,
                text: 'GESTORA: ${userBloc.pensionEntity!}',
              ),
              Divider(height: 0.03.sh),
              const Text(
                'Configuración de preferencias',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // SectiontitleSwitchComponent(
              //   title: 'Autenticación',
              //   valueSwitch: autentificaction,
              //   onChangedSwitch: (v) => guardar(v),
              // ),
              SectiontitleSwitchComponent(
                title: 'Tema Oscuro',
                valueSwitch: colorValue,
                onChangedSwitch: (v) => switchTheme(v),
              ),
              Divider(height: 0.03.sh),
              const Text(
                'Configuración general',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SectiontitleComponent(
                  title: 'Políticas de Privacidad',
                  icon: Icons.info_outline,
                  stateLoading: stateLoading,
                  onTap: () => privacyPolicy(context)),

              SectiontitleComponent(
                  title: 'Cerrar Sesión',
                  icon: Icons.info_outline,
                  onTap: () => closeSession(context)),
              Center(
                child: Text('Versión 2.0.9 beta'),
              )
            ],
          ))),
    );
  }

  privacyPolicy(BuildContext context) async {
    setState(() => stateLoading = true);
    var response = await serviceMethod(
        context, 'get', null, serviceGetPrivacyPolicy(), false, true);
    setState(() => stateLoading = false);
    if (response != null) {
      String pathFile = await saveFile(
          context, 'Políticas', 'Política de privacidad.pdf', response);
      await OpenFile.open(pathFile);
    }
  }

  void switchTheme(v) async {
    setState(() {
      colorValue = v;
    });
    ThemeProvider.controllerOf(context).nextTheme();
  }

  void guardar(v) async {
    // setState(() => autentificaction = v);
    // await prefs!.setBool('autentificaction', v);
  }

  closeSession(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ComponentAnimate(
              child: DialogTwoAction(
                  message: '¿Estás seguro que quieres cerrar sesión?',
                  actionCorrect: () => confirmDeleteSession(context),
                  messageCorrect: 'Salir'));
        });
  }

  confirmDeleteSession(BuildContext context) async {
    final procedureBloc =
        BlocProvider.of<ProcedureBloc>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);
    // var response = await serviceMethod( context, 'delete', null, serviceAuthSession(), true);
    // if ( response != null ) {
    prefs!.getKeys();
    for (String key in prefs!.getKeys()) {
      prefs!.remove(key);
    }
    for (var element in appState.files) {
      appState.updateFile(element.id!, null);
    }
    userBloc.add(UpdateCtrlLive(false));
    var appDir = (await getTemporaryDirectory()).path;
    new Directory(appDir).delete(recursive: true);
    authService.logout();
    procedureBloc.add(ClearProcedures());
    appState.updateTabProcedure(0);
    appState.updateStateProcessing(false);
    Navigator.pushReplacementNamed(context, 'login');
    // }
  }
}

class IconName extends StatelessWidget {
  final IconData icon;
  final String text;
  const IconName({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [Icon(icon), Flexible(child: Text(text))],
      ),
    );
  }
}
