part of 'home_viewmodel_bloc.dart';

@immutable
sealed class HomeViewmodelEvent {}

class FetchAllDataEvent extends HomeViewmodelEvent {}
