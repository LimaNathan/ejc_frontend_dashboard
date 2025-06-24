import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/auth/credentials.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewmodel with ChangeNotifier {
  AuthViewmodel(this._authRespository);

  final AuthRepository _authRespository;

  late final loginCommand = Command1(_login);
  late final logoutCommand = Command0(_logout);

  AsyncResult<AuthResponse> _login(Credentials credentials) {
    return _authRespository.login(credentials);
  }

  AsyncResult<Unit> _logout() {
    return _authRespository.logout();
  }
}
