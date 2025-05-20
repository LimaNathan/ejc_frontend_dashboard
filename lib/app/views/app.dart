import 'package:ejc_frontend_dashboard/app/utils/provider/providers.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/routes.dart';
import 'package:ejc_frontend_dashboard/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final providersSource = Providers();
    return MultiProvider(
      providers: providersSource.providers,
      child: MaterialApp.router(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context) //
                .colorScheme
                .inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: routes,
      ),
    );
  }
}
