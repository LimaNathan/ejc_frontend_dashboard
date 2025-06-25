import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:ejc_frontend_dashboard/app/utils/overlays/loading_overlay.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel_bloc.dart';
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




  @override
  Widget build(BuildContext context) {


    final authViewmodel = context.watch<AuthViewmodel>();
    final result = authViewmodel.loginCommand.result;
    final isLoading = authViewmodel.loginCommand.isRunning;




if(isLoading) {
  WidgetsBinding //
              .instance
              .addPostFrameCallback((_) => LoadingOverlay.show(context));
              }
              else{
                LoadingOverlay.hide();
              }

    return BlocBuilder<AuthViewmodelBloc, AuthViewmodelState>(
      builder: (context, state) {
        if (state is! AuthLoading) {
          LoadingOverlay.hide();
        }

        if (state is AuthError) {
          LoadingOverlay.hide();
          WidgetsBinding //
              .instance
              .addPostFrameCallback(
            (_) => showCustomSnackbar(
              context,
              message: state.message,
              type: SnackbarType.error,
            ),
          );
        }

        if (state is AuthLoading) {
          WidgetsBinding //
              .instance
              .addPostFrameCallback((_) => LoadingOverlay.show(context));
        }

        if (state is AuthSuccess) {
          WidgetsBinding //
              .instance
              .addPostFrameCallback(
            (_) => context.go(ConstantRoutes.homeView),
          );
        }
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
      },
    );
  }
}
