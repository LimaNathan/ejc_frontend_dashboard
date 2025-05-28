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
    on<PeopleViewmodelEvent>(_onFetchPaginatedPeople);
  }

  final PeopleRepository _peopleRepository;

  Future<void> _onFetchPaginatedPeople(
    PeopleViewmodelEvent event,
    Emitter<PeopleViewmodelState> emit,
  ) async {
    emit(PeopleViewmodelLoading());
    final page = (event as FetchPaginatedPeople).page;
    final pageSize = event.pageSize;

    final result = await _peopleRepository.fetchPaginatedUsers(
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (page) => emit(PeopleViewmodelLoaded(page: page)),
      (error) => emit(PeopleViewmodelError(error: error.toString())),
    );
  }
}
