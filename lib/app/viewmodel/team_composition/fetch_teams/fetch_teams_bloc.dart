import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:result_dart/result_dart.dart';

part 'fetch_team_event.dart';
part 'fetch_team_state.dart';

class FetchTeamBloc extends Bloc<FetchTeamEvent, FetchTeamState> {
  FetchTeamBloc(this._repository) : super(FetchTeamInitial()) {
    on<OnFetchAllTeams>((event, emit) async {
      await _repository.fetchTeams().fold(
        (onSuccess) {
          emit(FetchTeamSuccess(onSuccess));
        },
        (onError) {
          emit(FetchTeamError(error: onError.toString()));
        },
      );
    });
  }

  final TeamsRepository _repository;
}
