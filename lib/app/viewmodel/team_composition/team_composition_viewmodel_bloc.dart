import 'package:bloc/bloc.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/team/teams_repository.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';

import 'package:meta/meta.dart';

part 'team_composition_viewmodel_event.dart';
part 'team_composition_viewmodel_state.dart';

class TeamCompositionViewmodelBloc
    extends Bloc<TeamCompositionViewmodelEvent, TeamCompositionViewmodelState> {
  TeamCompositionViewmodelBloc(this._teamRepository)
      : super(TeamCompositionViewmodelInitial()) {
    on<OnFetchAllCompositions>(_onFetchAllCompositions);
  }

  final TeamsRepository _teamRepository;


  Future<void> _onFetchAllCompositions(
    OnFetchAllCompositions event,
    Emitter emit,
  ) async {
    emit(TeamCompositionViewmodelLoading());
    final response = await _teamRepository.fetchAllCompositions();
    response.fold(
      (onSuccess) => emit(LoadedAllCompositions(compositions: onSuccess)),
      (onFailure) => emit(TeamCompositionError(message: onFailure.toString())),
    );
  }
}
