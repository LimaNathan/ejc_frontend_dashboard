import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/components/skills_card.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/components/was_worked_card.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class PersonDialog extends StatelessWidget {
  const PersonDialog({
    required this.person,
    this.isAddingToTeam = false,
    super.key,
  });
  final PersonModel person;
  final bool? isAddingToTeam;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final birthDate = DateFormat('dd/MM/yyyy').format(person.aniversario);
    final ejcDo = '${person.ejcNumber}º Encontro de Jovens com Cristo';
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
        height: size.height * 0.75,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  person.name,
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
                  minRadius: size.height * 0.1,
                  child: person.photo != null
                      ? Image.memory(
                          base64Decode(person.photo!),
                        )
                      : const Icon(
                          HugeIcons.strokeRoundedUserList,
                        ),
                ),
                SizedBox(width: size.width * 0.05),
                Column(
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
                            text: person.circle,
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
                  ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Encontros que serviu:',
                      style: textTheme.titleLarge,
                    ),
                    WasWorkedCard(person: person),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aptidões:',
                      style: textTheme.titleLarge,
                    ),
                    SkillsCard(person: person),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: isAddingToTeam!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Text(
                      'Adicionar na equipe',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
