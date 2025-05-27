import 'dart:async';

import 'package:ejc_frontend_dashboard/app/data/services/supabase_service.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/views/auth/login_view.dart';
import 'package:ejc_frontend_dashboard/app/views/home/home_view.dart';
import 'package:go_router/go_router.dart';
import 'package:result_dart/result_dart.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: ConstantRoutes.initialRoute,
      builder: (context, state) {
        return const LoginView();
      },
    ),
    GoRoute(
      path: ConstantRoutes.homeView,
      redirect: _authRedirect,
      builder: (context, state) {
        return const HomeView();
      },
    ),
  ],
);

FutureOr<String?> _authRedirect(context, state) {
  final supabaseService = SupabaseService();
  return supabaseService //
      .getUser()
      .fold(
    (onSuccess) => null,
    (onError) {
      return ConstantRoutes.initialRoute;
    },
  );
}
