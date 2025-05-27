import 'package:result_dart/result_dart.dart';

abstract interface class HomeRepository {
  AsyncResult<int> fetchAllAwnsers();
  AsyncResult<int> fetchLastUntilThreeDaysAnwsers();
}
