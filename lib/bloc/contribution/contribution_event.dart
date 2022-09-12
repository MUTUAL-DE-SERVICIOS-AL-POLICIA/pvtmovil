part of 'contribution_bloc.dart';


abstract class ContributionEvent {}

class UpdateContributions extends ContributionEvent {
  final ContributionModel contribution;

  UpdateContributions(this.contribution);
}