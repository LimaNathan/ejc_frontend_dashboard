import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/views/auth/login_view.dart';
import 'package:ejc_frontend_dashboard/app/views/home/home_view.dart';
import 'package:go_router/go_router.dart';

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
      builder: (context, state) {
        return const HomeView();
      },
    ),
  ],
);
