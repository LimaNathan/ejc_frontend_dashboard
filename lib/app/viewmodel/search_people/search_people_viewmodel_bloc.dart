import 'package:bloc/bloc.dart';
import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/people/people_repository.dart';
import 'package:meta/meta.dart';

part 'search_people_viewmodel_event.dart';
part 'search_people_viewmodel_state.dart';

class SearchPeopleViewmodelBloc
    extends Bloc<SearchPeopleViewmodelEvent, SearchPeopleViewmodelState> {
  SearchPeopleViewmodelBloc(this._peopleRepository)
      : super(SearchPeopleViewmodelInitial()) {
    on<SearchPeopleByNameEvent>(_onSearchPeopleByName);
  }

  final PeopleRepository _peopleRepository;

  Future<void> _onSearchPeopleByName(
    SearchPeopleByNameEvent event,
    Emitter<SearchPeopleViewmodelState> emit,
  ) async {
    emit(SearchPeopleViewmodelLoading());
    final result = await _peopleRepository //
        .searchPeople(event.name);
    result.fold(
      (people) => emit(SearchPeopleViewmodelLoaded(people: people)),
      (error) => emit(
        SearchPeopleViewmodelError(
          error: error.toString(),
        ),
      ),
    );
  }
}
