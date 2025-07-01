import 'package:ejc_frontend_dashboard/app/data/repositories/team/teams_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/services/team/supabase_team_service.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:result_dart/result_dart.dart';

class RemoteTeamsRepository implements TeamsRepository {
  final SupabaseTeamService _supabaseTeamService = SupabaseTeamService();

  @override
  AsyncResult<List<TeamComposition>> fetchAllCompositions() {
    return _supabaseTeamService.getCompositions();
  }

  @override
  AsyncResult<List<DetailedTeamComposition>> fetchTeamById(String uuid) {
    return _supabaseTeamService.getCompositionByTeamId(uuid);
  }

  @override
  AsyncResult<List<TeamModel>> fetchTeams() {
    return _supabaseTeamService.getTeams();
  }

  @override
  AsyncResult<Unit> setUserTeamComposition(TeamComposition team) {
    return _supabaseTeamService.setUserTeamComposition(team);
  }

  @override
  AsyncResult<Unit> removeUserTeamComposition(String uuid) {
    return _supabaseTeamService.removeUserTeamComposition(uuid);
  }
}
