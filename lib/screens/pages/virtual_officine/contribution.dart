import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:theme_provider/theme_provider.dart';

class ScreenContributions extends StatefulWidget {
  final GlobalKey? keyMenu;
  const ScreenContributions({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<ScreenContributions> createState() => _ScreenContributionsState();
}

class _ScreenContributionsState extends State<ScreenContributions> {
  DateTime dateTime = DateTime.now();
  int countItems = 1;
  @override
  Widget build(BuildContext context) {
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: true).state;
    return Scaffold(
      drawer: const MenuDrawer(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: HedersComponent(title: 'Mis Aportes', menu: true, keyMenu: widget.keyMenu, onPressMenu: () => Scaffold.of(context).openDrawer()),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () => subtractYear(),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        height: 37.sp,
                        color: ThemeProvider.themeOf(context).data.hintColor,
                      ),
                    )),
                Text(
                  '${dateTime.year}',
                  style: TextStyle(fontSize: 30.sp),
                ),
                RotationTransition(
                    turns: const AlwaysStoppedAnimation(90 / 180),
                    child: GestureDetector(
                        onTap: () => addYear(),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            'assets/icons/back.svg',
                            height: 37.sp,
                            color: ThemeProvider.themeOf(context).data.hintColor,
                          ),
                        ))),
              ],
            )),
        !contributionBloc.existContribution
            ? Center()
            : Expanded(
                child: countItems>0?GridView.count(
                padding: const EdgeInsets.only(bottom: 50),
                crossAxisCount: 3,
                children: List.generate(
                    contributionBloc.contribution!.payload!.contributions!.where((e) => e.monthYear!.year == dateTime.year).length, (index) {
                  // return Center():
                  return GestureDetector(
                          onTap: () {
                            debugPrint('HOLA COMO ESTAS');
                            getContribution(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ContainerComponent(
                                color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${contributionBloc.contribution!.payload!.contributions!.where((e) => e.monthYear!.year == dateTime.year).toList()[index].state}'),
                                    Text(DateFormat('MMMM', "es_ES").format(contributionBloc.contribution!.payload!.contributions!
                                        .where((e) => e.monthYear!.year == dateTime.year)
                                        .toList()[index]
                                        .monthYear!).toUpperCase()),
                                    Text(
                                        '${contributionBloc.contribution!.payload!.contributions!.where((e) => e.monthYear!.year == dateTime.year).toList()[index].total} Bs.'),
                                  ],
                                ))),
                          ),
                        );
                }),
              ):const Center(child: Text('Sin Aportes'),))
      ]),
    );
  }

  getContribution(BuildContext context) async {
    // serviceContributions
  }

  subtractYear() {
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: false).state;
    setState(() {
      dateTime = DateTime(dateTime.year - 1);
      countItems = contributionBloc.contribution!.payload!.contributions!.where((e) => e.monthYear!.year == dateTime.year).length;
    });
    
  }

  addYear() {
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: false).state;
    if (DateTime.now().year > dateTime.year) {
    setState(() {
      dateTime = DateTime(dateTime.year + 1);
      countItems = contributionBloc.contribution!.payload!.contributions!.where((e) => e.monthYear!.year == dateTime.year).length;
    });
    }
  }
}
