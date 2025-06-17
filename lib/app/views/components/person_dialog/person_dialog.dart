import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/enum/team_role.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/components/skills_card.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/components/was_worked_card.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

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
  @override
  void initState() {
    super.initState();
    try {
      base64Decode(widget.person.photo!);
    } catch (e) {
      widget.person.photo = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final birthDate =
        DateFormat('dd/MM/yyyy').format(widget.person.aniversario);
    final ejcDo = '${widget.person.ejcNumber}º Encontro de Jovens com Cristo';
    final numbers = widget.person.phones.map((e) => e).join(', ');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.person.name,
                  style: textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              children: [
                CircleAvatar(
                  radius: size.width * 0.07,
                  child: widget.person.photo != null
                      ? ClipOval(
                          child: Image.memory(
                            base64Decode(widget.person.photo!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : const Icon(
                          HugeIcons.strokeRoundedUserList,
                        ),
                ),
                SizedBox(width: size.width * 0.05),
                SizedBox(
                  width: size.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Data de nascimento: ',
                          style: textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: birthDate,
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Círculo de origem: ',
                          style: textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: widget.person.circle.isEmpty
                                  ? '--'
                                  : widget.person.circle,
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Fez o: ',
                          style: textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: ejcDo,
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Contatos: ',
                          style: textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: numbers,
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () {
                      final teamComposition =
                          DetailedTeamComposition.fromPersonAndTeam(
                        widget.person,
                        widget.team!,
                        TeamRole.integrante,
                      );

                      if (widget.composition != null &&
                          widget.composition!.contains(teamComposition)) {
                        showCustomSnackbar(
                          context,
                          message: 'Encontrista já está nessa equipe',
                        );
                      }

                      if (widget.composition == null) {
                        widget.composition = [teamComposition];
                      }

                      if (widget.composition != null &&
                          !widget.composition!.contains(teamComposition)) {
                        widget.composition!.add(teamComposition);
                      }
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
  }
}
