import 'package:bloc/bloc.dart';
import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/people/people_repository.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/people/paginated_result.dart';
import 'package:meta/meta.dart';

part 'people_viewmodel_event.dart';
part 'people_viewmodel_state.dart';

class PeopleViewmodelBloc
    extends Bloc<PeopleViewmodelEvent, PeopleViewmodelState> {
  PeopleViewmodelBloc(this._peopleRepository)
      : super(PeopleViewmodelInitial()) {
    on<FetchPaginatedPeopleEvent>(_onFetchPaginatedPeople);
    on<OnDeleteOne>(_onDeleteOne);
  }

  final PeopleRepository _peopleRepository;

  Future _onFetchPaginatedPeople(
    FetchPaginatedPeopleEvent event,
    Emitter<PeopleViewmodelState> emit,
  ) async {
    emit(PeopleViewmodelLoading());
    final page = event.page;
    final pageSize = event.pageSize;

    final result = await _peopleRepository //
        .fetchPaginatedUsers(page: page, pageSize: pageSize);

    result.fold(
      (page) => emit(PeopleViewmodelLoaded(page: page)),
      (error) => emit(PeopleViewmodelError(error: error.toString())),
    );
  }

  Future _onDeleteOne(
    OnDeleteOne event,
    Emitter<PeopleViewmodelState> emit,
  ) async {
    final result = await _peopleRepository.deleteOne(event.uuid);

    result.fold(
      (onSuccess) {},
      (error) => emit(PeopleViewmodelError(error: error.toString())),
    );
  }
}
