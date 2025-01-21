import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRepository {
  AsyncResult<User> login(String email, String password);
}
