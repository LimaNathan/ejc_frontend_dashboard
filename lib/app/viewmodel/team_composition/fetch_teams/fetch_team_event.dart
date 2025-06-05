part of 'fetch_teams_bloc.dart';

@immutable
sealed class FetchTeamEvent {}

final class OnFetchAllTeams extends FetchTeamEvent {}
