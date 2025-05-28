part of 'auth_viewmodel_bloc.dart';

@immutable
sealed class AuthViewmodelState {}

final class AuthInitial extends AuthViewmodelState {}

final class AuthLoading extends AuthViewmodelState {}

final class AuthSuccess extends AuthViewmodelState {}

final class AuthUnlogged extends AuthViewmodelState {}

final class AuthError extends AuthViewmodelState {
  AuthError(this.message);
  final String message;
}
