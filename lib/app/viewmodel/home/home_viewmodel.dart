import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewmodel with ChangeNotifier {
  HomeViewmodel(this._homeRepository) {
    _homeRepository.listenToUserChanges((payload) {
      fetchAllAwnsersCommand.execute();
      fetchLastFivePersonsCommand.execute();
      fetchLastUntilThreeDaysAnwsersCommand.execute();
    });
  }
  final HomeRepository _homeRepository;

  late final fetchAllAwnsersCommand = Command0<int>(_fetchAllAwnsersCommand);
  late final fetchLastUntilThreeDaysAnwsersCommand =
      Command0<int>(_fetchLastUntilThreeDaysAnwsers);
  late final fetchLastFivePersonsCommand =
      Command0<List<PersonModel>>(_fetchLastFivePersons);

  AsyncResult<int> _fetchAllAwnsersCommand() async {
    return _homeRepository.fetchAllAwnsers();
  }

  AsyncResult<int> _fetchLastUntilThreeDaysAnwsers() async {
    return _homeRepository.fetchLastUntilThreeDaysAnwsers();
  }

  AsyncResult<List<PersonModel>> _fetchLastFivePersons() async {
    return _homeRepository.fetchLastFivePersons();
  }
}
