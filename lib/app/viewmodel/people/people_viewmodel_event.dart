part of 'people_viewmodel_bloc.dart';

@immutable
sealed class PeopleViewmodelEvent {}

class FetchPaginatedPeopleEvent extends PeopleViewmodelEvent {
  FetchPaginatedPeopleEvent({
    required this.page,
    required this.pageSize,
  });

  final int page;
  final int pageSize;
}
