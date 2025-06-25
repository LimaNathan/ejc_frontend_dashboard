import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/people/people_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({
    required this.person,
    super.key,
  });
  final PersonModel person;

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Cuidado!',
      ),
      content: Text('Você está preste a excluir '
          'o encontreiro: '
          '${widget.person.name}\n\n'
          'Tem certeza que deseja prosseguir?'),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () {
            context
                .read<PeopleViewmodel>()
                .onDeleteOne
                .execute(widget.person.uuid);
            Navigator.pop(context);
          },
          child: const Text('Sim'),
        ),
      ],
    );
  }
}
