import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/model/contribution_model.dart';
import 'package:theme_provider/theme_provider.dart';

class ContributionsYear extends StatelessWidget {
  final TabController tabController;
  final String year;
  final List<Contribution> contributions;
  final bool stateSubtract;
  final bool stateAdd;
  final Function() subtractYear;
  final Function() addYear;
  const ContributionsYear(
      {Key? key,
      required this.year,
      required this.contributions,
      required this.tabController,
      required this.stateSubtract,
      required this.stateAdd,
      required this.subtractYear,
      required this.addYear})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: stateSubtract,
                    child: GestureDetector(
                        onTap: () => subtractYear(),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            'assets/icons/back.svg',
                            height: 37.sp,
                            color:
                                ThemeProvider.themeOf(context).data.hintColor,
                          ),
                        )),
                  ),
                  Text(
                    year,
                    style: TextStyle(fontSize: 30.sp),
                  ),
                  Visibility(
                    visible: stateAdd,
                    child: RotationTransition(
                        turns: const AlwaysStoppedAnimation(90 / 180),
                        child: GestureDetector(
                            onTap: () => addYear(),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(
                                'assets/icons/back.svg',
                                height: 37.sp,
                                color: ThemeProvider.themeOf(context)
                                    .data
                                    .hintColor,
                              ),
                            ))),
                  ),
                ],
              )),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.only(bottom: 50),
              crossAxisCount: 3,
              children: List.generate(contributions.length, (index) {
                return GestureDetector(
                  child: Hero(
                      tag: 'flipcardHero$index',
                      child: Material(
                          type: MaterialType.transparency, // likely needed
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ContainerComponent(
                                color: ThemeProvider.themeOf(context)
                                    .data
                                    .scaffoldBackgroundColor,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${contributions[index].state}'),
                                    Text(DateFormat('MMMM', "es_ES")
                                        .format(contributions[index].monthYear!)
                                        .toUpperCase()),
                                    Text('${contributions[index].total} Bs.'),
                                  ],
                                ))),
                          ))),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   PageRouteBuilder(
                    //     opaque: false,
                    //     pageBuilder: (_, __, ___) => CardExpanded(id: 'flipcardHero$index'),
                    //   ),
                    // );
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
