import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class SearchPeopleViewmodel extends ChangeNotifier {
  SearchPeopleViewmodel(this._peopleRepository);
  final PeopleRepository _peopleRepository;

  late final onSeachPeopleByNameCommand = Command1(_onSearchPeopleByName);

  AsyncResult<List<PersonModel>> _onSearchPeopleByName(String name) {
    return _peopleRepository.searchPeople(name);
  }
}
