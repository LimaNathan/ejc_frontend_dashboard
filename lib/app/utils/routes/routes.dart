import 'dart:async';

import 'package:ejc_frontend_dashboard/app/data/services/supabase/auth/supabase_auth_service.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/views/auth/login_view.dart';
import 'package:ejc_frontend_dashboard/app/views/home_navigation/home_navigation_view.dart';
import 'package:ejc_frontend_dashboard/app/views/team_composition/team_composition_view.dart';
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
        return const HomeNavigationView();
      },
    ),
    GoRoute(
      path: ConstantRoutes.teamCompositionView,
      name: ConstantRoutes.teamCompositionView,
      redirect: _authRedirect,
      builder: (context, state) {
        return TeamCompositionView(
          team: state.extra! as TeamModel,
        );
      },
    ),
  ],
);

FutureOr<String?> _authRedirect(context, state) {
  final supabaseService = SupabaseAuthService();
  return supabaseService //
      .getUser()
      .fold(
    (onSuccess) => null,
    (onError) {
      return ConstantRoutes.initialRoute;
    },
  );
}
