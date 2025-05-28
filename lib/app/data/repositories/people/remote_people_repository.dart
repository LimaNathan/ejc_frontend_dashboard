import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:ejc_frontend_dashboard/app/data/services/services.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/paginated_result.dart';
import 'package:result_dart/result_dart.dart';

class RemotePeopleRepository implements PeopleRepository {
  final SupabasePeopleService _supabasePeopleService = SupabasePeopleService();
  @override
  AsyncResult<PaginatedResult<PersonModel>> fetchPaginatedUsers({
    required int page,
    required int pageSize,
  }) async =>
      _supabasePeopleService.fetchUsersPaginated(
        page: page,
        pageSize: pageSize,
      );
}
