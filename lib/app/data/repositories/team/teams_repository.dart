import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:result_dart/result_dart.dart';

abstract class TeamsRepository {
  AsyncResult<List<TeamModel>> fetchTeams();

  AsyncResult<List<DetailedTeamComposition>> fetchTeamById(String uuid);

  AsyncResult<List<TeamComposition>> fetchAllCompositions();

  AsyncResult<Unit> setUserTeamComposition(TeamComposition team);
}
