import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/main.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:theme_provider/theme_provider.dart';

class ScreenContributions extends StatefulWidget {
  final GlobalKey? keyMenu;
  const ScreenContributions({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<ScreenContributions> createState() => _ScreenContributionsState();
}

class _ScreenContributionsState extends State<ScreenContributions> {
  @override
  Widget build(BuildContext context) {
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
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        height: 37.sp,
                        color: ThemeProvider.themeOf(context).data.hintColor,
                      ),
                    )),
                Text(
                  '2022',
                  style: TextStyle(fontSize: 30.sp),
                ),
                RotationTransition(
                    turns: const AlwaysStoppedAnimation(90 / 180),
                    child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            'assets/icons/back.svg',
                            height: 37.sp,
                            color:
                                ThemeProvider.themeOf(context).data.hintColor,
                          ),
                        ))),
              ],
            )),
        Expanded(
            child: GridView.count(
          padding: const EdgeInsets.only(bottom: 50),
          crossAxisCount: 3,
          children: List.generate(8, (index) {
            return GestureDetector(
              onTap: () {
                debugPrint('HOLA COMO ESTAS');
                getContribution(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ContainerComponent(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('MES'),
                        Text('1600'),
                      ],
                    ))),
              ),
            );
          }),
        ))
      ]),
    );
  }

  getContribution(BuildContext context) async {
    // serviceContributions
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceContributions(prefs!.getInt('idAffiliate')!), true, true);
    if (response != null) {
      debugPrint('${response.body}');
    }
  }
}
