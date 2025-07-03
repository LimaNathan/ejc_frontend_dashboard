import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel.dart';
import 'package:ejc_frontend_dashboard/app/views/auth/components/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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

    authViewmodel = context.read<AuthViewmodel>();

    authViewmodel.loginCommand.addListener(_listener);
  }

  void _listener() {
    final result = authViewmodel.loginCommand.value;

    final isLoading = result.isRunning;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoading) {
        ShadToaster.of(context).show(
          const ShadToast(
            title: Text('Aguarde'),
            description: Text('Realizando login...'),
          ),
        );
      } else {
        result.when(
          data: (value) => context.go(ConstantRoutes.homeView),
          orElse: () {},
          failure: (exception) {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: const Text('Ops, ocorreu um erro'),
                description: Text(exception.toString()),
              ),
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
    return const Scaffold(
      body: Center(
        child: AuthForm(),
      ),
    );
  }
}
