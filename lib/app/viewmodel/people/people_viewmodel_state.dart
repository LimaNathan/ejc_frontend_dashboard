part of 'people_viewmodel_bloc.dart';

@immutable
sealed class PeopleViewmodelState {}

final class PeopleViewmodelInitial extends PeopleViewmodelState {}

final class PeopleViewmodelLoading extends PeopleViewmodelState {}

final class PeopleViewmodelLoaded extends PeopleViewmodelState {
  PeopleViewmodelLoaded({required this.page});

  final PaginatedResult<PersonModel> page;
}

final class PeopleViewmodelError extends PeopleViewmodelState {
  PeopleViewmodelError({required this.error});
  final String error;
}
