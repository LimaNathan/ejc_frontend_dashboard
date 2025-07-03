import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/team_composition/team_composition_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RemoveFromTeamDialog extends StatefulWidget {
  const RemoveFromTeamDialog({
    required this.person,
    super.key,
  });
  final DetailedTeamComposition person;

  @override
  State<RemoveFromTeamDialog> createState() => _RemoveFromTeamDialogState();
}

class _RemoveFromTeamDialogState extends State<RemoveFromTeamDialog> {
  late final TeamCompositionViewmodel teamCompositionViewmodel;

  @override
  void initState() {
    super.initState();
    teamCompositionViewmodel = context.read<TeamCompositionViewmodel>();
    teamCompositionViewmodel.onRemoveUserTeamComposition.addListener(_listener);
  }

  @override
  void dispose() {
    teamCompositionViewmodel.onRemoveUserTeamComposition
        .removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    final result = teamCompositionViewmodel.onRemoveUserTeamComposition.value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (result.isRunning) {
        ShadToaster.of(context).show(
          const ShadToast(
            title: Text('Aguarde'),
            description: Text('Removendo membro da equipe...'),
          ),
        );
        return;
      }

      result.when(
        data: (_) {
          Navigator.of(context).pop();
          ShadToaster.of(context).show(
            const ShadToast(
              title: Text('Sucesso!'),
              description: Text('Membro removido da equipe.'),
            ),
          );
        },
        failure: (error) {
          ShadToaster.of(context).show(
            ShadToast.destructive(
              title: const Text('Erro ao remover membro'),
              description: Text(error.toString()),
            ),
          );
        },
        orElse: () {},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShadDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: colorScheme.error,
          ),
          const SizedBox(width: 8),
          const Text('Cuidado!'),
        ],
      ),
      description: Text(
        'Você está prestes a remover o encontreiro: ${widget.person.name} da equipe.\n\n'
        'Tem certeza que deseja prosseguir?',
      ),
      actions: [
        ShadButton.ghost(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        ListenableBuilder(
          listenable: teamCompositionViewmodel.onRemoveUserTeamComposition,
          builder: (context, _) {
            final isLoading = teamCompositionViewmodel
                .onRemoveUserTeamComposition.value.isRunning;

            return ShadButton.destructive(
              onPressed: isLoading
                  ? null
                  : () {
                      teamCompositionViewmodel.onRemoveUserTeamComposition
                          .execute(widget.person.userId ?? '');
                    },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Text('Remover'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
