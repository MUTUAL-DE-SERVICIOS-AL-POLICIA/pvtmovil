import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/model/contribution_model.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:theme_provider/theme_provider.dart';

class ScreenContributions extends StatefulWidget {
  final GlobalKey? keyMenu;
  const ScreenContributions({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<ScreenContributions> createState() => _ScreenContributionsState();
}

class _ScreenContributionsState extends State<ScreenContributions> with TickerProviderStateMixin {
  DateTime dateTime = DateTime.now();
  int countItems = 1;
  TabController? tabController;
  // int countTabs = 0;
  @override
  void initState() {
    super.initState();
    // final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: false).state;
    tabController = TabController(vsync: this, length: 0);
    tabController!.addListener(() {
      // setState(() {
      //   _selectedIndex = _controller.index;
      // });
      setState(() {});
      debugPrint("Selected Index: ${tabController!.index}");
    });
    // tabController = TabController(vsync: this, length: 0);
    // if (contributionBloc.existContribution) {
    //   countTabs = int.parse(contributionBloc.contribution!.payload!.yearMax!) - int.parse(contributionBloc.contribution!.payload!.yearMin!) + 1;
    //   tabController = TabController(vsync: this, length: countTabs);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: true).state;
    var count = 0;
    if (contributionBloc.existContribution) {
      count = int.parse(contributionBloc.contribution!.payload!.yearMax!) - int.parse(contributionBloc.contribution!.payload!.yearMin!) + 1;
      tabController = TabController(vsync: this, length: count, initialIndex: count - 1);
    }
    return Scaffold(
      drawer: const MenuDrawer(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: HedersComponent(title: 'Mis Aportes', menu: true, keyMenu: widget.keyMenu, onPressMenu: () => Scaffold.of(context).openDrawer()),
        ),
        !contributionBloc.existContribution && count == 0
            ? Container()
            : Expanded(
                child: DefaultTabController(
                    length: count,
                    initialIndex: count - 1,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        for (var i = 0; i <= count - 1; i++)
                          CtrlYear(year: '${dateTime.year - count + i + 1}', contributions: contributionBloc.contribution!.payload!.contributions!)
                      ],
                    )))
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

  // callDialogAction(BuildContext context,String tag) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => Hero(
  //         tag:tag,
  //         child: DialogActions(tag:tag)));
  // }
}

class CtrlYear extends StatelessWidget {
  final String year;
  final List<Contribution> contributions;
  const CtrlYear({Key? key, required this.year, required this.contributions}) : super(key: key);

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
                    year,
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
                              color: ThemeProvider.themeOf(context).data.hintColor,
                            ),
                          ))),
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
                                color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${contributions[index].state}'),
                                    Text(DateFormat('MMMM', "es_ES").format(contributions[index].monthYear!).toUpperCase()),
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

class CardExpanded extends StatefulWidget {
  final String id;
  const CardExpanded({Key? key, required this.id}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          child: Center(
            child: Hero(
                tag: widget.id,
                child: Material(
                    type: MaterialType.transparency, // likely needed
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContainerComponent(
                          height: 200,
                          width: 300,
                          color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [Text('data')],
                          ))),
                    ))),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
