import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:muserpol_pvt/model/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<UpdateUser>((event, emit) =>
        emit(state.copyWith(existUser: true, user: event.user)));
    on<UpdateCtrlLive>(((event, emit) =>
        emit(state.copyWith(controlLive: event.controlLive))));
    on<UpdateCi>((event, emit) => emit(state.copyWith(ci: event.ci)));
    on<UpdateProcedureId>(
        (event, emit) => emit(state.copyWith(procedureId: event.procedureId)));
    on<UpdatePhone>((event, emit) => emit(state.copyWith(phone: event.phone)));
    on<UpdateStateCam>(
        (event, emit) => emit(state.copyWith(stateCam: event.state)));
    on<UpdateStateBtntoggleCameraLens>((event, emit) =>
        emit(state.copyWith(stateBtntoggleCameraLens: event.state)));
    on<UpdateVerifiedDocument>((event, emit) => emit(
        state.copyWith(user: state.user!.copyWith(verified: event.state))));
  }
}
