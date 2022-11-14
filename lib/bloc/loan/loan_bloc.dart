import 'package:bloc/bloc.dart';
import 'package:muserpol_pvt/model/loan_model.dart';

part 'loan_event.dart';
part 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc() : super(const LoanState()) {
    on<UpdateLoan>((event, emit) => emit(state.copyWith(existLoan: true, loan: event.loan)));
    on<ClearLoans>((event, emit) => emit(state.copyWith(existLoan: false)));
  }
}
