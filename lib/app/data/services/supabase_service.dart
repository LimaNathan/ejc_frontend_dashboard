import 'package:ejc_frontend_dashboard/app/data/exceptions/exceptions.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/credentials.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final Supabase _supabase = Supabase.instance;

  AsyncResult<AuthResponse> login(Credentials credentials) async {
    try {
      final response = await _supabase //
          .client
          .auth
          .signInWithPassword(
        email: credentials.email,
        password: credentials.password,
      )
          .onError((handleError, stackTrace) {
        throw AppAuthException(handleError.toString());
      });

      return Success(response);
    } on AppAuthException catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<Unit> logout() async {
    return _supabase //
        .client
        .auth
        .signOut()
        .onError(
          (e, s) async => //
              throw AppAuthException(e.toString(), s),
        )
        .then((value) => const Success(unit));
  }

  AsyncResult<AuthResponse> register(Credentials credentials) async {
    return _supabase //
        .client
        .auth
        .signUp(email: credentials.email, password: credentials.password)
        .onError(
          (e, s) async => //
              throw AppAuthException(e.toString(), s),
        )
        .then(Success.new);
  }

  AsyncResult<User> getUser() async {
    final session = _supabase.client.auth.currentSession;

    if (session != null) return Success(session.user);

    return Failure(AppAuthException('Não existe nenhuma sessão ativa.'));
  }
}
