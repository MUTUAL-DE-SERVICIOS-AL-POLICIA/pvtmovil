part of 'procedure_bloc.dart';

abstract class ProcedureEvent {}

class AddCurrentProcedures extends ProcedureEvent {
  final List<Datum> currentProcedures;

  AddCurrentProcedures(this.currentProcedures);
}

class UpdateCurrentProcedures extends ProcedureEvent {
  final List<Datum> currentProcedures;

  UpdateCurrentProcedures(this.currentProcedures);
}

class AddHistoryProcedures extends ProcedureEvent {
  final List<Datum> historicalProcedures;

  AddHistoryProcedures(this.historicalProcedures);
}

class UpdateEconomicComplement extends ProcedureEvent {
  final EconomicComplementModel infoEC;

  UpdateEconomicComplement(this.infoEC);
}

class UpdateStateComplementInfo extends ProcedureEvent {
  final bool state;

  UpdateStateComplementInfo(this.state);
}

class ClearProcedures extends ProcedureEvent {
  ClearProcedures();
}
