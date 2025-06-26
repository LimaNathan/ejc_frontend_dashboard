import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/paginated_result.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/people_filter.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class PeopleRepository {
  AsyncResult<PaginatedResult<PersonModel>> fetchPaginatedUsers({
    required int page,
    required int pageSize,
    PeopleFilter? filter,
  });

  AsyncResult<List<PersonModel>> searchPeople(String name);

  AsyncResult<bool> deleteOne(String uuid);
}
