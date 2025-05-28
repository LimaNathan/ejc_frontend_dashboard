import 'package:bloc/bloc.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/auth/auth_repository.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/auth/credentials.dart';
import 'package:meta/meta.dart';

part 'auth_viewmodel_event.dart';
part 'auth_viewmodel_state.dart';

class AuthViewmodelBloc extends Bloc<AuthViewmodelEvent, AuthViewmodelState> {
  AuthViewmodelBloc(
    this._authRepository,
  ) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
  }
  final AuthRepository _authRepository;

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthViewmodelState> emit,
  ) async {
    emit(AuthLoading());
    final response = await _authRepository.login(event.credentials);

    response.fold(
      (success) {
        emit(AuthSuccess());
      },
      (failure) {
        emit(AuthError(failure.toString()));
      },
    );
  }
}
