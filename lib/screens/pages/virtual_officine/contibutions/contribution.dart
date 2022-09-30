import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/model/biometric_user_model.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/contibutions/tabs_contributions.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
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
      body: Column(children: [
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
                  // add this property
                  debugPrint('asd $newValue');
                  if (newValue == 1) {
                    getContributionPasive(context);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 0,
                    child: Text("Descargar mis aportes como Activo"),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text("Descargar mis aportes como Pasivo"),
                  ),
                ],
              )),
        ),
        !contributionBloc.existContribution ? Container() : const TabsContributions(),
      ]),
    );
  }

  getContributionPasive(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final biometric = biometricUserModelFromJson(await authService.readBiometric());
    setState(() => stateLoading = true);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null, servicePrintLoans(biometric.affiliateId!), true, true);
    setState(() => stateLoading = false);
    if (response != null) {
      String pathFile = await saveFile('Lonas', 'contribucionesPasivo.pdf', response.bodyBytes);
      await OpenFile.open(pathFile);
    }
  }
}
