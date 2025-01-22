import 'package:ejc_frontend_dashboard/app/data/exceptions/exceptions.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/auth/auth_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/services/supabase_service.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/credentials.dart';
import 'package:ejc_frontend_dashboard/app/domains/validators/credentials_validator.dart';
import 'package:ejc_frontend_dashboard/app/utils/extensions/lucid_validator_extension.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  AsyncResult<AuthResponse> login(Credentials credentials) async {
    try {
      final validator = CredentialsValidator();
      return validator //
          .validateResult(credentials)
          .flatMap(_supabaseService.login);
    } catch (e, s) {
      return Failure(AppAuthException(e.toString(), s));
    }
  }

  @override
  AsyncResult<Unit> logout() async {
    try {
      return _supabaseService.logout();
    } catch (e, s) {
      return Failure(AppAuthException(e.toString(), s));
    }
  }

  @override
  AsyncResult<AuthResponse> register(Credentials credentials) async {
    try {
      final validator = CredentialsValidator();
      return validator //
          .validateResult(credentials)
          .flatMap(_supabaseService.register);
    } catch (e, s) {
      return Failure(AppAuthException(e.toString(), s));
    }
  }

  @override
  AsyncResult<User> getUser() async {
    return _supabaseService.getUser();
  }
}
