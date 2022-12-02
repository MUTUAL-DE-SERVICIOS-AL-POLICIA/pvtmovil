import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/loan/loan_bloc.dart';
import 'package:muserpol_pvt/components/headers.dart';
import 'package:muserpol_pvt/screens/pages/virtual_officine/loans/card_loan.dart';

class ScreenPageLoans extends StatefulWidget {
  final GlobalKey keyNotification;
  const ScreenPageLoans({Key? key, required this.keyNotification}) : super(key: key);

  @override
  State<ScreenPageLoans> createState() => _ScreenPageLoansState();
}

class _ScreenPageLoansState extends State<ScreenPageLoans> {
  @override
  Widget build(BuildContext context) {
    final loanBloc = BlocProvider.of<LoanBloc>(context, listen: true);
    return Column(children: [
      HedersComponent(
        keyNotification: widget.keyNotification,
        title: 'Mis Préstamos',
        stateBell: true,
      ),
      Expanded(
          child: SingleChildScrollView(
              child: loanBloc.state.existLoan
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // const Text('Nota: Si UD. cuenta con un prestamo antes de la gestión 2021, no se visualizará'),
                        if (loanBloc.state.loan!.payload!.inProcess!.isNotEmpty)
                          loans('Prestamos en proceso:', [
                            for (var item in loanBloc.state.loan!.payload!.inProcess!) CardLoan(itemProcess: item, color: const Color(0xffB3D4CF))
                          ]),
                        if (loanBloc.state.loan!.payload!.current!.isNotEmpty)
                          loans('Prestamos vigentes:', [for (var item in loanBloc.state.loan!.payload!.current!) CardLoan(itemCurrent: item)]),
                        if (loanBloc.state.loan!.payload!.liquited!.isNotEmpty)
                          loans('Prestamos Liquidados:', [for (var item in loanBloc.state.loan!.payload!.liquited!) CardLoan(itemCurrent: item)]),
                        if (loanBloc.state.loan!.error == 'true') Text(loanBloc.state.loan!.message!)
                      ]),
                    )
                  : Container())),
    ]);
  }

  Widget loans(String text, List<Widget> cards) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(text, style: const TextStyle(fontWeight: FontWeight.bold)), ...cards],
      ),
    );
  }
}
