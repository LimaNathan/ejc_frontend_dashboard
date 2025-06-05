part of 'fetch_teams_bloc.dart';

@immutable
sealed class FetchTeamState {}

final class FetchTeamInitial extends FetchTeamState {}

final class FetchTeamSuccess extends FetchTeamState {
  FetchTeamSuccess(this.teams);
  final List<TeamModel> teams;
}

final class FetchTeamError extends FetchTeamState {
  FetchTeamError({required this.error});
  final String error;
}
