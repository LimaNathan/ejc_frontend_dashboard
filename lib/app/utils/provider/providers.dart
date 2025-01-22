import 'package:ejc_frontend_dashboard/app/data/repositories/auth/auth_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/auth/remote_auth_repository.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers() {
    _providers.addAll(
      [
        Provider<AuthRepository>(create: (_) => RemoteAuthRepository()),
        Provider<AuthViewModel>(create: (_) => AuthViewModel()),
      ],
    );
  }

  final _providers = <Provider>[];

  List<Provider> get providers => _providers;
}
