import 'package:ejc_frontend_dashboard/app/domains/dtos/credentials.dart';
import 'package:ejc_frontend_dashboard/app/utils/overlays/loading_overlay.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/bloc/auth_viewmodel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  bool obscureText = true;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    void changeObscureText() {
      setState(() {
        obscureText = !obscureText;
      });
    }

    return BlocProvider(
      create: (context) => AuthViewmodelBloc(context.read()),
      child: BlocBuilder<AuthViewmodelBloc, AuthViewmodelState>(
        builder: (context, state) {
          if (state is! AuthLoading) {
            LoadingOverlay.hide();
          }

          if (state is AuthError) {
            LoadingOverlay.hide();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  animation: _bounceAnimation,
                  content: Text(
                    state.message,
                  ),
                ),
              );
            });
          }

          if (state is AuthLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              LoadingOverlay.show(context);
            });
          }
          return Scaffold(
            body: Center(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const ValueKey('user'),
                      controller: emailEC,
                      decoration: const InputDecoration(
                        label: Text('Usuário'),
                      ),
                    ),
                    TextFormField(
                      key: const ValueKey('password'),
                      obscureText: obscureText,
                      controller: passwordEC,
                      decoration: InputDecoration(
                        label: const Text('Senha'),
                        suffix: IconButton(
                          onPressed: changeObscureText,
                          icon: Icon(
                            obscureText ? Icons.lock : Icons.lock_open,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthViewmodelBloc>().add(
                              LoginEvent(
                                Credentials(
                                  email: emailEC.text,
                                  password: passwordEC.text,
                                ),
                              ),
                            );
                      },
                      child: const Text('Entrar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
