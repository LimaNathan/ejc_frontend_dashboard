import 'package:flutter/material.dart';

class NoTeamsComponent extends StatelessWidget {
  const NoTeamsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.groups_rounded,
          size: 64,
          color: colorScheme.onSurface,
        ),
        const SizedBox(height: 16),
        Text(
          'Nenhuma equipe cadastrada',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Clique no botão abaixo para adicionar uma nova equipe',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
