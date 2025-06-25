import 'package:ejc_frontend_dashboard/app/data/repositories/repositories.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
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
        ChangeNotifierProvider(
          create: (context) => HomeViewmodel(context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => PeopleViewmodel(context.read(), context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchPeopleViewmodel(context.read()),
        ),
      ],
    );
  }

  final _providers = <SingleChildWidget>[];

  List<SingleChildWidget> get providers => _providers;
}
