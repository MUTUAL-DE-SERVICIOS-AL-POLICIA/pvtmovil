import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/model/contribution_model.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/contibutions/card_expanded.dart';
import 'package:theme_provider/theme_provider.dart';

class ContributionsYear extends StatelessWidget {
  final TabController tabController;
  final String year;
  final List<Contribution> contributions;
  const ContributionsYear({
    Key? key,
    required this.year,
    required this.contributions,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return contributions.isNotEmpty
        ? GridView.count(
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
                              color: contributions[index].reimbursementTotal != '0,00' && contributions[index].reimbursementTotal != null
                                  ? const Color(0xffffdead)
                                  : ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
                              child: Center(
                                  child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${contributions[index].state}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(DateFormat('MMMM', "es_ES").format(contributions[index].monthYear!).toUpperCase(),style: TextStyle(fontSize: 15.sp),),
                                  Text('${contributions[index].total} Bs.'),
                                ],
                              )))),
                        ))),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => CardExpanded(index: 'flipcardHero$index', contribution: contributions[index]),
                    ),
                  );
                },
              );
            }),
          )
        : const Center(
            child: Text('Gestión sin aportes'),
          );
  }
}
