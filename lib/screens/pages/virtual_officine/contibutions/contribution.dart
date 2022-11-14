
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/components/headers.dart';
import 'package:muserpol_pvt/model/biometric_user_model.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/contibutions/tabs_contributions.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';

class ScreenContributions extends StatefulWidget {
  final GlobalKey? keyMenu;
  final GlobalKey keyBottomHeader;
  const ScreenContributions({Key? key, this.keyMenu, required this.keyBottomHeader}) : super(key: key);

  @override
  State<ScreenContributions> createState() => _ScreenContributionsState();
}

class _ScreenContributionsState extends State<ScreenContributions> {
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: true).state;

    return Scaffold(
      drawer: const MenuDrawer(),
      body: Builder(
            builder: (context) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: HedersComponent(
              title: 'Mis Aportes',
              menu: true,
              keyMenu: widget.keyMenu,
              onPressMenu: () => Scaffold.of(context).openDrawer(),
              option: PopupMenuButton(
                key: widget.keyBottomHeader,
                icon: const Icon(Icons.library_books_outlined),
                onSelected: (newValue) {
                  if (newValue == 0) getContributionActive(context);
                  if (newValue == 1) getContributionPasive(context);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Text("Descargar mis aportes como Activo"),
                  ),
                  if (contributionBloc.contribution!.payload!.affiliatePassive!)
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Descargar mis aportes como Pasivo"),
                    ),
                ],
              )),
        ),
        !contributionBloc.existContribution ? Container() : const TabsContributions(),
      ])),
    );
  }

  getContributionPasive(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final biometric = biometricUserModelFromJson(await authService.readBiometric());
    setState(() => stateLoading = true);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null, servicePrintContributionPasive(biometric.affiliateId!), true, false);
    setState(() => stateLoading = false);
    if (response != null) {
      String pathFile = await saveFile('Contributions', 'contribucionesPasivo.pdf', response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }

  getContributionActive(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final biometric = biometricUserModelFromJson(await authService.readBiometric());
    setState(() => stateLoading = true);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null, servicePrintContributionActive(biometric.affiliateId!), true, false);
    setState(() => stateLoading = false);
    if (response != null) {
      String pathFile = await saveFile('Contributions', 'contribucionesActivo.pdf', response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }
}
