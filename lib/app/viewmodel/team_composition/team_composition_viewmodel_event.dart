part of 'team_composition_viewmodel_bloc.dart';

@immutable
sealed class TeamCompositionViewmodelEvent {}


final class OnFetchTeamCompositionByTeamId
    extends TeamCompositionViewmodelEvent {
  OnFetchTeamCompositionByTeamId({required this.uuid});
  final String uuid;
}

final class OnFetchAllCompositions extends TeamCompositionViewmodelEvent {}

final class OnSendNewTeamComposition extends TeamCompositionViewmodelEvent {
  OnSendNewTeamComposition({required this.teamComposition});

  final List<TeamComposition> teamComposition;
}
