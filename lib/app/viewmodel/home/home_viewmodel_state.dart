part of 'home_viewmodel_bloc.dart';

@immutable
sealed class HomeViewmodelState {}

final class HomeInitial extends HomeViewmodelState {}

final class HomeLoading extends HomeViewmodelState {}

final class HomeSuccess extends HomeViewmodelState {
  HomeSuccess(this.data);
  final HomeData data;
}

final class HomeError extends HomeViewmodelState {
  HomeError(this.message);
  final String message;
}
