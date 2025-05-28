import 'package:ejc_frontend_dashboard/app/data/repositories/home/home_repository.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/home/home_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:result_dart/result_dart.dart';

part 'home_viewmodel_event.dart';
part 'home_viewmodel_state.dart';

class HomeViewmodelBloc extends Bloc<HomeViewmodelEvent, HomeViewmodelState> {
  HomeViewmodelBloc(this._homeRepository) : super(HomeInitial()) {
    on<FetchAllDataEvent>(_onFetchAllData);
  }

  final HomeRepository _homeRepository;

  Future<void> _onFetchAllData(
    FetchAllDataEvent event,
    Emitter<HomeViewmodelState> emit,
  ) async {
    emit(HomeLoading());

    final totalAwnsers = await _homeRepository //
        .fetchAllAwnsers()
        .fold(
      (onSuccess) => onSuccess,
      (onError) {
        emit(HomeError(onError.toString()));
        return;
      },
    );
    final untilThreeDaysAwnswers = await _homeRepository //
        .fetchLastUntilThreeDaysAnwsers()
        .fold(
      (onSuccess) => onSuccess,
      (onError) {
        emit(HomeError(onError.toString()));
        return;
      },
    );

    final lastAnswers = await _homeRepository //
        .fetchLastFivePersons()
        .fold(
      (onSuccess) => onSuccess,
      (onError) {
        emit(HomeError(onError.toString()));
        return;
      },
    );

    final homeData = HomeData(
      totalAnswers: totalAwnsers,
      totalAnswersUntilThreeDays: untilThreeDaysAwnswers,
      lastAnswers: lastAnswers,
    );
    emit(HomeSuccess(homeData));
  }
}
