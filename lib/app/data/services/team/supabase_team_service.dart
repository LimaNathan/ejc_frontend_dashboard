import 'dart:async';
import 'dart:developer';

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
          )
          .onError((error, _) {
        log(error.toString());
        throw AppSupabaseFetchException(error.toString());
      });
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
          .insert(members.map((e) => e.toJson()).toList())
          .onError((error, _) {
        log(error.toString());
        throw AppSupabaseFetchException(error.toString());
      });

      return const Success(unit);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  AsyncResult<List<TeamComposition>> getCompositions() async {
    try {
      final response = await _supabase.client
          .from('team_compositions')
          .select()
          .withConverter(
        (data) {
          final compositions = (data as List)
              .map((e) => TeamComposition.fromJson(e as Map<String, dynamic>))
              .toList();

          // Remover duplicados por `teamId`, mantendo o primeiro encontrado
          final uniqueCompositions = <String, TeamComposition>{};
          for (final item in compositions) {
            uniqueCompositions.putIfAbsent(item.teamId, () => item);
          }

          return uniqueCompositions.values.toList();
        },
      ).onError((error, _) {
        log(error.toString());
        throw AppSupabaseFetchException(error.toString());
      });

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
          .from('team_compositions')
          .select(
            'team_id, '
            'user_id, '
            'role, '
            'users(nome, foto, telefones)',
          )
          .eq('team_id', teamId)
          .withConverter(
            (converter) => converter //
                .map(DetailedTeamComposition.fromJson)
                .toList(),
          )
          .onError((error, _) {
        log(error.toString());
        throw AppSupabaseFetchException(error.toString());
      });

      return Success(response);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  AsyncResult<Unit> setUserTeamComposition(TeamComposition team) async {
    try {
      log('adicionando ${team.userId} na equipe ${team.teamId}');
      final convertedTeam = team.toJson();
      await _supabase.client //
          .from('team_compositions')
          .insert(convertedTeam)
          .onError((handleError, s) {
        log(handleError.toString());
        throw AppSupabaseFetchException(handleError.toString());
      });

      log('atualizando pessoa');
      final currentTeam = await _getTeamById(team.teamId);
      log('equipe ${team.teamId} encontrada: ${currentTeam.name}');
      log('atualizando de fato o usuário ${team.userId}');

      await _supabase.client //
          .from('users')
          .update({
            'equipe_atual': currentTeam.name,
          })
          .eq('id', team.userId ?? '')
          .onError((error, _) {
            log(error.toString());
            throw AppSupabaseFetchException(error.toString());
          });

      return const Success(unit);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  AsyncResult<Unit> removeUserTeamComposition(String uuid) async {
    try {
      log('removendo $uuid da equipe atual dele');

      await _supabase.client //
          .from('team_compositions')
          .delete()
          .eq('user_id', uuid)
          .onError((handleError, s) {
        log(handleError.toString());
        throw AppSupabaseFetchException(handleError.toString());
      });

      log('atualizando pessoa');

      await _supabase.client //
          .from('users')
          .update({
            'equipe_atual': '',
          })
          .eq('id', uuid)
          .onError((handleError, s) {
            log(handleError.toString());
            throw AppSupabaseFetchException(handleError.toString());
          });

      return const Success(unit);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  Future<TeamModel> _getTeamById(String uuid) async {
    return _supabase.client
        .from('teams')
        .select()
        .eq('id', uuid)
        .single()
        .withConverter(TeamModel.fromJson)
        .onError((error, _) {
      log(error.toString());
      throw AppSupabaseFetchException(error.toString());
    });
  }
}
