import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class Providers {
  Providers() {
    _providers.addAll(
      [
        //* Repositories

        Provider<AuthRepository>(create: (_) => RemoteAuthRepository()),
        Provider<HomeRepository>(create: (context) => RemoteHomeRepository()),
        Provider<PeopleRepository>(
          create: (context) => RemotePeopleRepository(),
        ),
        Provider<TeamsRepository>(
          create: (context) => RemoteTeamsRepository(),
        ),

        //* View Models
        ChangeNotifierProvider(
          create: (context) => AuthViewmodel(context.read()),
        ),
      ],
    );

    _blocProviders.addAll(
      [
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

  final _providers = <SingleChildWidget>[];

  List<SingleChildWidget> get providers => _providers;
  List<BlocProvider> get blocProviders => _blocProviders;
}
