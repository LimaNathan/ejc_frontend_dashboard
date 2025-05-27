import 'package:ejc_frontend_dashboard/app/domains/dtos/credentials.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/bloc/auth_viewmodel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    void changeObscureText() => setState(() => obscureText = !obscureText);
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.all(size.width * 0.025),
      width: size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: size.height * 0.025,
        children: [
          Column(
            children: [
              Text(
                'Bem vindo(a) de volta, ao SGE',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                'Sistema de Gerenciamento de Encontreiros',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                    ),
              ),
            ],
          ),
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
              suffixIcon: IconButton(
                iconSize: 16,
                onPressed: changeObscureText,
                padding: EdgeInsets.zero,
                icon: HugeIcon(
                  icon: obscureText
                      ? HugeIcons.strokeRoundedEye
                      : HugeIcons.strokeRoundedViewOffSlash,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          FilledButton(
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
    );
  }
}
