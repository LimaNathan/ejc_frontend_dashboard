import 'dart:isolate';

import 'package:ejc_frontend_dashboard/app/data/exceptions/exceptions.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTeamService {
  final _supabase = Supabase.instance;

  AsyncResult<List<TeamModel>> getTeams() async {
    try {
      final response = await _supabase //
          .client
          .from('teams')
          .select()
          .withConverter(
            (teams) => teams //
                .map(TeamModel.fromJson)
                .toList(),
          );
      return Success(response);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  AsyncResult<Unit> insertTeamCompositions(
    List<TeamComposition> members,
  ) async {
    try {
      await _supabase //
          .client
          .from('team_composition')
          .insert(members.map((e) => e.toJson()).toList());

      return const Success(unit);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  AsyncResult<List<TeamComposition>> getCompositions() async {
    try {
      final response = await _supabase //
          .client
          .from('team_compositions')
          .select()
          .withConverter(
            (teams) => teams //
                .map(TeamComposition.fromJson)
                .toList(),
          );
      return Success(response);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  AsyncResult<List<DetailedTeamComposition>> getCompositionByTeamId(
    String teamId,
  ) async {
    try {
      final response = await _supabase.client
          .from('team_composition')
          .select(
            'team_id, '
            'user_id, '
            'role, '
            'users(nome, foto, telefones)',
          )
          .eq(
            'team_id',
            teamId,
          );

      return Success(
        response //
            .map(DetailedTeamComposition.fromJson)
            .toList(),
      );
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  AsyncResult<Unit> setUserTeamComposition(TeamComposition team) async {
    try {
      await _supabase.client //
          .from('team_composition')
          .insert(team.toJson());

      await Isolate.run(() async {
        final currentTeam = await _supabase.client
            .from('teams')
            .select()
            .eq('id', team.teamId)
            .single()
            .withConverter(TeamModel.fromJson);

        await _supabase.client //
            .from('users')
            .update({
          'equipe_atual': currentTeam.name,
        }).eq('id', team.userId);
      });

      return const Success(unit);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }
}
