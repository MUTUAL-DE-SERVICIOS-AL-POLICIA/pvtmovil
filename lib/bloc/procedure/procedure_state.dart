part of 'procedure_bloc.dart';

class ProcedureState {
  final bool existCurrentProcedures;
  final List<Datum>? currentProcedures;

  final bool existHistoricalProcedures;
  final List<Datum>? historicalProcedures;

  final bool existInfoComplementInfo;
  final EconomicComplementModel? economicComplementInfo;

  const ProcedureState(
      {this.existCurrentProcedures = false,
      this.currentProcedures,
      this.existHistoricalProcedures = false,
      this.historicalProcedures,
      this.existInfoComplementInfo = false,
      this.economicComplementInfo});

  ProcedureState copyWith(
          {bool? existCurrentProcedures,
          List<Datum>? currentProcedures,
          bool? existHistoricalProcedures,
          List<Datum>? historicalProcedures,
          bool? existInfoComplementInfo,
          EconomicComplementModel? economicComplementInfo}) =>
      ProcedureState(
          existCurrentProcedures:
              existCurrentProcedures ?? this.existCurrentProcedures,
          currentProcedures: currentProcedures ?? this.currentProcedures,
          existHistoricalProcedures:
              existHistoricalProcedures ?? this.existHistoricalProcedures,
          historicalProcedures:
              historicalProcedures ?? this.historicalProcedures,
          existInfoComplementInfo:
              existInfoComplementInfo ?? this.existInfoComplementInfo,
          economicComplementInfo:
              economicComplementInfo ?? this.economicComplementInfo);
}
