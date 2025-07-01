import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/team_composition/team_composition_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Cuidado!',
      ),
      content: Text('Você está preste a remover '
          'o encontreiro: '
          '${widget.person.name} da equipe.\n\n'
          'Tem certeza que deseja prosseguir?'),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () {
            context
                .read<TeamCompositionViewmodel>()
                .onRemoveUserTeamComposition
                .execute(widget.person.userId ?? '');
            Navigator.pop(context);
          },
          child: const Text('Sim'),
        ),
      ],
    );
  }
}
