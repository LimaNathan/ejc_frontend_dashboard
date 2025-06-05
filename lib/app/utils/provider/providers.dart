import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers() {
    _providers.addAll(
      [
        Provider<AuthRepository>(create: (_) => RemoteAuthRepository()),
        Provider<HomeRepository>(create: (context) => RemoteHomeRepository()),
        Provider<PeopleRepository>(
          create: (context) => RemotePeopleRepository(),
        ),
        Provider<TeamsRepository>(
          create: (context) => RemoteTeamsRepository(),
        ),
      ],
    );

    _blocProviders.addAll(
      [
        BlocProvider<AuthViewmodelBloc>(
          create: (context) => AuthViewmodelBloc(context.read()),
        ),
        BlocProvider<HomeViewmodelBloc>(
          create: (context) => HomeViewmodelBloc(context.read()),
        ),
        BlocProvider<PeopleViewmodelBloc>(
          create: (context) => PeopleViewmodelBloc(context.read()),
        ),
        BlocProvider<SearchPeopleViewmodelBloc>(
          create: (context) => SearchPeopleViewmodelBloc(context.read()),
        ),
      ],
    );
  }

  final _blocProviders = <BlocProvider>[];

  final _providers = <Provider>[];

  List<Provider> get providers => _providers;
  List<BlocProvider> get blocProviders => _blocProviders;
}
