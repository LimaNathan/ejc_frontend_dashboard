import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_data.freezed.dart';

@freezed
abstract class HomeData with _$HomeData {
  factory HomeData({
    int? totalAnswers,
    int? totalAnswersUntilThreeDays,
    List<PersonModel>? lastAnswers,
  }) = _HomeData;
}
