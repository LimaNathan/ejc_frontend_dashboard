import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_data.freezed.dart';

@freezed
abstract class HomeData with _$HomeData {
  factory HomeData({int? totalAnswers, int? totalAnswersUntilThreeDays}) =
      _HomeData;
}
