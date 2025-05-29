part of 'search_people_viewmodel_bloc.dart';

@immutable
sealed class SearchPeopleViewmodelState {}

final class SearchPeopleViewmodelInitial extends SearchPeopleViewmodelState {}

final class SearchPeopleViewmodelLoading extends SearchPeopleViewmodelState {}

final class SearchPeopleViewmodelLoaded extends SearchPeopleViewmodelState {
  SearchPeopleViewmodelLoaded({required this.people});

  final List<PersonModel> people;
}

final class SearchPeopleViewmodelError extends SearchPeopleViewmodelState {
  SearchPeopleViewmodelError({required this.error});
  final String error;
}
