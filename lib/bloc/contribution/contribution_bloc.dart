import 'package:bloc/bloc.dart';
import 'package:muserpol_pvt/model/contribution_model.dart';

part 'contribution_event.dart';
part 'contribution_state.dart';

class ContributionBloc extends Bloc<ContributionEvent, ContributionState> {
  ContributionBloc() : super(const ContributionState()) {
    on<UpdateContributions>((event, emit) => emit(state.copyWith(existContribution: true, contribution: event.contribution)));
    on<ClearContributions>((event, emit) => emit(state.copyWith(existContribution: false)));
  }
}
