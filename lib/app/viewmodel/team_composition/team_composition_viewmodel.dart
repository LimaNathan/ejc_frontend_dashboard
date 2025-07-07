import 'package:ejc_frontend_dashboard/app/data/repositories/team/teams_repository.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class TeamCompositionViewmodel extends ChangeNotifier {
  TeamCompositionViewmodel(this._teamRepository);
  final TeamsRepository _teamRepository;

  late final onFetchAllCompositionCommand = Command0(_fetchAllCompositions);
  late final onFetchTeamsCommand = Command0(_fetchTeams);
  late final onAddToTeam = Command1(_setUserTeamComposition);
  late final onFindTeamCompositionById = Command1(_fetchTeamById);
  late final onRemoveUserTeamComposition = Command1(_removeUserTeamComposition);

  AsyncResult<List<DetailedTeamComposition>> _fetchTeamById(String uuid) {
    return _teamRepository.fetchTeamById(uuid);
  }

  AsyncResult<List<TeamComposition>> _fetchAllCompositions() async {
    return _teamRepository.fetchAllCompositions();
  }

  AsyncResult<List<TeamModel>> _fetchTeams() async {
    return _teamRepository.fetchTeams();
  }

  AsyncResult<Unit> _setUserTeamComposition(TeamComposition team) {
    return _teamRepository.setUserTeamComposition(team).whenComplete(
      () {
        onFetchAllCompositionCommand.execute();
      },
    );
  }

  AsyncResult<Unit> _removeUserTeamComposition(String uuid) {
    return _teamRepository.removeUserTeamComposition(uuid);
  }
}
