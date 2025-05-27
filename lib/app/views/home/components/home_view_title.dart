import 'package:flutter/material.dart';

class HomeViewTitle extends StatelessWidget {
  const HomeViewTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Página Inicial',
          style: textTheme.headlineLarge,
        ),
        Text(
          'Bem vindo ao dashboard do EJC',
          style: textTheme //
              .bodyLarge
              ?.copyWith(
            color: colorScheme //
                .onSurface
                .withValues(alpha: 100),
          ),
        ),
      ],
    );
  }
}
