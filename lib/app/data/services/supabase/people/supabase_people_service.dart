import 'package:ejc_frontend_dashboard/app/data/exceptions/exceptions.dart';
import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/paginated_result.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/people_filter.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePeopleService {
  final Supabase _supabase = Supabase.instance;

  AsyncResult<PaginatedResult<PersonModel>> fetchUsersPaginated({
    required int page,
    required int pageSize,
    PeopleFilter? filter,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final response = await _supabase.client
        .from('users')
        .select('*, user_teams(*, teams(*))')
        .match(filter != null ? filter.toJson() : {})
        .ilike('nome', '%${filter?.nome ?? ''}%')
        .order('created_at', ascending: false)
        .range(from, to)
        .onError(
          (handleError, _) => throw AppSupabaseFetchException(
            handleError.toString(),
          ),
        );

    final countResponse = await _supabase.client //
        .from('users')
        .select('id')
        .match(filter != null ? filter.toJson() : {})
        .ilike('nome', '%${filter?.nome ?? ''}%')
        .count()
        .onError(
          (handleError, _) => throw AppSupabaseFetchException(
            handleError.toString(),
          ),
        );

    final totalItems = countResponse.count;
    final totalPages = (totalItems / pageSize).ceil();

    final items = response.map(PersonModel.fromJson).toList();

    return Success(
      PaginatedResult<PersonModel>(
        items: items,
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: page,
        pageSize: pageSize,
      ),
    );
  }

  AsyncResult<List<PersonModel>> lastFiveAwnsersByName(String name) async {
    try {
      final response = await _supabase.client
          .from('users')
          .select('*, user_teams(*, teams(*))')
          .ilike('nome', '%$name%')
          .order('created_at', ascending: false)
          .limit(5);

      return Success(response.map(PersonModel.fromJson).toList());
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }

  AsyncResult<bool> deleteOne(String uuid) async {
    try {
      await _supabase.client //
          .from('user_teams')
          .delete()
          .eq('user_id', uuid)
          .select();

      final user = await _supabase.client //
          .from('users')
          .delete()
          .eq('id', uuid)
          .select();

      return Success(user.isNotEmpty);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }
}
