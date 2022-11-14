import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/loan/loan_bloc.dart';
import 'package:muserpol_pvt/components/headers.dart';
import 'package:muserpol_pvt/screens/pages/menu.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/loans/card_loan.dart';

class ScreenPageLoans extends StatefulWidget {
  final GlobalKey? keyMenu;
  const ScreenPageLoans({Key? key, this.keyMenu}) : super(key: key);

  @override
  State<ScreenPageLoans> createState() => _ScreenPageLoansState();
}

class _ScreenPageLoansState extends State<ScreenPageLoans> {
  @override
  Widget build(BuildContext context) {
    final loanBloc = BlocProvider.of<LoanBloc>(context, listen: true);
    return Scaffold(
      drawer: const MenuDrawer(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: HedersComponent(title: 'Mis Prestamos', menu: true, keyMenu: widget.keyMenu, onPressMenu: () => Scaffold.of(context).openDrawer()),
        ),
        Expanded(
            child: Center(
                child: SingleChildScrollView(
                    child: loanBloc.state.existLoan
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              if (loanBloc.state.loan!.payload!.inProcess!.isNotEmpty)
                                loans('Prestamos en proceso:', [
                                  for (var item in loanBloc.state.loan!.payload!.inProcess!)
                                    CardLoan(itemProcess: item, color: const Color(0xffffdead))
                                ]),
                              if (loanBloc.state.loan!.payload!.current!.isNotEmpty)
                                loans('Prestamos vigentes:', [for (var item in loanBloc.state.loan!.payload!.current!) CardLoan(itemCurrent: item)]),
                              if (loanBloc.state.loan!.payload!.liquited!.isNotEmpty)
                                loans(
                                    'Prestamos Liquidados:', [for (var item in loanBloc.state.loan!.payload!.liquited!) CardLoan(itemCurrent: item)]),
                              if (loanBloc.state.loan!.error == 'true') Text(loanBloc.state.loan!.message!)
                            ]),
                          )
                        : Container()))),
      ]),
    );
  }

  Widget loans(String text, List<Widget> cards) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [Text(text,style: const TextStyle(fontWeight: FontWeight.bold)), ...cards],
      ),
    );
  }
}
