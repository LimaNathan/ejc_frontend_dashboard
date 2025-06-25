import 'package:ejc_frontend_dashboard/app/data/exceptions/exceptions.dart';
import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/paginated_result.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePeopleService {
  final Supabase _supabase = Supabase.instance;

  AsyncResult<PaginatedResult<PersonModel>> fetchUsersPaginated({
    required int page,
    required int pageSize,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final response = await _supabase.client
        .from('users')
        .select('*, user_teams(*, teams(*))')
        .order('created_at', ascending: false)
        .range(from, to)
        .onError(
          (handleError, stackTrace) => throw AppSupabaseFetchException(
            handleError.toString(),
          ),
        );

    final countResponse =
        await _supabase.client.from('users').select('id').count().onError(
              (handleError, stackTrace) => throw AppSupabaseFetchException(
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

  AsyncResult<Unit> deleteOne(String uuid) async {
    if (uuid.isEmpty) {
      return Failure(AppSupabaseFetchException('UUID não pode ser vazio.'));
    }

    try {
      await _supabase.client //
          .from('user_teams')
          .delete()
          .eq('id', uuid);

      return const Success(unit);
    } catch (e) {
      return Failure(AppSupabaseFetchException(e.toString()));
    }
  }
}
