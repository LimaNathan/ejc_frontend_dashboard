import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/paginated_result.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/people_filter.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class PeopleViewmodel extends ChangeNotifier {
  PeopleViewmodel(this._peopleRepository, this._homeRepository) {
    _homeRepository.listenToUserChanges((payload) {});
  }

  final PeopleRepository _peopleRepository;
  final HomeRepository _homeRepository;
  late final onFetchPaginatedPeopleCommand = Command2(_fetchPaginated);

  late final onDeleteOne = Command1(_onDeleteOne);

  AsyncResult<PaginatedResult<PersonModel>> _fetchPaginated(
    ({int page, int size}) pageable, [
    PeopleFilter? filter,
  ]) async {
    return _peopleRepository.fetchPaginatedUsers(
      page: pageable.page,
      pageSize: pageable.size,
      filter: filter,
    );
  }

  AsyncResult<bool> _onDeleteOne(String uuid) async {
    return _peopleRepository.deleteOne(uuid);
  }
}
