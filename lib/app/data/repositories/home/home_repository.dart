import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class HomeRepository {
  AsyncResult<int> fetchAllAwnsers();
  AsyncResult<int> fetchLastUntilThreeDaysAnwsers();
  AsyncResult<List<PersonModel>> fetchLastFivePersons();
  void listenToUserChanges(void Function(Map<String, dynamic>) onChange);
}
