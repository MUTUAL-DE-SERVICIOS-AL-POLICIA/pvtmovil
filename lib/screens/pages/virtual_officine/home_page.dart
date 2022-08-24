import 'package:flutter/material.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
class PageHome extends StatefulWidget {
  final GlobalKey? keyMenu;
  const PageHome({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const MenuDrawer(),
      body: Builder(
            builder: (context) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                    child: HedersComponent(
                        title: 'Oficina Virtual',
                        menu: true,
                        keyMenu: widget.keyMenu,
                        onPressMenu: () => Scaffold.of(context).openDrawer()),
                  )])
      ),
    );
  }
}