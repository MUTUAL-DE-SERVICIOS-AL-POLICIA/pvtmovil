import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muserpol_pvt/bloc/contribution/contribution_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/model/contribution_model.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/contibutions/year.dart';

class TabsContributions extends StatefulWidget {
  const TabsContributions({Key? key}) : super(key: key);

  @override
  State<TabsContributions> createState() => _TabsContributionsState();
}

class _TabsContributionsState extends State<TabsContributions> with TickerProviderStateMixin {
  List<ContributionsTotal> contributionsTotal = [];
  TabController? tabController;
  bool stateSubtract = true;
  bool stateAdd = false;
  @override
  void initState() {
    super.initState();
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: false).state;
    setState(() {
      contributionsTotal = contributionBloc.contribution!.payload!.contributionsTotal!;
      tabController = TabController(vsync: this, length: contributionsTotal.length, initialIndex: contributionsTotal.length - 1);
    });
    tabController!.addListener(() {
      setState(() {
        if (tabController!.index == 0) {
          stateSubtract = false;
        } else {
          stateSubtract = true;
        }
        if (tabController!.index == tabController!.length - 1) {
          stateAdd = false;
        } else {
          stateAdd = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                stateSubtract
                    ? GestureDetector(
                        onTap: () => setState(() => tabController!.animateTo(tabController!.index - 1)),
                        child: Text(contributionsTotal[tabController!.index - 1].year!, style: TextStyle(fontSize: 25.sp)),
                      )
                    : Container(),
                ContainerComponent(
                  color: const Color(0xff419388),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      contributionsTotal[tabController!.index].year!,
                      style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                stateAdd
                    ? GestureDetector(
                        onTap: () => setState(() => tabController!.animateTo(tabController!.index + 1)),
                        child: Text(contributionsTotal[tabController!.index + 1].year!, style: TextStyle(fontSize: 25.sp)),
                      )
                    : Container()
              ],
            )),
        Expanded(
          child: DefaultTabController(
              length: contributionsTotal.length,
              initialIndex: contributionsTotal.length - 1,
              child: TabBarView(
                controller: tabController,
                children: [
                  for (var i = 0; i <= contributionsTotal.length - 1; i++)
                    ContributionsYear(
                      tabController: tabController!,
                      year: '${contributionsTotal[i].year}',
                      contributions: contributionsTotal[i].contributions!,
                    ),
                ],
              )),
        ),
      ],
    ));
  }
}
