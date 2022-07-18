part of 'user_bloc.dart';

class UserState {
  final bool existUser;
  final User? user;
  final bool controlLive;
  final String? ci;
  final int? procedureId;
  final String? phone;
  final bool stateCam;
  final bool stateBtntoggleCameraLens;
  const UserState(
      {this.existUser = false,
      this.user,
      this.controlLive = false,
      this.ci,
      this.procedureId,
      this.phone,
      this.stateCam = false,
      this.stateBtntoggleCameraLens = true});
  UserState copyWith(
          {bool? existUser,
          User? user,
          bool? controlLive,
          String? ci,
          int? procedureId,
          String? phone,
          bool? stateCam,
          bool? stateBtntoggleCameraLens}) =>
      UserState(
          existUser: existUser ?? this.existUser,
          user: user ?? this.user,
          controlLive: controlLive ?? this.controlLive,
          ci: ci ?? this.ci,
          procedureId: procedureId ?? this.procedureId,
          phone: phone ?? this.phone,
          stateCam: stateCam ?? this.stateCam,
          stateBtntoggleCameraLens:
              stateBtntoggleCameraLens ?? this.stateBtntoggleCameraLens);
}
