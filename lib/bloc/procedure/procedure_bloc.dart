import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:muserpol_pvt/model/economic_complement_model.dart';
import 'package:muserpol_pvt/model/procedure_model.dart';

part 'procedure_event.dart';
part 'procedure_state.dart';

class ProcedureBloc extends Bloc<ProcedureEvent, ProcedureState> {
  ProcedureBloc() : super(const ProcedureState()) {
    on<AddCurrentProcedures>((event, emit) {
      if (state.existCurrentProcedures) {
        List<Datum> currentProcedures = [
          ...state.currentProcedures!,
          ...event.currentProcedures
        ];
        emit(state.copyWith(currentProcedures: currentProcedures));
      } else {
        emit(state.copyWith(
            existCurrentProcedures: true,
            currentProcedures: event.currentProcedures));
      }
    });

    on<AddHistoryProcedures>((event, emit) {
      if (state.existHistoricalProcedures) {
        List<Datum> historicalProcedures = [
          ...state.historicalProcedures!,
          ...event.historicalProcedures
        ];
        emit(state.copyWith(historicalProcedures: historicalProcedures));
      } else {
        emit(state.copyWith(
            existHistoricalProcedures: true,
            historicalProcedures: event.historicalProcedures));
      }
    });

    on<UpdateEconomicComplement>((event, emit) => emit(state.copyWith(
        existInfoComplementInfo: true, economicComplementInfo: event.infoEC)));

    on<UpdateCurrentProcedures>((event, emit) =>
        emit(state.copyWith(currentProcedures: event.currentProcedures)));

    on<UpdateStateComplementInfo>((event, emit) =>
        emit(state.copyWith(existInfoComplementInfo: event.state)));

    on<ClearProcedures>((event, emit) => emit(state.copyWith(
        existCurrentProcedures: false,
        currentProcedures: [],
        existHistoricalProcedures: false,
        historicalProcedures: [])));
  }
}
