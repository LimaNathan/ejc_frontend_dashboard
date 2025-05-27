part of 'auth_viewmodel_bloc.dart';

@immutable
sealed class AuthViewmodelEvent {}

class LoginEvent extends AuthViewmodelEvent {
  LoginEvent(this.credentials);
  final Credentials credentials;
}
