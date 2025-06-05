part of 'team_composition_viewmodel_bloc.dart';

@immutable
sealed class TeamCompositionViewmodelState {}

final class TeamCompositionViewmodelInitial
    extends TeamCompositionViewmodelState {}

final class TeamCompositionViewmodelLoading
    extends TeamCompositionViewmodelState {}

final class TeamCompositionError extends TeamCompositionViewmodelState {
  TeamCompositionError({required this.message});
  final String message;
}

final class TeamCompositionLoaded extends TeamCompositionViewmodelState {
  TeamCompositionLoaded({required this.team});
  final DetailedTeamComposition team;
}

final class LoadedAllTeams extends TeamCompositionViewmodelState {
  LoadedAllTeams({required this.teams});
  final List<TeamModel> teams;
}

final class LoadedAllCompositions extends TeamCompositionViewmodelState {
  LoadedAllCompositions({required this.compositions});
  final List<TeamComposition> compositions;
}
