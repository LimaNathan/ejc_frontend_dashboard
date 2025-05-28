import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';

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
        Provider<PeopleRepository>(
          create: (context) => RemotePeopleRepository(),
        ),
        Provider(
          create: (context) => PeopleViewmodelBloc(context.read()),
        ),
      ],
    );
  }

  final _providers = <Provider>[];

  List<Provider> get providers => _providers;
}
