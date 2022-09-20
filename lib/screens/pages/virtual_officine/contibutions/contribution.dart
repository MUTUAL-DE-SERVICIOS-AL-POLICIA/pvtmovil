import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/contibutions/tabs_contributions.dart';

class ScreenContributions extends StatefulWidget {
  final GlobalKey? keyMenu;
  const ScreenContributions({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<ScreenContributions> createState() => _ScreenContributionsState();
}

class _ScreenContributionsState extends State<ScreenContributions> {
  @override
  Widget build(BuildContext context) {
    final contributionBloc =
        BlocProvider.of<ContributionBloc>(context, listen: true).state;
    return Scaffold(
      drawer: const MenuDrawer(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: HedersComponent(
              title: 'Mis Aportes',
              menu: true,
              keyMenu: widget.keyMenu,
              onPressMenu: () => Scaffold.of(context).openDrawer()),
        ),
        !contributionBloc.existContribution
            ? Container()
            : const TabsContributions()
      ]),
    );
  }
}
