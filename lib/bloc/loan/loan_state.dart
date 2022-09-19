part of 'loan_bloc.dart';

class LoanState {
  final LoanModel? loan;

  final bool existLoan;

  const LoanState({this.loan, this.existLoan = false});

  LoanState copyWith({bool? existLoan, LoanModel? loan}) => LoanState(existLoan: existLoan ?? this.existLoan, loan: loan ?? this.loan);
}
