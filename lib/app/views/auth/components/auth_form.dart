import 'package:ejc_frontend_dashboard/app/domains/dtos/auth/credentials.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    final theme = ShadTheme.of(context);

    void onPressed() {
      final authViewmodel = context.read<AuthViewmodel>();

      authViewmodel.loginCommand.execute(
        Credentials(
          email: emailEC.text,
          password: passwordEC.text,
        ),
      );
    }

    return SizedBox(
      width: 350,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/logo_ejc.png',
            height: 40,
          ),
          const SizedBox(height: 16),
          Text(
            'Bem vindo(a) de volta',
            style: theme.textTheme.h4,
          ),
          const SizedBox(height: 8),
          Text(
            'Entre com suas credenciais para continuar',
            style: theme.textTheme.muted,
          ),
          const SizedBox(height: 24),
          ShadInput(
            controller: emailEC,
            placeholder: const Text('Usuário'),
            trailing: const SizedBox(width: 24),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 350,
            child: OverflowBar(
              children: [
                SizedBox(
                  width: 300,
                  child: ShadInput(
                    obscureText: obscureText,
                    controller: passwordEC,
                    onEditingComplete: onPressed,
                    placeholder: const Text('Senha'),
                  ),
                ),
                Expanded(
                  child: ShadIconButton.ghost(
                    icon: HugeIcon(
                      size: 16,
                      icon: obscureText
                          ? HugeIcons.strokeRoundedEye
                          : HugeIcons.strokeRoundedViewOffSlash,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: changeObscureText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ShadButton(
            width: double.infinity,
            onPressed: onPressed,
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
  }
}
