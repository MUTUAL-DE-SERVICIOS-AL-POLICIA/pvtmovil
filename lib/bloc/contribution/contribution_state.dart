part of 'contribution_bloc.dart';

class ContributionState {
  final ContributionModel? contribution;
  final bool existContribution;
  const ContributionState({this.contribution, this.existContribution = false});

  ContributionState copyWith({bool? existContribution, ContributionModel? contribution}) =>
      ContributionState(
        existContribution: existContribution ?? this.existContribution,
        contribution: contribution ?? this.contribution);
}
