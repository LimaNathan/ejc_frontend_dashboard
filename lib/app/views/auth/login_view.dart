import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:ejc_frontend_dashboard/app/utils/overlays/loading_overlay.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel.dart';
import 'package:ejc_frontend_dashboard/app/views/auth/components/auth_form.dart';
import 'package:ejc_frontend_dashboard/app/views/auth/components/login_backgroud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final AuthViewmodel authViewmodel;

  @override
  void initState() {
    super.initState();

    authViewmodel = context //
        .read<AuthViewmodel>();

    authViewmodel.loginCommand.addListener(_listener);
  }

  void _listener() {
    final result = authViewmodel.loginCommand.value;

    final isLoading = result.isRunning;
    WidgetsBinding //
        .instance
        .addPostFrameCallback((_) {
      if (isLoading) {
        LoadingOverlay.show(context);
      } else {
        LoadingOverlay.hide();
        result.when(
          data: (value) => context.go(ConstantRoutes.homeView),
          orElse: () {},
          failure: (exception) {
            showCustomSnackbar(
              context,
              message: exception.toString(),
              type: SnackbarType.error,
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    authViewmodel.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context) //
          .colorScheme
          .onPrimary,
      body: const Center(
        child: Row(
          children: [
            LoginBackground(),
            AuthForm(),
          ],
        ),
      ),
    );
  }
}
