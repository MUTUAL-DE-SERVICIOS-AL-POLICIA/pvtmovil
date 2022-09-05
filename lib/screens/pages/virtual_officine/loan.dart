import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:theme_provider/theme_provider.dart';

class ScreenPageLoans extends StatefulWidget {
  final GlobalKey? keyMenu;
  const ScreenPageLoans({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<ScreenPageLoans> createState() => _ScreenPageLoansState();
}

class _ScreenPageLoansState extends State<ScreenPageLoans> {
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
          child: Column(children: [
            for (var i = 0; i <= 10; i++) CardLoan(index: i),
          ]),
        ))),
      ]),
    );
  }
}

class CardLoan extends StatelessWidget {
  final int index;
  const CardLoan({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenLoan(index: index)));
      },
      child: ContainerComponent(
          color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('$index'),
                Hero(tag: index, child: Text('$index')),
                const Text('VIGENTE'),
              ],
            )),
          )),
    );
  }
}

class ScreenLoan extends StatelessWidget {
  final int index;
  const ScreenLoan({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Hero(tag:index,child: Text('$index'))),
    );
  }
}
