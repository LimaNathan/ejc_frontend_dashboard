import 'package:ejc_frontend_dashboard/app/utils/provider/providers.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/routes.dart';
import 'package:ejc_frontend_dashboard/app/utils/theme/theme_data.dart';
import 'package:ejc_frontend_dashboard/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final providersSource = Providers();
    final themeData = CustomThemeData();
    return MultiProvider(
      providers: providersSource.providers,
      child: ShadApp.material(
        theme: ShadThemeData(
          brightness: Brightness.light,
          colorScheme: const ShadZincColorScheme.light(),
        ),
        builder: (context, theme) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: routes,
            theme: themeData.value(context, size),
          );
        },
      ),
    );
  }
}
