part of 'search_people_viewmodel_bloc.dart';

@immutable
sealed class SearchPeopleViewmodelEvent {}




class SearchPeopleByNameEvent extends SearchPeopleViewmodelEvent {
  SearchPeopleByNameEvent({
    required this.name,
  });

  final String name;
}
