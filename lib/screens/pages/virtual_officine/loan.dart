import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:theme_provider/theme_provider.dart';

class ScreenLoans extends StatefulWidget {
  final GlobalKey? keyMenu;
  const ScreenLoans({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<ScreenLoans> createState() => _ScreenLoansState();
}

class _ScreenLoansState extends State<ScreenLoans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: HedersComponent(
              title: 'Mis Prestamos',
              menu: true,
              keyMenu: widget.keyMenu,
              onPressMenu: () {
                debugPrint('hola');
                Scaffold.of(context).openDrawer();
              }),
        ),
        Expanded(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: const [
            CardLoan(),
            CardLoan(),
            CardLoan(),
            CardLoan(),
            CardLoan(),
          ]),
        ))),
      ]),
    );
  }
}

class CardLoan extends StatelessWidget {
  const CardLoan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerComponent(
        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('PRES-01'),
              Text('VIGENTE'),
            ],
          )),
        ));
  }
}
