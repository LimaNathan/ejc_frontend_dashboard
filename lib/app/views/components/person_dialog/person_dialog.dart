// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/enum/team_role.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/people/people_viewmodel.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/team_composition/team_composition_viewmodel.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/components/person_info.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/components/skills_card.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/components/was_worked_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// ignore: must_be_immutable
class PersonDialog extends StatefulWidget {
  PersonDialog({
    required this.person,
    this.isAddingToTeam,
    this.team,
    this.composition,
    super.key,
  });
  List<DetailedTeamComposition>? composition;
  final TeamModel? team;
  final PersonModel person;
  final bool? isAddingToTeam;

  @override
  State<PersonDialog> createState() => _PersonDialogState();
}

class _PersonDialogState extends State<PersonDialog> {
  late final PeopleViewmodel peopleViewmodel;
  late final TeamCompositionViewmodel teamCompositionViewmodel;
  TeamRole? role;

  @override
  void initState() {
    super.initState();

    peopleViewmodel = context.read<PeopleViewmodel>();
    teamCompositionViewmodel = context.read<TeamCompositionViewmodel>();

    peopleViewmodel.onDeleteOne.addListener(listener);

    try {
      base64Decode(widget.person.photo!);
    } catch (e) {
      widget.person.photo = null;
    }
  }

  Future<void> listener() async {
    if (peopleViewmodel //
        .onDeleteOne
        .value
        .isSuccess) {
      await Future.delayed(
        const Duration(milliseconds: 150),
        () => Navigator.pop(context),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    peopleViewmodel.onDeleteOne.removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: peopleViewmodel.onDeleteOne,
      builder: (context, child) {
        if (peopleViewmodel //
            .onDeleteOne
            .value
            .isRunning) {
          return const Center(child: CircularProgressIndicator());
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.03,
              horizontal: size.width * 0.035,
            ),
            width: size.width * 0.75,
            height: size.height * 0.95,
            child: Column(
              children: [
                PersonInfo(person: widget.person),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                  ),
                  child: const Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Encontros que serviu:',
                          style: textTheme.titleLarge,
                        ),
                        WasWorkedCard(person: widget.person),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aptidões:',
                          style: textTheme.titleLarge,
                        ),
                        SkillsCard(person: widget.person),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                if (widget.isAddingToTeam ?? false)
                  ShadSelect<TeamRole>(
                    placeholder:
                        const Text('Selecione a função dele na equipe'),
                    selectedOptionBuilder: (context, teamRole) {
                      return Text(teamRole.title);
                    },
                    onChanged: (value) => role = value,
                    options: TeamRole.values
                        .map(
                          (value) => ShadOption(
                            value: value,
                            child: Text(value.title),
                          ),
                        )
                        .toList(),
                  ),
                if (widget.isAddingToTeam ?? false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: () {
                          if (role == null) {
                            showCustomSnackbar(
                              context,
                              type: SnackbarType.error,
                              message: 'Você deve selecionar a'
                                  ' função do jovem na equipe',
                            );
                          }
                          teamCompositionViewmodel //
                              .onAddToTeam
                              .execute(
                            TeamComposition(
                              teamId: widget.team?.uuid ?? '',
                              userId: widget.person.uuid,
                              role: role,
                            ),
                          );
                        },
                        child: const Text(
                          'Adicionar na equipe',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
