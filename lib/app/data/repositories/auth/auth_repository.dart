import 'package:ejc_frontend_dashboard/app/domains/dtos/auth/credentials.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRepository {
  AsyncResult<AuthResponse> login(Credentials credentials);
  AsyncResult<Unit> logout();
  AsyncResult<User> getUser();
  AsyncResult<AuthResponse> register(Credentials credentials);
}
