import 'package:ejc_frontend_dashboard/app/utils/provider/providers.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/routes.dart';
import 'package:ejc_frontend_dashboard/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final providersSource = Providers();
    return MultiProvider(
      providers: providersSource.providers,
      child: MultiBlocProvider(
        providers: providersSource.blocProviders,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: routes,
          theme: ThemeData(
            colorSchemeSeed: const Color.fromARGB(255, 241, 87, 64),
            useMaterial3: true,
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headlineSmall: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              bodySmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              activeIndicatorBorder: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll<Size>(
                  Size(size.width * 0.3, 50),
                ),
                shape: WidgetStatePropertyAll<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll<Size>(
                  Size(size.width * 0.3, 50),
                ),
                shape: WidgetStatePropertyAll<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context) //
                  .colorScheme
                  .inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
