import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ejc_frontend_dashboard/app/utils/images/app_images.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType}, $change', name: 'onChange');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('${bloc.runtimeType}, $error, $stackTrace', name: 'onError');

    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  await Supabase.initialize(
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    url: const String.fromEnvironment('SUPABASE_URL'),
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );

  // Pré-carrega os SVGs para melhor performance
  await _precacheSvgs();

  usePathUrlStrategy();

  runApp(await builder());
}

Future<void> _precacheSvgs() async {
  final svgAssets = [
    AppImages.cafezinhoSVG,
    AppImages.comprasSVG,
    AppImages.cozinhaSVG,
    AppImages.gaconsSVG,
    AppImages.liturgiaSVG,
    AppImages.minimercadoSVG,
    AppImages.ordemSVG,
    AppImages.salaSVG,
    AppImages.secretariaSVG,
    AppImages.vigiliaSVG,
  ];

  for (final asset in svgAssets) {
    try {
      final loader = SvgAssetLoader(asset);
      await svg.cache.putIfAbsent(
        asset,
        () => loader.loadBytes(null),
      );
    } catch (e, stack) {
      log(
        'Erro ao pré-carregar SVG: $asset',
        error: e,
        stackTrace: stack,
      );
    }
  }
}
