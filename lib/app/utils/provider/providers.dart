import 'package:ejc_frontend_dashboard/app/data/repositories/auth/auth_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/auth/remote_auth_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/home/home_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/home/remote_home_repository.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel_bloc.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/home/home_viewmodel_bloc.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers() {
    _providers.addAll(
      [
        Provider<AuthRepository>(
          create: (_) => RemoteAuthRepository(),
        ),
        Provider(
          create: (context) => AuthViewmodelBloc(context.read()),
        ),
        Provider<HomeRepository>(
          create: (context) => RemoteHomeRepository(),
        ),
        Provider(
          create: (context) => HomeViewmodelBloc(context.read()),
        ),
      ],
    );
  }

  final _providers = <Provider>[];

  List<Provider> get providers => _providers;
}
